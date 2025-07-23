import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:petcare/common/widgets/Tile/profilemenutile.dart';
import 'package:petcare/features/screen/auth/login/loginscreen.dart';
import 'package:petcare/features/screen/personal/profile/widgets/editProfile.dart';
import 'package:petcare/features/screen/personal/profile/widgets/profileheaderwidgets.dart';
import 'package:petcare/services/user_session_service.dart';

import '../../../../utlis/constants/colors.dart';
import '../../../../utlis/constants/image_strings.dart';
import '../Screen/Appoinments/appoinments.dart';
import '../Screen/order/orderScreen.dart';

class BusinessProfileScreen extends StatefulWidget {
  const BusinessProfileScreen({super.key});

  @override
  State<BusinessProfileScreen> createState() => _BusinessProfileScreenState();
}

class _BusinessProfileScreenState extends State<BusinessProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Business user header
          ProfileHeaderWidget(
            name: 'Pet Care Business',
            location: 'New York, USA',
            imagePath: AppImages.person,
            onEdit: () {
              Get.to(() => EditProfile());
            },
          ),
          SizedBox(height: 40.h),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: AppColors.secondary),
                  ),
                  child: Column(
                    children: [
                      ProfileMenuTile(
                        icon: Icons.business,
                        title: 'My Products',
                        onTap: () {},
                      ),
                      Divider(height: 1, color: AppColors.divider),
                      ProfileMenuTile(
                        icon: Icons.schedule,
                        title: 'Appointments',
                        onTap: () {
                          Get.to(() => AppointmentScreen());
                        },
                      ),
                      Divider(height: 1, color: AppColors.divider),
                      ProfileMenuTile(
                        icon: Icons.room_service,
                        title: 'Orders',
                        onTap: () {
                          Get.to(() => OrderScreen());
                        },
                      ),
                      Divider(height: 1, color: AppColors.divider),
                      ProfileMenuTile(
                        icon: Icons.shopping_bag_outlined,
                        title: 'My Services',
                        onTap: () {},
                      ),
                      Divider(height: 1, color: AppColors.divider),
                      ProfileMenuTile(
                        icon: Icons.analytics,
                        title: 'My Clients',
                        onTap: () {},
                      ),
                      Divider(height: 1, color: AppColors.divider),
                      ProfileMenuTile(
                        icon: Icons.account_balance_wallet_outlined,
                        title: 'My Articles',
                        onTap: () {},
                      ),
                      Divider(height: 1, color: AppColors.divider),
                      ProfileMenuTile(
                        icon: Icons.settings,
                        title: 'Reports',
                        onTap: () {},
                      ),
                      Divider(height: 1, color: AppColors.divider),
                      ProfileMenuTile(
                        icon: Icons.help_sharp,
                        title: 'Payments',
                        onTap: () {},
                      ),
                      Divider(height: 1, color: AppColors.divider),
                      ProfileMenuTile(
                        icon: Icons.swap_horiz,
                        title: 'Switch to Service Account',
                        onTap: () {
                          UserSessionService.showAccountSwitchDialog(context);
                        },
                      ),
                      Divider(height: 1, color: AppColors.divider),
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
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: IntrinsicHeight(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        Text(
                                          'Logout',
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                            color: AppColors.primary,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          'Are you sure you want to logout?',
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                            color: AppColors.primary,
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: OutlinedButton(
                                                onPressed: () => Navigator.pop(context),
                                                style: OutlinedButton.styleFrom(
                                                  side: BorderSide(color: AppColors.primary),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(30)),
                                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                                ),
                                                child: Text(
                                                  'Cancel',
                                                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                                    color: AppColors.black,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  UserSessionService.logout(context);
                                                  Navigator.pushAndRemoveUntil(
                                                    context,
                                                    MaterialPageRoute(builder: (_) => LoginScreen()),
                                                    (route) => false,
                                                  );
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: AppColors.primary,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(30)),
                                                  padding: EdgeInsets.symmetric(vertical: 12),
                                                ),
                                                child: Text(
                                                  'Logout',
                                                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                                    color: AppColors.white,
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
            ),
          ),
        ],
      ),
    );
  }
}
