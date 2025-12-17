const nodemailer = require('nodemailer');

const sendEmail = async (options) => {
  // Use Gmail or any SMTP service
  const transporter = nodemailer.createTransport({
    service: 'gmail', 
    auth: {
      user: process.env.EMAIL_USERNAME, // Your Gmail address
      pass: process.env.EMAIL_PASSWORD, // Your App Password (not login password)
    },
  });

  const mailOptions = {
    from: `Rentverse Security <${process.env.EMAIL_USERNAME}>`,
    to: options.email,
    subject: options.subject,
    html: options.message,
  };

  await transporter.sendMail(mailOptions);
};

module.exports = sendEmail;