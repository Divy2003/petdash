import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../utlis/constants/colors.dart';
import '../../../../utlis/constants/size.dart';
import '../../../../models/category_model.dart';
import '../../../../provider/business_provider.dart';
import 'ServiceDetails.dart';

class ServicesList extends StatefulWidget {
  final CategoryModel? category;
  final String? categoryName;

  const ServicesList({
    super.key,
    this.category,
    this.categoryName,
  });

  @override
  State<ServicesList> createState() => _ServicesListState();
}

class _ServicesListState extends State<ServicesList> {
  String get displayTitle {
    if (widget.category != null) {
      return widget.category!.name;
    }
    return widget.categoryName ?? 'Services';
  }

  @override
  void initState() {
    super.initState();
    // Load businesses when widget initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.category != null) {
        context
            .read<BusinessProvider>()
            .loadBusinessesByCategory(widget.category!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(title: displayTitle),
      body: Column(
        children: [
          // Filter & Sort
          Container(
            color: AppColors.white,
            padding: EdgeInsets.symmetric(
              horizontal: AppSizes.md,
              vertical: AppSizes.sm,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(Icons.sort,
                          size: AppSizes.iconMd,
                          color: AppColors.textPrimaryColor),
                      SizedBox(width: AppSizes.xs),
                      Text(
                        'Sort',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: AppColors.secondary,
                            ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 1.w,
                  height: 20.h,
                  color: Colors.grey[300],
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.filter_list,
                          size: AppSizes.iconMd,
                          color: AppColors.textPrimaryColor),
                      SizedBox(width: AppSizes.xs),
                      Text(
                        'Filter',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: AppColors.secondary,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // List
          Expanded(
            child: Consumer<BusinessProvider>(
              builder: (context, businessProvider, child) {
                if (businessProvider.isLoading) {
                  return _buildLoadingList();
                }

                if (businessProvider.error != null) {
                  return _buildErrorView(businessProvider);
                }

                if (businessProvider.hasBusinesses) {
                  return _buildBusinessList(businessProvider.businesses);
                }

                // Fallback to hardcoded data if no businesses
                return _buildFallbackList(businessProvider);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingList() {
    return ListView.builder(
      padding: EdgeInsets.all(AppSizes.md),
      itemCount: 4,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(bottom: AppSizes.md),
          height: 200.h,
          decoration: BoxDecoration(
            color: AppColors.grey.withOpacity(0.3),
            borderRadius: BorderRadius.circular(AppSizes.cardRadiusMd),
          ),
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  Widget _buildErrorView(BusinessProvider businessProvider) {
    return Container(
      padding: EdgeInsets.all(AppSizes.md),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: AppColors.error,
          ),
          SizedBox(height: AppSizes.md),
          Text(
            'Failed to load businesses',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.error,
                ),
          ),
          SizedBox(height: AppSizes.sm),
          Text(
            businessProvider.error ?? 'Unknown error',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSizes.lg),
          ElevatedButton(
            onPressed: () {
              businessProvider.clearError();
              if (widget.category != null) {
                businessProvider.loadBusinessesByCategory(widget.category!);
              }
            },
            child: const Text('Retry'),
          ),
          SizedBox(height: AppSizes.sm),
          TextButton(
            onPressed: () {
              // Show fallback data
              setState(() {});
            },
            child: const Text('Use Offline Mode'),
          ),
        ],
      ),
    );
  }

  Widget _buildBusinessList(businesses) {
    return ListView.builder(
      padding: EdgeInsets.all(AppSizes.md),
      itemCount: businesses.length,
      itemBuilder: (context, index) {
        final business = businesses[index];
        return GestureDetector(
          onTap: () {
            Get.to(() => ServiceDetails(
                  providerName: business.name,
                  businessId: business.id,
                ));
          },
          child: _buildBusinessCard(business),
        );
      },
    );
  }

  Widget _buildFallbackList(BusinessProvider businessProvider) {
    final fallbackBusinesses = businessProvider.getFallbackBusinesses();

    return ListView.builder(
      padding: EdgeInsets.all(AppSizes.md),
      itemCount: fallbackBusinesses.length,
      itemBuilder: (context, index) {
        final provider = fallbackBusinesses[index];
        return GestureDetector(
          onTap: () {
            Get.to(() => ServiceDetails(providerName: provider['name']));
          },
          child: _buildFallbackBusinessCard(provider),
        );
      },
    );
  }

  Widget _buildBusinessCard(business) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.cardRadiusMd),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image + Rating
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(AppSizes.cardRadiusMd),
                ),
                child: business.profileImage != null
                    ? Image.network(
                        business.profileImage!,
                        height: 150.h,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 150.h,
                            width: double.infinity,
                            color: AppColors.grey.withOpacity(0.3),
                            child: Icon(
                              Icons.business,
                              size: 48,
                              color: AppColors.grey,
                            ),
                          );
                        },
                      )
                    : Container(
                        height: 150.h,
                        width: double.infinity,
                        color: AppColors.grey.withOpacity(0.3),
                        child: Icon(
                          Icons.business,
                          size: 48,
                          color: AppColors.grey,
                        ),
                      ),
              ),
              if (business.rating != null)
                Positioned(
                  top: AppSizes.sm,
                  left: AppSizes.sm,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.sm,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.star,
                            color: AppColors.white, size: AppSizes.iconSm),
                        SizedBox(width: 4.w),
                        Text(
                          business.ratingDisplay,
                          style:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                    color: AppColors.white,
                                    fontSize: AppSizes.fontSizeSm.sp,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),

          // Info
          Padding(
            padding: EdgeInsets.all(AppSizes.md),
            child: Row(
              children: [
                // Business Logo
                Container(
                  width: 40.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppSizes.cardRadiusSm),
                    color: AppColors.primary.withOpacity(0.1),
                  ),
                  child: _buildBusinessLogo(business),
                ),
                SizedBox(width: AppSizes.sm),

                // Name + Open Time
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        business.name,
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: AppSizes.fontSizeMd.sp,
                              color: AppColors.secondary,
                            ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        business.openStatus,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: AppColors.textPrimaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ],
                  ),
                ),

                // Distance
                Text(
                  business.distanceDisplay,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: AppColors.textPrimaryColor,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFallbackBusinessCard(Map<String, dynamic> provider) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.cardRadiusMd),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image + Rating
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(AppSizes.cardRadiusMd),
                ),
                child: Image.asset(
                  provider['image'],
                  height: 150.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: AppSizes.sm,
                left: AppSizes.sm,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.sm,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.star,
                          color: AppColors.white, size: AppSizes.iconSm),
                      SizedBox(width: 4.w),
                      Text(
                        provider['rating'].toString(),
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: AppColors.white,
                              fontSize: AppSizes.fontSizeSm.sp,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Info
          Padding(
            padding: EdgeInsets.all(AppSizes.md),
            child: Row(
              children: [
                // Logo
                Container(
                  width: 40.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppSizes.cardRadiusSm),
                    image: DecorationImage(
                      image: AssetImage(provider['logo']),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: AppSizes.sm),

                // Name + Open Time
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        provider['name'],
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: AppSizes.fontSizeMd.sp,
                              color: AppColors.secondary,
                            ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        provider['openTime'],
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              color: AppColors.textPrimaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ],
                  ),
                ),

                // Distance
                Text(
                  provider['distance'],
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: AppColors.textPrimaryColor,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBusinessLogo(business) {
    // Try to get shop image from the business data
    String? logoUrl;

    // Prefer shopImage for logo, fallback to profileImage
    if (business.shopImage != null && business.shopImage!.isNotEmpty) {
      logoUrl = business.shopImage;
    } else if (business.profileImage != null &&
        business.profileImage!.isNotEmpty) {
      logoUrl = business.profileImage;
    }

    if (logoUrl != null && logoUrl.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(AppSizes.cardRadiusSm),
        child: Image.network(
          logoUrl,
          width: 40.w,
          height: 40.h,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Icon(
              Icons.business,
              color: AppColors.primary,
              size: 20,
            );
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            );
          },
        ),
      );
    }

    // Fallback to icon
    return Icon(
      Icons.business,
      color: AppColors.primary,
      size: 20,
    );
  }
}
