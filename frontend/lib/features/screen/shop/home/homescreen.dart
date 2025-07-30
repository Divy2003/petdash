import 'package:flutter/material.dart';
import '../../../../utlis/constants/size.dart';

import 'widgets/home_appbar.dart';
import 'widgets/home_header_banner.dart';
import 'widgets/service_grid.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            HomeAppBar(),
            SizedBox(height: AppSizes.spaceBtwSections/2),
            const HomeHeaderBanner(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSizes.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Search Services Nearby",
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: AppSizes.fontSizeLg,
                    ),
                  ),
                  SizedBox(height: AppSizes.spaceBtwItems),
                  const ServiceGrid(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

