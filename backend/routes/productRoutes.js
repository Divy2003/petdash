const express = require('express');
const router = express.Router();
const productController = require('../controllers/productflow_controllers/productController');
const upload = require('../middlewares/uploadImage');
const auth = require('../middlewares/auth');
const { requireBusinessAccess } = require('../middlewares/roleAuth');

// Public routes
router.get('/', productController.getAllProducts);
router.get('/search', productController.searchProducts);
router.get('/category/:category', productController.getProductsByCategory);
router.get('/:productId', productController.getProductById);

// Protected routes (business access required)
router.post('/', auth, requireBusinessAccess, upload.array('images', 5), productController.createProduct);
router.put('/:productId', auth, requireBusinessAccess, upload.array('images', 5), productController.updateProduct);
router.delete('/:productId', auth, requireBusinessAccess, productController.deleteProduct);
router.get('/business/list', auth, requireBusinessAccess, productController.getBusinessProducts);

module.exports = router; 