const Category = require('../models/Category');
const User = require('../models/User');

// Helper: Check if user is admin (using current role)
async function isAdmin(user) {
  // Check if user has admin access
  const currentRole = user.currentRole || user.userType;
  return user && (currentRole === 'Admin' || user.userType === 'Admin');
}

// Create Category (Admin only)
exports.createCategory = async (req, res) => {
  try {
    if (!isAdmin(req.user)) {
      return res.status(403).json({ message: 'Only admin can create categories' });
    }

    const {
      name,
      description,
      shortDescription,
      icon,
      thumbnailImage,
      color,
      textColor,
      order,
      isFeatured,
      metaTitle,
      metaDescription,
      tags
    } = req.body;

    // Handle uploaded image
    let imageUrl = req.body.image;
    if (req.file) {
      // Serve as /uploads/filename
      imageUrl = `/uploads/${req.file.filename}`;
    }

    const category = new Category({
      name,
      description,
      shortDescription,
      icon,
      image: imageUrl,
      thumbnailImage,
      color,
      textColor,
      order: order || 0,
      isFeatured: isFeatured || false,
      metaTitle,
      metaDescription,
      tags: tags || [],
      createdBy: req.user._id
    });

    await category.save();

    // Populate creator info
    await category.populate('createdBy', 'name email');

    res.status(201).json({
      message: 'Category created successfully',
      category
    });
  } catch (error) {
    if (error.code === 11000) {
      const field = Object.keys(error.keyPattern)[0];
      return res.status(400).json({
        message: `Category ${field} already exists`,
        error: `A category with this ${field} already exists`
      });
    }
    res.status(500).json({
      message: 'Error creating category',
      error: error.message
    });
  }
};

// Get All Categories (Public - for displaying to users)
exports.getAllCategories = async (req, res) => {
  try {
    const categories = await Category.find({ isActive: true })
      .sort({ order: 1, name: 1 })
      .select('-createdAt -updatedAt');
    
    res.status(200).json({ 
      message: 'Categories fetched successfully', 
      categories 
    });
  } catch (error) {
    res.status(500).json({ 
      message: 'Error fetching categories', 
      error: error.message 
    });
  }
};

// Get All Categories for Admin (includes inactive)
exports.getAllCategoriesAdmin = async (req, res) => {
  try {
    if (!isAdmin(req.user)) {
      return res.status(403).json({ message: 'Only admin can access this endpoint' });
    }

    const categories = await Category.find()
      .sort({ order: 1, name: 1 });
    
    res.status(200).json({ 
      message: 'Categories fetched successfully', 
      categories 
    });
  } catch (error) {
    res.status(500).json({ 
      message: 'Error fetching categories', 
      error: error.message 
    });
  }
};

// Get Single Category
exports.getCategory = async (req, res) => {
  try {
    const category = await Category.findById(req.params.id);
    if (!category) {
      return res.status(404).json({ message: 'Category not found' });
    }
    
    res.status(200).json({ 
      message: 'Category fetched successfully', 
      category 
    });
  } catch (error) {
    res.status(500).json({ 
      message: 'Error fetching category', 
      error: error.message 
    });
  }
};

// Update Category (Admin only)
exports.updateCategory = async (req, res) => {
  try {
    if (!isAdmin(req.user)) {
      return res.status(403).json({ message: 'Only admin can update categories' });
    }

    const updateData = {};
    const allowedFields = [
      'name', 'description', 'shortDescription', 'icon', 'image', 'thumbnailImage',
      'color', 'textColor', 'order', 'isActive', 'isFeatured', 'metaTitle',
      'metaDescription', 'tags'
    ];

    // Only include fields that are provided in the request
    allowedFields.forEach(field => {
      if (req.body[field] !== undefined) {
        updateData[field] = req.body[field];
      }
    });

    // Handle uploaded image
    if (req.file) {
      // Serve as /uploads/filename
      updateData.image = `/uploads/${req.file.filename}`;
    }

    // Update timestamp
    updateData.updatedAt = Date.now();

    const category = await Category.findByIdAndUpdate(
      req.params.id,
      updateData,
      { new: true, runValidators: true }
    ).populate('createdBy', 'name email');

    if (!category) {
      return res.status(404).json({ message: 'Category not found' });
    }

    res.status(200).json({
      message: 'Category updated successfully',
      category
    });
  } catch (error) {
    if (error.code === 11000) {
      const field = Object.keys(error.keyPattern)[0];
      return res.status(400).json({
        message: `Category ${field} already exists`,
        error: `A category with this ${field} already exists`
      });
    }
    res.status(500).json({
      message: 'Error updating category',
      error: error.message
    });
  }
};

// Delete Category (Admin only)
exports.deleteCategory = async (req, res) => {
  try {
    if (!isAdmin(req.user)) {
      return res.status(403).json({ message: 'Only admin can delete categories' });
    }

    const category = await Category.findByIdAndDelete(req.params.id);
    if (!category) {
      return res.status(404).json({ message: 'Category not found' });
    }

    res.status(200).json({ 
      message: 'Category deleted successfully' 
    });
  } catch (error) {
    res.status(500).json({ 
      message: 'Error deleting category', 
      error: error.message 
    });
  }
};

// Seed default categories (Admin only)
exports.seedCategories = async (req, res) => {
  try {
    if (!isAdmin(req.user)) {
      return res.status(403).json({ message: 'Only admin can seed categories' });
    }

    const defaultCategories = [
      {
        name: 'Sitting',
        description: 'Pet sitting services for when you\'re away',
        icon: '🏠',
        color: '#e8f5e8',
        order: 1
      },
      {
        name: 'Health',
        description: 'Veterinary and health care services',
        icon: '🏥',
        color: '#e8f0ff',
        order: 2
      },
      {
        name: 'Boarding',
        description: 'Overnight pet boarding facilities',
        icon: '🏨',
        color: '#ffe8e8',
        order: 3
      },
      {
        name: 'Training',
        description: 'Pet training and behavior services',
        icon: '🎓',
        color: '#fff8e8',
        order: 4
      },
      {
        name: 'Grooming',
        description: 'Pet grooming and beauty services',
        icon: '✂️',
        color: '#f8e8ff',
        order: 5
      },
      {
        name: 'Walking',
        description: 'Dog walking and exercise services',
        icon: '🚶',
        color: '#e8fff8',
        order: 6
      }
    ];

    const createdCategories = [];
    for (const categoryData of defaultCategories) {
      try {
        const existingCategory = await Category.findOne({ name: categoryData.name });
        if (!existingCategory) {
          const category = new Category(categoryData);
          await category.save();
          createdCategories.push(category);
        }
      } catch (error) {
        console.log(`Category ${categoryData.name} already exists or error occurred`);
      }
    }

    res.status(201).json({ 
      message: 'Categories seeded successfully', 
      createdCategories 
    });
  } catch (error) {
    res.status(500).json({ 
      message: 'Error seeding categories', 
      error: error.message 
    });
  }
};
