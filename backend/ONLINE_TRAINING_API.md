# Online Training System API Documentation

## 🎯 Overview

The Online Training System provides comprehensive course management for pet training. It includes course creation for admins, enrollment for users, progress tracking, badges, certificates, and analytics.

## 🏗️ System Architecture

### Models
- **Course**: Training course information with steps, badges, and metadata
- **CourseEnrollment**: User enrollment and progress tracking
- **User**: Extended to include Admin user type for course management

### Key Features
- ✅ **Admin Course Management**: Create, update, delete courses
- ✅ **Online & Offline Training**: Support for both training types
- ✅ **Progress Tracking**: Step-by-step completion tracking
- ✅ **Badge System**: Achievement badges for milestones
- ✅ **Certificates**: Course completion certificates
- ✅ **Reviews & Ratings**: Course feedback system
- ✅ **Analytics**: Learning progress analytics

---

## 📋 API Endpoints

### Base URL: `/api/courses`

---

## 🔓 PUBLIC ENDPOINTS

### 1. Get All Courses
**GET** `/api/courses`

Get all active courses with filtering and pagination.

#### Query Parameters
- `page` (number): Page number (default: 1)
- `limit` (number): Items per page (default: 10)
- `category` (string): Filter by category
- `difficulty` (string): Filter by difficulty level
- `trainingType` (string): 'online' or 'offline' (default: 'online')
- `minPrice` (number): Minimum price filter
- `maxPrice` (number): Maximum price filter
- `search` (string): Search in title, description, tags
- `sortBy` (string): Sort field (default: 'createdAt')
- `sortOrder` (string): 'asc' or 'desc' (default: 'desc')

#### Response
```json
{
  "message": "Courses fetched successfully",
  "courses": [
    {
      "_id": "course_id",
      "title": "Puppy Basics",
      "description": "Complete guide to puppy training fundamentals",
      "shortDescription": "Essential puppy training for new pet owners",
      "category": "Puppy Basics",
      "difficulty": "Beginner",
      "difficultyLevel": 1,
      "price": 49,
      "originalPrice": 69,
      "duration": 180,
      "estimatedCompletionTime": "2-3 weeks",
      "coverImage": "https://example.com/image.jpg",
      "trainingType": "online",
      "isFeatured": true,
      "isPopular": true,
      "enrollmentCount": 150,
      "averageRating": 4.8,
      "totalReviews": 45,
      "learningObjectives": ["Basic commands", "House training"],
      "tags": ["puppy", "basic", "training"]
    }
  ],
  "pagination": {
    "currentPage": 1,
    "totalPages": 5,
    "totalCourses": 50,
    "hasNext": true,
    "hasPrev": false
  }
}
```

### 2. Get Course Details
**GET** `/api/courses/:courseId`

Get detailed course information including steps and badges.

#### Response
```json
{
  "message": "Course details fetched successfully",
  "course": {
    "_id": "course_id",
    "title": "Puppy Basics",
    "description": "Complete guide to puppy training fundamentals",
    "category": "Puppy Basics",
    "difficulty": "Beginner",
    "difficultyLevel": 1,
    "price": 49,
    "duration": 180,
    "coverImage": "https://example.com/image.jpg",
    "steps": [
      {
        "_id": "step_id",
        "title": "Getting Sally comfortable",
        "description": "Learn how to make your puppy feel safe",
        "content": "Creating a comfortable environment...",
        "videoUrl": "https://example.com/video.mp4",
        "imageUrl": "https://example.com/step-image.jpg",
        "duration": 15,
        "order": 1
      }
    ],
    "badges": [
      {
        "_id": "badge_id",
        "name": "Puppy Starter",
        "description": "Completed first puppy training lesson",
        "icon": "🐕",
        "color": "#FFD700",
        "criteria": "Complete first step"
      }
    ],
    "learningObjectives": ["Basic commands", "House training"],
    "prerequisites": []
  },
  "enrollmentStatus": null,
  "userProgress": null
}
```

### 3. Get Featured Courses
**GET** `/api/courses/featured/list`

#### Query Parameters
- `limit` (number): Number of courses (default: 6)
- `trainingType` (string): 'online' or 'offline' (default: 'online')

### 4. Get Popular Courses
**GET** `/api/courses/popular/list`

#### Query Parameters
- `limit` (number): Number of courses (default: 6)
- `trainingType` (string): 'online' or 'offline' (default: 'online')

### 5. Get Courses by Category
**GET** `/api/courses/category/:category`

#### Available Categories
- Puppy Basics
- Adult Basics
- Grooming
- Sitting
- Fetch
- Stay
- Shake
- Leash Training
- Re-enforcement

### 6. Get Course Categories
**GET** `/api/courses/categories/list`

Returns all categories with course counts and price ranges.

### 7. Get Course Reviews
**GET** `/api/courses/:courseId/reviews`

Get reviews and ratings for a specific course.

---

## 🔐 PROTECTED ENDPOINTS (Require Authentication)

### 8. Enroll in Course
**POST** `/api/courses/:courseId/enroll`

Enroll the authenticated user in a course.

#### Request Body
```json
{
  "paymentMethod": "card",
  "transactionId": "txn_123456789"
}
```

