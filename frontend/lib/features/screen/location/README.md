# Location Selection Feature

This feature provides a comprehensive location selection system for the PetDash app, allowing users to choose their delivery location through multiple methods.

## Features

### 1. Location Selection Modal (`location_selection_modal.dart`)
- **Tabbed Interface**: Home, Work, and Other location categories
- **Saved Addresses**: Display previously saved addresses for each category
- **Current Location**: Quick access to use device's current location
- **Add New Address**: Option to add new addresses via Google Maps

### 2. Google Maps Integration (`google_map_screen.dart`)
- **Interactive Map**: Full-screen Google Maps with tap-to-select functionality
- **Current Location**: Automatic detection and display of user's current location
- **Address Geocoding**: Converts coordinates to readable addresses
- **Location Confirmation**: Bottom sheet with location details and confirmation button

### 3. Home App Bar Integration (`home_appbar.dart`)
- **Dynamic Location Display**: Shows current selected location or "My Location" as default
- **Modal Trigger**: Tapping the location opens the selection modal
- **Real-time Updates**: Location display updates when user selects a new location

## Setup Requirements

### Dependencies Added
```yaml
dependencies:
  google_maps_flutter: ^2.12.3
  geolocator: ^11.0.0
  permission_handler: ^12.0.1
  geocoding: ^4.0.0
```

### Android Configuration
1. **Permissions** (AndroidManifest.xml):
```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```

2. **Google Maps API Key** (AndroidManifest.xml):
```xml
<meta-data android:name="com.google.android.geo.API_KEY"
    android:value="AIzaSyDXLquInbZLHKdE7s2UolTfUbfbl3oj-w0"/>
```

### Provider Integration
The `LocationProvider` is added to the main app's MultiProvider for global state management.

## Usage Flow

1. **User taps location** in home app bar
2. **Modal opens** showing location options
3. **User can**:
   - Select from saved addresses (Home/Work/Other tabs)
   - Tap "Use my current location" to open Google Maps
   - Tap "Add New Address" to open Google Maps for new location
4. **Google Maps screen** allows:
   - Viewing current location
   - Tapping anywhere on map to select new location
   - Confirming selection with "Add" button
5. **Location updates** throughout the app via Provider

## File Structure
```
lib/features/screen/location/
├── location_selection_modal.dart    # Main selection interface
├── google_map_screen.dart          # Google Maps integration
└── README.md                       # This documentation

lib/provider/
└── location_provider.dart          # State management

lib/features/screen/shop/home/widgets/
└── home_appbar.dart                # Updated with location display
```

## Key Features Implemented

✅ Modal bottom sheet with tabbed interface
✅ Google Maps integration with API key
✅ Current location detection
✅ Address geocoding (coordinates to address)
✅ Location permissions handling
✅ Real-time location display in app bar
✅ Responsive design with proper styling
✅ Error handling and loading states

## Future Enhancements

- Save/load addresses from backend
- Location search functionality
- Favorite locations
- Location history
- Delivery radius validation
