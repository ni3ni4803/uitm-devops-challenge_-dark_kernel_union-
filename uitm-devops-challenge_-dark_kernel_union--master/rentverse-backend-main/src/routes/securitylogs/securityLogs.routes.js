const express = require('express');
const router = express.Router();

// ✅ PATH BETUL (NAIK 2 LEVEL)
const { auth, authorize } = require('../../middleware/auth');

const controller = require('./securityLogs.controller');

// ============================
// MODULE 5 – SECURITY LOGS
// ============================

// 🔒 ADMIN ONLY
router.get(
  '/',
  auth,
  authorize('ADMIN'),
  controller.getSecurityLogs
);

router.post(
  '/',
  auth,
  authorize('ADMIN'),
  controller.createSecurityLog
);

module.exports = router;
