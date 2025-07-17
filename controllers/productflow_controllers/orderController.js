const Order = require('../../models/Order');
const Product = require('../../models/Product');

// Add to cart (add or update cart order for user)
exports.addToCart = async (req, res) => {
  try {
    // Validate user authentication
    if (!req.user || !req.user.id) {
      return res.status(401).json({ message: 'Authentication required' });
    }

    const userId = req.user.id;
    const { productId, quantity, subscription } = req.body;

    // Validate required fields
    if (!productId) {
      return res.status(400).json({ message: 'Product ID is required' });
    }
    if (!quantity || quantity < 1) {
      return res.status(400).json({ message: 'Valid quantity is required' });
    }

    console.log('Adding to cart:', { userId, productId, quantity, subscription });

    // Find product
    const product = await Product.findById(productId);
    if (!product) {
      return res.status(404).json({ message: 'Product not found' });
    }

    console.log('Product found:', product.name);

    // Find or create cart
    let cart = await Order.findOne({ user: userId, status: 'cart' });
    if (!cart) {
      console.log('Creating new cart for user:', userId);
      cart = new Order({
        user: userId,
        products: [],
        status: 'cart',
        subtotal: 0,
        shippingCost: 0,
        tax: 0,
        total: 0
      });
    } else {
      console.log('Found existing cart with', cart.products.length, 'items');
      // Populate products for existing cart
      await cart.populate('products.product');
    }

    // Check if product already in cart
    const prodIndex = cart.products.findIndex(p => {
      if (cart.isNew) return false; // New cart, no products yet
      return p.product && p.product.toString() === productId;
    });

    if (prodIndex > -1) {
      console.log('Updating existing product in cart');
      cart.products[prodIndex].quantity += parseInt(quantity);
      cart.products[prodIndex].subscription = subscription || false;
    } else {
      console.log('Adding new product to cart');
      cart.products.push({
        product: productId,
        quantity: parseInt(quantity),
        price: product.price,
        subscription: subscription || false
      });
    }

    // Recalculate totals
    cart.subtotal = cart.products.reduce((sum, p) => sum + (p.price * p.quantity), 0);
    cart.shippingCost = product.shippingCost || 0;
    cart.tax = cart.subtotal * 0.08; // 8% tax rate
    cart.total = cart.subtotal + cart.shippingCost + cart.tax;

    console.log('Cart totals:', { subtotal: cart.subtotal, tax: cart.tax, total: cart.total });

    await cart.save();
    console.log('Cart saved successfully');

    // Populate the cart before sending response
    await cart.populate('products.product');

    res.json({ message: 'Added to cart successfully', cart });
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
    if (!cart) return res.json({ cart: { products: [], subtotal: 0, shippingCost: 0, tax: 0, total: 0 } });
    res.json({ cart });
  } catch (error) {
    console.error('Get cart error:', error);
    res.status(500).json({ message: 'Server error', error: error.message });
  }
};

// Update cart item quantity
exports.updateCartItem = async (req, res) => {
  try {
    const userId = req.user.id;
    const { productId, quantity } = req.body;

    if (quantity <= 0) {
      return res.status(400).json({ message: 'Quantity must be greater than 0' });
    }

    const cart = await Order.findOne({ user: userId, status: 'cart' }).populate('products.product');
    if (!cart) return res.status(404).json({ message: 'Cart not found' });

    const productIndex = cart.products.findIndex(p => p.product._id.toString() === productId);
    if (productIndex === -1) {
      return res.status(404).json({ message: 'Product not found in cart' });
    }

    cart.products[productIndex].quantity = quantity;

    // Recalculate totals
    cart.subtotal = cart.products.reduce((sum, p) => sum + p.price * p.quantity, 0);
    cart.shippingCost = cart.products.reduce((sum, p) => {
      const productShipping = p.product.shippingCost || 0;
      return sum + productShipping;
    }, 0);
    cart.tax = cart.subtotal * 0.08;
    cart.total = cart.subtotal + cart.shippingCost + cart.tax;

    await cart.save();
    res.json({ message: 'Cart updated successfully', cart });
  } catch (error) {
    console.error('Update cart item error:', error);
    res.status(500).json({ message: 'Server error', error: error.message });
  }
};

