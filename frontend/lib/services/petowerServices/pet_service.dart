import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/pet_model.dart';
import '../../utlis/app_config/app_config.dart';

class PetService {
  static const String baseUrl = AppConfig.baseUrl;

  // Get headers with authentication
  static Future<Map<String, String>> _getHeaders({bool isMultipart = false}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';
    
    if (isMultipart) {
      return {
        'Authorization': 'Bearer $token',
      };
    } else {
      return {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
    }
  }

  // Create Pet Profile
  static Future<PetModel?> createPetProfile({
    required String name,
    String? species,
    String? typeOfPet,
    String? breed,
    String? weight,
    String? gender,
    DateTime? birthday,
    List<String>? allergies,
    String? currentMedications,
    DateTime? lastVaccinatedDate,
    List<Vaccination>? vaccinations,
    List<String>? favoriteToys,
    File? profileImageFile,
    bool? neutered,
    bool? vaccinated,
    bool? friendlyWithDogs,
    bool? friendlyWithCats,
    bool? friendlyWithKidsUnder10,
    bool? friendlyWithKidsOver10,
    bool? microchipped,
    bool? purebred,
    bool? pottyTrained,
    String? preferredVeterinarian,
    String? preferredPharmacy,
    String? preferredGroomer,
    String? favoriteDogPark,
  }) async {
    try {
      print('🔄 Creating pet profile...');
      print('📍 URL: $baseUrl/pet/create');

      final headers = await _getHeaders(isMultipart: true);
      
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/pet/create'),
      );

      // Add headers
      request.headers.addAll(headers);

      // Add text fields
      request.fields['name'] = name;
      if (species != null) request.fields['species'] = species;
      if (typeOfPet != null) request.fields['typeOfPet'] = typeOfPet;
      if (breed != null) request.fields['breed'] = breed;
      if (weight != null) request.fields['weight'] = weight;
      if (gender != null) request.fields['gender'] = gender;
      if (birthday != null) request.fields['birthday'] = birthday.toIso8601String();
      if (allergies != null) request.fields['allergies'] = json.encode(allergies);
      if (currentMedications != null) request.fields['currentMedications'] = currentMedications;
      if (lastVaccinatedDate != null) request.fields['lastVaccinatedDate'] = lastVaccinatedDate.toIso8601String();
      if (vaccinations != null) request.fields['vaccinations'] = json.encode(vaccinations.map((v) => v.toJson()).toList());
      if (favoriteToys != null) request.fields['favoriteToys'] = json.encode(favoriteToys);
      
      // Boolean fields
      if (neutered != null) request.fields['neutered'] = neutered.toString();
      if (vaccinated != null) request.fields['vaccinated'] = vaccinated.toString();
      if (friendlyWithDogs != null) request.fields['friendlyWithDogs'] = friendlyWithDogs.toString();
      if (friendlyWithCats != null) request.fields['friendlyWithCats'] = friendlyWithCats.toString();
      if (friendlyWithKidsUnder10 != null) request.fields['friendlyWithKidsUnder10'] = friendlyWithKidsUnder10.toString();
      if (friendlyWithKidsOver10 != null) request.fields['friendlyWithKidsOver10'] = friendlyWithKidsOver10.toString();
      if (microchipped != null) request.fields['microchipped'] = microchipped.toString();
      if (purebred != null) request.fields['purebred'] = purebred.toString();
      if (pottyTrained != null) request.fields['pottyTrained'] = pottyTrained.toString();
      
      // Primary services
      if (preferredVeterinarian != null) request.fields['preferredVeterinarian'] = preferredVeterinarian;
      if (preferredPharmacy != null) request.fields['preferredPharmacy'] = preferredPharmacy;
      if (preferredGroomer != null) request.fields['preferredGroomer'] = preferredGroomer;
      if (favoriteDogPark != null) request.fields['favoriteDogPark'] = favoriteDogPark;

      // Add profile image if provided
      if (profileImageFile != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'profileImage',
          profileImageFile.path,
        ));
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print('📊 Response Status: ${response.statusCode}');
      print('📄 Response Body: ${response.body}');

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        if (data['pet'] != null) {
          print('✅ Pet profile created successfully');
          return PetModel.fromJson(data['pet']);
        }
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to create pet profile');
      }

