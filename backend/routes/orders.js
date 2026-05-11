const express = require('express');
const router = express.Router();
const authMiddleware = require('../middleware/auth');

// In-memory order store (cleared on server restart)
const orders = [];

// POST /api/orders  — place an order (auth required)
router.post('/', authMiddleware, (req, res) => {
  const { items, shippingInfo, paymentMethod, subtotal, shipping, total } = req.body;

  if (!items || items.length === 0)
    return res.status(400).json({ message: 'Order must contain at least one item' });

  const order = {
    id: `ORD-${Date.now()}`,
    userId: req.user.id,
    items,
    shippingInfo,
    paymentMethod,
    subtotal,
    shipping,
    total,
    status: 'confirmed',
    createdAt: new Date().toISOString(),
  };

  orders.push(order);
  res.status(201).json(order);
});

// GET /api/orders  — get current user's orders (auth required)
router.get('/', authMiddleware, (req, res) => {
  const userOrders = orders.filter(o => o.userId === req.user.id);
  res.json(userOrders);
});

module.exports = router;
