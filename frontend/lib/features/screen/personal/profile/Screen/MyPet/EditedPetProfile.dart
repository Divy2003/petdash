import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../../../common/widgets/Button/primarybutton.dart';
import '../../../../../../common/widgets/appbar/appbar.dart';
import '../../../../../../utlis/constants/colors.dart';
import '../../../../../../utlis/constants/size.dart';
import '../../../../../../services/petowerServices/pet_service.dart';
import '../../../../business/widgets/avatarImagepicker.dart';
import '../../../../business/widgets/custom_text_field.dart';

class EditPetScreen extends StatefulWidget {
  final bool isEdit;
  final Map<String, dynamic>? petData; // Use this in edit mode
  final String? petId; // Pet ID for updating

  const EditPetScreen({super.key, this.isEdit = false, this.petData, this.petId});

  @override
  State<EditPetScreen> createState() => _EditPetScreenState();
}

class _EditPetScreenState extends State<EditPetScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isMale = true;
  bool isLoading = false;

  // Form Fields
  late TextEditingController nameController;
  late TextEditingController speciesController;
  late TextEditingController breedController;
  late TextEditingController weightController;
  late TextEditingController birthdayController;
  late TextEditingController allergiesController;
  late TextEditingController medicationsController;
  late TextEditingController vaccinatedDateController;
  late TextEditingController favoriteToysController;

  // Switches
  Map<String, bool> switches = {
    'neutered': false,
    'vaccinated': false,
    'friendlyDogs': false,
    'friendlyCats': false,
    'friendlyKidsUnder10': false,
    'friendlyKidsOver10': false,
    'microchipped': false,
    'purebred': false,
    'pottyTrained': false,
  };

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    nameController = TextEditingController(text: widget.petData?['name'] ?? '');
    speciesController = TextEditingController(text: widget.petData?['species'] ?? '');
    breedController = TextEditingController(text: widget.petData?['breed'] ?? '');
    weightController = TextEditingController(text: widget.petData?['weight'] ?? '');

    // Format dates for display
    String birthdayText = '';
    if (widget.petData?['birthday'] != null) {
      try {
        final date = DateTime.parse(widget.petData!['birthday']);
        birthdayText = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      } catch (e) {
        birthdayText = widget.petData!['birthday'];
      }
    }
    birthdayController = TextEditingController(text: birthdayText);

    // Handle allergies array
    String allergiesText = '';
    if (widget.petData?['allergies'] != null) {
      if (widget.petData!['allergies'] is List) {
        allergiesText = (widget.petData!['allergies'] as List).join(', ');
      } else {
        allergiesText = widget.petData!['allergies'].toString();
      }
    }
    allergiesController = TextEditingController(text: allergiesText);

    medicationsController = TextEditingController(text: widget.petData?['currentMedications'] ?? '');

    // Format vaccination date
    String vaccinatedDateText = '';
    if (widget.petData?['lastVaccinatedDate'] != null) {
      try {
        final date = DateTime.parse(widget.petData!['lastVaccinatedDate']);
        vaccinatedDateText = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      } catch (e) {
        vaccinatedDateText = widget.petData!['lastVaccinatedDate'];
      }
    }
    vaccinatedDateController = TextEditingController(text: vaccinatedDateText);

    // Handle favorite toys array
    String favoriteToysText = '';
    if (widget.petData?['favoriteToys'] != null) {
      if (widget.petData!['favoriteToys'] is List) {
        favoriteToysText = (widget.petData!['favoriteToys'] as List).join(', ');
      } else {
        favoriteToysText = widget.petData!['favoriteToys'].toString();
      }
    }
    favoriteToysController = TextEditingController(text: favoriteToysText);

    // Set gender
    if (widget.petData?['gender'] != null) {
      isMale = widget.petData!['gender'].toString().toLowerCase() == 'male';
    }

    // Set switches if editing
    if (widget.isEdit && widget.petData != null) {
      switches['neutered'] = widget.petData!['neutered'] ?? false;
      switches['vaccinated'] = widget.petData!['vaccinated'] ?? false;
      switches['friendlyDogs'] = widget.petData!['friendlyWithDogs'] ?? false;
      switches['friendlyCats'] = widget.petData!['friendlyWithCats'] ?? false;
      switches['friendlyKidsUnder10'] = widget.petData!['friendlyWithKidsUnder10'] ?? false;
      switches['friendlyKidsOver10'] = widget.petData!['friendlyWithKidsOver10'] ?? false;
      switches['microchipped'] = widget.petData!['microchipped'] ?? false;
      switches['purebred'] = widget.petData!['purebred'] ?? false;
      switches['pottyTrained'] = widget.petData!['pottyTrained'] ?? false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          title: widget.isEdit ? 'Edit Pet' : 'Add New Pet'),

      body: SingleChildScrollView(
        padding:  EdgeInsets.symmetric(
            horizontal: AppSizes.defaultPaddingHorizontal,
            vertical: AppSizes.defaultPaddingVertical),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Photo & QR row
              Center(
                child: AvatarImagePicker(),
              ),
              const SizedBox(height: 16),

              CustomTextField(
                label: 'Pet’s Name',
                hintText: "Troy",
                controller: nameController,
              ),
              SizedBox(height: AppSizes.defaultSpace/2),
              CustomTextField(
                label: 'Species Type of Pet',
                hintText: "Dog",
                controller: speciesController,
              ),
              SizedBox(height: AppSizes.defaultSpace/2),
              CustomTextField(
                label: 'Breed',
                hintText: "Toy Terrier",
                controller: breedController,
              ),
              SizedBox(height: AppSizes.defaultSpace/2),
              CustomTextField(
                label: 'Size (optional)',
                hintText: "Weight",
                controller: weightController,
              ),
              SizedBox(height: AppSizes.defaultSpace/2),
              // Text fields
              Row(
                children: [
                  _buildGenderToggle("Male", isMale, () => setState(() => isMale = true)),
                  SizedBox(width: 10.w),
                  _buildGenderToggle("Female", !isMale, () => setState(() => isMale = false)),
                ],
              ),

              SizedBox(height: AppSizes.defaultSpace/2),
              CustomTextField(
                label: 'Birthday',
                controller: birthdayController,
              ),
              SizedBox(height: AppSizes.defaultSpace/2),
              CustomTextField(
                label: 'Allergies',
                controller: allergiesController,
              ),
              SizedBox(height: AppSizes.defaultSpace/2),
              CustomTextField(
                label: 'Current Medications',
                controller: medicationsController,
              ),
              SizedBox(height: AppSizes.defaultSpace/2),
              CustomTextField(
                label: 'Last vaccinated date',
                controller: vaccinatedDateController,
              ),
              SizedBox(height: AppSizes.defaultSpace/2),
              CustomTextField(
                label: 'Favorite Toys',
                controller: favoriteToysController,
              ),

              SizedBox(height: AppSizes.spaceBtwItems),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                    'Additional Information',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),

              // Switches
              _buildSwitch('Neutered/ Spade', 'neutered'),
              _buildSwitch('Vaccinated', 'vaccinated'),
              _buildSwitch('Friendly with Dogs', 'friendlyDogs'),
              _buildSwitch('Friendly with Cats', 'friendlyCats'),
              _buildSwitch('Friendly with Kids <10 year', 'friendlyKidsUnder10'),
              _buildSwitch('Friendly with Kids >10 year', 'friendlyKidsOver10'),
              _buildSwitch('Microchipped', 'microchipped'),
              _buildSwitch('Purebred', 'purebred'),
              _buildSwitch('Potty Trained', 'pottyTrained'),

              const SizedBox(height: 16),

              // Primary Services
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                    'Primary Services',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              _buildSelectServiceButton('Preferred Primary Veterinarian'),
              _buildSelectServiceButton('Preferred Pharmacy'),
              _buildSelectServiceButton('Preferred Primary Groomer'),
              _buildSelectServiceButton('Favorite Dog Park'),

              const SizedBox(height: 20),
              PrimaryButton(
                title: isLoading ? 'Saving...' : 'Save',
                onPressed: isLoading ? null : _savePet,
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildGenderToggle(String label, bool isActive, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(AppSizes.borderRadiusSm),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: isActive ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSwitch(String title, String key) {
    return SwitchListTile(
      title: Text(title),
      value: switches[key]!,
      activeColor: AppColors.white,
      activeTrackColor: const Color(0xFF1976D2),
      inactiveThumbColor: AppColors.dividerColor,
      inactiveTrackColor: AppColors.white,
      onChanged: (val) => setState(() => switches[key] = val),
    );
  }

  Widget _buildSelectServiceButton(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w500,
            ),
          ),

          TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.all(5),
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.borderRadiusMd),
              ),
              //minimumSize: Size(50.w, 35.h),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            onPressed: () {
              // Handle select service
            },
            child:  Text('Select',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _savePet() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (nameController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Pet name is required',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (widget.isEdit && widget.petId == null) {
      Get.snackbar(
        'Error',
        'Pet ID is required for updating',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // Parse allergies and favorite toys from comma-separated strings
      List<String>? allergies;
      if (allergiesController.text.trim().isNotEmpty) {
        allergies = allergiesController.text
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();
      }

      List<String>? favoriteToys;
      if (favoriteToysController.text.trim().isNotEmpty) {
        favoriteToys = favoriteToysController.text
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();
      }

      // Parse dates
      DateTime? birthday;
      if (birthdayController.text.trim().isNotEmpty) {
        try {
          birthday = DateTime.parse(birthdayController.text.trim());
        } catch (e) {
          Get.snackbar(
            'Error',
            'Invalid birthday format. Please use YYYY-MM-DD',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          setState(() {
            isLoading = false;
          });
          return;
        }
      }

      DateTime? lastVaccinatedDate;
      if (vaccinatedDateController.text.trim().isNotEmpty) {
        try {
          lastVaccinatedDate = DateTime.parse(vaccinatedDateController.text.trim());
        } catch (e) {
          Get.snackbar(
            'Error',
            'Invalid vaccination date format. Please use YYYY-MM-DD',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          setState(() {
            isLoading = false;
          });
          return;
        }
      }

      final result = await PetService.updatePetProfile(
        petId: widget.petId!,
        name: nameController.text.trim(),
        species: speciesController.text.trim().isNotEmpty ? speciesController.text.trim() : null,
        breed: breedController.text.trim().isNotEmpty ? breedController.text.trim() : null,
        weight: weightController.text.trim().isNotEmpty ? weightController.text.trim() : null,
        gender: isMale ? 'Male' : 'Female',
        birthday: birthday,
        allergies: allergies,
        currentMedications: medicationsController.text.trim().isNotEmpty ? medicationsController.text.trim() : null,
        lastVaccinatedDate: lastVaccinatedDate,
        favoriteToys: favoriteToys,
        neutered: switches['neutered'],
        vaccinated: switches['vaccinated'],
        friendlyWithDogs: switches['friendlyDogs'],
        friendlyWithCats: switches['friendlyCats'],
        friendlyWithKidsUnder10: switches['friendlyKidsUnder10'],
        friendlyWithKidsOver10: switches['friendlyKidsOver10'],
        microchipped: switches['microchipped'],
        purebred: switches['purebred'],
        pottyTrained: switches['pottyTrained'],
      );

      if (result != null) {
        Get.snackbar(
          'Success',
          'Pet profile updated successfully!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
       Navigator.pop(context, true); // Return true to indicate success
      } else {
        Get.snackbar(
          'Error',
          'Failed to update pet profile',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update pet profile: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
