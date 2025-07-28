import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:petcare/utlis/constants/colors.dart';
import '../../../../../common/widgets/Button/primarybutton.dart';
import '../../widgets/custom_text_field.dart';

class AddNewClients extends StatefulWidget {
  const AddNewClients({super.key});

  @override
  State<AddNewClients> createState() => _AddNewClientsState();
}

class _AddNewClientsState extends State<AddNewClients> {
  bool isMale = true;

  // Controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _petNameController = TextEditingController();
  final _speciesController = TextEditingController();
  final _breedController = TextEditingController();
  final _sizeController = TextEditingController();
  final _birthdayController = TextEditingController();
  final _allergiesController = TextEditingController();
  final _medicationsController = TextEditingController();
  final _vaccinatedDateController = TextEditingController();
  final _toysController = TextEditingController();

  // Focus nodes
  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _phoneFocus = FocusNode();
  final _petNameFocus = FocusNode();
  final _speciesFocus = FocusNode();
  final _breedFocus = FocusNode();
  final _sizeFocus = FocusNode();
  final _birthdayFocus = FocusNode();
  final _allergiesFocus = FocusNode();
  final _medicationsFocus = FocusNode();
  final _vaccinatedDateFocus = FocusNode();
  final _toysFocus = FocusNode();

  final Map<String, bool> switches = {
    "Neutered/ Spade": true,
    "Vaccinated": true,
    "Friendly with Dogs": true,
    "Friendly with Cats": false,
    "Friendly with Kids <10 year": true,
    "Friendly with Kids >10 year": true,
    "Microchipped": true,
    "Purebred": true,
    "Potty Trained": true,
    "Send Push Notifications": true,
    "Receive Emails?": true,
  };

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _petNameController.dispose();
    _speciesController.dispose();
    _breedController.dispose();
    _sizeController.dispose();
    _birthdayController.dispose();
    _allergiesController.dispose();
    _medicationsController.dispose();
    _vaccinatedDateController.dispose();
    _toysController.dispose();

    _nameFocus.dispose();
    _emailFocus.dispose();
    _phoneFocus.dispose();
    _petNameFocus.dispose();
    _speciesFocus.dispose();
    _breedFocus.dispose();
    _sizeFocus.dispose();
    _birthdayFocus.dispose();
    _allergiesFocus.dispose();
    _medicationsFocus.dispose();
    _vaccinatedDateFocus.dispose();
    _toysFocus.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Upload Client", style: TextStyle(fontSize: 18.sp))),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 40.r,
                  backgroundColor: Colors.blueGrey,
                  child: Icon(Icons.camera_alt, color: Colors.white, size: 24.sp),
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "Last Visit Date",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: AppColors.primary,
                        fontSize: 14.sp,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      "5/2/2021",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 15.sp,
                      ),
                    ),
                  ],
                )
              ],
            ),

            SizedBox(height: 20.h),

            CustomTextField(
              label: 'Client Name',
              hintText: "Your name",
              controller: _nameController,
              focusNode: _nameFocus,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: () => FocusScope.of(context).requestFocus(_emailFocus),
            ),
            SizedBox(height: 10.h),
            CustomTextField(
              label: 'Client Email',
              hintText: "Email",
              controller: _emailController,
              focusNode: _emailFocus,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: () => FocusScope.of(context).requestFocus(_phoneFocus),
            ),
            SizedBox(height: 10.h),
            CustomTextField(
              label: 'Client Phone Number',
              hintText: "Phone number",
              controller: _phoneController,
              focusNode: _phoneFocus,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: () => FocusScope.of(context).requestFocus(_petNameFocus),
            ),
            SizedBox(height: 10.h),
            CustomTextField(
              label: "Pet's Name",
              hintText: "Troy",
              controller: _petNameController,
              focusNode: _petNameFocus,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: () => FocusScope.of(context).requestFocus(_speciesFocus),
            ),
            SizedBox(height: 10.h),
            CustomTextField(
              label: "Species Type of Pet",
              hintText: "Dog",
              controller: _speciesController,
              focusNode: _speciesFocus,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: () => FocusScope.of(context).requestFocus(_breedFocus),
            ),
            SizedBox(height: 10.h),
            CustomTextField(
              label: "Breed",
              hintText: "Toy Terrier",
              controller: _breedController,
              focusNode: _breedFocus,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: () => FocusScope.of(context).requestFocus(_sizeFocus),
            ),
            SizedBox(height: 10.h),
            CustomTextField(
              label: "Size (optional)",
              hintText: "Weight",
              controller: _sizeController,
              focusNode: _sizeFocus,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: () => FocusScope.of(context).requestFocus(_birthdayFocus),
            ),
            SizedBox(height: 10.h),
            CustomTextField(
              label: "Birthday",
              controller: _birthdayController,
              focusNode: _birthdayFocus,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: () => FocusScope.of(context).requestFocus(_allergiesFocus),
            ),
            SizedBox(height: 10.h),
            CustomTextField(
              label: "Allergies",
              controller: _allergiesController,
              focusNode: _allergiesFocus,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: () => FocusScope.of(context).requestFocus(_medicationsFocus),
            ),
            SizedBox(height: 10.h),
            CustomTextField(
              label: "Current Medications",
              hintText: "None",
              controller: _medicationsController,
              focusNode: _medicationsFocus,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: () => FocusScope.of(context).requestFocus(_vaccinatedDateFocus),
            ),
            SizedBox(height: 10.h),
            CustomTextField(
              label: "Last Vaccinated Date",
              controller: _vaccinatedDateController,
              focusNode: _vaccinatedDateFocus,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: () => FocusScope.of(context).requestFocus(_toysFocus),
            ),
            SizedBox(height: 10.h),
            CustomTextField(
              label: "Favorite Toys",
              controller: _toysController,
              focusNode: _toysFocus,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: () => FocusScope.of(context).unfocus(),
            ),

            SizedBox(height: 20.h),

            Align(
              alignment: Alignment.centerLeft,
              child: Text("What Best Describes Your Pet?", style: TextStyle(fontSize: 14.sp)),
            ),
            SizedBox(height: 8.h),

            Row(
              children: [
                _buildGenderToggle("Male", isMale, () => setState(() => isMale = true)),
                SizedBox(width: 10.w),
                _buildGenderToggle("Female", !isMale, () => setState(() => isMale = false)),
              ],
            ),

            SizedBox(height: 24.h),
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Additional Information", style: TextStyle(fontSize: 14.sp)),
            ),
            SizedBox(height: 12.h),

            ...switches.entries.map((entry) => _buildSwitch(entry.key, entry.value)),

            SizedBox(height: 24.h),
            PrimaryButton(title: 'Save', onPressed: () {
              // Save logic here
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitch(String title, bool value) {
    return SwitchListTile(
      title: Text(title, style: TextStyle(fontSize: 13.sp)),
      value: switches[title]!,
      activeColor: AppColors.white,
      activeTrackColor: const Color(0xFF1976D2),
      inactiveThumbColor: AppColors.dividerColor,
      inactiveTrackColor: AppColors.white,
      onChanged: (val) {
        setState(() {
          switches[title] = val;
        });
      },
    );
  }

  Widget _buildGenderToggle(String label, bool isActive, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF1976D2) : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(8.r),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 14.sp,
            ),
          ),
        ),
      ),
    );
  }
}
