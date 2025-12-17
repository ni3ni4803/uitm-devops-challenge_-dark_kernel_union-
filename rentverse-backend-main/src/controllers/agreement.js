const crypto = require('crypto');
const prisma = require('../config/database');

exports.signAgreement = async (req, res) => {
  const { propertyId, agreementContent } = req.body;
  const userId = req.user.id;

  // 1. Create a Cryptographic Hash of the content
  // This ensures "Data Integrity" - if content changes, hash changes.
  const contentHash = crypto
    .createHash('sha256')
    .update(JSON.stringify(agreementContent))
    .digest('hex');

  // 2. Simulate Digital Signature (In real world, this is done by Private Key on mobile)
  // For this challenge, we create a server-side seal linking User + Content
  const signature = crypto
    .createHmac('sha256', process.env.JWT_SECRET) // Using server secret as "Notary"
    .update(contentHash + userId)
    .digest('hex');

  // 3. Store Immutable Record
  const agreement = await prisma.agreement.create({
    data: {
      userId,
      propertyId,
      contentHash,
      signature
    }
  });

  res.json({ 
    status: 'Signed', 
    agreementId: agreement.id, 
    integrityHash: contentHash 
  });
};

exports.verifyAgreement = async (req, res) => {
  const { agreementId, currentContent } = req.body;
  
  const agreement = await prisma.agreement.findUnique({ where: { id: agreementId }});
  
  // Re-hash the current content to see if it matches the original
  const currentHash = crypto
    .createHash('sha256')
    .update(JSON.stringify(currentContent))
    .digest('hex');

  if (agreement.contentHash === currentHash) {
    res.json({ valid: true, message: "Document Integrity Verified" });
  } else {
    res.status(409).json({ valid: false, message: "TAMPER DETECTED: Document has been modified" });
  }
};