# Review System API Documentation

## Overview
The review system allows pet owners to leave reviews for businesses and enables businesses to respond to reviews. Only users with userType "Pet Owner" can create reviews, and only businesses can respond to reviews about their services.

## Features
- ✅ Pet owners can create reviews for businesses
- ✅ Businesses can respond to reviews
- ✅ Image uploads for reviews (up to 5 images)
- ✅ Rating system (1-5 stars)
- ✅ Average rating calculation
- ✅ Review pagination
- ✅ One review per user per business
- ✅ Soft delete functionality

## API Endpoints

### 1. Create Review
**POST** `/api/review/create`

**Authentication:** Required (Pet Owner only)

**Body:**
```json
{
  "businessId": "64a1b2c3d4e5f6789012345",
  "rating": 5,
  "reviewText": "Excellent service! My dog loved the grooming session.",
  "serviceId": "64a1b2c3d4e5f6789012346", // Optional
  "appointmentId": "64a1b2c3d4e5f6789012347" // Optional
}
```

**Files:** `images` (optional, max 5 files, 5MB each)

**Response:**
```json
{
  "message": "Review submitted successfully",
  "review": {
    "_id": "64a1b2c3d4e5f6789012348",
    "reviewer": "64a1b2c3d4e5f6789012349",
    "business": "64a1b2c3d4e5f6789012345",
    "rating": 5,
    "reviewText": "Excellent service!",
    "images": ["uploads/review-1234567890.jpg"],
    "createdAt": "2024-01-15T10:30:00.000Z"
  },
  "businessRating": {
    "averageRating": 4.8,
    "totalReviews": 25
  }
}
```

### 2. Get Business Reviews
**GET** `/api/review/business/:businessId?page=1&limit=10`

**Authentication:** Not required

**Response:**
```json
{
  "message": "Reviews fetched successfully",
  "reviews": [
    {
      "_id": "64a1b2c3d4e5f6789012348",
      "reviewer": {
        "_id": "64a1b2c3d4e5f6789012349",
        "name": "John Doe",
        "profileImage": "uploads/profile-123.jpg"
      },
      "rating": 5,
      "reviewText": "Excellent service!",
      "images": ["uploads/review-1234567890.jpg"],
      "businessResponse": {
        "responseText": "Thank you for your feedback!",
        "responseDate": "2024-01-16T09:00:00.000Z"
      },
      "createdAt": "2024-01-15T10:30:00.000Z"
    }
  ],
  "pagination": {
    "total": 25,
    "page": 1,
    "pages": 3
  },
  "ratingStats": {
    "averageRating": 4.8,
    "totalReviews": 25
  }
}
```

### 3. Get Single Review
**GET** `/api/review/:reviewId`

**Authentication:** Not required

**Response:**
```json
{
  "message": "Review fetched successfully",
  "review": {
    "_id": "64a1b2c3d4e5f6789012348",
    "reviewer": {
      "_id": "64a1b2c3d4e5f6789012349",
      "name": "John Doe",
      "profileImage": "uploads/profile-123.jpg"
    },
    "business": {
      "_id": "64a1b2c3d4e5f6789012345",
      "name": "Pet Grooming Plus",
      "shopImage": "uploads/shop-456.jpg"
    },
    "rating": 5,
    "reviewText": "Excellent service!",
    "images": ["uploads/review-1234567890.jpg"],
    "createdAt": "2024-01-15T10:30:00.000Z"
  }
}
```

### 4. Update Review
**PUT** `/api/review/update/:reviewId`

**Authentication:** Required (Review owner only)

**Body:**
```json
{
  "rating": 4,
  "reviewText": "Updated review text"
}
```

**Files:** `images` (optional, max 5 files, 5MB each)

**Response:**
```json
{
  "message": "Review updated successfully",
  "review": {
    "_id": "64a1b2c3d4e5f6789012348",
    "rating": 4,
    "reviewText": "Updated review text",
    "updatedAt": "2024-01-16T11:00:00.000Z"
  },
  "businessRating": {
    "averageRating": 4.7,
    "totalReviews": 25
  }
}
```

### 5. Business Response to Review
**POST** `/api/review/respond/:reviewId`

**Authentication:** Required (Business owner only)

**Body:**
```json
{
  "responseText": "Thank you for your feedback! We're glad you enjoyed our service."
}
```

**Response:**
```json
{
  "message": "Response added successfully",
  "review": {
    "_id": "64a1b2c3d4e5f6789012348",
    "businessResponse": {
      "responseText": "Thank you for your feedback!",
      "responseDate": "2024-01-16T09:00:00.000Z"
    }
  }
}
```

### 6. Delete Review
**DELETE** `/api/review/delete/:reviewId`

**Authentication:** Required (Review owner only)

**Response:**
```json
{
  "message": "Review deleted successfully",
  "businessRating": {
    "averageRating": 4.6,
    "totalReviews": 24
  }
}
```

## Business Profile Integration

Business profiles now include review statistics:

**GET** `/api/business/profile/:businessId`

**Response includes:**
```json
{
  "business": {
    "_id": "64a1b2c3d4e5f6789012345",
    "name": "Pet Grooming Plus",
    "averageRating": 4.8,
    "totalReviews": 25,
    // ... other business fields
  }
}
```

## Error Responses

### 400 Bad Request
```json
{
  "message": "You have already reviewed this business. Please edit your existing review instead."
}
```

### 403 Forbidden
```json
{
  "message": "Only pet owners can leave reviews"
}
```

### 404 Not Found
```json
{
  "message": "Business not found"
}
```

## Database Schema

### Review Model
```javascript
{
  reviewer: ObjectId (ref: User),
  business: ObjectId (ref: User),
  rating: Number (1-5),
  reviewText: String (max 1000 chars),
  images: [String],
  service: ObjectId (ref: Service, optional),
  appointment: ObjectId (ref: Appointment, optional),
  isActive: Boolean,
  businessResponse: {
    responseText: String (max 500 chars),
    responseDate: Date
  },
  createdAt: Date,
  updatedAt: Date
}
```

## Usage Notes

1. **One Review Per Business:** Each pet owner can only leave one review per business
2. **Image Uploads:** Reviews support up to 5 images, 5MB each
3. **Soft Delete:** Reviews are soft-deleted (marked as inactive) rather than permanently removed
4. **Rating Calculation:** Average ratings are calculated in real-time and rounded to 1 decimal place
5. **Authentication:** Pet owners can create/edit reviews, businesses can respond to reviews
6. **Pagination:** Review lists support pagination with configurable page size
