import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../common/widgets/Button/primarybutton.dart';
import '../../../../utlis/constants/size.dart';
import '../../../../utlis/constants/colors.dart';
import '../../../../provider/profile_provider.dart';
import 'widgets/pet_owner_preferences_widget.dart';

class PetOwnerProfileScreen extends StatefulWidget {
  const PetOwnerProfileScreen({super.key});

  @override
  State<PetOwnerProfileScreen> createState() => _PetOwnerProfileScreenState();
}

class _PetOwnerProfileScreenState extends State<PetOwnerProfileScreen> {
  Map<String, dynamic> _preferences = {};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    await profileProvider.getProfile();
  }

  void _onPreferencesChanged(Map<String, dynamic> preferences) {
    setState(() {
      _preferences = preferences;
    });
  }

  Future<void> _savePreferences() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Here you would typically save the preferences to your backend
      // For now, we'll just show a success message
      
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
      
      Get.snackbar(
        'Success',
        'Your preferences have been saved successfully!',
        backgroundColor: AppColors.success,
        colorText: AppColors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to save preferences: ${e.toString()}',
        backgroundColor: AppColors.error,
        colorText: AppColors.white,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Pet Owner Profile'),
      body: Consumer<ProfileProvider>(
        builder: (context, profileProvider, child) {
          if (profileProvider.isLoading && profileProvider.profile == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(AppSizes.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Info Section
                Container(
                  padding: EdgeInsets.all(AppSizes.md),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg),
                    border: Border.all(color: AppColors.grey.withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Profile Information',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                      ),
                      SizedBox(height: AppSizes.spaceBtwItems),
                      
                      if (profileProvider.profile != null) ...[
                        _buildInfoRow('Name', profileProvider.profile!.name ?? 'Not set'),
                        _buildInfoRow('Email', profileProvider.profile!.email ?? 'Not set'),
                        _buildInfoRow('Phone', profileProvider.profile!.phoneNumber ?? 'Not set'),
                        _buildInfoRow('Current Role', profileProvider.profile!.currentRole ?? 'Pet Owner'),
                        if (profileProvider.profile!.primaryAddress != null)
                          _buildInfoRow('Address', profileProvider.profile!.displayAddress),
                      ] else ...[
                        Text(
                          'No profile information available',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.grey,
                              ),
                        ),
                      ],
                    ],
                  ),
                ),
                SizedBox(height: AppSizes.spaceBtwSections),

                // Search Preferences Section
                PetOwnerPreferencesWidget(
                  initialMaxDistance: 10.0, // You can load this from saved preferences
                  initialPreferredLocation: profileProvider.profile?.displayAddress,
                  onPreferencesChanged: _onPreferencesChanged,
                ),
                SizedBox(height: AppSizes.spaceBtwSections),

                // Current Preferences Display
                if (_preferences.isNotEmpty) ...[
                  Container(
                    padding: EdgeInsets.all(AppSizes.md),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg),
                      border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Current Preferences',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.success,
                              ),
                        ),
                        SizedBox(height: AppSizes.sm),
                        Text(
                          'Max Distance: ${_preferences['maxDistance']?.round()} miles',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Text(
                          'Use Current Location: ${_preferences['useCurrentLocation'] ? 'Yes' : 'No'}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        if (_preferences['preferredLocation']?.isNotEmpty == true)
                          Text(
                            'Preferred Location: ${_preferences['preferredLocation']}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                      ],
                    ),
                  ),
                  SizedBox(height: AppSizes.spaceBtwSections),
                ],

                // Save Button
                PrimaryButton(
                  title: _isLoading ? 'Saving...' : 'Save Preferences',
                  onPressed: _isLoading || _preferences.isEmpty ? null : _savePreferences,
                ),
                SizedBox(height: AppSizes.lg),

                // Info Section
                Container(
                  padding: EdgeInsets.all(AppSizes.md),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg),
                    border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: AppColors.primary,
                            size: 20,
                          ),
                          SizedBox(width: AppSizes.xs),
                          Text(
                            'How it works',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppSizes.sm),
                      Text(
                        '• Set your maximum search distance to find businesses near you\n'
                        '• Use your current location or set a preferred location\n'
                        '• We\'ll show businesses within your specified radius\n'
                        '• Distance is calculated in miles for easy understanding',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.primary,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSizes.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.grey,
                  ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.black,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
