import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import '../utlis/app_config/app_config.dart';

class LocationService {
  // Calculate distance between two coordinates using Haversine formula
  static double calculateDistance(double lat1,
      double lon1,
      double lat2,
      double lon2,) {
    const double earthRadius = 6371; // Earth's radius in kilometers

    double dLat = _degreesToRadians(lat2 - lat1);
    double dLon = _degreesToRadians(lon2 - lon1);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(lat1)) *
            cos(_degreesToRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double distance = earthRadius * c;

    return distance; // Distance in kilometers
  }

  static double _degreesToRadians(double degrees) {
    return degrees * (pi / 180);
  }

  // Convert kilometers to miles
  static double kmToMiles(double km) {
    return km * 0.621371;
  }

  // Get current user location
  static Future<Position?> getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return null;
      }

      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      print('Error getting current location: $e');
      return null;
    }
  }

  // Calculate distance from current location to a business
  static Future<double?> getDistanceToBusinessInMiles({
    required double businessLat,
    required double businessLng,
  }) async {
    try {
      Position? currentPosition = await getCurrentLocation();
      if (currentPosition == null) return null;

      double distanceKm = calculateDistance(
        currentPosition.latitude,
        currentPosition.longitude,
        businessLat,
        businessLng,
      );

      return kmToMiles(distanceKm);
    } catch (e) {
      print('Error calculating distance to business: $e');
      return null;
    }
  }

  // Get distance using Google Distance Matrix API (more accurate for driving distance)
  static Future<double?> getDistanceUsingGoogleAPI({
    required double fromLat,
    required double fromLng,
    required double toLat,
    required double toLng,
    String mode = 'driving', // driving, walking, bicycling, transit
  }) async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://maps.googleapis.com/maps/api/distancematrix/json?'
              'origins=$fromLat,$fromLng&'
              'destinations=$toLat,$toLng&'
              'mode=$mode&'
              'units=metric&'
              'key=${AppConfig.googleMapsApiKey}',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'OK' &&
            data['rows'] != null &&
            data['rows'].isNotEmpty &&
            data['rows'][0]['elements'] != null &&
            data['rows'][0]['elements'].isNotEmpty &&
            data['rows'][0]['elements'][0]['status'] == 'OK') {
          final element = data['rows'][0]['elements'][0];
          final distanceValue = element['distance']['value']; // in meters

          // Convert meters to miles
          double distanceKm = distanceValue / 1000.0;
          return kmToMiles(distanceKm);
        }
      }

      return null;
    } catch (e) {
      print('Error getting distance from Google API: $e');
      return null;
    }
  }

  // Get nearby businesses within a certain radius
  static Future<List<Map<String, dynamic>>> getNearbyBusinesses({
    required double userLat,
    required double userLng,
    double radiusMiles = 10.0,
    required List<Map<String, dynamic>> allBusinesses,
  }) async {
    List<Map<String, dynamic>> nearbyBusinesses = [];
    double radiusKm = radiusMiles / 0.621371; // Convert miles to km

    for (var business in allBusinesses) {
      if (business['latitude'] != null && business['longitude'] != null) {
        double distance = calculateDistance(
          userLat,
          userLng,
          business['latitude'].toDouble(),
          business['longitude'].toDouble(),
        );

        if (distance <= radiusKm) {
          business['distanceKm'] = distance;
          business['distanceMiles'] = kmToMiles(distance);
          nearbyBusinesses.add(business);
        }
      }
    }

    // Sort by distance
    nearbyBusinesses.sort((a, b) =>
        a['distanceKm'].compareTo(b['distanceKm']));

    return nearbyBusinesses;
  }

  // Format distance for display
  static String formatDistance(double miles) {
    if (miles < 0.1) {
      return 'Less than 0.1 mi';
    } else if (miles < 1.0) {
      return '${(miles * 10).round() / 10} mi';
    } else {
      return '${miles.round()} mi';
    }
  }

  // Get address from coordinates using Google Geocoding API
  static Future<Map<String, String>?> getAddressFromCoordinates({
    required double lat,
    required double lng,
  }) async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://maps.googleapis.com/maps/api/geocode/json?'
              'latlng=$lat,$lng&'
              'key=${AppConfig.googleMapsApiKey}',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'OK' &&

            data['results'] != null &&
            data['results'].isNotEmpty) {
          final result = data['results'][0];
          final components = result['address_components'];

          String street = '';
          String city = '';
          String state = '';
          String zipCode = '';
          String country = '';

          for (var component in components) {
            final types = List<String>.from(component['types']);
            final longName = component['long_name'];

            if (types.contains('street_number') || types.contains('route')) {
              street += '$longName ';
            } else if (types.contains('locality') ||
                types.contains('administrative_area_level_2')) {
              city = longName;
            } else if (types.contains('administrative_area_level_1')) {
              state = longName;
            } else if (types.contains('postal_code')) {
              zipCode = longName;
            } else if (types.contains('country')) {
              country = longName;
            }
          }

          return {
            'streetName': street.trim(),
            'city': city,
            'state': state,
            'zipCode': zipCode,
            'country': country.isNotEmpty ? country : 'India',
            'formattedAddress': result['formatted_address'] ?? '',
          };
        }
      }

      return null;
    } catch (e) {
      print('Error getting address from coordinates: $e');
      return null;
    }
  }

  // Search places using Google Places API
  static Future<List<Map<String, dynamic>>> searchPlaces({
    required String query,
    double? lat,
    double? lng,
    int radius = 50000, // 50km radius
  }) async {
    try {
      String url = 'https://maps.googleapis.com/maps/api/place/textsearch/json?'
          'query=${Uri.encodeComponent(query)}&'
          'key=${AppConfig.googleMapsApiKey}';

      if (lat != null && lng != null) {
        url += '&location=$lat,$lng&radius=$radius';
      }

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'OK' && data['results'] != null) {
          return List<Map<String, dynamic>>.from(data['results']);
        }
      }

      return [];
    } catch (e) {
      print('Error searching places: $e');
      return [];
    }
  }

  // Forward geocode: get lat/lng from a full address string
  static Future<Map<String, double>?> getLatLngForAddress(
      String address) async {
    try {
      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?address='
            '${Uri.encodeComponent(address)}&key=${AppConfig.googleMapsApiKey}',
      );
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK' && data['results'] != null &&
            data['results'].isNotEmpty) {
          final loc = data['results'][0]['geometry']['location'];
          final lat = (loc['lat'] as num).toDouble();
          final lng = (loc['lng'] as num).toDouble();
          return { 'lat': lat, 'lng': lng};
        }
      }
      return null;
    } catch (e) {
      print('Error forward geocoding "$address": $e');
      return null;
    }
  }

  // Convenience: distance in miles from current user to a destination address
  static Future<double?> getDistanceToAddressInMiles(String address) async {
    try {
      final pos = await getCurrentLocation();
      if (pos == null) return null;
      final dest = await getLatLngForAddress(address);
      if (dest == null) return null;
      final km = calculateDistance(
        pos.latitude,
        pos.longitude,
        dest['lat']!,
        dest['lng']!,
      );
      return kmToMiles(km);
    } catch (e) {
      print('Error computing distance to address: $e');
      return null;
    }
  }
}
