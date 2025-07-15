# PetDash Backend API Documentation

## Appointment Management System

### Overview
The appointment management system allows pet owners to book appointments with service providers and automatically sends email confirmations to both parties.

### Appointment Endpoints

#### 1. Create Appointment
**POST** `/api/appointment/create`

Creates a new appointment booking and sends confirmation emails to both customer and business.

**Headers:**
```
Authorization: Bearer <jwt_token>
Content-Type: application/json
```

**Request Body:**
```json
{
  "businessId": "64a1b2c3d4e5f6789012345a",
  "serviceId": "64a1b2c3d4e5f6789012345b",
  "petId": "64a1b2c3d4e5f6789012345c",
  "appointmentDate": "2024-05-20",
  "appointmentTime": "11:00 AM",
  "addOnServices": [
    {
      "name": "Nail Trimming",
      "price": 15
    }
  ],
  "subtotal": 80,
  "tax": 20,
  "total": 100,
  "notes": "Pet is nervous around strangers",
  "couponCode": "SAVE10"
}
```

**Response:**
```json
{
  "message": "Appointment created successfully",
  "appointment": {
    "_id": "64a1b2c3d4e5f6789012345d",
    "bookingId": "APT17524859528611234",
    "status": "upcoming",
    "emailSent": true,
    "createdAt": "2024-01-15T10:30:00.000Z"
  },
  "emailSent": true
}
```

#### 2. Get Customer Appointments
**GET** `/api/appointment/customer`

Retrieves all appointments for the logged-in customer (pet owner).

**Headers:**
```
Authorization: Bearer <jwt_token>
```

#### 3. Get Business Appointments
**GET** `/api/appointment/business`

Retrieves all appointments for the logged-in business owner.

**Headers:**
```
Authorization: Bearer <jwt_token>
```

#### 4. Get Appointment Details
**GET** `/api/appointment/:appointmentId`

Retrieves detailed information about a specific appointment.

#### 5. Update Appointment Status
**PUT** `/api/appointment/:appointmentId/status`

Updates the status of an appointment (upcoming, completed, cancelled).

**Request Body:**
```json
{
  "status": "completed"
}
```

### Email Notifications

The appointment system automatically sends email notifications:

1. **Customer Confirmation Email**: Sent to the pet owner with booking details
2. **Business Notification Email**: Sent to the service provider with customer and pet details

Both emails include booking ID, appointment details, contact information, and service specifics.

---

## Category Management System

### Overview
The category management system allows admins to manage service categories (like Sitting, Health, Boarding, Training, Grooming, Walking) and enables users to discover businesses by category.

## API Endpoints

### 1. Category Management (Admin)

#### Create Category
```
POST /api/category/create
Authorization: Bearer <admin_token>
Content-Type: application/json

{
  "name": "Grooming",
  "description": "Pet grooming and beauty services",
  "icon": "✂️",
  "color": "#f8e8ff",
  "order": 5
}
```

#### Get All Categories (Public)
```
GET /api/category/public
```

#### Get All Categories (Admin)
```
GET /api/category/admin/all
Authorization: Bearer <admin_token>
```

#### Update Category
```
PUT /api/category/update/:categoryId
Authorization: Bearer <admin_token>
Content-Type: application/json

{
  "name": "Updated Name",
  "description": "Updated description",
  "isActive": true
}
```

#### Delete Category
```
DELETE /api/category/delete/:categoryId
Authorization: Bearer <admin_token>
```

#### Seed Default Categories
```
POST /api/category/seed
Authorization: Bearer <admin_token>
```

### 2. Business Discovery

#### Get Businesses by Category
```
GET /api/business/category/:categoryId?page=1&limit=10&city=NewYork&state=NY&zipCode=10001
```

