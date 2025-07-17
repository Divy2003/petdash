# Article/Blog System API Documentation

## Overview
The article system allows business owners to create, edit, and delete blog articles, while pet users can read, like, and comment on articles. This creates an engaging content platform for pet care knowledge sharing.

## Features
- ✅ Business owners can create, edit, delete articles
- ✅ Pet users can read and like articles
- ✅ Image uploads for articles (featured image + additional images)
- ✅ Article categories and tags
- ✅ Related products linking
- ✅ Draft/Published status system
- ✅ View tracking and engagement metrics
- ✅ Search and filtering capabilities
- ✅ Trending articles


## API Endpoints

### Public Endpoints (No Authentication)

#### 1. Get Published Articles
**GET** `/api/article/published?page=1&limit=10&category=Pet Care&tags=training,health&search=dog&author=businessId`

**Response:**
```json
{
  "message": "Articles fetched successfully",
  "articles": [
    {
      "_id": "64a1b2c3d4e5f6789012345",
      "title": "How to Train Your Puppy",
      "category": "Training Tips",
      "excerpt": "Essential tips for puppy training...",
      "featuredImage": "uploads/article-1234567890.jpg",
      "author": {
        "_id": "64a1b2c3d4e5f6789012346",
        "name": "Pet Training Pro",
        "shopImage": "uploads/shop-123.jpg"
      },
      "tags": ["training", "puppy", "behavior"],
      "views": 150,
      "likeCount": 25,
      "commentCount": 8,
      "publishedAt": "2024-01-15T10:30:00.000Z"
    }
  ],
  "pagination": {
    "total": 50,
    "page": 1,
    "pages": 5,
    "hasNext": true,
    "hasPrev": false
  }
}
```

#### 2. Get Single Article
**GET** `/api/article/:articleId`

**Response:**
```json
{
  "message": "Article fetched successfully",
  "article": {
    "_id": "64a1b2c3d4e5f6789012345",
    "title": "How to Train Your Puppy",
    "category": "Training Tips",
    "body": "Full article content here...",
    "excerpt": "Essential tips for puppy training...",
    "featuredImage": "uploads/article-1234567890.jpg",
    "images": ["uploads/article-img1.jpg", "uploads/article-img2.jpg"],
    "author": {
      "_id": "64a1b2c3d4e5f6789012346",
      "name": "Pet Training Pro",
      "shopImage": "uploads/shop-123.jpg",
      "email": "trainer@petpro.com",
      "phoneNumber": "+1234567890"
    },
    "tags": ["training", "puppy", "behavior"],
    "relatedProducts": [
      {
        "_id": "64a1b2c3d4e5f6789012347",
        "name": "Training Treats",
        "price": 15.99,
        "images": ["uploads/product-123.jpg"]
      }
    ],
    "views": 151,
    "likes": [
      {
        "user": "64a1b2c3d4e5f6789012348",
        "likedAt": "2024-01-16T09:00:00.000Z"
      }
    ],
    "publishedAt": "2024-01-15T10:30:00.000Z"
  }
}
```

#### 3. Get Article Categories
**GET** `/api/article/meta/categories`

**Response:**
```json
{
  "message": "Categories fetched successfully",
  "categories": [
    "Pet Care",
    "Training Tips",
    "Health & Wellness",
    "Nutrition",
    "Grooming",
    "Behavior",
    "Safety",
    "Product Reviews",
    "Seasonal Care",
    "Emergency Care",
    "General"
  ]
}
```

#### 4. Get Trending Articles
**GET** `/api/article/meta/trending?limit=5`

**Response:**
```json
{
  "message": "Trending articles fetched successfully",
  "articles": [
    {
      "_id": "64a1b2c3d4e5f6789012345",
      "title": "How to Train Your Puppy",
      "excerpt": "Essential tips for puppy training...",
      "featuredImage": "uploads/article-1234567890.jpg",
      "views": 150,
      "likes": 25,
      "publishedAt": "2024-01-15T10:30:00.000Z",
      "author": {
        "name": "Pet Training Pro",
        "shopImage": "uploads/shop-123.jpg"
      },
      "category": "Training Tips"
    }
  ]
}
```

### Protected Endpoints (Authentication Required)

#### 5. Create Article
**POST** `/api/article/create`

**Authentication:** Required (Business owners only)

**Body (multipart/form-data):**
```
title: "How to Train Your Puppy"
category: "Training Tips"
body: "Full article content here..."
excerpt: "Essential tips for puppy training..."
tags: ["training", "puppy", "behavior"]
relatedProducts: ["64a1b2c3d4e5f6789012347"]
status: "published" // or "draft"
featuredImage: [file]
images: [file1, file2]
```

