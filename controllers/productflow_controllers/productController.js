const Product = require('../../models/Product');
const User = require('../../models/User');

// Create a new product (Business only)
exports.createProduct = async (req, res) => {
  try {
    if (req.user.userType !== 'Business') {
      return res.status(403).json({ message: 'Only businesses can create products.' });
    }
    const { name, description, price, images, stock, subscriptionAvailable, category } = req.body;
    const product = new Product({
      name,
      description,
      price,
      images,
      stock,
      business: req.user.id,
      subscriptionAvailable,
      category
    });
    await product.save();
    res.status(201).json({ message: 'Product created successfully', product });
  } catch (error) {
    console.error('Create product error:', error);
    res.status(500).json({ message: 'Server error', error: error.message });
  }
};

// Update a product (Business only)
exports.updateProduct = async (req, res) => {
  try {
    const { productId } = req.params;
    const product = await Product.findById(productId);
    if (!product) {
      return res.status(404).json({ message: 'Product not found' });
    }
    if (product.business.toString() !== req.user.id) {
      return res.status(403).json({ message: 'Not authorized to update this product' });
    }
    const updates = req.body;
    Object.assign(product, updates);
    await product.save();
    res.json({ message: 'Product updated successfully', product });
  } catch (error) {
    console.error('Update product error:', error);
    res.status(500).json({ message: 'Server error', error: error.message });
  }
};

// Delete a product (Business only)
exports.deleteProduct = async (req, res) => {
  try {
    const { productId } = req.params;
    const product = await Product.findById(productId);
    if (!product) {
      return res.status(404).json({ message: 'Product not found' });
    }
    if (product.business.toString() !== req.user.id) {
      return res.status(403).json({ message: 'Not authorized to delete this product' });
    }
    await product.remove();
    res.json({ message: 'Product deleted successfully' });
  } catch (error) {
    console.error('Delete product error:', error);
    res.status(500).json({ message: 'Server error', error: error.message });
  }
};

// Get all products (public)
exports.getAllProducts = async (req, res) => {
  try {
    const products = await Product.find().populate('business', 'name');
    res.json({ products });
  } catch (error) {
    console.error('Get all products error:', error);
    res.status(500).json({ message: 'Server error', error: error.message });
  }
};

// Get product by ID (public)
exports.getProductById = async (req, res) => {
  try {
    const { productId } = req.params;
    const product = await Product.findById(productId).populate('business', 'name');
    if (!product) {
      return res.status(404).json({ message: 'Product not found' });
    }
    res.json({ product });
  } catch (error) {
    console.error('Get product by id error:', error);
    res.status(500).json({ message: 'Server error', error: error.message });
  }
};

// Get products for a business (Business only)
exports.getBusinessProducts = async (req, res) => {
  try {
    if (req.user.userType !== 'Business') {
      return res.status(403).json({ message: 'Only businesses can view their products.' });
    }
    const products = await Product.find({ business: req.user.id });
    res.json({ products });
  } catch (error) {
    console.error('Get business products error:', error);
    res.status(500).json({ message: 'Server error', error: error.message });
  }
}; 