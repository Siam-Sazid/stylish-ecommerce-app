require('dotenv').config();
const express = require('express');
const cors = require('cors');

const productRoutes  = require('./routes/products');
const categoryRoutes = require('./routes/categories');
const authRoutes     = require('./routes/auth');
const orderRoutes    = require('./routes/orders');

const app = express();

app.use(cors());
app.use(express.json());

// Health check
app.get('/', (req, res) => res.json({ status: 'ShopEase API is running' }));

// Routes
app.use('/api/products',   productRoutes);
app.use('/api/categories', categoryRoutes);
app.use('/api/auth',       authRoutes);
app.use('/api/orders',     orderRoutes);

// 404 handler
app.use((req, res) => res.status(404).json({ message: 'Route not found' }));

// Global error handler
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ message: 'Internal server error' });
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`ShopEase API running on http://localhost:${PORT}`));
