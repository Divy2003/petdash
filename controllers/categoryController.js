const Category = require('../models/Category');

// Helper: Check if user is admin (you can modify this based on your admin logic)
function isAdmin(user) {
  // For now, assuming admin is a specific userType or email
  // You can modify this logic based on your requirements
  return user && (user.userType === 'Admin' || user.email === 'admin@petdash.com');
}

// Create Category (Admin only)
exports.createCategory = async (req, res) => {
  try {
    if (!isAdmin(req.user)) {
      return res.status(403).json({ message: 'Only admin can create categories' });
    }

    const { name, description, icon, color, order } = req.body;
    
    const category = new Category({
      name,
      description,
      icon,
      color,
      order
    });

    await category.save();
    res.status(201).json({ 
      message: 'Category created successfully', 
      category 
    });
  } catch (error) {
    if (error.code === 11000) {
      return res.status(400).json({ message: 'Category name already exists' });
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

    const { name, description, icon, color, order, isActive } = req.body;
    
    const category = await Category.findByIdAndUpdate(
      req.params.id,
      { name, description, icon, color, order, isActive },
      { new: true, runValidators: true }
    );

    if (!category) {
      return res.status(404).json({ message: 'Category not found' });
    }

    res.status(200).json({ 
      message: 'Category updated successfully', 
      category 
    });
  } catch (error) {
    if (error.code === 11000) {
      return res.status(400).json({ message: 'Category name already exists' });
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
