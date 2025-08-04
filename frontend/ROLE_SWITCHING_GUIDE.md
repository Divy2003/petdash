# Role Switching Implementation Guide

This guide explains how to implement and use the role switching functionality in the PetDash Flutter application.

## Overview

The role switching system allows users with multiple roles (Pet Owner and Business) to switch between their accounts seamlessly. The system includes:

- **Backend validation** to ensure users can only switch to roles they have access to
- **JWT token management** with updated role information
- **State management** using Provider pattern
- **UI components** for easy role switching

## Backend API

### Switch Role Endpoint

```http
POST /api/auth/switch-role
Content-Type: application/json
Authorization: Bearer <your-jwt-token>

{
  "newRole": "Pet Owner" // or "Business"
}
```

### Response

**Success (200):**
```json
{
  "message": "Successfully switched to Pet Owner role",
  "token": "new-jwt-token-with-updated-role",
  "user": {
    "currentRole": "Pet Owner",
    "availableRoles": ["Pet Owner", "Business"],
    "canSwitchRoles": true
  },
  "previousRole": "Business"
}
```

**Error (403):**
```json
{
  "message": "You do not have permission to switch to this role",
  "availableRoles": ["Business"]
}
```

## Frontend Implementation

### 1. Service Layer

The `RoleSwitchingService` handles all API interactions:

```dart
import '../services/role_switching_service.dart';

// Switch to a new role
final result = await RoleSwitchingService.switchRole('Pet Owner');

// Check if user can switch to a role
final canSwitch = await RoleSwitchingService.canSwitchToRole('Business');

// Get current role information
final roleInfo = await RoleSwitchingService.getCurrentRoleInfo();
```

### 2. State Management

The `RoleSwitchingProvider` manages role state:

```dart
import 'package:provider/provider.dart';
import '../provider/role_switching_provider.dart';

// In your widget
Consumer<RoleSwitchingProvider>(
  builder: (context, provider, child) {
    return Text('Current Role: ${provider.currentRole}');
  },
)

// Switch role programmatically
final provider = context.read<RoleSwitchingProvider>();
final success = await provider.switchRole('Business');
```

### 3. UI Components

#### Quick Switch Button

```dart
import '../widgets/role_switch_widget.dart';

RoleSwitchWidget(
  showAsButton: true,
  onRoleChanged: () {
    // Handle role change
    Navigator.pushReplacement(context, /* new screen */);
  },
)
```

#### Role Selector

```dart
RoleSwitchWidget(
  showAsButton: false,
  showCurrentRole: true,
  onRoleChanged: () {
    // Handle role change
  },
)
```

#### App Bar Action

```dart
AppBar(
  title: Text('My App'),
  actions: [
    RoleSwitchAppBarAction(),
  ],
)
```

### 4. Integration with Existing Code

Update your existing switch account functionality:

```dart
import '../services/user_session_service.dart';

// This now uses proper role switching with backend validation
await UserSessionService.switchAccountType(context);
```

## Usage Examples

### Example 1: Manual API Call

```dart
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> switchToBusinessRole() async {
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer your-jwt-token-here',
  };

  final response = await http.post(
    Uri.parse('http://localhost:5000/api/auth/switch-role'),
    headers: headers,
    body: json.encode({'newRole': 'Business'}),
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    // Update stored token
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', data['token']);
    await prefs.setString('user_type', data['user']['currentRole']);
    
    print('Successfully switched to Business role');
  } else {
    print('Failed to switch role: ${response.body}');
  }
}
```

### Example 2: Using the Service

```dart
import '../services/role_switching_service.dart';

Future<void> handleRoleSwitch() async {
  try {
    // Validate before switching
    final validation = await RoleSwitchingService.validateRoleSwitch('Pet Owner');
    
    if (!validation.isValid) {
      print('Cannot switch: ${validation.errorMessage}');
      return;
    }

    // Perform the switch
    final result = await RoleSwitchingService.switchRole('Pet Owner');
    print('Switched successfully: ${result['message']}');
    
    // Navigate to appropriate screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => PetOwnerHomeScreen()),
    );
  } catch (e) {
    print('Error switching role: $e');
  }
}
```

### Example 3: Using the Provider

```dart
import 'package:provider/provider.dart';
import '../provider/role_switching_provider.dart';

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<RoleSwitchingProvider>(
      builder: (context, roleProvider, child) {
        if (roleProvider.isLoading) {
          return CircularProgressIndicator();
        }

        if (!roleProvider.hasMultipleRoles) {
          return Text('Single role user');
        }

        return Column(
          children: [
            Text('Current: ${roleProvider.currentRole}'),
            ElevatedButton(
              onPressed: () async {
                final success = await roleProvider.quickSwitchRole();
                if (success) {
                  // Handle successful switch
                }
              },
              child: Text('Switch Role'),
            ),
          ],
        );
      },
    );
  }
}
```

## Error Handling

The system provides comprehensive error handling:

```dart
try {
  await RoleSwitchingService.switchRole('Business');
} on RoleSwitchException catch (e) {
  if (e.statusCode == 403) {
    print('Permission denied: ${e.message}');
    if (e.availableRoles != null) {
      print('Available roles: ${e.availableRoles!.join(', ')}');
    }
  } else if (e.statusCode == 401) {
    print('Authentication required');
    // Redirect to login
  } else {
    print('Role switch failed: ${e.message}');
  }
} catch (e) {
  print('Unexpected error: $e');
}
```

## Security Considerations

1. **Backend Validation**: All role switches are validated on the backend
2. **JWT Token Updates**: New tokens are issued with updated role information
3. **Permission Checks**: Users can only switch to roles they have access to
4. **Audit Trail**: Role switches are logged in the user's role history

## Testing

Use the provided example screen to test the functionality:

```dart
import '../examples/role_switching_example.dart';

// Navigate to the example screen
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => RoleSwitchingExampleScreen(),
  ),
);
```

## Integration Checklist

- [ ] Add `RoleSwitchingProvider` to your app's providers
- [ ] Update existing switch account functionality
- [ ] Add role switch widgets to appropriate screens
- [ ] Test with users who have multiple roles
- [ ] Handle error cases appropriately
- [ ] Update navigation logic based on current role

## Troubleshooting

**Issue**: Role switch fails with 403 error
**Solution**: Check that the user has the target role in their `availableRoles` array

**Issue**: Token not updating after role switch
**Solution**: Ensure you're calling the service methods correctly and updating SharedPreferences

**Issue**: UI not updating after role switch
**Solution**: Make sure you're using the Provider pattern correctly and calling `notifyListeners()`
