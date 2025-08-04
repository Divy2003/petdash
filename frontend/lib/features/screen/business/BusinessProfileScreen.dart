import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:petcare/common/widgets/Tile/profilemenutile.dart';
import 'package:petcare/features/screen/auth/login/loginscreen.dart';
import 'package:petcare/features/screen/business/profiles/Createprofile.dart';
import 'package:petcare/features/screen/personal/profile/widgets/editProfile.dart';
import 'package:petcare/features/screen/personal/profile/widgets/profileheaderwidgets.dart';
import 'package:petcare/services/user_session_service.dart';

import '../../../utlis/constants/colors.dart';
import '../../../utlis/constants/image_strings.dart';
import '../../../utlis/constants/size.dart';
import 'Screen/Appoinments/appoinments.dart';
import 'Screen/MyArticles/MyArticles.dart';
import 'Screen/MyClients/myClients.dart';
import 'Screen/MyPaymentsMethod/MyPaymentMethods.dart';
import 'Screen/MyProducts/myproducts.dart';
import 'Screen/MyServices/myServices.dart';
import 'Screen/Reports/StatisticsScreen.dart';
import 'Screen/Subscription/Subscription.dart';
import 'Screen/order/orderScreen.dart';

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
                padding: EdgeInsets.all(AppSizes.sm),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(AppSizes.cardRadiusLg),
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
                        title: 'Create Profile',
                        onTap: () => Get.to(() => CreateProfile()),
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
                        onTap: () => Get.to(() => MyClients()),
                      ),
                      Divider(
                          height: AppSizes.dividerHeight,
                          color: AppColors.divider),
                      ProfileMenuTile(
                        icon: Icons.article_outlined,
                        title: 'My Articles',
                        onTap: () => Get.to(() => MyArticles()),
                      ),
                      Divider(
                          height: AppSizes.dividerHeight,
                          color: AppColors.divider),
                      ProfileMenuTile(
                        icon: Icons.bar_chart,
                        title: 'Reports',
                        onTap: () => Get.to(() => StatisticsScreen()),
                      ),
                      Divider(
                          height: AppSizes.dividerHeight,
                          color: AppColors.divider),
                      ProfileMenuTile(
                        icon: Icons.credit_card,
                        title: 'PaymentsMethod',
                        onTap: () => Get.to(() => MyCardScreen()),
                      ),
                      Divider(
                          height: AppSizes.dividerHeight,
                          color: AppColors.divider),
                      ProfileMenuTile(
                        icon: Icons.subscriptions,
                        title: 'Subscription',
                        onTap: () => Get.to(() => SubscriptionScreen()),
                      ),
                      Divider(
                          height: AppSizes.dividerHeight,
                          color: AppColors.divider),
                      ProfileMenuTile(
                        icon: Icons.swap_horiz,
                        title: 'Switch to Service Account',
                        onTap: () {
                          UserSessionService.showAccountSwitchDialog(context);
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
                                          style: Theme.of(context)
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
                                          style: Theme.of(context)
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
                                                style: OutlinedButton.styleFrom(
                                                  side: BorderSide(
                                                      color: AppColors.primary),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            AppSizes
                                                                .buttonRadius),
                                                  ),
                                                  padding: EdgeInsets.symmetric(
                                                    vertical:
                                                        AppSizes.buttonHeight,
                                                  ),
                                                ),
                                                child: Text(
                                                  'Cancel',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium!
                                                      .copyWith(
                                                        color: AppColors.black,
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
                                                  Navigator.pushAndRemoveUntil(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (_) =>
                                                            LoginScreen()),
                                                    (route) => false,
                                                  );
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      AppColors.primary,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            AppSizes
                                                                .buttonRadius),
                                                  ),
                                                  padding: EdgeInsets.symmetric(
                                                    vertical:
                                                        AppSizes.buttonHeight,
                                                  ),
                                                ),
                                                child: Text(
                                                  'Logout',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium!
                                                      .copyWith(
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
