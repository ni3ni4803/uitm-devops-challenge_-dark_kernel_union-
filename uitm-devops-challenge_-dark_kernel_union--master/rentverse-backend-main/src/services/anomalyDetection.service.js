const { prisma } = require('../config/database');
const securityLogger = require('./securityLogger.service');

class AnomalyDetection {
  async checkFailedLogins(userId, ipAddress) {
    const recentFails = await prisma.securityEvent.count({
      where: {
        userId,
        eventType: 'LOGIN_FAILED',
        createdAt: { gte: new Date(Date.now() - 10 * 60 * 1000) },
      },
    });

    if (recentFails >= 5) {
      await securityLogger.log({
        userId,
        eventType: 'ACCOUNT_FLAGGED',
        ipAddress,
        riskLevel: 2,
        description: 'Multiple failed login attempts detected',
      });

      await prisma.user.update({
        where: { id: userId },
        data: { isActive: false },
      });
    }
  }
}

module.exports = new AnomalyDetection();
