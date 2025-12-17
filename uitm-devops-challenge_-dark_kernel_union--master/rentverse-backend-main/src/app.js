require('dotenv').config();
const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const morgan = require('morgan');

const { connectDB } = require('./config/database');

const app = express();

// =====================
// BASIC SETUP (STABLE)
// =====================
connectDB();

app.use(helmet());
app.use(cors());
app.use(morgan('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// =====================
// ROOT TEST
// =====================
app.get('/', (req, res) => {
  res.json({
    message: 'Rentverse Backend API is running',
    status: 'OK',
    environment: process.env.NODE_ENV || 'development',
  });
});

// =====================
// MODULE 5 – SECURITY LOGS
// =====================
const securityLogsRoutes = require('./routes/securitylogs/securityLogs.routes');
app.use('/api/admin/security-logs', securityLogsRoutes);



// =====================
// HEALTH CHECK
// =====================
app.get('/health', async (req, res) => {
  try {
    const { prisma } = require('./config/database');
    await prisma.$queryRaw`SELECT 1`;

    res.json({
      status: 'OK',
      database: 'Connected',
      uptime: process.uptime(),
    });
  } catch (err) {
    res.status(500).json({
      status: 'ERROR',
      database: 'Disconnected',
      error: err.message,
    });
  }
});

// =====================
// 404
// =====================
app.use((req, res) => {
  res.status(404).json({ error: 'Route not found' });
});

// =====================
// GLOBAL ERROR
// =====================
app.use((err, req, res, next) => {
  console.error(err);
  res.status(500).json({
    error: 'Internal Server Error',
    message: err.message,
  });
});

module.exports = app;
