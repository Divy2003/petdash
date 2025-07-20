# Pet Adoption System

## Overview
A comprehensive pet adoption system that allows shelters and organizations to post pets for adoption, and users to browse, search, and favorite pets. The system includes full CRUD operations, image uploads, location-based search, and user favorites functionality.

## Features

### 🏢 For Shelters/Organizations (Business Users)
- ✅ Create adoption listings with multiple images
- ✅ Update adoption status and details
- ✅ Delete adoption listings
- ✅ View all their posted adoptions
- ✅ Track views and favorites on their listings

### 👥 For Pet Adopters (Pet Owner Users)
- ✅ Browse all available pets
- ✅ Filter by species, age, gender, size, location
- ✅ Search pets by text query
- ✅ View detailed pet information
- ✅ Add/remove pets from favorites
- ✅ View their favorite pets list

### 🌐 Public Features
- ✅ Browse available pets without authentication
- ✅ Search functionality
- ✅ Location-based filtering
- ✅ View pet details (increments view count)

## API Endpoints

### Public Endpoints
- `GET /api/adoption/` - Get all adoption listings with filters
- `GET /api/adoption/:id` - Get single adoption listing
- `GET /api/adoption/search` - Search adoptions by query and location

### Authenticated User Endpoints
- `POST /api/adoption/:id/favorite` - Toggle favorite status
- `GET /api/adoption/user/favorites` - Get user's favorite adoptions

### Business User Endpoints
- `POST /api/adoption/` - Create adoption listing
- `PUT /api/adoption/:id` - Update adoption listing
- `DELETE /api/adoption/:id` - Delete adoption listing
- `GET /api/adoption/business/listings` - Get business's adoption listings

## Database Schema

### Adoption Model
```javascript
{
  // Pet Information
  name: String (required),
  species: String (required),
  breed: String,
  age: String (required),
  ageCategory: "Young" | "Adult" | "Senior" (required),
  gender: "Male" | "Female" (required),
  size: "Small" | "Medium" | "Large" | "Extra Large",
  weight: String,
  color: String,
  
  // Images
  images: [String],
  primaryImage: String,
  
  // Health & Behavior
  vaccinated: Boolean,
  neutered: Boolean,
  microchipped: Boolean,
  healthStatus: "Healthy" | "Special Needs" | "Under Treatment",
  specialNeeds: String,
  
  // Personality & Compatibility
  personality: [String],
  goodWithKids: Boolean,
  goodWithDogs: Boolean,
  goodWithCats: Boolean,
  energyLevel: "Low" | "Medium" | "High",
  
  // Description & Story
  description: String (required),
  story: String,
  
  // Location & Contact
  location: {
    address: String,
    city: String (required),
    state: String (required),
    zipCode: String,
    coordinates: { latitude: Number, longitude: Number }
  },
  
  // Shelter Information
  shelter: {
    name: String (required),
    phone: String,
    email: String,
    website: String,
    hours: String,
    adoptionProcess: String
  },
  
  // Adoption Details
  adoptionFee: Number,
  adoptionStatus: "Available" | "Pending" | "Adopted" | "On Hold" | "Not Available",
  adoptionRequirements: [String],
  
  // Metadata
  datePosted: Date,
  lastUpdated: Date,
  views: Number,
  favorites: [ObjectId],
  postedBy: ObjectId (ref: User),
  isActive: Boolean,
  featured: Boolean
}
```

## Installation & Setup

1. **Install Dependencies** (already done if you have the main project running)
   ```bash
   cd backend
   npm install
   ```

2. **Start the Server**
   ```bash
   npm start
   ```

3. **Database Seeding**
   The adoption data is automatically seeded when the server starts. Sample data includes:
   - Pearl (Golden Retriever Mix, Young Female)
   - Chianti (Domestic Shorthair Cat, Adult Female)
   - Lilo (Mixed Breed Dog, Adult Male)

## Testing the API

### Using Postman
1. Import the collection: `backend/Adoption-API-Collection.postman_collection.json`
2. Set the `baseUrl` variable to `http://localhost:5000`
3. Login using the authentication endpoints to get a token
4. Test all endpoints with the provided examples

### Using cURL
```bash
# Get all adoptions
curl -X GET "http://localhost:5000/api/adoption/"

# Get specific adoption
curl -X GET "http://localhost:5000/api/adoption/ADOPTION_ID"

# Search adoptions
curl -X GET "http://localhost:5000/api/adoption/search?q=friendly"
```

### Using the Demo Frontend
1. Open `backend/examples/adoption-frontend-example.html` in a web browser
2. Make sure the server is running on localhost:5000
3. Browse and filter pets using the interface

## Sample Data

The system comes with 3 sample adoption listings:

1. **Pearl** - Golden Retriever Mix, 1 year old, Female
   - Featured listing
   - Good with kids and dogs
   - Located in Mesa, New Jersey

2. **Chianti** - Domestic Shorthair Cat, 2 years old, Female
   - Hurricane Laura survivor
   - Needs quiet home
   - Located in Port Washington, NY

3. **Lilo** - Mixed Breed Dog, 3 years old, Male
   - Calm and loyal
   - Good with seniors
   - Located in Mesa, New Jersey

## Authentication

### Business User (for creating/managing listings)
```
Email: business1@example.com
Password: password123
```

### Pet Owner (for favorites functionality)
```
Email: petowner1@example.com
Password: password123
```

## File Structure
```
backend/
├── controllers/adopt/
│   └── adoptionController.js     # Main adoption controller
├── models/
│   └── Adoption.js               # Adoption data model
├── routes/
│   └── adoptionRoutes.js         # API routes
├── seeders/
│   └── adoptionSeeder.js         # Sample data seeder
├── docs/
│   └── ADOPTION_API.md           # Detailed API documentation
├── examples/
│   └── adoption-frontend-example.html  # Demo frontend
└── Adoption-API-Collection.postman_collection.json  # Postman collection
```

## Key Features Implemented

### ✅ CRUD Operations
- **Create**: Businesses can create adoption listings with images
- **Read**: Public can view all listings, authenticated users can view favorites
- **Update**: Businesses can update their own listings
- **Delete**: Businesses can delete their own listings

### ✅ Advanced Filtering
- Filter by species, age category, gender, size
- Location-based filtering by city/state
- Compatibility filters (good with kids/dogs/cats)
- Pagination support

### ✅ Search Functionality
- Text search across name, breed, description, personality
- Location-based search with radius
- Combined text and location search

### ✅ Image Management
- Multiple image upload support (up to 5 images)
- Primary image selection
- Image handling in form data

### ✅ User Interactions
- Favorite/unfavorite pets
- View tracking (increments on each view)
- User-specific favorites list

### ✅ Business Features
- Business-specific listing management
- View analytics (view counts, favorites)
- Status management (Available, Pending, Adopted, etc.)

## Next Steps for Enhancement

1. **Email Notifications**: Notify when pets are favorited or adopted
2. **Application System**: Allow users to submit adoption applications
3. **Advanced Search**: Add more filters like breed-specific search
4. **Image Optimization**: Implement image resizing and optimization
5. **Social Features**: Allow users to share pets on social media
6. **Mobile App**: Create React Native or Flutter mobile app
7. **Admin Dashboard**: Create admin interface for managing all listings

## Support

For questions or issues with the adoption system, please refer to:
- API Documentation: `backend/docs/ADOPTION_API.md`
- Postman Collection: `backend/Adoption-API-Collection.postman_collection.json`
- Demo Frontend: `backend/examples/adoption-frontend-example.html`
