import 'package:flutter/material.dart';
import '../../../../utlis/constants/image_strings.dart';
import 'service_tile.dart';
import '../../../../utlis/constants/size.dart';

class ServiceGrid extends StatelessWidget {
  const ServiceGrid({super.key});

  final List<Map<String, dynamic>> serviceList = const [
    {
      'title': 'Sitting',
      'color': Color(0x807DC1CF),
      'icon': AppImages.sitting,
    },
    {
      'title': 'Health',
      'color': Color(0xA31976D2),
      'icon': AppImages.health,
    },
    {
      'title': 'Boarding',
      'color': Color(0x80F0546C),
      'icon': AppImages.boarding,
    },
    {
      'title': 'Training',
      'color': Color(0x80FFC107),
      'icon': AppImages.training,
    },
    {
      'title': 'Grooming',
      'color': Color(0x99FFC107),
      'icon': AppImages.grooming,
    },
    {
      'title': 'Walking',
      'color': Color(0x804CD964),
      'icon': AppImages.walking,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 2,
      crossAxisSpacing: AppSizes.gridViewSpacing,
      mainAxisSpacing: AppSizes.gridViewSpacing,
      children: serviceList.map((service) {
        return GestureDetector(

          child: ServiceTile(
            title: service['title'],
            color: service['color'],
            iconPath: service['icon'],
          ),
        );
      }).toList(),
    );
  }
}