      return null;
    } catch (e) {
      print('❌ Pet creation error: ${e.toString()}');
      throw Exception('Failed to create pet profile: ${e.toString()}');
    }
  }

  // Update Pet Profile
  static Future<PetModel?> updatePetProfile({
    required String petId,
    String? name,
    String? species,
    String? typeOfPet,
    String? breed,
    String? weight,
    String? gender,
    DateTime? birthday,
    List<String>? allergies,
    String? currentMedications,
    DateTime? lastVaccinatedDate,
    List<Vaccination>? vaccinations,
    List<String>? favoriteToys,
    File? profileImageFile,
    bool? neutered,
    bool? vaccinated,
    bool? friendlyWithDogs,
    bool? friendlyWithCats,
    bool? friendlyWithKidsUnder10,
    bool? friendlyWithKidsOver10,
    bool? microchipped,
    bool? purebred,
    bool? pottyTrained,
    String? preferredVeterinarian,
    String? preferredPharmacy,
    String? preferredGroomer,
    String? favoriteDogPark,
  }) async {
    try {
      print('🔄 Updating pet profile...');
      print('📍 URL: $baseUrl/pet/update/$petId');

      final headers = await _getHeaders(isMultipart: true);
      
      var request = http.MultipartRequest(
        'PUT',
        Uri.parse('$baseUrl/pet/update/$petId'),
      );

      // Add headers
      request.headers.addAll(headers);

      // Add text fields (only if not null)
      if (name != null) request.fields['name'] = name;
      if (species != null) request.fields['species'] = species;
      if (typeOfPet != null) request.fields['typeOfPet'] = typeOfPet;
      if (breed != null) request.fields['breed'] = breed;
      if (weight != null) request.fields['weight'] = weight;
      if (gender != null) request.fields['gender'] = gender;
      if (birthday != null) request.fields['birthday'] = birthday.toIso8601String();
      if (allergies != null) request.fields['allergies'] = json.encode(allergies);
      if (currentMedications != null) request.fields['currentMedications'] = currentMedications;
      if (lastVaccinatedDate != null) request.fields['lastVaccinatedDate'] = lastVaccinatedDate.toIso8601String();
      if (vaccinations != null) request.fields['vaccinations'] = json.encode(vaccinations.map((v) => v.toJson()).toList());
      if (favoriteToys != null) request.fields['favoriteToys'] = json.encode(favoriteToys);
      
      // Boolean fields
      if (neutered != null) request.fields['neutered'] = neutered.toString();
      if (vaccinated != null) request.fields['vaccinated'] = vaccinated.toString();
      if (friendlyWithDogs != null) request.fields['friendlyWithDogs'] = friendlyWithDogs.toString();
      if (friendlyWithCats != null) request.fields['friendlyWithCats'] = friendlyWithCats.toString();
      if (friendlyWithKidsUnder10 != null) request.fields['friendlyWithKidsUnder10'] = friendlyWithKidsUnder10.toString();
      if (friendlyWithKidsOver10 != null) request.fields['friendlyWithKidsOver10'] = friendlyWithKidsOver10.toString();
      if (microchipped != null) request.fields['microchipped'] = microchipped.toString();
      if (purebred != null) request.fields['purebred'] = purebred.toString();
      if (pottyTrained != null) request.fields['pottyTrained'] = pottyTrained.toString();
      
      // Primary services
      if (preferredVeterinarian != null) request.fields['preferredVeterinarian'] = preferredVeterinarian;
      if (preferredPharmacy != null) request.fields['preferredPharmacy'] = preferredPharmacy;
      if (preferredGroomer != null) request.fields['preferredGroomer'] = preferredGroomer;
      if (favoriteDogPark != null) request.fields['favoriteDogPark'] = favoriteDogPark;

      // Add profile image if provided
      if (profileImageFile != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'profileImage',
          profileImageFile.path,
        ));
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print('📊 Response Status: ${response.statusCode}');
      print('📄 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['pet'] != null) {
          print('✅ Pet profile updated successfully');
          return PetModel.fromJson(data['pet']);
        }
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to update pet profile');
      }

      return null;
    } catch (e) {
      print('❌ Pet update error: ${e.toString()}');
      throw Exception('Failed to update pet profile: ${e.toString()}');
    }
  }

  // Get Pet Profile by ID
  static Future<PetModel?> getPetProfile(String petId) async {
    try {
      print('🔄 Fetching pet profile...');
      print('📍 URL: $baseUrl/pet/$petId');

      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/pet/$petId'),
        headers: headers,
      );

      print('📊 Response Status: ${response.statusCode}');
      print('📄 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['pet'] != null) {
          print('✅ Pet profile fetched successfully');
          return PetModel.fromJson(data['pet']);
        }
      } else if (response.statusCode == 404) {
        throw Exception('Pet not found');
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to fetch pet profile');
      }

      return null;
    } catch (e) {
      print('❌ Pet fetch error: ${e.toString()}');
      throw Exception('Failed to fetch pet profile: ${e.toString()}');
    }
  }

  // Get All Pets for the authenticated user
  static Future<List<PetModel>> getAllPets() async {
    try {
      print('🔄 Fetching all pets...');
      print('📍 URL: $baseUrl/pet/all');

      final headers = await _getHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl/pet/all'),
        headers: headers,
      );

      print('📊 Response Status: ${response.statusCode}');
      print('📄 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['pets'] != null) {
          final List<dynamic> petsJson = data['pets'];
          print('✅ ${petsJson.length} pets fetched successfully');
          return petsJson.map((json) => PetModel.fromJson(json)).toList();
        }
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to fetch pets');
      }

      return [];
    } catch (e) {
      print('❌ Pets fetch error: ${e.toString()}');
      throw Exception('Failed to fetch pets: ${e.toString()}');
    }
  }
}
