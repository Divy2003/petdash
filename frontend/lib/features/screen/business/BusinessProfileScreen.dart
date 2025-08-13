import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:petcare/common/widgets/Tile/profilemenutile.dart';
import 'package:petcare/features/screen/auth/login/loginscreen.dart';
import 'package:petcare/features/screen/business/profiles/Createprofile.dart';
import 'package:petcare/features/screen/personal/profile/widgets/editProfile.dart';
import 'package:petcare/features/screen/personal/profile/widgets/profileheaderwidgets.dart';
import 'package:petcare/services/user_session_service.dart';
import 'package:petcare/provider/profile_provider.dart';

import '../../../common/widgets/progessIndicator/threedotindicator.dart';
import '../../../services/BusinessServices/deleteAccounts_service.dart';
import '../../../utlis/constants/colors.dart';
import '../../../utlis/constants/image_strings.dart';
import '../../../utlis/constants/size.dart';
import 'Screen/Appoinments/appoinments.dart';

import 'Screen/MyProducts/myproducts.dart';
import 'Screen/MyServices/myServices.dart';

import 'Screen/order/orderScreen.dart';

class BusinessProfileScreen extends StatefulWidget {
  const BusinessProfileScreen({super.key});

  @override
  State<BusinessProfileScreen> createState() => _BusinessProfileScreenState();
}

