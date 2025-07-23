const Review = require('../models/Review');
const User = require('../models/User');
const multer = require('multer');
const path = require('path');

// Create a new review
exports.createReview = async (req, res) => {
  try {
    const { businessId, rating, reviewText, serviceId, appointmentId } = req.body;
    const reviewerId = req.user.id;
    
    // Validate user type - only Pet Owners can leave reviews
    const reviewer = await User.findById(reviewerId);
    if (!reviewer) {
      return res.status(404).json({ message: 'Reviewer not found' });
    }

    const reviewerCurrentRole = reviewer.currentRole || reviewer.userType;
    if (reviewerCurrentRole !== 'Pet Owner' && (!reviewer.availableRoles || !reviewer.availableRoles.includes('Pet Owner'))) {
      return res.status(403).json({
        message: 'Pet Owner access required to leave reviews'
      });
    }

    // Validate business exists and is a business account
    const business = await User.findById(businessId);
    if (!business) {
      return res.status(404).json({ message: 'Business not found' });
    }

    const businessCurrentRole = business.currentRole || business.userType;
    if (businessCurrentRole !== 'Business' && business.userType !== 'Business') {
      return res.status(404).json({
        message: 'Business not found'
      });
    }
    
    // Check if user has already reviewed this business
    const existingReview = await Review.findOne({ 
      reviewer: reviewerId, 
      business: businessId 
    });
    
    if (existingReview) {
      return res.status(400).json({ 
        message: 'You have already reviewed this business. Please edit your existing review instead.' 
      });
    }
    
    // Create review object
    const reviewData = {
      reviewer: reviewerId,
      business: businessId,
      rating,
      reviewText
    };
    
    // Add optional fields if provided
    if (serviceId) reviewData.service = serviceId;
    if (appointmentId) reviewData.appointment = appointmentId;
    
    // Add images if uploaded
    if (req.files && req.files.length > 0) {
      reviewData.images = req.files.map(file => file.path);
    }
    
    // Create and save the review
    const newReview = new Review(reviewData);
    await newReview.save();
    
    // Calculate new average rating for the business
    const ratingStats = await Review.calculateAverageRating(businessId);
    
    res.status(201).json({
      message: 'Review submitted successfully',
      review: newReview,
      businessRating: ratingStats
    });
    
  } catch (error) {
    console.error('Create review error:', error);
    res.status(500).json({ 
      message: 'Error creating review', 
      error: error.message 
    });
  }
};

// Get all reviews for a business
exports.getBusinessReviews = async (req, res) => {
  try {
    const { businessId } = req.params;
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 10;
    
    // Validate business exists
    const business = await User.findById(businessId);
    if (!business || business.userType !== 'Business') {
      return res.status(404).json({ 
        message: 'Business not found' 
      });
    }
    
    // Get reviews with pagination
    const reviews = await Review.find({ 
      business: businessId,
      isActive: true 
    })
    .populate('reviewer', 'name profileImage')
    .sort({ createdAt: -1 })
    .skip((page - 1) * limit)
    .limit(limit);
    
    // Get total count for pagination
    const totalReviews = await Review.countDocuments({ 
      business: businessId,
      isActive: true 
    });
    
    // Calculate average rating
    const ratingStats = await Review.calculateAverageRating(businessId);
    
    res.status(200).json({
      message: 'Reviews fetched successfully',
      reviews,
      pagination: {
        total: totalReviews,
        page,
        pages: Math.ceil(totalReviews / limit)
      },
      ratingStats
    });
    
  } catch (error) {
    console.error('Get business reviews error:', error);
    res.status(500).json({ 
      message: 'Error fetching reviews', 
      error: error.message 
    });
  }
};

// Get a specific review by ID
exports.getReviewById = async (req, res) => {
  try {
    const { reviewId } = req.params;
    
    const review = await Review.findById(reviewId)
      .populate('reviewer', 'name profileImage')
      .populate('business', 'name shopImage');
    
    if (!review) {
      return res.status(404).json({ 
        message: 'Review not found' 
      });
    }
    
    res.status(200).json({
      message: 'Review fetched successfully',
      review
    });
    
  } catch (error) {
    console.error('Get review error:', error);
    res.status(500).json({ 
      message: 'Error fetching review', 
      error: error.message 
    });
  }
};

// Update a review (only by the reviewer)
exports.updateReview = async (req, res) => {
  try {
    const { reviewId } = req.params;
    const { rating, reviewText } = req.body;
    const userId = req.user.id;
    
    // Find the review
    const review = await Review.findById(reviewId);
    
    if (!review) {
      return res.status(404).json({ 
        message: 'Review not found' 
      });
    }
    
    // Check if user is the reviewer
    if (review.reviewer.toString() !== userId) {
      return res.status(403).json({ 
        message: 'You can only edit your own reviews' 
      });
    }
    
    // Update review fields
    review.rating = rating || review.rating;
    review.reviewText = reviewText || review.reviewText;
    
    // Add new images if uploaded
    if (req.files && req.files.length > 0) {
      review.images = req.files.map(file => file.path);
    }
    
    await review.save();
    
    // Calculate new average rating for the business
    const ratingStats = await Review.calculateAverageRating(review.business);
    
    res.status(200).json({
      message: 'Review updated successfully',
      review,
      businessRating: ratingStats
    });
    
  } catch (error) {
    console.error('Update review error:', error);
    res.status(500).json({ 
      message: 'Error updating review', 
      error: error.message 
    });
  }
};

// Business response to a review (only by the business owner)
exports.respondToReview = async (req, res) => {
  try {
    const { reviewId } = req.params;
    const { responseText } = req.body;
    const userId = req.user.id;
    
    // Find the review
    const review = await Review.findById(reviewId);
    
    if (!review) {
      return res.status(404).json({ 
        message: 'Review not found' 
      });
    }
    
    // Check if user is the business owner
    if (review.business.toString() !== userId) {
      return res.status(403).json({ 
        message: 'Only the business owner can respond to this review' 
      });
    }
    
    // Add business response
    review.businessResponse = {
      responseText,
      responseDate: new Date()
    };
    
    await review.save();
    
    res.status(200).json({
      message: 'Response added successfully',
      review
    });
    
  } catch (error) {
    console.error('Respond to review error:', error);
    res.status(500).json({ 
      message: 'Error responding to review', 
      error: error.message 
    });
  }
};

// Delete a review (only by the reviewer or admin)
exports.deleteReview = async (req, res) => {
  try {
    const { reviewId } = req.params;
    const userId = req.user.id;
    
    // Find the review
    const review = await Review.findById(reviewId);
    
    if (!review) {
      return res.status(404).json({ 
        message: 'Review not found' 
      });
    }
    
    // Check if user is the reviewer
    if (review.reviewer.toString() !== userId) {
      return res.status(403).json({ 
        message: 'You can only delete your own reviews' 
      });
    }
    
    // Soft delete by marking as inactive
    review.isActive = false;
    await review.save();
    
    // Calculate new average rating for the business
    const ratingStats = await Review.calculateAverageRating(review.business);
    
    res.status(200).json({
      message: 'Review deleted successfully',
      businessRating: ratingStats
    });
    
  } catch (error) {
    console.error('Delete review error:', error);
    res.status(500).json({ 
      message: 'Error deleting review', 
      error: error.message 
    });
  }
};
