const prisma = require('../config/database').prisma || require('../config/database');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const crypto = require('crypto'); // Native Node.js module for random codes
const sendEmail = require('../utils/sendEmail'); // Ensure you created this file in src/utils/

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
    
    // Hash password
    const hashedPassword = await bcrypt.hash(password, 12);

    const newUser = await prisma.user.create({
      data: {
        email,
        password: hashedPassword,
        firstName,
        lastName,
        name: `${firstName} ${lastName}`,
        role: role || 'USER',
        mfaEnabled: true, // Auto-enable MFA for Email Verification
      },
    });

    // Remove password from response
    const { password: _, ...userWithoutPassword } = newUser;
    res.status(201).json({ 
      success: true, 
      message: "User registered. Please login to verify email.", 
      user: userWithoutPassword 
    });
  } catch (error) {
    console.error("Register Error:", error);
    res.status(400).json({ success: false, error: error.message });
  }
};

// 2. LOGIN (Step 1: Password Check & Email Code)
exports.login = async (req, res) => {
  try {
    const { email, password } = req.body;
    const user = await prisma.user.findUnique({ where: { email } });

    if (!user || !(await bcrypt.compare(password, user.password))) {
      return res.status(401).json({ success: false, message: 'Invalid credentials' });
    }

    // --- EMAIL MFA LOGIC ---
    if (user.mfaEnabled) {
      // 1. Generate 6-digit random code
      const mfaCode = Math.floor(100000 + Math.random() * 900000).toString();
      
      // 2. Hash it for security (so DB admins can't see it)
      const mfaSecret = crypto
        .createHash('sha256')
        .update(mfaCode)
        .digest('hex');

      // 3. Set expiration (10 minutes)
      const mfaExpires = new Date(Date.now() + 10 * 60 * 1000);

      // 4. Save hash and expiry to DB
      await prisma.user.update({
        where: { id: user.id },
        data: { mfaSecret, mfaExpires },
      });

      // 5. Send Email
      const message = `
        <h3>Rentverse Login Code</h3>
        <p>Your verification code is:</p>
        <h1 style="color: blue;">${mfaCode}</h1>
        <p>This code expires in 10 minutes.</p>
      `;

      try {
        await sendEmail({
          email: user.email,
          subject: 'Your Login Verification Code',
          message,
        });

        return res.status(200).json({
          success: true,
          mfaRequired: true,
          userId: user.id,
          message: `Verification code sent to ${user.email}`,
        });
      } catch (err) {
        console.error("Email Error:", err);
        return res.status(500).json({ success: false, message: "Email could not be sent" });
      }
    }

    // If MFA is OFF (Fallback), just login
    const token = signToken(user.id, user.role);
    res.json({ success: true, token });
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
};

// 3. VERIFY MFA (Step 2: Check Code)
exports.verifyMFA = async (req, res) => {
  try {
    const { userId, token } = req.body; // 'token' is the 6-digit code
    
    const user = await prisma.user.findUnique({ where: { id: userId } });

    if (!user || !user.mfaSecret) {
      return res.status(400).json({ success: false, message: "Invalid request or code expired" });
    }

    // Check Expiration
    if (user.mfaExpires && new Date() > user.mfaExpires) {
      return res.status(401).json({ success: false, message: "Code expired" });
    }

    // Hash the incoming code to compare with DB
    const incomingCodeHash = crypto
      .createHash('sha256')
      .update(token)
      .digest('hex');

    if (incomingCodeHash === user.mfaSecret) {
      // Success: Clear used code
      await prisma.user.update({
        where: { id: user.id },
        data: { mfaSecret: null, mfaExpires: null },
      });

      // Issue JWT
      const jwtToken = signToken(user.id, user.role);
      res.json({ success: true, message: "MFA Verified", token: jwtToken });
    } else {
      res.status(401).json({ success: false, message: "Invalid Code" });
    }
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
};

// 4. Setup MFA - Deprecated/Auto-enabled
exports.setupMFA = async (req, res) => {
  res.json({ success: true, message: "MFA is automatically enabled via Email." });
};