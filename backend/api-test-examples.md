# API Testing Examples for New Features

## 1. Role-Specific Primary Address Features

### Add Address with Role-Specific Primary Settings

```bash
# Add address that's primary for Business role
POST /api/profile/addresses
Authorization: Bearer <token>
Content-Type: application/json

{
  "label": "Business Office",
  "streetName": "123 Business St",
  "city": "Business City",
  "state": "CA",
  "zipCode": "12345",
  "country": "USA",
  "isPrimaryForBusiness": true
}
```

```bash
# Add address that's primary for Pet Owner role
POST /api/profile/addresses
Authorization: Bearer <token>
Content-Type: application/json

{
  "label": "Home Address",
  "streetName": "456 Home Ave",
  "city": "Home City",
  "state": "CA",
  "zipCode": "54321",
  "country": "USA",
  "isPrimaryForPetOwner": true
}
```

### Set Primary Address for Specific Role

```bash
# Set address as primary for specific role
PUT /api/profile/addresses/{addressId}/primary
Authorization: Bearer <token>
Content-Type: application/json

{
  "forRole": "Business"
}
```

```bash
# Set address as primary for current role (default behavior)
PUT /api/profile/addresses/{addressId}/primary
Authorization: Bearer <token>
Content-Type: application/json

{}
```

### Get Primary Address for Specific Role

```bash
# Get primary address for Business role
GET /api/profile/addresses/primary?forRole=Business
Authorization: Bearer <token>
```

```bash
# Get primary address for Pet Owner role
GET /api/profile/addresses/primary?forRole=Pet%20Owner
Authorization: Bearer <token>
```

```bash
# Get primary address for current role (default)
GET /api/profile/addresses/primary
Authorization: Bearer <token>
```

### Get Primary Addresses for All Roles

```bash
# Get primary addresses for all roles
GET /api/profile/addresses/primary/all-roles
Authorization: Bearer <token>

# Response example:
{
  "message": "Primary addresses fetched successfully",
  "addresses": {
    "general": { /* legacy primary address */ },
    "business": { /* business primary address */ },
    "petOwner": { /* pet owner primary address */ },
    "currentRole": { /* primary for current role */ }
  },
  "currentRole": "Pet Owner"
}
```

## 2. Complete Profile Deletion

### Delete Complete Profile

```bash
# Delete complete user profile and all related data
DELETE /api/profile/delete-profile
Authorization: Bearer <token>
Content-Type: application/json

{
  "confirmPassword": "user_actual_password"
}
```

**Response Example:**
```json
{
  "message": "Profile and all related data deleted successfully",
  "deletionSummary": {
    "pets": 3,
    "services": 5,
    "appointments": 12,
    "orders": 8,
    "reviews": 4,
    "articles": 2,
    "adoptions": 1,
    "subscriptions": 2,
    "products": 7
  }
}
```

**Error Response (Invalid Password):**
```json
{
  "message": "Invalid password"
}
```

**Error Response (Admin User):**
```json
{
  "message": "Admin profiles cannot be deleted through this endpoint"
}
```

## 3. Updated Profile Response

### Get Profile (Updated Response)

```bash
GET /api/profile/get-profile
Authorization: Bearer <token>

# Response now includes both legacy and role-specific primary addresses:
{
  "message": "Profile fetched successfully",
  "user": {
    "name": "John Doe",
    "email": "john@example.com",
    "userType": "Pet Owner",
    "currentRole": "Business",
    "availableRoles": ["Pet Owner"],
    "canSwitchRoles": true,
    "addresses": [...],
    "primaryAddress": { /* legacy primary */ },
    "primaryAddressForCurrentRole": { /* role-specific primary */ }
  }
}
```

## Key Features Summary

1. **Separate Primary Addresses**: Users can now set different primary addresses for Business and Pet Owner roles
2. **Role-Aware APIs**: All address APIs now support role-specific operations
3. **Backward Compatibility**: Legacy primary address functionality is preserved
4. **Complete Profile Deletion**: Single endpoint to delete user and all related data
5. **Comprehensive Cleanup**: Deletion removes pets, services, appointments, orders, reviews, articles, adoptions, and more
6. **Security**: Profile deletion requires password confirmation
7. **Admin Protection**: Admin profiles cannot be deleted through the standard endpoint
