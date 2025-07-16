const express = require('express');
const router = express.Router();
const orderController = require('../controllers/productflow_controllers/orderController');
const auth = require('../middlewares/auth');

// Cart endpoints
router.post('/cart', auth, orderController.addToCart);
router.get('/cart', auth, orderController.getCart);

// Order endpoints
router.post('/orders', auth, orderController.checkout);
router.get('/orders', auth, orderController.getOrders);

module.exports = router; 