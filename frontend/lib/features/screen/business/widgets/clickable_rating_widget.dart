import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utlis/constants/size.dart';
import '../../../../utlis/constants/colors.dart';
import '../../../../services/BusinessServices/review_service.dart';

class ClickableRatingWidget extends StatefulWidget {
  final String businessId;
  final double currentRating;
  final int totalReviews;
  final Function(double)? onRatingChanged;
  final bool isReadOnly;

  const ClickableRatingWidget({
    super.key,
    required this.businessId,
    this.currentRating = 0.0,
    this.totalReviews = 0,
    this.onRatingChanged,
    this.isReadOnly = false,
  });

  @override
  State<ClickableRatingWidget> createState() => _ClickableRatingWidgetState();
}

class _ClickableRatingWidgetState extends State<ClickableRatingWidget> {
  double _selectedRating = 0.0;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _selectedRating = widget.currentRating;
  }

  void _onStarTapped(int starIndex) {
    if (widget.isReadOnly) return;

    setState(() {
      _selectedRating = (starIndex + 1).toDouble();
    });

    if (widget.onRatingChanged != null) {
      widget.onRatingChanged!(_selectedRating);
    }
  }

  Future<void> _submitRating() async {
    if (_selectedRating == 0.0) {
      Get.snackbar(
        'Invalid Rating',
        'Please select a rating before submitting',
        backgroundColor: AppColors.warning,
        colorText: AppColors.white,
      );
      return;
    }

    // Show dialog to get review text
    String? reviewText = await _showReviewDialog();
    if (reviewText == null || reviewText.trim().isEmpty) {
      return; // User cancelled or didn't enter text
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final success = await ReviewService.createReview(
        businessId: widget.businessId,
        rating: _selectedRating.toInt(),
        reviewText: reviewText.trim(),
      );

      if (success) {
        Get.snackbar(
          'Success',
          'Your rating and review have been submitted successfully!',
          backgroundColor: AppColors.success,
          colorText: AppColors.white,
        );
        
        // Refresh the page or notify parent
        if (widget.onRatingChanged != null) {
          widget.onRatingChanged!(_selectedRating);
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to submit rating: ${e.toString()}',
        backgroundColor: AppColors.error,
        colorText: AppColors.white,
      );
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  Future<String?> _showReviewDialog() async {
    final TextEditingController reviewController = TextEditingController();
    
    return await Get.dialog<String>(
      AlertDialog(
        title: Text(
          'Write a Review',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Show selected rating
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Your Rating: ',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: AppColors.black,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(5, (index) {
                    return Icon(
                      index < _selectedRating
                          ? Icons.star
                          : Icons.star_border,
                      color: AppColors.warning,
                      size: 20,
                    );
                  }),
                ),
                SizedBox(width: AppSizes.xs),
                Text(
                  _selectedRating.toStringAsFixed(1),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSizes.md),
            
            // Review text input
            TextField(
              controller: reviewController,
              maxLines: 4,
              maxLength: 500,
              decoration: InputDecoration(
                hintText: 'Share your experience with this business...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg),
                  borderSide: BorderSide(color: AppColors.primary),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: TextStyle(color: AppColors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final text = reviewController.text.trim();
              if (text.isNotEmpty) {
                Get.back(result: text);
              } else {
                Get.snackbar(
                  'Required',
                  'Please write a review before submitting',
                  backgroundColor: AppColors.warning,
                  colorText: AppColors.white,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
            ),
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.isReadOnly ? 'Business Rating' : 'Rate This Business',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                ),
              ),
              if (widget.totalReviews > 0)
                Text(
                  '(${widget.totalReviews} review${widget.totalReviews != 1 ? 's' : ''})',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.grey,
                      ),
                ),
            ],
          ),
          SizedBox(height: AppSizes.sm),

          // Star Rating
          Row(
            children: [
              // Stars
              Row(
                children: List.generate(5, (index) {
                  final isSelected = index < _selectedRating;
                  return GestureDetector(
                    onTap: widget.isReadOnly ? null : () => _onStarTapped(index),
                    child: Container(
                      padding: EdgeInsets.all(AppSizes.xs / 2),
                      child: Icon(
                        isSelected ? Icons.star : Icons.star_border,
                        color: AppColors.warning,
                        size: widget.isReadOnly ? 20 : 28,
                      ),
                    ),
                  );
                }),
              ),
              SizedBox(width: AppSizes.sm),
              
              // Rating Number
              Text(
                _selectedRating.toStringAsFixed(1),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
              ),
            ],
          ),

          // Submit Button (only for interactive mode)
          if (!widget.isReadOnly && _selectedRating > 0) ...[
            SizedBox(height: AppSizes.md),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitRating,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                  padding: EdgeInsets.symmetric(vertical: AppSizes.sm),
                ),
                child: _isSubmitting
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.white,
                            ),
                          ),
                          SizedBox(width: AppSizes.xs),
                          const Text('Submitting...'),
                        ],
                      )
                    : const Text('Submit Rating & Review'),
              ),
            ),
          ],

          // Instructions for interactive mode
          if (!widget.isReadOnly && _selectedRating == 0) ...[
            SizedBox(height: AppSizes.sm),
            Text(
              'Tap the stars above to rate this business',
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
