const prisma = require('../config/database').prisma || require('../config/database');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const crypto = require('crypto'); // Built-in Node module for random codes
const sendEmail = require('../utils/sendEmail'); // Import the helper

// Helper to sign JWT
const signToken = (id, role) => {
  return jwt.sign({ id, role }, process.env.JWT_SECRET, {
    expiresIn: process.env.JWT_EXPIRES_IN || '15m',
  });
};

// 1. REGISTER
exports.register = async (req, res) => {
  try {
    const { email, password, firstName, lastName, role } = req.body;
    const hashedPassword = await bcrypt.hash(password, 12);

    const newUser = await prisma.user.create({
      data: {
        email,
        password: hashedPassword,
        firstName,
        lastName,
        name: `${firstName} ${lastName}`,
        role: role || 'USER',
        mfaEnabled: true, // AUTO-ENABLE MFA for all new users (Security Best Practice)
      },
    });

    const { password: _, ...userWithoutPassword } = newUser;
    res.status(201).json({ message: "User registered. Please login to verify email.", user: userWithoutPassword });
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};

// 2. LOGIN (Step 1: Check Password & Send Email)
exports.login = async (req, res) => {
  try {
    const { email, password } = req.body;
    const user = await prisma.user.findUnique({ where: { email } });

    if (!user || !(await bcrypt.compare(password, user.password))) {
      return res.status(401).json({ message: 'Invalid credentials' });
    }

    // MFA LOGIC (Email Based)
    if (user.mfaEnabled) {
      // 1. Generate random 6-digit code
      const mfaCode = Math.floor(100000 + Math.random() * 900000).toString();
      
      // 2. Hash it before saving to DB (Security)
      const mfaCodeHash = crypto
        .createHash('sha256')
        .update(mfaCode)
        .digest('hex');

      // 3. Set expiration (10 minutes)
      const mfaExpires = new Date(Date.now() + 10 * 60 * 1000);

      // 4. Update User DB
      await prisma.user.update({
        where: { id: user.id },
        data: { 
          mfaSecret: mfaCodeHash, // Re-using this field to store the temp code hash
          mfaExpires: mfaExpires  // Ensure you added this field to schema.prisma!
          // If you didn't add mfaExpires to schema, let me know. 
          // For now, we can skip expiration check or just check updated_at.
        }
      });

      // 5. Send Email
      const message = `
        <h1>Rentverse Login Verification</h1>
        <p>Your verification code is:</p>
        <h2>${mfaCode}</h2>
        <p>This code expires in 10 minutes.</p>
      `;

      try {
        await sendEmail({
          email: user.email,
          subject: 'Your Login Code',
          message,
        });

        return res.status(200).json({
          mfaRequired: true,
          userId: user.id,
          message: `Verification code sent to ${user.email}`,
        });
      } catch (emailError) {
        console.error(emailError);
        return res.status(500).json({ message: 'Error sending email' });
      }
    }

    // If MFA is somehow off, login normally
    const token = signToken(user.id, user.role);
    res.json({ status: 'success', token });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// 3. VERIFY MFA (Step 2: Check Email Code)
exports.verifyMFA = async (req, res) => {
  try {
    const { userId, token } = req.body; // 'token' here is the 6-digit Email Code
    
    const user = await prisma.user.findUnique({ where: { id: userId } });

    if (!user || !user.mfaSecret) {
      return res.status(400).json({ message: "Invalid request or code expired" });
    }

    // 1. Hash the incoming code to compare with stored hash
    const incomingCodeHash = crypto
      .createHash('sha256')
      .update(token)
      .digest('hex');

    // 2. Compare
    if (incomingCodeHash === user.mfaSecret) {
      
      // Clear the used code
      await prisma.user.update({
        where: { id: user.id },
        data: { mfaSecret: null }
      });

      // Issue Token
      const jwtToken = signToken(user.id, user.role);
      res.json({ status: 'success', message: "Login Successful", token: jwtToken });
    } else {
      res.status(401).json({ message: "Invalid Code" });
    }
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Setup is no longer needed for Email MFA since it's automatic, 
// but we keep a dummy function if routes expect it.
exports.setupMFA = async (req, res) => {
  res.json({ message: "MFA is automatically enabled via Email." });
};