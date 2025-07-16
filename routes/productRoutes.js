const express = require('express');
const router = express.Router();
const productController = require('../controllers/productflow_controllers/productController');
const auth = require('../middlewares/auth');

// Public routes
router.get('/', productController.getAllProducts);
router.get('/search', productController.searchProducts);
router.get('/category/:category', productController.getProductsByCategory);
router.get('/:productId', productController.getProductById);

// Protected routes (business only)
router.post('/', auth, productController.createProduct);
router.put('/:productId', auth, productController.updateProduct);
router.delete('/:productId', auth, productController.deleteProduct);
router.get('/business/list', auth, productController.getBusinessProducts);

module.exports = router; 