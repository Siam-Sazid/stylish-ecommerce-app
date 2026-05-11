const express = require('express');
const router = express.Router();
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const users = require('../data/users');

const resetTokens = {}; // { email: { otp, expiresAt } }

function generateToken(user) {
  return jwt.sign(
    { id: user.id, email: user.email },
    process.env.JWT_SECRET,
    { expiresIn: process.env.JWT_EXPIRES_IN }
  );
}

function safeUser(user) {
  const { password, ...rest } = user;
  return rest;
}

// POST /api/auth/login
router.post('/login', async (req, res) => {
  const { email, password } = req.body;
  if (!email || !password)
    return res.status(400).json({ message: 'Email and password are required' });

  const user = users.find(u => u.email.toLowerCase() === email.toLowerCase());
  if (!user)
    return res.status(401).json({ message: 'Invalid email or password' });

  const match = await bcrypt.compare(password, user.password);
  if (!match)
    return res.status(401).json({ message: 'Invalid email or password' });

  res.json({ token: generateToken(user), user: safeUser(user) });
});

// POST /api/auth/register
router.post('/register', async (req, res) => {
  const { name, email, password } = req.body;
  if (!name || !email || !password)
    return res.status(400).json({ message: 'Name, email and password are required' });

  if (users.find(u => u.email.toLowerCase() === email.toLowerCase()))
    return res.status(409).json({ message: 'Email already in use' });

  if (password.length < 6)
    return res.status(400).json({ message: 'Password must be at least 6 characters' });

  const newUser = {
    id: `u${Date.now()}`,
    name,
    email,
    password: await bcrypt.hash(password, 10),
    avatarUrl: null,
  };
  users.push(newUser);

  res.status(201).json({ token: generateToken(newUser), user: safeUser(newUser) });
});

// POST /api/auth/forgot-password
router.post('/forgot-password', (req, res) => {
  const { email } = req.body;
  if (!email) return res.status(400).json({ message: 'Email is required' });

  const user = users.find(u => u.email.toLowerCase() === email.toLowerCase());
  if (!user) {
    // Don't reveal whether the email exists
    return res.json({ message: 'If that email is registered, an OTP has been sent.' });
  }

  const otp = Math.floor(100000 + Math.random() * 900000).toString();
  resetTokens[email.toLowerCase()] = { otp, expiresAt: Date.now() + 10 * 60 * 1000 };

  console.log(`[DEV] Password reset OTP for ${email}: ${otp}`);

  res.json({ message: 'OTP sent successfully' });
});

// POST /api/auth/reset-password
router.post('/reset-password', async (req, res) => {
  const { email, otp, newPassword } = req.body;
  if (!email || !otp || !newPassword)
    return res.status(400).json({ message: 'Email, OTP, and new password are required' });

  const record = resetTokens[email.toLowerCase()];
  if (!record) return res.status(400).json({ message: 'Invalid or expired OTP' });

  if (Date.now() > record.expiresAt) {
    delete resetTokens[email.toLowerCase()];
    return res.status(400).json({ message: 'OTP has expired. Please request a new one.' });
  }

  if (record.otp !== otp) return res.status(400).json({ message: 'Invalid OTP' });

  if (newPassword.length < 6)
    return res.status(400).json({ message: 'Password must be at least 6 characters' });

  const user = users.find(u => u.email.toLowerCase() === email.toLowerCase());
  if (!user) return res.status(404).json({ message: 'User not found' });

  user.password = await bcrypt.hash(newPassword, 10);
  delete resetTokens[email.toLowerCase()];

  res.json({ message: 'Password reset successfully' });
});

module.exports = router;
