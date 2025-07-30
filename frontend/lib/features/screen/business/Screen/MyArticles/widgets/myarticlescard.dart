import 'package:flutter/material.dart';
import 'package:petcare/utlis/constants/size.dart';

import '../../../../../../utlis/constants/colors.dart';

class ArticleCard extends StatelessWidget {
  final String title;
  final String date;
  final String imageUrl;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const ArticleCard({
    super.key,
    required this.title,
    required this.date,
    required this.imageUrl,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12,vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusMd),
        border: Border.all(
            color: AppColors.textPrimaryColor,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Image
          Image.asset(
              imageUrl,
              height: 120,
              width: 127,
              fit: BoxFit.cover
          ),
          SizedBox(height: 10),
          Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Posted $date",
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: AppColors.primary,
              ),
              ),
              Spacer(),
              GestureDetector(
                onTap: onEdit,
                child: const Icon(Icons.edit, size: 16, color: Colors.grey),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: onDelete,
                child: const Icon(Icons.delete, size: 16, color: Colors.red),
              ),
            ],
          ),
        ],
      ),
    );
  }
}