const express = require('express');
const router = express.Router();
const courseController = require('../controllers/training/courseController');
const authMiddleware = require('../middlewares/auth');
const { requireAdmin, updateUserContext } = require('../middlewares/roleAuth');

// ==================== PUBLIC ROUTES ====================

// Get all active courses (with filters)
router.get('/', courseController.getAllCourses);

// Get course by ID
router.get('/:courseId', courseController.getCourseById);

// Get featured courses
router.get('/featured/list', courseController.getFeaturedCourses);

// Get popular courses
router.get('/popular/list', courseController.getPopularCourses);

// Get courses by category
router.get('/category/:category', courseController.getCoursesByCategory);

// Get course categories with counts
router.get('/categories/list', courseController.getCourseCategories);

// Get course reviews
router.get('/:courseId/reviews', courseController.getCourseReviews);

// ==================== PROTECTED ROUTES (Require Authentication) ====================

// Course enrollment
router.post('/:courseId/enroll', authMiddleware, updateUserContext, courseController.enrollInCourse);

// Get user's enrolled courses
router.get('/user/enrollments', authMiddleware, updateUserContext, courseController.getUserEnrollments);

// Get specific enrollment details
router.get('/enrollments/:enrollmentId', authMiddleware, updateUserContext, courseController.getEnrollmentDetails);

// Mark step as completed
router.put('/enrollments/:enrollmentId/steps/:stepId/complete', authMiddleware, updateUserContext, courseController.completeStep);

// Add course review and rating
router.post('/enrollments/:enrollmentId/review', authMiddleware, updateUserContext, courseController.addCourseReview);

// Get user's certificates
router.get('/user/certificates', authMiddleware, updateUserContext, courseController.getUserCertificates);

// Get user's earned badges
router.get('/user/badges', authMiddleware, updateUserContext, courseController.getUserBadges);

// Get user's learning analytics
router.get('/user/analytics', authMiddleware, updateUserContext, courseController.getUserLearningAnalytics);

// ==================== ADMIN ROUTES (Admin Only) ====================

// Create new course (Admin only)
router.post('/admin/create', authMiddleware, requireAdmin, courseController.createCourse);

// Update course (Admin only)
router.put('/admin/:courseId', authMiddleware, requireAdmin, courseController.updateCourse);

// Delete course (Admin only)
router.delete('/admin/:courseId', authMiddleware, requireAdmin, courseController.deleteCourse);

// Get all courses for admin management
router.get('/admin/all', authMiddleware, requireAdmin, courseController.getAllCoursesAdmin);

module.exports = router;