**Response:**
```json
{
  "message": "Article created successfully",
  "article": {
    "_id": "64a1b2c3d4e5f6789012345",
    "title": "How to Train Your Puppy",
    "category": "Training Tips",
    "body": "Full article content here...",
    "status": "published",
    "author": {
      "_id": "64a1b2c3d4e5f6789012346",
      "name": "Pet Training Pro",
      "shopImage": "uploads/shop-123.jpg"
    },
    "createdAt": "2024-01-15T10:30:00.000Z"
  }
}
```

#### 6. Get My Articles
**GET** `/api/article/my/articles?page=1&limit=10&status=published&category=Pet Care`

**Authentication:** Required (Business owners only)

**Response:**
```json
{
  "message": "My articles fetched successfully",
  "articles": [
    {
      "_id": "64a1b2c3d4e5f6789012345",
      "title": "How to Train Your Puppy",
      "category": "Training Tips",
      "status": "published",
      "views": 150,
      "likeCount": 25,
      "commentCount": 8,
      "createdAt": "2024-01-15T10:30:00.000Z",
      "publishedAt": "2024-01-15T10:30:00.000Z"
    }
  ],
  "pagination": {
    "total": 10,
    "page": 1,
    "pages": 1
  }
}
```

#### 7. Update Article
**PUT** `/api/article/update/:articleId`

**Authentication:** Required (Author only)

**Body (multipart/form-data):**
```
title: "Updated Article Title"
category: "Training Tips"
body: "Updated article content..."
status: "published"
featuredImage: [file] // optional
images: [file1, file2] // optional
```

**Response:**
```json
{
  "message": "Article updated successfully",
  "article": {
    "_id": "64a1b2c3d4e5f6789012345",
    "title": "Updated Article Title",
    "updatedAt": "2024-01-16T12:00:00.000Z"
  }
}
```

#### 8. Delete Article
**DELETE** `/api/article/delete/:articleId`

**Authentication:** Required (Author only)

**Response:**
```json
{
  "message": "Article deleted successfully"
}
```

#### 9. Like/Unlike Article
**POST** `/api/article/like/:articleId`

**Authentication:** Required

**Response:**
```json
{
  "message": "Article liked",
  "liked": true,
  "likeCount": 26
}
```

#### 10. Add Comment
**POST** `/api/article/comment/:articleId`

**Authentication:** Required

**Body:**
```json
{
  "comment": "Great article! Very helpful tips."
}
```

**Response:**
```json
{
  "message": "Comment added successfully",
  "comment": {
    "_id": "64a1b2c3d4e5f6789012349",
    "user": {
      "_id": "64a1b2c3d4e5f6789012348",
      "name": "John Doe",
      "profileImage": "uploads/profile-123.jpg"
    },
    "comment": "Great article! Very helpful tips.",
    "commentedAt": "2024-01-16T11:00:00.000Z"
  },
  "commentCount": 9
}
```

## Error Responses

### 403 Forbidden
```json
{
  "message": "Only business owners can create articles"
}
```

### 404 Not Found
```json
{
  "message": "Article not found"
}
```



## Database Schema

### Article Model
```javascript
{
  author: ObjectId (ref: User),
  title: String (max 200 chars),
  category: String (enum),
  body: String (max 10000 chars),
  tags: [String],
  relatedProducts: [ObjectId] (ref: Product),
  featuredImage: String,
  images: [String],
  status: String (draft/published/archived),
  excerpt: String (max 500 chars),
  views: Number,
  likes: [{
    user: ObjectId (ref: User),
    likedAt: Date
  }],
  publishedAt: Date,
  isActive: Boolean,
  createdAt: Date,
  updatedAt: Date
}
```

## Usage Flow

### For Business Owners:
1. **Create Article** → Draft or publish immediately
2. **Manage Articles** → View, edit, delete own articles
3. **Track Performance** → Monitor views and likes

### For Pet Users:
1. **Browse Articles** → Filter by category, search, trending
2. **Read Articles** → Full content with related products
3. **Engage** → Like articles
4. **Discover** → Find businesses through quality content

## Key Features

1. **Content Management** - Full CRUD operations for business owners
2. **Engagement** - Likes and view tracking
3. **Discovery** - Search, filtering, trending articles
4. **Media Support** - Featured images and additional images
5. **Product Integration** - Link related products to articles
6. **SEO Friendly** - Excerpts, tags, categories for better discoverability