#### Response
```json
{
  "message": "Successfully enrolled in course",
  "enrollment": {
    "_id": "enrollment_id",
    "userId": "user_id",
    "courseId": "course_id",
    "enrolledAt": "2024-01-15T10:00:00.000Z",
    "status": "enrolled",
    "paymentStatus": "completed",
    "paymentAmount": 49,
    "progressPercentage": 0,
    "currentStep": 0
  }
}
```

### 9. Get User Enrollments
**GET** `/api/courses/user/enrollments`

Get all courses the user is enrolled in.

#### Query Parameters
- `status` (string): Filter by enrollment status
- `page` (number): Page number
- `limit` (number): Items per page

### 10. Get Enrollment Details
**GET** `/api/courses/enrollments/:enrollmentId`

Get detailed information about a specific enrollment.

### 11. Complete Step
**PUT** `/api/courses/enrollments/:enrollmentId/steps/:stepId/complete`

Mark a course step as completed.

#### Request Body
```json
{
  "timeSpent": 15,
  "notes": "Great lesson on puppy comfort"
}
```

#### Response
```json
{
  "message": "Step completed successfully",
  "enrollment": {
    "progressPercentage": 33,
    "currentStep": 1,
    "status": "in_progress",
    "completedSteps": 1,
    "earnedBadges": [
      {
        "badgeId": "badge_id",
        "badgeName": "Puppy Starter",
        "earnedAt": "2024-01-15T11:00:00.000Z"
      }
    ]
  }
}
```

### 12. Add Course Review
**POST** `/api/courses/enrollments/:enrollmentId/review`

Add a review and rating for a completed course.

#### Request Body
```json
{
  "rating": 5,
  "review": "Excellent course! Learned so much about puppy training."
}
```

### 13. Get User Certificates
**GET** `/api/courses/user/certificates`

Get all certificates earned by the user.

### 14. Get User Badges
**GET** `/api/courses/user/badges`

Get all badges earned by the user across all courses.

### 15. Get Learning Analytics
**GET** `/api/courses/user/analytics`

Get comprehensive learning analytics for the user.

#### Response
```json
{
  "message": "User learning analytics fetched successfully",
  "analytics": {
    "totalEnrollments": 5,
    "completedCourses": 3,
    "inProgressCourses": 2,
    "totalTimeSpent": 450,
    "totalBadgesEarned": 12,
    "averageProgress": 75,
    "categoryProgress": {
      "Puppy Basics": {
        "enrolled": 2,
        "completed": 1,
        "timeSpent": 180
      }
    }
  }
}
```

---

## 👑 ADMIN ENDPOINTS (Admin Only)

### 16. Create Course
**POST** `/api/courses/admin/create`

Create a new training course (Admin only).

#### Request Body
```json
{
  "title": "Advanced Dog Training",
  "description": "Comprehensive advanced training course",
  "shortDescription": "Advanced techniques for experienced trainers",
  "category": "Adult Basics",
  "difficulty": "Advanced",
  "difficultyLevel": 4,
  "price": 99,
  "originalPrice": 129,
  "duration": 300,
  "estimatedCompletionTime": "4-6 weeks",
  "coverImage": "https://example.com/cover.jpg",
  "trainingType": "online",
  "learningObjectives": [
    "Advanced obedience commands",
    "Behavioral problem solving"
  ],
  "steps": [
    {
      "title": "Advanced Commands",
      "description": "Learn complex commands",
      "content": "Detailed step content...",
      "duration": 30,
      "order": 1
    }
  ],
  "badges": [
    {
      "name": "Advanced Trainer",
      "description": "Completed advanced training",
      "icon": "🏆",
      "color": "#FFD700",
      "criteria": "Complete 100% of course"
    }
  ],
  "tags": ["advanced", "training", "obedience"],
  "isFeatured": true
}
```

### 17. Update Course
**PUT** `/api/courses/admin/:courseId`

Update an existing course (Admin only).

### 18. Delete Course
**DELETE** `/api/courses/admin/:courseId`

Soft delete a course (Admin only).

### 19. Get All Courses (Admin)
**GET** `/api/courses/admin/all`

Get all courses for admin management with additional filters.

---

## 🎯 Course Categories

The system supports the following training categories:

1. **Puppy Basics** - Fundamental puppy training
2. **Adult Basics** - Training for adult dogs
3. **Grooming** - Pet grooming techniques
4. **Sitting** - Sit command training
5. **Fetch** - Fetch game training
6. **Stay** - Stay command training
7. **Shake** - Shake/paw command training
8. **Leash Training** - Leash walking techniques
9. **Re-enforcement** - Positive reinforcement methods

## 🏆 Badge System

Badges are automatically awarded based on course progress:
- **Starter Badges**: Awarded when starting a course
- **Progress Badges**: Awarded at 50% completion
- **Completion Badges**: Awarded at 100% completion
- **Category Badges**: Awarded for completing courses in specific categories

## 📊 Progress Tracking

The system tracks:
- Step completion with timestamps
- Time spent on each step
- Overall course progress percentage
- User notes for each step
- Badge achievements
- Certificate generation

## 🔄 Training Types

- **Online Training**: Self-paced video courses
- **Offline Training**: Scheduled in-person sessions (future feature)

The Online Training System is now fully implemented and ready for use! 🚀
