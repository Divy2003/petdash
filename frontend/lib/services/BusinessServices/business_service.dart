import '../../models/business_model.dart';
import '../api_service.dart';

class BusinessService {
  // Get businesses by category
  static Future<List<BusinessModel>> getBusinessesByCategory(
    String categoryId, {
    int page = 1,
    int limit = 10,
    String? city,
    String? state,
    String? zipCode,
  }) async {
    try {
      Map<String, String> queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
      };

      if (city != null && city.isNotEmpty) {
        queryParams['city'] = city;
      }
      if (state != null && state.isNotEmpty) {
        queryParams['state'] = state;
      }
      if (zipCode != null && zipCode.isNotEmpty) {
        queryParams['zipCode'] = zipCode;
      }

      print(
          '🌐 BusinessService: Making API call to /business/category/$categoryId');
      print('📋 BusinessService: Query params: $queryParams');

      final response = await ApiService.get(
        '/business/category/$categoryId',
        queryParams: queryParams,
      );

      print('📥 BusinessService: API response received');
      print('🔍 BusinessService: Response keys: ${response.keys.toList()}');

      if (response['businesses'] != null) {
        final List<dynamic> businessesJson = response['businesses'];
        print(
            '✅ BusinessService: Found ${businessesJson.length} businesses in response');

        // Log each business for debugging
        for (int i = 0; i < businessesJson.length; i++) {
          final businessJson = businessesJson[i];
          print(
              '   Business ${i + 1}: ${businessJson['name']} (ID: ${businessJson['_id']})');
          print('     UserType: ${businessJson['userType']}');
          print('     IsActive: ${businessJson['isActive']}');
          print('     Email: ${businessJson['email']}');
          print('     Profile Image: ${businessJson['profileImage']}');
          print('     Shop Image: ${businessJson['shopImage']}');
        }

        final businesses =
            businessesJson.map((json) => BusinessModel.fromJson(json)).toList();
        print(
            '🏗️ BusinessService: Successfully parsed ${businesses.length} BusinessModel objects');
        return businesses;
      } else {
        print('⚠️ BusinessService: No "businesses" key in response');
        print('📄 BusinessService: Full response: $response');
      }

      return [];
    } catch (e) {
      print('❌ BusinessService: Error fetching businesses: $e');
      throw Exception('Failed to fetch businesses: ${e.toString()}');
    }
  }

  // Get detailed business profile
  static Future<BusinessModel?> getBusinessProfile(String businessId) async {
    try {
      final response = await ApiService.get('/business/profile/$businessId');

      if (response['business'] != null) {
        return BusinessModel.fromJson(response['business']);
      }

      return null;
    } catch (e) {
      throw Exception('Failed to fetch business profile: ${e.toString()}');
    }
  }

  // Search businesses
  static Future<List<BusinessModel>> searchBusinesses({
    String? query,
    String? category,
    String? city,
    String? state,
    String? zipCode,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      Map<String, String> queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
      };

      if (query != null && query.isNotEmpty) {
        queryParams['query'] = query;
      }
      if (category != null && category.isNotEmpty) {
        queryParams['category'] = category;
      }
      if (city != null && city.isNotEmpty) {
        queryParams['city'] = city;
      }
      if (state != null && state.isNotEmpty) {
        queryParams['state'] = state;
      }
      if (zipCode != null && zipCode.isNotEmpty) {
        queryParams['zipCode'] = zipCode;
      }

      final response = await ApiService.get(
        '/business/search',
        queryParams: queryParams,
      );

      if (response['businesses'] != null) {
        final List<dynamic> businessesJson = response['businesses'];
        return businessesJson
            .map((json) => BusinessModel.fromJson(json))
            .toList();
      }

      return [];
    } catch (e) {
      throw Exception('Failed to search businesses: ${e.toString()}');
    }
  }
}
