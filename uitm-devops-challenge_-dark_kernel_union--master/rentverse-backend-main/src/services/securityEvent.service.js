const { prisma } = require('../config/database');

/**
 * Log a security-related event into the database
 */
async function logSecurityEvent({
  userId = null,
  eventType,
  ipAddress,
  userAgent,
  riskLevel = 1,
  description = null,
}) {
  try {
    await prisma.securityEvent.create({
      data: {
        userId,
        eventType,
        ipAddress,
        userAgent,
        riskLevel,
        description,
      },
    });
  } catch (error) {
    console.error('❌ Failed to log security event:', error.message);
  }
}

module.exports = {
  logSecurityEvent,
};
