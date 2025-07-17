const express = require('express');
const router = express.Router();
const subscriptionController = require('../controllers/productflow_controllers/subscriptionController');
const auth = require('../middlewares/auth');

// Subscription endpoints
router.post('/', auth, subscriptionController.createSubscription);
router.get('/', auth, subscriptionController.getUserSubscriptions);
router.put('/:subscriptionId', auth, subscriptionController.updateSubscription);
router.delete('/:subscriptionId', auth, subscriptionController.cancelSubscription);

module.exports = router;
