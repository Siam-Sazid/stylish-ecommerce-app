const express = require('express');
const router = express.Router();
const products = require('../data/products');
const categories = require('../data/categories');

// GET /api/products
router.get('/', (req, res) => {
  res.json(products);
});

// GET /api/products/featured
router.get('/featured', (req, res) => {
  res.json(products.filter(p => p.isFeatured));
});

// GET /api/products/search?q=query
router.get('/search', (req, res) => {
  const q = (req.query.q || '').toLowerCase().trim();
  if (!q) return res.json(products);
  const results = products.filter(
    p => p.name.toLowerCase().includes(q) || p.description.toLowerCase().includes(q)
  );
  res.json(results);
});

// GET /api/products/category/:categoryId
router.get('/category/:categoryId', (req, res) => {
  res.json(products.filter(p => p.categoryId === req.params.categoryId));
});

// GET /api/products/:id
router.get('/:id', (req, res) => {
  const product = products.find(p => p.id === req.params.id);
  if (!product) return res.status(404).json({ message: 'Product not found' });
  res.json(product);
});

module.exports = router;
