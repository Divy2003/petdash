import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../common/widgets/appbar/appbar.dart';
import '../../../../../../utlis/constants/colors.dart';
import '../../../../../../utlis/constants/image_strings.dart';
import '../../../../../../utlis/constants/size.dart';
import '../../../../../../models/pet_model.dart';
import '../../../../../../services/petowerServices/pet_service.dart';
import '../../../../../../utlis/app_config/app_config.dart';
import 'EditedPetProfile.dart';

class GetPetProfile extends StatefulWidget {
  final String petId;

  const GetPetProfile({super.key, required this.petId});

  @override
  State<GetPetProfile> createState() => _GetPetProfileState();
}

class _GetPetProfileState extends State<GetPetProfile> {
  PetModel? pet;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadPetProfile();
  }

  Future<void> _loadPetProfile() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final fetchedPet = await PetService.getPetProfile(widget.petId);
      setState(() {
        pet = fetchedPet;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
      Get.snackbar(
        'Error',
        'Failed to load pet profile: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: pet?.name ?? 'Pet Profile',
        actions: [
          if (pet != null)
            IconButton(
              icon: Icon(Icons.edit, color: AppColors.primary),
              onPressed: () async {
                final result = await Get.to(() => EditPetScreen(
                      isEdit: true,
                      petData: pet!.toJson(),
                      petId: pet!.id!,
                    ));
                if (result == true) {
                  _loadPetProfile(); // Refresh the profile
                }
              },
            ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error, size: 64, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(
                        'Error loading pet profile',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        errorMessage!,
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadPetProfile,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : pet == null
                  ? const Center(child: Text('Pet not found'))
                  : SingleChildScrollView(
                      padding: EdgeInsets.all(AppSizes.defaultPaddingHorizontal),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Pet Image and Basic Info
                          _buildPetHeader(),
                          const SizedBox(height: 24),

                          // Basic Information
                          _buildSection('Basic Information', [
                            _buildInfoRow('Name', pet!.name),
                            if (pet!.species != null) _buildInfoRow('Species', pet!.species!),
                            if (pet!.breed != null) _buildInfoRow('Breed', pet!.breed!),
                            if (pet!.weight != null) _buildInfoRow('Weight', pet!.weight!),
                            if (pet!.gender != null) _buildInfoRow('Gender', pet!.gender!),
                            if (pet!.birthday != null)
                              _buildInfoRow('Birthday', _formatDate(pet!.birthday!)),
                          ]),

                          // Health Information
                          if (_hasHealthInfo())
                            _buildSection('Health Information', [
                              if (pet!.allergies != null && pet!.allergies!.isNotEmpty)
                                _buildInfoRow('Allergies', pet!.allergies!.join(', ')),
                              if (pet!.currentMedications != null)
                                _buildInfoRow('Current Medications', pet!.currentMedications!),
                              if (pet!.lastVaccinatedDate != null)
                                _buildInfoRow('Last Vaccinated', _formatDate(pet!.lastVaccinatedDate!)),
                            ]),

                          // Personality & Behavior
                          if (_hasPersonalityInfo())
                            _buildSection('Personality & Behavior', [
                              if (pet!.friendlyWithDogs != null)
                                _buildBooleanRow('Friendly with Dogs', pet!.friendlyWithDogs!),
                              if (pet!.friendlyWithCats != null)
                                _buildBooleanRow('Friendly with Cats', pet!.friendlyWithCats!),
                              if (pet!.friendlyWithKidsUnder10 != null)
                                _buildBooleanRow('Friendly with Kids <10', pet!.friendlyWithKidsUnder10!),
                              if (pet!.friendlyWithKidsOver10 != null)
                                _buildBooleanRow('Friendly with Kids >10', pet!.friendlyWithKidsOver10!),
                            ]),

                          // Additional Information
                          if (_hasAdditionalInfo())
                            _buildSection('Additional Information', [
                              if (pet!.neutered != null)
                                _buildBooleanRow('Neutered/Spayed', pet!.neutered!),
                              if (pet!.vaccinated != null)
                                _buildBooleanRow('Vaccinated', pet!.vaccinated!),
                              if (pet!.microchipped != null)
                                _buildBooleanRow('Microchipped', pet!.microchipped!),
                              if (pet!.purebred != null)
                                _buildBooleanRow('Purebred', pet!.purebred!),
                              if (pet!.pottyTrained != null)
                                _buildBooleanRow('Potty Trained', pet!.pottyTrained!),
                            ]),
                        ],
                      ),
                    ),
    );
  }

  Widget _buildPetHeader() {
    return Center(
      child: Column(
        children: [
          // Pet Image
          ClipRRect(
            borderRadius: BorderRadius.circular(80),
            child: pet!.profileImage != null
                ? Image.network(
                    '${AppConfig.baseFileUrl}/${pet!.profileImage}',
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        AppImages.dog1,
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                      );
                    },
                  )
                : Image.asset(
                    AppImages.dog1,
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
          ),
          const SizedBox(height: 16),

          // Pet Name
          Text(
            pet!.name,
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),

          if (pet!.breed != null)
            Text(
              pet!.breed!,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: AppColors.textPrimaryColor,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: EdgeInsets.all(AppSizes.md),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg),
            boxShadow: [
              BoxShadow(
                color: AppColors.textPrimaryColor.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(children: children),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: AppColors.textPrimaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBooleanRow(String label, bool value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
          Icon(
            value ? Icons.check_circle : Icons.cancel,
            color: value ? Colors.green : Colors.red,
            size: 20,
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  bool _hasHealthInfo() {
    return (pet!.allergies != null && pet!.allergies!.isNotEmpty) ||
           pet!.currentMedications != null ||
           pet!.lastVaccinatedDate != null;
  }

  bool _hasPersonalityInfo() {
    return pet!.friendlyWithDogs != null ||
           pet!.friendlyWithCats != null ||
           pet!.friendlyWithKidsUnder10 != null ||
           pet!.friendlyWithKidsOver10 != null;
  }

  bool _hasAdditionalInfo() {
    return pet!.neutered != null ||
           pet!.vaccinated != null ||
           pet!.microchipped != null ||
           pet!.purebred != null ||
           pet!.pottyTrained != null;
  }
}
