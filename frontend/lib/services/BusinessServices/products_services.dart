import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../features/screen/business/model/addproductsmodel.dart';
import '../../utlis/app_config/app_config.dart';

class ProductApiService {
  // Fetch products for the business
  static Future<List<ProductRequest>> fetchMyProducts(String token) async {
    final url = Uri.parse('${AppConfig.baseUrl}/product/business/list');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      // The backend returns products under 'products' key, not 'data'
      final List<dynamic> dataList =
          decoded['products'] ?? decoded['data'] ?? [];
      return dataList
          .map<ProductRequest>((item) => ProductRequest.fromJson(item))
          .toList();
    } else {
      print("❌ Failed to fetch products: ${response.statusCode}");
      print("❌ Response body: ${response.body}");
      return [];
    }
  }
  //detele
  static Future<bool> deleteProduct(String token, String productId) async {
    final response = await http.delete(
      Uri.parse('${AppConfig.baseUrl}/product/$productId'),
      headers: {'Authorization': 'Bearer $token'},
    );
    return response.statusCode == 200;
  }

  // Create a new product
  static Future<bool> createProduct({
    required String token,
    required ProductRequest product,
  }) async {
    final url = Uri.parse('${AppConfig.baseUrl}/product/');

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(product.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('✅ Product created: ${response.body}');
      return true;
    } else {
      print('❌ Error: ${response.statusCode}');
      print(response.body);
      return false;
    }
  }

  // Get product by ID
  static Future<ProductRequest?> getProductById(
      String token, String productId) async {
    final url = Uri.parse('${AppConfig.baseUrl}/product/$productId');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final productData = decoded['product'] ?? decoded['data'];
      return ProductRequest.fromJson(productData);
    } else {
      print("❌ Failed to fetch product: ${response.statusCode}");
      return null;
    }
  }

  // Update a product
  static Future<bool> updateProduct({
    required String token,
    required String productId,
    required ProductRequest product,
  }) async {
    final url = Uri.parse('${AppConfig.baseUrl}/product/$productId');

    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(product.toJson()),
    );

    if (response.statusCode == 200) {
      print('✅ Product updated: ${response.body}');
      return true;
    } else {
      print('❌ Error updating product: ${response.statusCode}');
      print(response.body);
      return false;
    }
  }
}
