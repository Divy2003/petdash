import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petcare/features/screen/personal/profile/Screen/MyPet/AddAnotherPet.dart';

import '../../../../../../common/widgets/Button/primarybutton.dart';
import '../../../../../../common/widgets/appbar/appbar.dart';
import '../../../../../../common/widgets/progessIndicator/threedotindicator.dart';
import '../../../../../../utlis/constants/colors.dart';
import '../../../../../../utlis/constants/image_strings.dart';
import '../../../../../../utlis/constants/size.dart';
import '../../../../../../models/pet_model.dart';
import '../../../../../../services/petowerServices/pet_service.dart';
import '../../../../../../utlis/app_config/app_config.dart';
import 'EditedPetProfile.dart';
import 'GetPetProfile.dart';

class MyPetsScreen extends StatefulWidget {
  const MyPetsScreen({super.key});

  @override
  State<MyPetsScreen> createState() => _MyPetsScreenState();
}

class _MyPetsScreenState extends State<MyPetsScreen> {
  List<PetModel> pets = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadPets();
  }

  Future<void> _loadPets() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final fetchedPets = await PetService.getAllPets();
      setState(() {
        pets = fetchedPets;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
      Get.snackbar(
        'Error',
        'Failed to load pets: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'My Pets'),

      body: isLoading
          ? const Center(child: ThreeDotIndicator())
          : errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error, size: 64, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(
                        'Error loading pets',
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
                        onPressed: _loadPets,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : pets.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.pets, size: 64, color: AppColors.primary),
                          const SizedBox(height: 16),
                          Text(
                            'No pets found',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Add your first pet to get started',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 16),
                          PrimaryButton(
                            title: 'Add Your First Pet',
                            onPressed: () async {
                              final result = await Get.to(() => AddOrEditPetScreen());
                              if (result == true) {
                                _loadPets(); // Refresh the list
                              }
                            },
                          ),
                        ],
                      ),
                    )
                  : SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSizes.defaultPaddingHorizontal,
                          vertical: AppSizes.defaultPaddingVertical,
                        ),
                        child: Column(
                          children: [
                            // Pet List
                            ...pets.map((pet) => _buildPetCard(pet)),
                            const SizedBox(height: 24),

                            // Add Another Pet Button
                            PrimaryButton(
                              title: 'Add Another Pet',
                              onPressed: () async {
                                final result = await Get.to(() => AddOrEditPetScreen());
                                if (result == true) {
                                  _loadPets(); // Refresh the list
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
    );
  }

  Widget _buildPetCard(PetModel pet) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(AppSizes.sm),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimaryColor.withOpacity(0.5),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () {
          Get.to(() => GetPetProfile(petId: pet.id!));
        },
        child: Row(
          children: [
            // Pet Image
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: pet.profileImage != null
                  ? Image.network(
                      '${AppConfig.baseFileUrl}/${pet.profileImage}',
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          AppImages.dog1,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        );
                      },
                    )
                  : Image.asset(
                      AppImages.dog1,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
            ),
            const SizedBox(width: 12),

            // Pet Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pet.name,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (pet.breed != null)
                    Text(
                      pet.breed!,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  if (pet.species != null)
                    Text(
                      pet.species!,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: AppColors.textPrimaryColor,
                      ),
                    ),
                  if (pet.weight != null)
                    Text(
                      'Weight: ${pet.weight}',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: AppColors.textPrimaryColor,
                      ),
                    ),
                ],
              ),
            ),

            // Edit Icon
            IconButton(
              icon: Icon(Icons.edit, color: AppColors.dividerColor),
              onPressed: () async {
                final result = await Get.to(() => EditPetScreen(
                      isEdit: true,
                      petData: pet.toJson(),
                      petId: pet.id!,
                    ));
                if (result == true) {
                  _loadPets(); // Refresh the list
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
