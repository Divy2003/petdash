const User = require('../models/User');
const Service = require('../models/Service');
const Category = require('../models/Category');
const Review = require('../models/Review');

// Get businesses by category
exports.getBusinessesByCategory = async (req, res) => {
  try {
    const { categoryId } = req.params;
    const { page = 1, limit = 10, city, state, zipCode } = req.query;

    // Verify category exists
    const category = await Category.findById(categoryId);
    if (!category) {
      return res.status(404).json({ message: 'Category not found' });
    }

    // Build location filter
    let locationFilter = {};
    if (city) locationFilter.city = new RegExp(city, 'i');
    if (state) locationFilter.state = new RegExp(state, 'i');
    if (zipCode) locationFilter.zipCode = zipCode;

    // Find services in this category
    const services = await Service.find({
      category: categoryId,
      isActive: true
    }).populate('business', '_id');

    // Get unique business IDs
    const businessIds = [...new Set(services.map(service => service.business && service.business._id ? service.business._id.toString() : null).filter(Boolean))];

    // Build business filter
    const businessFilter = {
      _id: { $in: businessIds },
      userType: 'Business',
      ...locationFilter
    };

    // Get businesses with pagination
    const businesses = await User.find(businessFilter)
      .select('-password -resetPasswordToken -resetPasswordExpires')
      .limit(limit * 1)
      .skip((page - 1) * limit)
      .sort({ name: 1 });

    // Get total count for pagination
    const total = await User.countDocuments(businessFilter);

    // For each business, get their services in this category and review statistics
    const businessesWithServices = await Promise.all(
      businesses.map(async (business) => {
        const businessServices = await Service.find({
          business: business._id,
          category: categoryId,
          isActive: true
        }).select('title description price images');

        // Get review statistics for this business
        const reviewStats = await Review.calculateAverageRating(business._id);

        return {
          ...business.toObject(),
          services: businessServices,
          serviceCount: businessServices.length,
          averageRating: reviewStats.averageRating,
          totalReviews: reviewStats.totalReviews
        };
      })
    );

    res.status(200).json({
      message: 'Businesses fetched successfully',
      category: {
        id: category._id,
        name: category.name,
        description: category.description
      },
      businesses: businessesWithServices,
      pagination: {
        currentPage: parseInt(page),
        totalPages: Math.ceil(total / limit),
        totalBusinesses: total,
        hasNext: page < Math.ceil(total / limit),
        hasPrev: page > 1
      }
    });
  } catch (error) {
    res.status(500).json({
      message: 'Error fetching businesses',
      error: error.message
    });
  }
};

// Get detailed business profile with all services
exports.getBusinessProfile = async (req, res) => {
  try {
    const { businessId } = req.params;

    // Get business details
    const business = await User.findOne({
      _id: businessId,
      userType: 'Business'
    }).select('-password -resetPasswordToken -resetPasswordExpires');

    if (!business) {
      return res.status(404).json({ message: 'Business not found' });
    }

    // Get all services offered by this business
    const services = await Service.find({
      business: businessId,
      isActive: true
    }).populate('category', 'name description icon color');

    // Group services by category
    const servicesByCategory = services.reduce((acc, service) => {
      const categoryName = service.category.name;
      if (!acc[categoryName]) {
        acc[categoryName] = {
          category: service.category,
          services: []
        };
      }
      acc[categoryName].services.push({
        _id: service._id,
        title: service.title,
        description: service.description,
        serviceIncluded: service.serviceIncluded,
        notes: service.notes,
        price: service.price,
        images: service.images,
        availableFor: service.availableFor
      });
      return acc;
    }, {});

    // Get review statistics for this business
    const reviewStats = await Review.calculateAverageRating(businessId);

    res.status(200).json({
      message: 'Business profile fetched successfully',
      business: {
        ...business.toObject(),
        totalServices: services.length,
        categoriesOffered: Object.keys(servicesByCategory).length,
        averageRating: reviewStats.averageRating,
        totalReviews: reviewStats.totalReviews
      },
      servicesByCategory
    });
  } catch (error) {
    res.status(500).json({
      message: 'Error fetching business profile',
      error: error.message
    });
  }
};

// Search businesses across all categories
exports.searchBusinesses = async (req, res) => {
  try {
    const { 
      query, 
      category, 
      city, 
      state, 
      zipCode, 
      page = 1, 
      limit = 10 
    } = req.query;

    // Build search filters
    let businessFilter = { userType: 'Business' };
    let serviceFilter = { isActive: true };

    // Location filters
    if (city) businessFilter.city = new RegExp(city, 'i');
    if (state) businessFilter.state = new RegExp(state, 'i');
    if (zipCode) businessFilter.zipCode = zipCode;

    // Category filter
    if (category) {
      const categoryDoc = await Category.findOne({ 
        name: new RegExp(category, 'i') 
      });
      if (categoryDoc) {
        serviceFilter.category = categoryDoc._id;
      }
    }

    // Text search in business name or service title/description
    if (query) {
      const businessIds = await User.find({
        ...businessFilter,
        name: new RegExp(query, 'i')
      }).distinct('_id');

      const serviceBusinessIds = await Service.find({
        ...serviceFilter,
        $or: [
          { title: new RegExp(query, 'i') },
          { description: new RegExp(query, 'i') }
        ]
      }).distinct('business');

      const allBusinessIds = [...new Set([...businessIds, ...serviceBusinessIds])];
      businessFilter._id = { $in: allBusinessIds };
    } else if (category) {
      // If only category filter, get businesses that have services in that category
      const serviceBusinessIds = await Service.find(serviceFilter).distinct('business');
      businessFilter._id = { $in: serviceBusinessIds };
    }

    // Get businesses with pagination
    const businesses = await User.find(businessFilter)
      .select('-password -resetPasswordToken -resetPasswordExpires')
      .limit(limit * 1)
      .skip((page - 1) * limit)
      .sort({ name: 1 });

    const total = await User.countDocuments(businessFilter);

    // Get services and reviews for each business
    const businessesWithServices = await Promise.all(
      businesses.map(async (business) => {
        const businessServices = await Service.find({
          business: business._id,
          isActive: true,
          ...(category && serviceFilter.category ? { category: serviceFilter.category } : {})
        }).populate('category', 'name icon color')
          .select('title description price images category');

        // Get review statistics for this business
        const reviewStats = await Review.calculateAverageRating(business._id);

        return {
          ...business.toObject(),
          services: businessServices,
          serviceCount: businessServices.length,
          averageRating: reviewStats.averageRating,
          totalReviews: reviewStats.totalReviews
        };
      })
    );

    res.status(200).json({
      message: 'Search results fetched successfully',
      businesses: businessesWithServices,
      searchParams: { query, category, city, state, zipCode },
      pagination: {
        currentPage: parseInt(page),
        totalPages: Math.ceil(total / limit),
        totalBusinesses: total,
        hasNext: page < Math.ceil(total / limit),
        hasPrev: page > 1
      }
    });
  } catch (error) {
    res.status(500).json({
      message: 'Error searching businesses',
      error: error.message
    });
  }
};
