import 'package:flutter/material.dart';
import '../../../../utlis/constants/size.dart';
import '../../../../utlis/constants/colors.dart';

class RatingDisplayWidget extends StatelessWidget {
  final double rating;
  final int totalReviews;
  final double? distance; // Distance in miles
  final bool showDistance;
  final bool isLoading;

  const RatingDisplayWidget({
    super.key,
    required this.rating,
    required this.totalReviews,
    this.distance,
    this.showDistance = true,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Container(
        padding: EdgeInsets.all(AppSizes.md),
        decoration: BoxDecoration(
          color: AppColors.grey.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg),
          border: Border.all(color: AppColors.grey.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.primary,
              ),
            ),
            SizedBox(width: AppSizes.sm),
            Text(
              'Loading rating...',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.grey,
                  ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            'Business Rating & Info',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
          ),
          SizedBox(height: AppSizes.sm),

          // Rating Section
          Row(
            children: [
              // Star Rating
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < rating.floor()
                        ? Icons.star
                        : index < rating
                            ? Icons.star_half
                            : Icons.star_border,
                    color: AppColors.warning,
                    size: 20,
                  );
                }),
              ),
              SizedBox(width: AppSizes.xs),
              
              // Rating Number
              Text(
                rating.toStringAsFixed(1),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
              ),
              SizedBox(width: AppSizes.xs),
              
              // Review Count
              Text(
                '(${totalReviews} review${totalReviews != 1 ? 's' : ''})',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.grey,
                    ),
              ),
            ],
          ),

          // Distance Section (if enabled and distance is provided)
          if (showDistance && distance != null) ...[
            SizedBox(height: AppSizes.sm),
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: AppColors.primary,
                  size: 16,
                ),
                SizedBox(width: AppSizes.xs),
                Text(
                  '${distance!.toStringAsFixed(1)} miles away',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.black,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
          ],

          // No Rating Message
          if (rating == 0.0 && totalReviews == 0) ...[
            SizedBox(height: AppSizes.xs),
            Text(
              'No reviews yet. Be the first to get reviewed!',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.grey,
                    fontStyle: FontStyle.italic,
                  ),
            ),
          ],
        ],
      ),
    );
  }
}

class RatingStarsWidget extends StatelessWidget {
  final double rating;
  final double size;
  final Color? color;
  final bool showRating;

  const RatingStarsWidget({
    super.key,
    required this.rating,
    this.size = 16,
    this.color,
    this.showRating = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Stars
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(5, (index) {
            return Icon(
              index < rating.floor()
                  ? Icons.star
                  : index < rating
                      ? Icons.star_half
                      : Icons.star_border,
              color: color ?? AppColors.warning,
              size: size,
            );
          }),
        ),
        
        // Rating number
        if (showRating) ...[
          SizedBox(width: AppSizes.xs),
          Text(
            rating.toStringAsFixed(1),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppColors.black,
                ),
          ),
        ],
      ],
    );
  }
}

class CompactRatingWidget extends StatelessWidget {
  final double rating;
  final int totalReviews;
  final double? distance;

  const CompactRatingWidget({
    super.key,
    required this.rating,
    required this.totalReviews,
    this.distance,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Rating Stars
        RatingStarsWidget(
          rating: rating,
          size: 14,
          showRating: false,
        ),
        SizedBox(width: AppSizes.xs),
        
        // Rating and Reviews
        Text(
          '${rating.toStringAsFixed(1)} (${totalReviews})',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.black,
                fontWeight: FontWeight.w500,
              ),
        ),
        
        // Distance
        if (distance != null) ...[
          SizedBox(width: AppSizes.sm),
          Icon(
            Icons.location_on,
            color: AppColors.grey,
            size: 12,
          ),
          SizedBox(width: 2),
          Text(
            '${distance!.toStringAsFixed(1)}mi',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.grey,
                ),
          ),
        ],
      ],
    );
  }
}