// Remove item from cart
exports.removeFromCart = async (req, res) => {
  try {
    const userId = req.user.id;
    const { productId } = req.params;

    const cart = await Order.findOne({ user: userId, status: 'cart' }).populate('products.product');
    if (!cart) return res.status(404).json({ message: 'Cart not found' });

    cart.products = cart.products.filter(p => p.product._id.toString() !== productId);

    // Recalculate totals
    cart.subtotal = cart.products.reduce((sum, p) => sum + p.price * p.quantity, 0);
    cart.shippingCost = cart.products.reduce((sum, p) => {
      const productShipping = p.product.shippingCost || 0;
      return sum + productShipping;
    }, 0);
    cart.tax = cart.subtotal * 0.08;
    cart.total = cart.subtotal + cart.shippingCost + cart.tax;

    await cart.save();
    res.json({ message: 'Item removed from cart', cart });
  } catch (error) {
    console.error('Remove from cart error:', error);
    res.status(500).json({ message: 'Server error', error: error.message });
  }
};

// Apply promo code
exports.applyPromoCode = async (req, res) => {
  try {
    const userId = req.user.id;
    const { promoCode } = req.body;

    const cart = await Order.findOne({ user: userId, status: 'cart' }).populate('products.product');
    if (!cart) return res.status(404).json({ message: 'Cart not found' });

    // Mock promo codes - in real app, you'd have a PromoCode model
    const validPromoCodes = {
      'SAVE10': { discount: 10, discountType: 'percentage' },
      'SAVE20': { discount: 20, discountType: 'percentage' },
      'FLAT5': { discount: 5, discountType: 'fixed' }
    };

    if (!validPromoCodes[promoCode]) {
      return res.status(400).json({ message: 'Invalid promo code' });
    }

    cart.promoCode = {
      code: promoCode,
      discount: validPromoCodes[promoCode].discount,
      discountType: validPromoCodes[promoCode].discountType
    };

    // Recalculate totals with discount
    cart.subtotal = cart.products.reduce((sum, p) => sum + p.price * p.quantity, 0);
    cart.shippingCost = cart.products.reduce((sum, p) => {
      const productShipping = p.product.shippingCost || 0;
      return sum + productShipping;
    }, 0);
    cart.tax = cart.subtotal * 0.08;

    let discount = 0;
    if (cart.promoCode.discountType === 'percentage') {
      discount = cart.subtotal * (cart.promoCode.discount / 100);
    } else {
      discount = cart.promoCode.discount;
    }

    cart.total = cart.subtotal + cart.shippingCost + cart.tax - discount;

    await cart.save();
    res.json({ message: 'Promo code applied successfully', cart, discount });
  } catch (error) {
    console.error('Apply promo code error:', error);
    res.status(500).json({ message: 'Server error', error: error.message });
  }
};

// Checkout (create order from cart, mock payment)
exports.checkout = async (req, res) => {
  try {
    const userId = req.user.id;
    const { shippingAddress, paymentMethod } = req.body;

    let cart = await Order.findOne({ user: userId, status: 'cart' }).populate('products.product');
    if (!cart || cart.products.length === 0) {
      return res.status(400).json({ message: 'Cart is empty' });
    }

    // Validate shipping address
    if (!shippingAddress || !shippingAddress.street || !shippingAddress.city || !shippingAddress.zipCode) {
      return res.status(400).json({ message: 'Complete shipping address is required' });
    }

    // Mock payment processing
    const paymentSuccess = Math.random() > 0.2; // 80% chance success

    cart.status = paymentSuccess ? 'paid' : 'failed';
    cart.paymentStatus = paymentSuccess ? 'paid' : 'failed';
    cart.shippingAddress = {
      street: shippingAddress.street,
      city: shippingAddress.city,
      state: shippingAddress.state,
      zipCode: shippingAddress.zipCode,
      country: shippingAddress.country || 'USA'
    };
    cart.paymentMethod = paymentMethod;

    await cart.save();

    if (paymentSuccess) {
      // Create a new empty cart for the user
      await Order.create({
        user: userId,
        products: [],
        status: 'cart',
        subtotal: 0,
        shippingCost: 0,
        tax: 0,
        total: 0
      });

      res.json({
        message: 'Order placed successfully',
        order: cart,
        orderNumber: cart.orderNumber
      });
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
    const orders = await Order.find({ user: userId, status: { $ne: 'cart' } })
      .populate('products.product')
      .sort({ createdAt: -1 });
    res.json({ orders });
  } catch (error) {
    console.error('Get orders error:', error);
    res.status(500).json({ message: 'Server error', error: error.message });
  }
};

// Get order details by order number
exports.getOrderDetails = async (req, res) => {
  try {
    const userId = req.user.id;
    const { orderNumber } = req.params;

    const order = await Order.findOne({
      user: userId,
      orderNumber: orderNumber,
      status: { $ne: 'cart' }
    }).populate('products.product');

    if (!order) {
      return res.status(404).json({ message: 'Order not found' });
    }

    res.json({ order });
  } catch (error) {
    console.error('Get order details error:', error);
    res.status(500).json({ message: 'Server error', error: error.message });
  }
};