const { prisma } = require('../../config/database');

// ===============================
// GET ALL SECURITY LOGS
// ===============================
exports.getSecurityLogs = async (req, res) => {
  try {
    const logs = await prisma.securityEvent.findMany({
      orderBy: { createdAt: 'desc' },
    });

    return res.json({
      success: true,
      data: logs,
    });
  } catch (err) {
    console.error(err);
    return res.status(500).json({
      success: false,
      message: 'Failed to fetch security logs',
    });
  }
};

// ===============================
// CREATE SECURITY LOG
// ===============================
exports.createSecurityLog = async (req, res) => {
  try {
    const { eventType, description, riskLevel = 1 } = req.body;

    const log = await prisma.securityEvent.create({
      data: {
        eventType,
        description,
        riskLevel,
        ipAddress: req.ip,
        userAgent: req.headers['user-agent'],
      },
    });

    return res.status(201).json({
      success: true,
      data: log,
    });
  } catch (err) {
    console.error(err);
    return res.status(500).json({
      success: false,
      message: 'Failed to create security log',
    });
  }
};
