import 'package:flutter/material.dart';
import '../../../utlis/constants/colors.dart';
import '../../../utlis/constants/size.dart';


class ServiceCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imagePath;

  const ServiceCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 129,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 19, vertical: 32),
      decoration: BoxDecoration(
        color: AppColors.cart,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.clip,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: AppColors.white,
                    fontSize: AppSizes.fontSizeSm,
                  ),
                ),
              ],
            ),
          ),
          ClipOval(
            child: Image.asset(
              imagePath,
              width: 77,
              height: 77,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