class _BusinessProfileScreenState extends State<BusinessProfileScreen> {
  @override
  void initState() {
    super.initState();
    // Load profile data when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProfileData();
    });
  }

  Future<void> _loadProfileData() async {
    await context.read<ProfileProvider>().getProfile();
  }

  Future<void> _refreshProfile() async {
    await _loadProfileData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ProfileProvider>(
        builder: (context, profileProvider, child) {
          // Show loading indicator while fetching profile
          if (profileProvider.isLoading && profileProvider.profile == null) {
            return const Center(child: ThreeDotIndicator());
          }

          // Show error if there's an error fetching profile
          if (profileProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: AppColors.error),
                  SizedBox(height: AppSizes.md),
                  Text(
                    'Error loading profile',
                    style: Theme
                        .of(context)
                        .textTheme
                        .titleMedium,
                  ),
                  SizedBox(height: AppSizes.sm),
                  Text(
                    profileProvider.error!,
                    style: Theme
                        .of(context)
                        .textTheme
                        .bodySmall,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: AppSizes.md),
                  ElevatedButton(
                    onPressed: _refreshProfile,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          // Get profile data or use defaults
          final profile = profileProvider.profile;
          final businessName = profile?.name ?? 'Pet Care Business';
          // Hide location on Business profile header
          final businessLocation = '';
          final profileImagePath = profile?.profileImage ?? AppImages.person;

          return RefreshIndicator(
            onRefresh: _refreshProfile,
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  // Business user header with real data
                  ProfileHeaderWidget(
                    name: businessName,
                    location: businessLocation,
                    imagePath: profileImagePath,
                    onEdit: () async {
                      final result = await Get.to(
                              () => EditProfile(initialProfile: profile));
                      // Refresh profile data when returning from edit
                      if (result == true) {
                        _refreshProfile();
                      }
                    },
                  ),

                  SizedBox(height: AppSizes.lg),

                  // Menu Section
                  Padding(
                    padding: EdgeInsets.all(AppSizes.sm),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius:
                        BorderRadius.circular(AppSizes.cardRadiusLg),
                        border: Border.all(color: AppColors.secondary),
                      ),
                      child: Column(
                        children: [
                          ProfileMenuTile(
                            icon: Icons.shopping_bag,
                            title: 'My Products',
                            onTap: () => Get.to(() => MyProductsScreen()),
                          ),
                          Divider(
                              height: AppSizes.dividerHeight,
                              color: AppColors.divider),
                          ProfileMenuTile(
                            icon: Icons.supervised_user_circle,
                            title: profile?.name != null
                                ? 'Edit Profile'
                                : 'Create Profile',
                            onTap: () async {
                              final result =
                              await Get.to(() => CreateProfile());
                              // Refresh profile data when returning from create/edit
                              if (result == true) {
                                _refreshProfile();
                              }
                            },
                          ),
                          Divider(
                              height: AppSizes.dividerHeight,
                              color: AppColors.divider),
                          ProfileMenuTile(
                            icon: Icons.calendar_today,
                            title: 'Appointments',
                            onTap: () => Get.to(() => AppointmentScreen()),
                          ),
                          Divider(
                              height: AppSizes.dividerHeight,
                              color: AppColors.divider),
                          ProfileMenuTile(
                            icon: Icons.receipt_long,
                            title: 'Orders',
                            onTap: () => Get.to(() => OrderScreen()),
                          ),
                          Divider(
                              height: AppSizes.dividerHeight,
                              color: AppColors.divider),
                          ProfileMenuTile(
                            icon: Icons.miscellaneous_services,
                            title: 'My Services',
                            onTap: () => Get.to(() => MyServices()),
                          ),
                          Divider(
                              height: AppSizes.dividerHeight,
                              color: AppColors.divider),
                          ProfileMenuTile(
                            icon: Icons.group,
                            title: 'My Clients',
                            onTap: () => Get.to(() => ()),
                          ),
                          Divider(
                              height: AppSizes.dividerHeight,
                              color: AppColors.divider),
                          ProfileMenuTile(
                            icon: Icons.article_outlined,
                            title: 'My Articles',
                            onTap: () => Get.to(() => ()),
                          ),
                          Divider(
                              height: AppSizes.dividerHeight,
                              color: AppColors.divider),
                          ProfileMenuTile(
                            icon: Icons.bar_chart,
                            title: 'Reports',
                            onTap: () => Get.to(() => ()),
                          ),
                          Divider(
                              height: AppSizes.dividerHeight,
                              color: AppColors.divider),
                          ProfileMenuTile(
                            icon: Icons.credit_card,
                            title: 'PaymentsMethod',
                            onTap: () => Get.to(() => ()),
                          ),
                          Divider(
                              height: AppSizes.dividerHeight,
                              color: AppColors.divider),
                          ProfileMenuTile(
                            icon: Icons.subscriptions,
                            title: 'Subscription',
                            onTap: () => Get.to(() => ()),
                          ),
                          Divider(
                              height: AppSizes.dividerHeight,
                              color: AppColors.divider),
                          ProfileMenuTile(
                            icon: Icons.account_box,
                            title: 'Account detetion',
                            onTap: () {
                              _showAccountDeletionConfirmationDialog();
                            },
                          ),
                          Divider(
                              height: AppSizes.dividerHeight,
                              color: AppColors.divider),
                          ProfileMenuTile(
                            icon: Icons.swap_horiz,
                            title: 'Switch to Service Account',
                            onTap: () {
                              UserSessionService.showAccountSwitchDialog(
                                  context);
                            },
                          ),
                          Divider(
                              height: AppSizes.dividerHeight,
                              color: AppColors.divider),
                          ProfileMenuTile(
                            icon: Icons.logout,
                            title: 'Logout',
                            isLogout: true,
                            onTap: () {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return Dialog(
                                    backgroundColor: AppColors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          AppSizes.cardRadiusLg),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(AppSizes.lg),
                                      child: IntrinsicHeight(
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                          children: [
                                            Text(
                                              'Logout',
                                              textAlign: TextAlign.center,
                                              style: Theme
                                                  .of(context)
                                                  .textTheme
                                                  .titleLarge!
                                                  .copyWith(
                                                color: AppColors.primary,
                                              ),
                                            ),
                                            SizedBox(height: AppSizes.sm),
                                            Text(
                                              'Are you sure you want to logout?',
                                              textAlign: TextAlign.center,
                                              style: Theme
                                                  .of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .copyWith(
                                                color: AppColors.primary,
                                              ),
                                            ),
                                            SizedBox(height: AppSizes.md),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: OutlinedButton(
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                    style: OutlinedButton
                                                        .styleFrom(
                                                      side: BorderSide(
                                                          color: AppColors
                                                              .primary),
                                                      shape:
                                                      RoundedRectangleBorder(
                                                        borderRadius: BorderRadius
                                                            .circular(AppSizes
                                                            .buttonRadius),
                                                      ),
                                                      padding:
                                                      EdgeInsets.symmetric(
                                                        vertical: AppSizes
                                                            .buttonHeight,
                                                      ),
                                                    ),
                                                    child: Text(
                                                      'Cancel',
                                                      style: Theme
                                                          .of(context)
                                                          .textTheme
                                                          .titleMedium!
                                                          .copyWith(
                                                        color:
                                                        AppColors.black,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: AppSizes.sm),
                                                Expanded(
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                      UserSessionService.logout(
                                                          context);
                                                      Navigator
                                                          .pushAndRemoveUntil(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (_) =>
                                                                LoginScreen()),
                                                            (route) => false,
                                                      );
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                      AppColors.primary,
                                                      shape:
                                                      RoundedRectangleBorder(
                                                        borderRadius: BorderRadius
                                                            .circular(AppSizes
                                                            .buttonRadius),
                                                      ),
                                                      padding:
                                                      EdgeInsets.symmetric(
                                                        vertical: AppSizes
                                                            .buttonHeight,
                                                      ),
                                                    ),
                                                    child: Text(
                                                      'Logout',
                                                      style: Theme
                                                          .of(context)
                                                          .textTheme
                                                          .titleMedium!
                                                          .copyWith(
                                                        color:
                                                        AppColors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Add some bottom padding for better scrolling
                  SizedBox(height: AppSizes.xl),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _showAccountDeletionConfirmationDialog() async {
    final TextEditingController passwordController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.cardRadiusLg),
          ),
          title: Text(
            'Account Deletion',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: AppColors.primary,
            ),
          ),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Text(
                    'Are you sure you want to delete your account? This action cannot be undone.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(AppSizes.inputFieldRadius),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password is required';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(dialogContext).pop(),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                    ),
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        Navigator.of(dialogContext).pop();
                        await _handleAccountDeletion(passwordController.text);
                      }
                    },
                    child: const Text('Delete'),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }



  Future<void> _handleAccountDeletion(String password) async {
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    try {
      // You should get token from your session service / provider
      final token = await UserSessionService.getToken();

      final result = await DeletionService.deleteAccount(
        password: password,
        token: token ?? '',
      );
      Get.back(); // Remove loading dialog

      if (result["statusCode"] == 200 || result["statusCode"] == 204) {
        Get.dialog(
          AlertDialog(
            title: const Text('Success'),
            content: const Text('Your account has been deleted.'),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () => Get.offAll(() => const LoginScreen()),
              ),
            ],
          ),
        );
      } else {
        String errorMessage =
            result["body"]["message"] ?? 'Failed to delete account.';
        Get.dialog(
          AlertDialog(
            title: const Text('Error'),
            content: Text(errorMessage),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () => Get.back(),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      Get.back();
      Get.dialog(
        AlertDialog(
          title: const Text('Error'),
          content: const Text('An unexpected error occurred.'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () => Get.back(),
            ),
          ],
        ),
      );
    }
  }
}
