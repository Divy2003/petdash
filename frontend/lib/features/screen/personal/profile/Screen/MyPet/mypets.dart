import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:petcare/features/screen/personal/profile/Screen/MyPet/AddAnotherPet.dart';

import '../../../../../../common/widgets/Button/primarybutton.dart';
import '../../../../../../common/widgets/appbar/appbar.dart';
import '../../../../../../utlis/constants/colors.dart';
import '../../../../../../utlis/constants/image_strings.dart';
import '../../../../../../utlis/constants/size.dart';
import 'EditedPetProfile.dart';
import 'GetPetProfile.dart';

class MyPetsScreen extends StatefulWidget {
  const MyPetsScreen({super.key});

  @override
  State<MyPetsScreen> createState() => _MyPetsScreenState();
}

class _MyPetsScreenState extends State<MyPetsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'My Pets'),

      body: SingleChildScrollView(
        child: Padding(
          padding:  EdgeInsets.symmetric(
              horizontal:AppSizes.defaultPaddingHorizontal,
              vertical: AppSizes.defaultPaddingVertical ),
          child: GestureDetector(
            onTap: () {
             Get.to(() => GetPetProfile());
            },
            child: Column(
              children: [
                Container(
                  padding:  EdgeInsets.all(AppSizes.sm),
                  decoration: BoxDecoration(
                    color:AppColors.white,
                    borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.textPrimaryColor.withOpacity(0.5),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Pet Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.asset(
                          AppImages.dog1,// Replace with your pet image URL
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Pet Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:  [
                            Text(
                              'Troy',
                              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text('Toy terrier',
                              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                            Text(
                              'Training Ninja',
                              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                color: AppColors.textPrimaryColor,
                              ),
                            ),
                            Text(
                              'Badges Earned: 80/250',
                              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                color: AppColors.textPrimaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Edit Icon
                      IconButton(
                        icon:  Icon(
                            Icons.edit, color: AppColors.dividerColor),
                        onPressed: () {
                          Get.to(() => EditPetScreen());
                          // Handle edit
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Add Another Pet Button
                PrimaryButton(
                  title: 'Add Another Pet',
                  onPressed: () {
                    Get.to(() => AddOrEditPetScreen());
                    // Handle add another pet
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
