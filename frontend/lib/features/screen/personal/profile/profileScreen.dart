import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:petcare/common/widgets/Tile/profilemenutile.dart';
import 'package:petcare/features/screen/personal/profile/widgets/editProfile.dart';
import 'package:petcare/features/screen/personal/profile/widgets/profileheaderwidgets.dart';

import '../../../../utlis/constants/colors.dart';
import '../../../../utlis/constants/image_strings.dart';
import '../../../../utlis/constants/size.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Column(
        children: [

          // cart user
          ProfileHeaderWidget(
            name: 'John Doe',
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
                              icon: Icons.pets,
                              title: 'My Pets',
                              onTap: (){},
                          ),
                          Divider(height: 1,color: AppColors.divider,),
                          ProfileMenuTile(
                            icon: Icons.account_balance_wallet_outlined,
                            title: 'Saved Addresses',
                            onTap: (){},
                          ),
                          Divider(height: 1,color: AppColors.divider,),
                          ProfileMenuTile(
                            icon: Icons.account_balance_wallet_outlined,
                            title: 'Payment Method',
                            onTap: (){},
                          ),
                          Divider(height: 1,color: AppColors.divider,),
                          ProfileMenuTile(
                            icon: Icons.shopping_bag_outlined,
                            title: 'My order',
                            onTap: (){},
                          ),
                          Divider(height: 1,color: AppColors.divider,),
                          ProfileMenuTile(
                            icon: Icons.settings,
                            title: 'setting',
                            onTap: (){},
                          ),
                          Divider(height: 1,color: AppColors.divider,),
                          ProfileMenuTile(
                            icon: Icons.help_sharp,
                            title: 'Help',
                            onTap: (){},
                          ),
                          Divider(height: 1,color: AppColors.divider,),
                          ProfileMenuTile(
                            icon: Icons.logout_rounded,
                            title: "Logout",
                            isLogout: true,// Automatically sets color to red
                            onTap: () {
                              showDialog(

                                context: context,
                                barrierDismissible: false, // Don't close on tap outside
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
                                                    child:  Text(
                                                      'Cancel',
                                                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                                        color: AppColors.black,
                                                      ),
                                                      // ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                Expanded(
                                                  child: ElevatedButton(
                                                    onPressed: (){},
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor: AppColors.primary,
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(30)),
                                                      padding:  EdgeInsets.symmetric(vertical: 12),
                                                    ),
                                                    child:  Text(
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
                            // Logout action
                          ),


                        ],
                      ),
                  ),
                ),
           )
          )

        ],
      ),
    );
  }
}
