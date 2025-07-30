// Flutter Profile Screen with time formatting, image handling, and best practices
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:petcare/services/profile_service.dart';
import 'package:petcare/utlis/constants/colors.dart';
import 'package:petcare/utlis/constants/image_strings.dart';
import 'package:petcare/utlis/constants/size.dart';
import '../../../../common/widgets/Button/primarybutton.dart';
import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../models/profile_model.dart';

class CreateProfile extends StatefulWidget {
  const CreateProfile({super.key});

  @override
  State<CreateProfile> createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final addressController = TextEditingController();
  final shopOpenTimeController = TextEditingController();
  final shopCloseTimeController = TextEditingController();

  File? _profileImageFile;
  File? _shopImageFile;
  ProfileModel? _profile;
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final profileData = await ProfileService.getProfile();
      final profile = ProfileModel.fromJson(profileData);
      setState(() {
        _profile = profile;
        nameController.text = profile.name ?? '';
        emailController.text = profile.email ?? '';
        phoneNumberController.text = profile.phoneNumber ?? '';
        addressController.text = profile.primaryAddress?.fullAddress ?? '';
        shopOpenTimeController.text = profile.shopOpenTime ?? '';
        shopCloseTimeController.text = profile.shopCloseTime ?? '';
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorSnackBar('Failed to load profile: $e');
    }
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showSuccessSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  Future<void> _pickImage(bool isShopImage) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        if (isShopImage) {
          _shopImageFile = File(picked.path);
        } else {
          _profileImageFile = File(picked.path);
        }
      });
    }
  }

  Future<void> _selectTime(TextEditingController controller) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      final formatted = '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      controller.text = formatted;
    }
  }

  Future<void> _saveProfile() async {
    if (_isSaving) return;
    setState(() => _isSaving = true);
    try {
      await ProfileService.updateProfile(
        name: nameController.text.trim().isEmpty ? null : nameController.text.trim(),
        email: emailController.text.trim().isEmpty ? null : emailController.text.trim(),
        phoneNumber: phoneNumberController.text.trim().isEmpty ? null : phoneNumberController.text.trim(),
        address: addressController.text.trim().isEmpty ? null : addressController.text.trim(),
        profileImage: _profileImageFile,
        shopImage: _shopImageFile,
        shopOpenTime: shopOpenTimeController.text.trim().isEmpty ? null : shopOpenTimeController.text.trim(),
        shopCloseTime: shopCloseTimeController.text.trim().isEmpty ? null : shopCloseTimeController.text.trim(),
      );
      _showSuccessSnackBar('Profile updated successfully');
      Navigator.pop(context, true);
    } catch (e) {
      _showErrorSnackBar('Failed to update profile: $e');
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Create Profile'),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImagePicker(),
            _buildTextField('Full Name', nameController),
            _buildTextField('Email', emailController),
            _buildTextField('Phone Number', phoneNumberController),
            _buildTextField('Address', addressController),
            if (_profile?.isBusiness == true) ...[
              _buildShopImagePicker(),
              _buildTimeField('Opening Time', shopOpenTimeController),
              _buildTimeField('Closing Time', shopCloseTimeController),
            ],
            const SizedBox(height: 20),
            PrimaryButton(
              title: _isSaving ? 'Saving...' : 'Update Profile',
              onPressed: _isSaving ? null : _saveProfile,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return Center(
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: _profileImageFile != null
                ? FileImage(_profileImageFile!)
                : (_profile?.profileImage != null
                ? NetworkImage(_profile!.profileImage!)
                : const AssetImage(AppImages.person)) as ImageProvider,
          ),
          GestureDetector(
            onTap: () => _pickImage(false),
            child: CircleAvatar(
              radius: 15,
              backgroundColor: AppColors.primary,
              child: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShopImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        const Text('Shop Image'),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _pickImage(true),
          child: Container(
            height: 120,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.textPrimaryColor),
              borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg),
            ),
            child: _shopImageFile != null
                ? ClipRRect(
              borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg),
              child: Image.file(_shopImageFile!, fit: BoxFit.cover),
            )
                : (_profile?.shopImage != null
                ? ClipRRect(
              borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg),
              child: Image.network(_profile!.shopImage!, fit: BoxFit.cover),
            )
                : const Center(child: Icon(Icons.add_photo_alternate, size: 40))),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg),
          ),
        ),
      ),
    );
  }

  Widget _buildTimeField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        onTap: () => _selectTime(controller),
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: const Icon(Icons.access_time),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg),
          ),
        ),
      ),
    );
  }
}