Response:
```json
{
  "message": "Businesses fetched successfully",
  "category": {
    "id": "categoryId",
    "name": "Grooming",
    "description": "Pet grooming and beauty services"
  },
  "businesses": [
    {
      "_id": "businessId",
      "name": "Pet Spa NYC",
      "email": "contact@petspa.com",
      "phoneNumber": "555-0123",
      "city": "New York",
      "state": "NY",
      "services": [
        {
          "_id": "serviceId",
          "title": "Full Grooming Package",
          "description": "Complete grooming service",
          "price": "$50-80",
          "images": ["image1.jpg"]
        }
      ],
      "serviceCount": 1
    }
  ],
  "pagination": {
    "currentPage": 1,
    "totalPages": 5,
    "totalBusinesses": 45,
    "hasNext": true,
    "hasPrev": false
  }
}
```

#### Get Business Profile with All Services
```
GET /api/business/profile/:businessId
```

Response:
```json
{
  "message": "Business profile fetched successfully",
  "business": {
    "_id": "businessId",
    "name": "Pet Spa NYC",
    "email": "contact@petspa.com",
    "phoneNumber": "555-0123",
    "streetName": "123 Main St",
    "city": "New York",
    "state": "NY",
    "zipCode": "10001",
    "totalServices": 5,
    "categoriesOffered": 3
  },
  "servicesByCategory": {
    "Grooming": {
      "category": {
        "_id": "categoryId",
        "name": "Grooming",
        "description": "Pet grooming and beauty services",
        "icon": "✂️",
        "color": "#f8e8ff"
      },
      "services": [
        {
          "_id": "serviceId",
          "title": "Full Grooming Package",
          "description": "Complete grooming service",
          "price": "$50-80"
        }
      ]
    }
  }
}
```

#### Search Businesses
```
GET /api/business/search?query=grooming&category=Grooming&city=NewYork&page=1&limit=10
```

### 3. Enhanced Service Management

#### Create Service (Now requires category)
```
POST /api/service/create
Authorization: Bearer <business_token>
Content-Type: multipart/form-data

{
  "category": "categoryId",
  "title": "Dog Walking Service",
  "description": "Professional dog walking",
  "price": "$20-30",
  "availableFor": {
    "dogs": ["Small", "Medium", "Large"],
    "cats": []
  }
}
```

#### Get Business Services
```
GET /api/service/business/all?page=1&limit=10&category=categoryId
Authorization: Bearer <business_token>
```

#### Delete Service
```
DELETE /api/service/delete/:serviceId
Authorization: Bearer <business_token>
```

## User Flow

### 1. Admin Setup
1. Admin creates an account with userType: "Admin" or uses admin@petdash.com
2. Admin calls `/api/category/seed` to create default categories
3. Admin can manage categories through CRUD operations

### 2. Business Registration & Service Creation
1. Business registers with userType: "Business"
2. Business creates services and assigns them to categories
3. Services are now discoverable by category

### 3. User Discovery Flow
1. User calls `/api/category/public` to get all available categories
2. User clicks on a category (e.g., "Grooming")
3. Frontend calls `/api/business/category/:categoryId` to get businesses offering grooming services
4. User clicks on a specific business
5. Frontend calls `/api/business/profile/:businessId` to get detailed business info and all services

### 4. Search Flow
1. User searches using `/api/business/search` with various filters
2. Results show businesses matching the criteria

## Database Schema Changes

### Category Model
```javascript
{
  name: String (required, unique),
  description: String (required),
  icon: String (required),
  color: String (default: '#007bff'),
  isActive: Boolean (default: true),
  order: Number (default: 0),
  createdAt: Date,
  updatedAt: Date
}
```

### Updated Service Model
```javascript
{
  business: ObjectId (ref: 'User', required),
  category: ObjectId (ref: 'Category', required), // NEW FIELD
  title: String (required),
  description: String,
  serviceIncluded: String,
  notes: String,
  price: String,
  images: [String],
  availableFor: {
    cats: [String],
    dogs: [String]
  },
  isActive: Boolean (default: true), // NEW FIELD
  createdAt: Date, // NEW FIELD
  updatedAt: Date // NEW FIELD
}
```

## Testing the Implementation

1. Start the server: `npm run dev`
2. Create an admin user or use existing admin credentials
3. Seed categories: `POST /api/category/seed`
4. Create business accounts and add services with categories
5. Test the discovery flow using the business endpoints
