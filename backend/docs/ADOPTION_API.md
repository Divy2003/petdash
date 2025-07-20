# Pet Adoption API Documentation

## Overview
The Pet Adoption API provides endpoints for managing pet adoption listings, allowing shelters and organizations to post pets for adoption, and users to browse and favorite pets.

## Base URL
```
/api/adoption
```

## Authentication
Most endpoints require authentication using JWT tokens. Include the token in the Authorization header:
```
Authorization: Bearer <your_jwt_token>
```

## Endpoints

### 1. Get All Adoption Listings
**GET** `/api/adoption/`

Get all available adoption listings with optional filtering.

**Query Parameters:**
- `species` (string): Filter by pet species (e.g., "Dog", "Cat")
- `ageCategory` (string): Filter by age category ("Young", "Adult", "Senior")
- `gender` (string): Filter by gender ("Male", "Female")
- `size` (string): Filter by size ("Small", "Medium", "Large", "Extra Large")
- `city` (string): Filter by city
- `state` (string): Filter by state
- `adoptionStatus` (string): Filter by status (default: "Available")
- `goodWithKids` (boolean): Filter pets good with kids
- `goodWithDogs` (boolean): Filter pets good with dogs
- `goodWithCats` (boolean): Filter pets good with cats
- `page` (number): Page number (default: 1)
- `limit` (number): Items per page (default: 10)
- `sort` (string): Sort order (default: "-datePosted")

**Response:**
```json
{
  "message": "Adoption listings fetched successfully",
  "adoptions": [...],
  "pagination": {
    "currentPage": 1,
    "totalPages": 5,
    "totalItems": 50,
    "itemsPerPage": 10
  }
}
```

### 2. Get Single Adoption Listing
**GET** `/api/adoption/:id`

Get details of a specific adoption listing. This endpoint increments the view count.

**Response:**
```json
{
  "message": "Adoption listing fetched successfully",
  "adoption": {
    "_id": "...",
    "name": "Pearl",
    "species": "Dog",
    "breed": "Golden Retriever Mix",
    "age": "1 year",
    "ageCategory": "Young",
    "gender": "Female",
    "description": "Pearl is a sweet and gentle...",
    "location": {
      "city": "Mesa",
      "state": "New Jersey"
    },
    "shelter": {
      "name": "North Shore Animal League America",
      "phone": "516-883-7575"
    },
    "adoptionFee": 250,
    "views": 15
  }
}
```

### 3. Search Adoption Listings
**GET** `/api/adoption/search`

Search adoption listings by text query and location.

**Query Parameters:**
- `q` (string): Search query (searches name, breed, description, personality)
- `location` (string): Coordinates in format "lat,lng" for location-based search
- `radius` (number): Search radius in miles (default: 50)
- `page` (number): Page number (default: 1)
- `limit` (number): Items per page (default: 10)

### 4. Create Adoption Listing
**POST** `/api/adoption/`
**Authentication Required** (Business users only)

Create a new adoption listing.

**Content-Type:** `multipart/form-data`

**Body Parameters:**
- `name` (string, required): Pet's name
- `species` (string, required): Pet species
- `breed` (string): Pet breed
- `age` (string, required): Pet age
- `ageCategory` (string, required): "Young", "Adult", or "Senior"
- `gender` (string, required): "Male" or "Female"
- `description` (string, required): Pet description
- `location` (JSON string): Location object
- `shelter` (JSON string): Shelter information object
- `adoptionFee` (number): Adoption fee
- `personality` (JSON string): Array of personality traits
- `adoptionRequirements` (JSON string): Array of requirements
- `images` (files): Up to 5 image files

