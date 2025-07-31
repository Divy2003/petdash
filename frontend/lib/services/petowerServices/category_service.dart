import 'package:petcare/utlis/constants/image_strings.dart';

import '../../models/category_model.dart';
import '../api_service.dart';

class CategoryService {
  // Get all active categories for public display
  static Future<List<CategoryModel>> getPublicCategories() async {
    try {
      final response = await ApiService.get('/category/public');

      if (response['categories'] != null) {
        final List<dynamic> categoriesJson = response['categories'];
        return categoriesJson
            .map((json) => CategoryModel.fromJson(json))
            .toList();
      }

      return [];
    } catch (e) {
      throw Exception('Failed to fetch categories: ${e.toString()}');
    }
  }

  // Get single category by ID (requires authentication)
  static Future<CategoryModel?> getCategoryById(String categoryId) async {
    try {
      final response =
          await ApiService.get('/category/$categoryId', requireAuth: true);

      if (response['category'] != null) {
        return CategoryModel.fromJson(response['category']);
      }

      return null;
    } catch (e) {
      throw Exception('Failed to fetch category: ${e.toString()}');
    }
  }

  // Map category names to local icons
  static String getLocalIconForCategory(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'pet sitting':
      case 'sitting':
        return AppImages.sitting;
      case 'veterinary':
      case 'health':
      case 'medical':
        return AppImages.sitting;
      case 'pet boarding':
      case 'boarding':
        return AppImages.sitting;
      case 'pet training':
      case 'training':
        return AppImages.sitting;
      case 'pet grooming':
      case 'grooming':
        return AppImages.sitting;
      case 'dog walking':
      case 'walking':
        return AppImages.sitting;
      default:
        return AppImages.sitting;
    }
  }

  // Map category names to colors
  static int getColorForCategory(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'pet sitting':
      case 'sitting':
        return 0x807DC1CF;
      case 'veterinary':
      case 'health':
      case 'medical':
        return 0xA31976D2;
      case 'pet boarding':
      case 'boarding':
        return 0x80F0546C;
      case 'pet training':
      case 'training':
        return 0x80FFC107;
      case 'pet grooming':
      case 'grooming':
        return 0x99FFC107;
      case 'dog walking':
      case 'walking':
        return 0x804CD964;
      default:
        return 0x80808080; // Gray default
    }
  }
}
