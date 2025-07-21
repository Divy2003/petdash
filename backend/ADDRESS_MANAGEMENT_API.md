# Address Management API Documentation

## Overview
The Address Management API allows users to manage multiple addresses with one designated as primary. This system maintains backward compatibility with existing legacy address fields while providing enhanced functionality.

## 🎯 Key Features

- **Multiple Addresses**: Users can add, update, and delete multiple addresses
- **Primary Address**: One address can be designated as primary
- **Backward Compatibility**: Legacy address fields are automatically synced
- **Soft Delete**: Addresses are soft-deleted to maintain data integrity
- **Validation**: Comprehensive validation for all address fields

## 📋 API Endpoints

### Base URL: `/api/profile`

All endpoints require authentication via Bearer token.

---

## 1. Get User Profile (with Primary Address)

**GET** `/api/profile/get-profile`

Returns user profile including primary address information.

### Response
```json
{
  "message": "Profile fetched successfully",
  "profile": {
    "_id": "user_id",
    "name": "John Doe",
    "email": "john@example.com",
    "userType": "Pet Owner",
    "phoneNumber": "+1234567890",
    "streetName": "123 Main St",
    "city": "New York",
    "state": "NY",
    "zipCode": "12345",
    "addresses": [
      {
        "_id": "address_id",
        "label": "Home",
        "streetName": "123 Main St",
        "city": "New York",
        "state": "NY",
        "zipCode": "12345",
        "country": "USA",
        "isPrimary": true,
        "isActive": true,
        "createdAt": "2024-01-15T10:00:00.000Z",
        "updatedAt": "2024-01-15T10:00:00.000Z"
      }
    ],
    "primaryAddress": {
      "_id": "address_id",
      "label": "Home",
      "streetName": "123 Main St",
      "city": "New York",
      "state": "NY",
      "zipCode": "12345",
      "country": "USA",
      "isPrimary": true,
      "isActive": true
    }
  }
}
```

---

## 2. Get All User Addresses

**GET** `/api/profile/addresses`

Returns all active addresses for the authenticated user.

### Response
```json
{
  "message": "Addresses fetched successfully",
  "addresses": [
    {
      "_id": "address_id_1",
      "label": "Home",
      "streetName": "123 Main St",
      "city": "New York",
      "state": "NY",
      "zipCode": "12345",
      "country": "USA",
      "isPrimary": true,
      "isActive": true,
      "createdAt": "2024-01-15T10:00:00.000Z",
      "updatedAt": "2024-01-15T10:00:00.000Z"
    },
    {
      "_id": "address_id_2",
      "label": "Work",
      "streetName": "789 Business Ave",
      "city": "New York",
      "state": "NY",
      "zipCode": "12347",
      "country": "USA",
      "isPrimary": false,
      "isActive": true,
      "createdAt": "2024-01-16T10:00:00.000Z",
      "updatedAt": "2024-01-16T10:00:00.000Z"
    }
  ]
}
```

---

## 3. Add New Address

**POST** `/api/profile/addresses`

Adds a new address for the authenticated user.

### Request Body
```json
{
  "label": "Work",
  "streetName": "789 Business Ave",
  "city": "New York",
  "state": "NY",
  "zipCode": "12347",
  "country": "USA",
  "isPrimary": false
}
```

### Required Fields
- `label` (string): Unique label for the address
- `streetName` (string): Street address
- `city` (string): City name
- `state` (string): State/Province
- `zipCode` (string): ZIP/Postal code

### Optional Fields
- `country` (string): Country (defaults to "USA")
- `isPrimary` (boolean): Set as primary address (defaults to false)

### Response
```json
{
  "message": "Address added successfully",
  "address": {
    "_id": "new_address_id",
    "label": "Work",
    "streetName": "789 Business Ave",
    "city": "New York",
    "state": "NY",
    "zipCode": "12347",
    "country": "USA",
    "isPrimary": false,
    "isActive": true,
    "createdAt": "2024-01-16T10:00:00.000Z",
    "updatedAt": "2024-01-16T10:00:00.000Z"
  }
}
```

### Error Responses
- **400**: Missing required fields or duplicate label
- **404**: User not found

---

## 4. Update Address

**PUT** `/api/profile/addresses/:addressId`

Updates an existing address.

### Request Body
```json
{
  "label": "Updated Work",
  "streetName": "999 New Business St",
  "city": "New York",
  "state": "NY",
  "zipCode": "12348",
  "country": "USA"
}
```

### Response
```json
{
  "message": "Address updated successfully",
  "address": {
    "_id": "address_id",
    "label": "Updated Work",
    "streetName": "999 New Business St",
    "city": "New York",
    "state": "NY",
    "zipCode": "12348",
    "country": "USA",
    "isPrimary": false,
    "isActive": true,
    "updatedAt": "2024-01-16T11:00:00.000Z"
  }
}
```

### Error Responses
- **400**: Duplicate label
- **404**: Address or user not found

---

## 5. Delete Address

**DELETE** `/api/profile/addresses/:addressId`

Soft deletes an address (sets isActive to false).

### Response
```json
{
  "message": "Address deleted successfully"
}
```

### Error Responses
- **400**: Cannot delete the only address
- **404**: Address or user not found

---

## 6. Set Primary Address

**PUT** `/api/profile/addresses/:addressId/primary`

Sets the specified address as the primary address.

### Response
```json
{
  "message": "Primary address set successfully",
  "address": {
    "_id": "address_id",
    "label": "Home",
    "streetName": "123 Main St",
    "city": "New York",
    "state": "NY",
    "zipCode": "12345",
    "country": "USA",
    "isPrimary": true,
    "isActive": true
  }
}
```

### Error Responses
- **404**: Address or user not found

---

## 7. Get Primary Address

**GET** `/api/profile/addresses/primary`

Returns the user's primary address.

### Response
```json
{
  "message": "Primary address fetched successfully",
  "address": {
    "_id": "address_id",
    "label": "Home",
    "streetName": "123 Main St",
    "city": "New York",
    "state": "NY",
    "zipCode": "12345",
    "country": "USA",
    "isPrimary": true,
    "isActive": true
  }
}
```

### Error Responses
- **404**: No primary address found

---

## 8. Update Profile (Legacy Support)

**PUT** `/api/profile/create-update-profile`

Updates user profile with backward compatibility for legacy address fields.

### Request Body
```json
{
  "name": "John Doe",
  "phoneNumber": "+1234567890",
  "streetName": "123 New Main St",
  "city": "New York",
  "state": "NY",
  "zipCode": "12345"
}
```

**Note**: When legacy address fields are provided, they automatically update the primary address or create one if none exists.

---

## 🔄 Backward Compatibility

The system maintains full backward compatibility:

1. **Legacy Fields**: `streetName`, `city`, `state`, `zipCode` are still available
2. **Auto-Sync**: Primary address changes automatically update legacy fields
3. **Migration**: Existing users' legacy data is preserved and migrated to the new system

## 🛡️ Business Rules

1. **Unique Labels**: Each user can only have one address per label
2. **Primary Address**: Only one address can be primary at a time
3. **Minimum Addresses**: Users must have at least one active address
4. **Auto-Primary**: If no addresses exist, the first added address becomes primary
5. **Legacy Sync**: Primary address always syncs with legacy fields

## 🔧 Migration

Run the migration script to convert existing legacy address data:

```bash
node backend/migrations/migrateAddresses.js
```

This script will:
- Find users with legacy address data
- Create primary addresses from legacy fields
- Preserve all existing data
- Skip users with incomplete address information

The address management system is now ready for use with full backward compatibility! 🎉
