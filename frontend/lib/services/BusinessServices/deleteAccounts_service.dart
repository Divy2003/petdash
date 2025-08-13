import 'dart:convert';

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../utlis/app_config/app_config.dart';




class DeletionService {
  static Future<Map<String, dynamic>> deleteAccount({
    required String password,
    required String token,
  }) async {
    final url = Uri.parse('${AppConfig.baseUrl}/profile/delete-profile');

    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        "confirmPassword": password,
      }),
    );

    final responseBody =
    response.body.isNotEmpty ? json.decode(response.body) : {};

    return {
      "statusCode": response.statusCode,
      "body": responseBody,
    };
  }
}


// Make sure you have the _refreshProfile method defined in your state class
// Future<void> _refreshProfile() async {
//   // Your logic to refresh the profile data
//   setState(() {
//     // Potentially re-fetch profile or clear data
//   });
//   print("Profile refresh triggered.");
// }