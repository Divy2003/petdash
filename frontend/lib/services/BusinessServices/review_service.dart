import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../utlis/app_config/app_config.dart';

class ReviewService {
  static const String baseUrl = AppConfig.baseUrl;

  // Get headers with authentication
  static Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';
    
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // Get business reviews and rating statistics
  static Future<Map<String, dynamic>> getBusinessReviews(
    String businessId, {
    int page = 1,
    int limit = 10,
  }) async {
    try {
      print('🔄 Fetching business reviews...');
      print('📍 URL: $baseUrl/review/business/$businessId');

      final response = await http.get(
        Uri.parse('$baseUrl/review/business/$businessId?page=$page&limit=$limit'),
      );

      print('📊 Response Status: ${response.statusCode}');
      print('📄 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'reviews': data['reviews'] ?? [],
          'pagination': data['pagination'] ?? {},
          'ratingStats': data['ratingStats'] ?? {
            'averageRating': 0.0,
            'totalReviews': 0,
          },
        };
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to fetch reviews');
      }
    } catch (e) {
      print('❌ Reviews fetch error: ${e.toString()}');
      throw Exception('Failed to fetch reviews: ${e.toString()}');
    }
  }

  // Get current user's business rating (for business profile)
  static Future<Map<String, dynamic>> getMyBusinessRating() async {
    try {
      print('🔄 Fetching my business rating...');
      
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('user_id') ?? '';
      
      if (userId.isEmpty) {
        throw Exception('User ID not found');
      }

      return await getBusinessReviews(userId, page: 1, limit: 1);
    } catch (e) {
      print('❌ My business rating fetch error: ${e.toString()}');
      return {
        'reviews': [],
        'pagination': {},
        'ratingStats': {
          'averageRating': 0.0,
          'totalReviews': 0,
        },
      };
    }
  }

  // Create a review (for pet owners)
  static Future<bool> createReview({
    required String businessId,
    required int rating,
    required String reviewText,
    String? serviceId,
    String? appointmentId,
  }) async {
    try {
      print('🔄 Creating review...');
      print('📍 URL: $baseUrl/review/create');

      final headers = await _getHeaders();
      final body = json.encode({
        'businessId': businessId,
        'rating': rating,
        'reviewText': reviewText,
        if (serviceId != null) 'serviceId': serviceId,
        if (appointmentId != null) 'appointmentId': appointmentId,
      });

      final response = await http.post(
        Uri.parse('$baseUrl/review/create'),
        headers: headers,
        body: body,
      );

      print('📊 Response Status: ${response.statusCode}');
      print('📄 Response Body: ${response.body}');

      if (response.statusCode == 201) {
        return true;
      } else if (response.statusCode == 401) {
        throw Exception('Authentication failed. Please login again.');
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to create review');
      }
    } catch (e) {
      print('❌ Create review error: ${e.toString()}');
      throw Exception('Failed to create review: ${e.toString()}');
    }
  }

  // Respond to a review (for businesses)
  static Future<bool> respondToReview({
    required String reviewId,
    required String responseText,
  }) async {
    try {
      print('🔄 Responding to review...');
      print('📍 URL: $baseUrl/review/respond/$reviewId');

      final headers = await _getHeaders();
      final body = json.encode({
        'responseText': responseText,
      });

      final response = await http.post(
        Uri.parse('$baseUrl/review/respond/$reviewId'),
        headers: headers,
        body: body,
      );

      print('📊 Response Status: ${response.statusCode}');
      print('📄 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 401) {
        throw Exception('Authentication failed. Please login again.');
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to respond to review');
      }
    } catch (e) {
      print('❌ Respond to review error: ${e.toString()}');
      throw Exception('Failed to respond to review: ${e.toString()}');
    }
  }

  // Update a review (for the reviewer)
  static Future<bool> updateReview({
    required String reviewId,
    int? rating,
    String? reviewText,
  }) async {
    try {
      print('🔄 Updating review...');
      print('📍 URL: $baseUrl/review/update/$reviewId');

      final headers = await _getHeaders();
      final body = json.encode({
        if (rating != null) 'rating': rating,
        if (reviewText != null) 'reviewText': reviewText,
      });

      final response = await http.put(
        Uri.parse('$baseUrl/review/update/$reviewId'),
        headers: headers,
        body: body,
      );

      print('📊 Response Status: ${response.statusCode}');
      print('📄 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 401) {
        throw Exception('Authentication failed. Please login again.');
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to update review');
      }
    } catch (e) {
      print('❌ Update review error: ${e.toString()}');
      throw Exception('Failed to update review: ${e.toString()}');
    }
  }

  // Delete a review (for the reviewer)
  static Future<bool> deleteReview(String reviewId) async {
    try {
      print('🔄 Deleting review...');
      print('📍 URL: $baseUrl/review/delete/$reviewId');

      final headers = await _getHeaders();
      final response = await http.delete(
        Uri.parse('$baseUrl/review/delete/$reviewId'),
        headers: headers,
      );

      print('📊 Response Status: ${response.statusCode}');
      print('📄 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 401) {
        throw Exception('Authentication failed. Please login again.');
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to delete review');
      }
    } catch (e) {
      print('❌ Delete review error: ${e.toString()}');
      throw Exception('Failed to delete review: ${e.toString()}');
    }
  }
}
