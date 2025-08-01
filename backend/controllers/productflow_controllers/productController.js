const Product = require('../../models/Product');
const User = require('../../models/User');

// Create a new product (Business only)
exports.createProduct = async (req, res) => {
  try {
    // Check current role for business access
    const currentRole = req.user.currentRole || req.user.userType;
    if (currentRole !== 'Business' && (!req.user.availableRoles || !req.user.availableRoles.includes('Business'))) {
      return res.status(403).json({ message: 'Business access required to create products.' });
    }
    const {
      name,
      description,
      price,
      images,
      stock,
      subscriptionAvailable,
      category,
      manufacturer,
      shippingCost,
      monthlyDeliveryPrice,
      brand,
      itemWeight,
      itemForm,
      ageRange,
      breedRecommendation,
      dietType
    } = req.body;

    const product = new Product({
      name,
      description,
      price,
      images,
      stock,
      business: req.user.id,
      subscriptionAvailable,
      category,
      manufacturer,
      shippingCost,
      monthlyDeliveryPrice,
      brand,
      itemWeight,
      itemForm,
      ageRange,
      breedRecommendation,
      dietType
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
    await Product.deleteOne({ _id: productId });
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
    // Check current role for business access
    const currentRole = req.user.currentRole || req.user.userType;
    if (currentRole !== 'Business' && (!req.user.availableRoles || !req.user.availableRoles.includes('Business'))) {
      return res.status(403).json({ message: 'Business access required to view products.' });
    }
    const products = await Product.find({ business: req.user.id }).sort({ createdAt: -1 });
    res.json({ products });
  } catch (error) {
    console.error('Get business products error:', error);
    res.status(500).json({ message: 'Server error', error: error.message });
  }
};

// Get products by category (public)
exports.getProductsByCategory = async (req, res) => {
  try {
    const { category } = req.params;
    const products = await Product.find({ category }).populate('business', 'name');
    res.json({ products });
  } catch (error) {
    console.error('Get products by category error:', error);
    res.status(500).json({ message: 'Server error', error: error.message });
  }
};

// Search products (public)
exports.searchProducts = async (req, res) => {
  try {
    const { q, category, minPrice, maxPrice } = req.query;
    let query = {};

    if (q) {
      query.$or = [
        { name: { $regex: q, $options: 'i' } },
        { description: { $regex: q, $options: 'i' } },
        { manufacturer: { $regex: q, $options: 'i' } },
        { brand: { $regex: q, $options: 'i' } }
      ];
    }

    if (category) {
      query.category = category;
    }

    if (minPrice || maxPrice) {
      query.price = {};
      if (minPrice) query.price.$gte = parseFloat(minPrice);
      if (maxPrice) query.price.$lte = parseFloat(maxPrice);
    }

    const products = await Product.find(query).populate('business', 'name');
    res.json({ products });
  } catch (error) {
    console.error('Search products error:', error);
    res.status(500).json({ message: 'Server error', error: error.message });
  }
};