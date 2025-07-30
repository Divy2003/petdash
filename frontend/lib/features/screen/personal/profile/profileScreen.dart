import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:petcare/common/widgets/Tile/profilemenutile.dart';
import 'package:petcare/features/screen/auth/login/loginscreen.dart';
import 'package:petcare/features/screen/personal/profile/widgets/editProfile.dart';
import 'package:petcare/features/screen/personal/profile/widgets/profileheaderwidgets.dart';
import 'package:petcare/services/user_session_service.dart';
import 'package:petcare/services/profile_service.dart';
import 'package:petcare/models/profile_model.dart';

import '../../../../utlis/constants/colors.dart';
import '../../../../utlis/constants/image_strings.dart';
import '../../../../utlis/constants/size.dart';
import 'Screen/MyOrder/myorderScreen.dart';
import 'Screen/MyPet/mypets.dart';
import 'Screen/Save Address/saveAddressScreen.dart';
import 'Screen/Support/supportScreen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ProfileModel? _profile;
  bool _isLoading = true;

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
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load profile: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _refreshProfile() async {
    setState(() {
      _isLoading = true;
    });
    await _loadProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // cart user
                ProfileHeaderWidget(
                  name: _profile?.name ?? 'User',
                  location: _profile?.displayAddress ?? 'No address set',
                  imagePath: _profile?.profileImage ?? AppImages.person,
                  onEdit: () async {
                    final result = await Get.to(() => EditProfile());
                    if (result == true) {
                      // Refresh profile data if edit was successful
                      _refreshProfile();
                    }
                  },
                ),
                SizedBox(height: AppSizes.defaultSpace * 2),
                Expanded(
                    child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(AppSizes.sm),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius:
                            BorderRadius.circular(AppSizes.borderRadiusLg),
                        border: Border.all(color: AppColors.secondary),
                      ),
                      child: Column(
                        children: [
                          ProfileMenuTile(
                            icon: Icons.pets,
                            title: 'My Pets',
                            onTap: () {
                              Get.to(() => MyPetsScreen());
                            },
                          ),
                          Divider(
                            height: 1,
                            color: AppColors.divider,
                          ),
                          ProfileMenuTile(
                            icon: Icons.account_balance_wallet_outlined,
                            title: 'Saved Addresses',
                            onTap: () {
                              Get.to(() => SaveAddressScreen());
                            },
                          ),
                          Divider(
                            height: 1,
                            color: AppColors.divider,
                          ),
                          ProfileMenuTile(
                            icon: Icons.account_balance_wallet_outlined,
                            title: 'Payment Method',
                            onTap: () {},
                          ),
                          Divider(
                            height: 1,
                            color: AppColors.divider,
                          ),
                          ProfileMenuTile(
                            icon: Icons.shopping_bag_outlined,
                            title: 'My order',
                            onTap: () {
                              Get.to(() => MyOrdersScreen());
                            },
                          ),
                          Divider(
                            height: 1,
                            color: AppColors.divider,
                          ),
                          ProfileMenuTile(
                            icon: Icons.settings,
                            title: 'setting',
                            onTap: () {},
                          ),
                          Divider(
                            height: 1,
                            color: AppColors.divider,
                          ),
                          ProfileMenuTile(
                            icon: Icons.help_sharp,
                            title: 'Help',
                            onTap: () {},
                          ),
                          Divider(
                            height: 1,
                            color: AppColors.divider,
                          ),
                          ProfileMenuTile(
                            icon: Icons.support_agent_outlined,
                            title: 'Support',
                            onTap: () {
                              Get.to(() => SupportScreen());
                            },
                          ),
                          Divider(
                            height: 1,
                            color: AppColors.divider,
                          ),
                          ProfileMenuTile(
                            icon: Icons.swap_horiz,
                            title: 'Switch to Business Account',
                            onTap: () {
                              UserSessionService.showAccountSwitchDialog(
                                  context);
                            },
                          ),
                          Divider(
                            height: 1,
                            color: AppColors.divider,
                          ),
                          ProfileMenuTile(
                            icon: Icons.logout_rounded,
                            title: "Logout",
                            isLogout: true, // Automatically sets color to red
                            onTap: () {
                              showDialog(
                                context: context,
                                barrierDismissible:
                                    false, // Don't close on tap outside
                                builder: (BuildContext context) {
                                  return Dialog(
                                    backgroundColor: AppColors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: IntrinsicHeight(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            Text(
                                              'Logout',
                                              textAlign: TextAlign.center,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge!
                                                  .copyWith(
                                                    color: AppColors.primary,
                                                  ),
                                            ),
                                            const SizedBox(height: 10),
                                            Text(
                                              'Are you sure you want to logout?',
                                              textAlign: TextAlign.center,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .copyWith(
                                                    color: AppColors.primary,
                                                  ),
                                            ),
                                            const SizedBox(height: 20),
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
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          30)),
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 12),
                                                    ),
                                                    child: Text(
                                                      'Cancel',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleMedium!
                                                          .copyWith(
                                                            color:
                                                                AppColors.black,
                                                          ),
                                                      // ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
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
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          30)),
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 12),
                                                    ),
                                                    child: Text(
                                                      'Logout',
                                                      style: Theme.of(context)
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
                            // Logout action
                          ),
                        ],
                      ),
                    ),
                  ),
                ))
              ],
            ),
    );
  }
}