**Example Request:**
```javascript
const formData = new FormData();
formData.append('name', 'Buddy');
formData.append('species', 'Dog');
formData.append('breed', 'Labrador');
formData.append('age', '2 years');
formData.append('ageCategory', 'Adult');
formData.append('gender', 'Male');
formData.append('description', 'Friendly and energetic dog...');
formData.append('location', JSON.stringify({
  city: 'New York',
  state: 'NY',
  zipCode: '10001'
}));
formData.append('shelter', JSON.stringify({
  name: 'City Animal Shelter',
  phone: '555-0123',
  email: 'info@shelter.org'
}));
formData.append('adoptionFee', '200');
formData.append('personality', JSON.stringify(['Friendly', 'Playful']));
formData.append('images', imageFile1);
formData.append('images', imageFile2);
```

### 5. Update Adoption Listing
**PUT** `/api/adoption/:id`
**Authentication Required** (Business users only - own listings)

Update an existing adoption listing.

**Content-Type:** `multipart/form-data`

Same parameters as create endpoint.

### 6. Delete Adoption Listing
**DELETE** `/api/adoption/:id`
**Authentication Required** (Business users only - own listings)

Delete an adoption listing.

**Response:**
```json
{
  "message": "Adoption listing deleted successfully"
}
```

### 7. Get Business Adoption Listings
**GET** `/api/adoption/business/listings`
**Authentication Required** (Business users only)

Get all adoption listings created by the authenticated business.

**Query Parameters:**
- `page` (number): Page number (default: 1)
- `limit` (number): Items per page (default: 10)
- `adoptionStatus` (string): Filter by status

### 8. Toggle Favorite
**POST** `/api/adoption/:id/favorite`
**Authentication Required**

Add or remove an adoption listing from user's favorites.

**Response:**
```json
{
  "message": "Added to favorites",
  "isFavorited": true
}
```

### 9. Get User's Favorite Adoptions
**GET** `/api/adoption/user/favorites`
**Authentication Required**

Get all adoption listings favorited by the authenticated user.

**Query Parameters:**
- `page` (number): Page number (default: 1)
- `limit` (number): Items per page (default: 10)

## Data Models

### Adoption Schema
```javascript
{
  name: String (required),
  species: String (required),
  breed: String,
  age: String (required),
  ageCategory: "Young" | "Adult" | "Senior" (required),
  gender: "Male" | "Female" (required),
  size: "Small" | "Medium" | "Large" | "Extra Large",
  weight: String,
  color: String,
  images: [String],
  primaryImage: String,
  vaccinated: Boolean,
  neutered: Boolean,
  microchipped: Boolean,
  healthStatus: "Healthy" | "Special Needs" | "Under Treatment",
  specialNeeds: String,
  personality: [String],
  goodWithKids: Boolean,
  goodWithDogs: Boolean,
  goodWithCats: Boolean,
  energyLevel: "Low" | "Medium" | "High",
  description: String (required),
  story: String,
  location: {
    address: String,
    city: String (required),
    state: String (required),
    zipCode: String,
    coordinates: {
      latitude: Number,
      longitude: Number
    }
  },
  shelter: {
    name: String (required),
    phone: String,
    email: String,
    website: String,
    hours: String,
    adoptionProcess: String
  },
  adoptionFee: Number,
  adoptionStatus: "Available" | "Pending" | "Adopted" | "On Hold" | "Not Available",
  adoptionRequirements: [String],
  datePosted: Date,
  lastUpdated: Date,
  views: Number,
  favorites: [ObjectId],
  postedBy: ObjectId (ref: User),
  isActive: Boolean,
  featured: Boolean
}
```

## Error Responses

### 400 Bad Request
```json
{
  "message": "Validation error",
  "error": "Detailed error message"
}
```

### 401 Unauthorized
```json
{
  "message": "Access denied. No token provided."
}
```

### 403 Forbidden
```json
{
  "message": "Only businesses can create adoption listings"
}
```

### 404 Not Found
```json
{
  "message": "Adoption listing not found"
}
```

### 500 Internal Server Error
```json
{
  "message": "Error creating adoption listing",
  "error": "Detailed error message"
}
```
