# OTP-Based Password Reset Implementation

## Overview
The password reset functionality has been updated to use OTP (One-Time Password) instead of URL tokens for enhanced security.

## Changes Made

### 1. User Model Updates
- Added `resetPasswordOTP` field to store the 6-digit OTP
- Added `resetPasswordOTPExpires` field to store OTP expiration time
- OTP expires in 10 minutes for security

### 2. API Endpoints

#### Request Password Reset
**POST** `/auth/request-password-reset`

**Request Body:**
```json
{
  "email": "user@example.com"
}
```

**Response:**
```json
{
  "message": "Password reset OTP sent to email"
}
```

**Functionality:**
- Generates a 6-digit random OTP
- Stores OTP and expiration time in database
- Sends OTP via email with HTML formatting
- OTP expires in 10 minutes

#### Verify OTP (Optional)
**POST** `/auth/verify-otp`

**Request Body:**
```json
{
  "email": "user@example.com",
  "otp": "123456"
}
```

**Response:**
```json
{
  "message": "OTP verified successfully",
  "verified": true
}
```

#### Reset Password
**POST** `/auth/reset-password`

**Request Body:**
```json
{
  "email": "user@example.com",
  "otp": "123456",
  "newPassword": "newSecurePassword123"
}
```

**Response:**
```json
{
  "message": "Password has been reset successfully"
}
```

## Security Features

1. **Short Expiration Time**: OTP expires in 10 minutes
2. **6-Digit Random OTP**: Provides good security while being user-friendly
3. **Email Verification**: OTP is sent only to the registered email
4. **One-Time Use**: OTP is cleared after successful password reset
5. **Database Validation**: OTP and expiration are validated against database

## Email Template

The OTP email includes:
- Clear subject line: "Password Reset OTP"
- Formatted OTP in large, bold text
- Expiration time information
- Security notice about ignoring if not requested

## Frontend Integration

The frontend should implement a 3-step flow:
1. **Request OTP**: User enters email
2. **Enter OTP**: User enters received 6-digit OTP
3. **Reset Password**: User enters new password

## Error Handling

- Invalid email: "User not found"
- Invalid/expired OTP: "Invalid or expired OTP"
- Server errors: Appropriate error messages with details

## Backward Compatibility

The old token-based fields are still maintained in the User model for backward compatibility, but the new OTP system takes precedence.

## Testing

To test the implementation:
1. Start the server
2. Use Postman or similar tool to test the endpoints
3. Check email for OTP delivery
4. Verify OTP validation and password reset functionality
