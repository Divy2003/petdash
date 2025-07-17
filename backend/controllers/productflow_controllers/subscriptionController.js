const Order = require('../../models/Order');
const Product = require('../../models/Product');

// Create subscription from cart
exports.createSubscription = async (req, res) => {
  try {
    const userId = req.user.id;
    const { productId, deliveryFrequency } = req.body; // monthly, weekly, etc.
    
    const product = await Product.findById(productId);
    if (!product) {
      return res.status(404).json({ message: 'Product not found' });
    }
    
    if (!product.subscriptionAvailable) {
      return res.status(400).json({ message: 'Product is not available for subscription' });
    }
    
    // Create subscription order
    const subscription = new Order({
      user: userId,
      products: [{
        product: productId,
        quantity: 1,
        price: product.monthlyDeliveryPrice || product.price,
        subscription: true
      }],
      status: 'subscription',
      paymentStatus: 'pending',
      subtotal: product.monthlyDeliveryPrice || product.price,
      shippingCost: product.shippingCost || 0,
      tax: (product.monthlyDeliveryPrice || product.price) * 0.08,
      total: (product.monthlyDeliveryPrice || product.price) + (product.shippingCost || 0) + ((product.monthlyDeliveryPrice || product.price) * 0.08),
      deliveryFrequency: deliveryFrequency
    });
    
    await subscription.save();
    res.status(201).json({ message: 'Subscription created successfully', subscription });
  } catch (error) {
    console.error('Create subscription error:', error);
    res.status(500).json({ message: 'Server error', error: error.message });
  }
};

// Get user subscriptions
exports.getUserSubscriptions = async (req, res) => {
  try {
    const userId = req.user.id;
    const subscriptions = await Order.find({ 
      user: userId, 
      status: 'subscription' 
    }).populate('products.product');
    
    res.json({ subscriptions });
  } catch (error) {
    console.error('Get user subscriptions error:', error);
    res.status(500).json({ message: 'Server error', error: error.message });
  }
};

// Cancel subscription
exports.cancelSubscription = async (req, res) => {
  try {
    const userId = req.user.id;
    const { subscriptionId } = req.params;
    
    const subscription = await Order.findOne({
      _id: subscriptionId,
      user: userId,
      status: 'subscription'
    });
    
    if (!subscription) {
      return res.status(404).json({ message: 'Subscription not found' });
    }
    
    subscription.status = 'cancelled';
    await subscription.save();
    
    res.json({ message: 'Subscription cancelled successfully' });
  } catch (error) {
    console.error('Cancel subscription error:', error);
    res.status(500).json({ message: 'Server error', error: error.message });
  }
};

// Update subscription
exports.updateSubscription = async (req, res) => {
  try {
    const userId = req.user.id;
    const { subscriptionId } = req.params;
    const { deliveryFrequency, quantity } = req.body;
    
    const subscription = await Order.findOne({
      _id: subscriptionId,
      user: userId,
      status: 'subscription'
    }).populate('products.product');
    
    if (!subscription) {
      return res.status(404).json({ message: 'Subscription not found' });
    }
    
    if (deliveryFrequency) {
      subscription.deliveryFrequency = deliveryFrequency;
    }
    
    if (quantity) {
      subscription.products[0].quantity = quantity;
      // Recalculate totals
      const product = subscription.products[0];
      subscription.subtotal = product.price * quantity;
      subscription.tax = subscription.subtotal * 0.08;
      subscription.total = subscription.subtotal + subscription.shippingCost + subscription.tax;
    }
    
    await subscription.save();
    res.json({ message: 'Subscription updated successfully', subscription });
  } catch (error) {
    console.error('Update subscription error:', error);
    res.status(500).json({ message: 'Server error', error: error.message });
  }
};
