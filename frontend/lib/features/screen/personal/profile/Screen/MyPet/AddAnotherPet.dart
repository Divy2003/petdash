import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../common/widgets/Button/primarybutton.dart';
import '../../../../../../common/widgets/appbar/appbar.dart';
import '../../../../../../utlis/constants/colors.dart';
import '../../../../../../utlis/constants/size.dart';
import '../../../../business/widgets/custom_text_field.dart';

class AddOrEditPetScreen extends StatefulWidget {
  final bool isEdit;
  final Map<String, dynamic>? petData; // Use this in edit mode

  const AddOrEditPetScreen({super.key, this.isEdit = false, this.petData});

  @override
  State<AddOrEditPetScreen> createState() => _AddOrEditPetScreenState();
}

class _AddOrEditPetScreenState extends State<AddOrEditPetScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isMale = true;

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
    nameController = TextEditingController(text: widget.petData?['name'] ?? '');
    speciesController = TextEditingController(text: widget.petData?['species'] ?? '');
    breedController = TextEditingController(text: widget.petData?['breed'] ?? '');
    weightController = TextEditingController(text: widget.petData?['weight'] ?? '');
    birthdayController = TextEditingController(text: widget.petData?['birthday'] ?? '');
    allergiesController = TextEditingController(text: widget.petData?['allergies'] ?? '');
    medicationsController = TextEditingController(text: widget.petData?['medications'] ?? '');
    vaccinatedDateController = TextEditingController(text: widget.petData?['vaccinatedDate'] ?? '');
    favoriteToysController = TextEditingController(text: widget.petData?['favoriteToys'] ?? '');

    // Set switches if editing
    if (widget.isEdit && widget.petData != null) {
      switches.updateAll((key, value) => widget.petData![key] ?? false);
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
              CircleAvatar(radius: 40, child: Icon(Icons.camera_alt)),
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
                  title: 'Save', onPressed: () {
                // Save logic here
              }),
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
}
