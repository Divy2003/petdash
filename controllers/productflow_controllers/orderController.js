const Order = require('../../models/Order');
const Product = require('../../models/Product');

// Add to cart (add or update cart order for user)
exports.addToCart = async (req, res) => {
  try {
    const userId = req.user.id;
    const { productId, quantity, subscription } = req.body;
    const product = await Product.findById(productId);
    if (!product) return res.status(404).json({ message: 'Product not found' });
    // Find or create cart
    let cart = await Order.findOne({ user: userId, status: 'cart' });
    if (!cart) {
      cart = new Order({ user: userId, products: [], status: 'cart', total: 0 });
    }
    // Check if product already in cart
    const prodIndex = cart.products.findIndex(p => p.product.toString() === productId);
    if (prodIndex > -1) {
      cart.products[prodIndex].quantity += quantity;
      cart.products[prodIndex].subscription = subscription || false;
    } else {
      cart.products.push({
        product: productId,
        quantity,
        price: product.price,
        subscription: subscription || false    
      });
    }
    // Recalculate total
    cart.total = cart.products.reduce((sum, p) => sum + p.price * p.quantity, 0);
    await cart.save();
    res.json({ message: 'Added to cart', cart });
  } catch (error) {
    console.error('Add to cart error:', error);
    res.status(500).json({ message: 'Server error', error: error.message });
  }
};

// View cart
exports.getCart = async (req, res) => {
  try {
    const userId = req.user.id;
    const cart = await Order.findOne({ user: userId, status: 'cart' }).populate('products.product');
    if (!cart) return res.json({ cart: { products: [], total: 0 } });
    res.json({ cart });
  } catch (error) {
    console.error('Get cart error:', error);
    res.status(500).json({ message: 'Server error', error: error.message });
  }
};

// Checkout (create order from cart, mock payment)
exports.checkout = async (req, res) => {
  try {
    const userId = req.user.id;
    const { shippingAddress, paymentMethod } = req.body;
    let cart = await Order.findOne({ user: userId, status: 'cart' });
    if (!cart || cart.products.length === 0) {
      return res.status(400).json({ message: 'Cart is empty' });
    }
    // Mock payment
    const paymentSuccess = Math.random() > 0.2; // 80% chance success
    cart.status = paymentSuccess ? 'paid' : 'failed';
    cart.paymentStatus = paymentSuccess ? 'paid' : 'failed';
    cart.shippingAddress = shippingAddress;
    cart.paymentMethod = paymentMethod;
    await cart.save();
    // Remove cart (create new empty cart for user)
    if (paymentSuccess) {
      // Optionally, create a new empty cart for the user
      // await Order.create({ user: userId, products: [], status: 'cart', total: 0 });
      res.json({ message: 'Order placed successfully', order: cart });
    } else {
      res.status(402).json({ message: 'Payment failed', order: cart });
    }
  } catch (error) {
    console.error('Checkout error:', error);
    res.status(500).json({ message: 'Server error', error: error.message });
  }
};

// View orders (not cart)
exports.getOrders = async (req, res) => {
  try {
    const userId = req.user.id;
    const orders = await Order.find({ user: userId, status: { $ne: 'cart' } }).populate('products.product');
    res.json({ orders });
  } catch (error) {
    console.error('Get orders error:', error);
    res.status(500).json({ message: 'Server error', error: error.message });
  }
}; 