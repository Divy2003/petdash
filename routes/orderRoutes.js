const express = require('express');
const router = express.Router();
const orderController = require('../controllers/productflow_controllers/orderController');
const auth = require('../middlewares/auth');

// Cart endpoints
router.post('/cart', auth, orderController.addToCart);
router.get('/cart', auth, orderController.getCart);
router.put('/cart', auth, orderController.updateCartItem);
router.delete('/cart/:productId', auth, orderController.removeFromCart);
router.post('/cart/promo', auth, orderController.applyPromoCode);

// Order endpoints
router.post('/orders', auth, orderController.checkout);
router.get('/orders', auth, orderController.getOrders);
router.get('/orders/:orderNumber', auth, orderController.getOrderDetails);

module.exports = router; 