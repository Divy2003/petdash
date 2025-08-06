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
      _loadBusinessesWithRetry();
    });
  }

  // Load businesses with retry mechanism and better error handling
  Future<void> _loadBusinessesWithRetry({int retryCount = 0}) async {
    final businessProvider = context.read<BusinessProvider>();

    if (widget.category != null) {
      try {
        print(
            '🔍 ServicesList: Loading businesses for category: ${widget.category!.name} (ID: ${widget.category!.id})');
        print('🔄 ServicesList: Retry attempt: $retryCount');

        await businessProvider.loadBusinessesByCategory(widget.category!);

        print(
            '✅ ServicesList: Load completed. Found ${businessProvider.businesses.length} businesses');

        // If successful but no businesses found, this might be a new business category
        // or the user's business profile hasn't been indexed yet
        if (!businessProvider.hasBusinesses && retryCount < 2) {
          print(
              '⏳ ServicesList: No businesses found, retrying in 2 seconds...');
          // Wait a bit and retry
          await Future.delayed(const Duration(seconds: 2));
          await _loadBusinessesWithRetry(retryCount: retryCount + 1);
        } else if (businessProvider.hasBusinesses) {
          print('📋 ServicesList: Businesses found:');
          for (int i = 0; i < businessProvider.businesses.length; i++) {
            final business = businessProvider.businesses[i];
            print('  ${i + 1}. ${business.name} (ID: ${business.id})');
            print('     Email: ${business.email}');
            print('     Phone: ${business.phone ?? 'N/A'}');
            print('     Profile Image: ${business.profileImage ?? 'N/A'}');
            print('     Shop Image: ${business.shopImage ?? 'N/A'}');
            print('     Rating: ${business.rating ?? 'N/A'}');
            print('     Active: ${business.isActive}');
          }
        }
      } catch (e) {
        print('❌ ServicesList: Error loading businesses: $e');
        // If error occurs and we haven't retried yet, try once more
        if (retryCount < 1) {
          print('🔄 ServicesList: Retrying after error in 1 second...');
          await Future.delayed(const Duration(seconds: 1));
          await _loadBusinessesWithRetry(retryCount: retryCount + 1);
        }
      }
    } else {
      print('⚠️ ServicesList: No category provided for loading businesses');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(
        title: displayTitle,
      ),
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

          // List with pull-to-refresh
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
                  return RefreshIndicator(
                    onRefresh: () async {
                      await businessProvider.forceRefreshBusinesses();
                    },
                    child: _buildBusinessList(businessProvider.businesses),
                  );
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
    // Check if this is an authentication error
    bool isAuthError =
        businessProvider.error?.contains('Authentication') == true ||
            businessProvider.error?.contains('401') == true ||
            businessProvider.error?.contains('token') == true;

    // Check if this is a network error
    bool isNetworkError = businessProvider.error?.contains('Network') == true ||
        businessProvider.error?.contains('Connection') == true ||
        businessProvider.error?.contains('SocketException') == true;

    return Container(
      padding: EdgeInsets.all(AppSizes.md),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isAuthError
                ? Icons.lock_outline
                : isNetworkError
                    ? Icons.wifi_off
                    : Icons.error_outline,
            size: 64,
            color: AppColors.error,
          ),
          SizedBox(height: AppSizes.md),
          Text(
            isAuthError
                ? 'Authentication Required'
                : isNetworkError
                    ? 'Connection Problem'
                    : 'Failed to load businesses',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.error,
                ),
          ),
          SizedBox(height: AppSizes.sm),
          Text(
            _getErrorMessage(businessProvider.error),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSizes.lg),

          // Primary action button
          ElevatedButton(
            onPressed: () async {
              businessProvider.clearError();
              await _loadBusinessesWithRetry();
            },
            child: Text(isAuthError ? 'Login Again' : 'Retry'),
          ),

          SizedBox(height: AppSizes.sm),

          // Secondary action - show sample data
          TextButton(
            onPressed: () {
              // Force show fallback data by clearing error
              businessProvider.clearError();
              setState(() {});
            },
            child: const Text('Browse Sample Businesses'),
          ),

          SizedBox(height: AppSizes.sm),

          // Debug action - load all business profiles
          ElevatedButton(
            onPressed: () {
              businessProvider.clearError();
              businessProvider.loadAllBusinessesWithProfiles();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
            ),
            child: const Text('Load All Business Profiles',
                style: TextStyle(color: Colors.white)),
          ),

          // If it's a new business profile issue, show helpful message
          if (!isAuthError && !isNetworkError)
            FutureBuilder<bool>(
              future: businessProvider.isCurrentUserBusiness(),
              builder: (context, snapshot) {
                if (snapshot.data == true) {
                  return Padding(
                    padding: EdgeInsets.only(top: AppSizes.md),
                    child: Container(
                      padding: EdgeInsets.all(AppSizes.sm),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius:
                            BorderRadius.circular(AppSizes.cardRadiusSm),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.business_center, color: AppColors.primary),
                          SizedBox(height: AppSizes.xs),
                          Text(
                            'Business Owner?',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'Your business profile may take a few minutes to appear in search results after creation or updates.',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.primary,
                                    ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
        ],
      ),
    );
  }

  String _getErrorMessage(String? error) {
    if (error == null) return 'Unknown error occurred';

    if (error.contains('Authentication') ||
        error.contains('401') ||
        error.contains('token')) {
      return 'Please log in again to access business listings';
    }

    if (error.contains('Network') ||
        error.contains('Connection') ||
        error.contains('SocketException')) {
      return 'Please check your internet connection and try again';
    }

    if (error.contains('businesses') && error.contains('fetch')) {
      return 'Unable to load business listings. This might be temporary.';
    }

    return error.length > 100 ? '${error.substring(0, 100)}...' : error;
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

    return Column(
      children: [
        // Info message about sample data
        Container(
          margin: EdgeInsets.all(AppSizes.md),
          padding: EdgeInsets.all(AppSizes.md),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppSizes.cardRadiusSm),
            border: Border.all(color: AppColors.primary.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: AppColors.primary),
              SizedBox(width: AppSizes.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sample Businesses',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Showing sample data. Real businesses will appear here once they register and create profiles.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.primary,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Refresh button
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.md),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () async {
                await _loadBusinessesWithRetry();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Check for New Businesses'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
              ),
            ),
          ),
        ),

        SizedBox(height: AppSizes.md),

        // Sample businesses list
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: AppSizes.md),
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
          ),
        ),
      ],
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
                child: business.profileImage != null &&
                        business.profileImage!.isNotEmpty
                    ? Image.network(
                        business.profileImage!,
                        height: 150.h,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            height: 150.h,
                            width: double.infinity,
                            color: AppColors.grey.withOpacity(0.1),
                            child: Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.primary),
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          print(
                              '❌ Image load error for ${business.name}: $error');
                          print('📍 Image URL: ${business.profileImage}');
                          print('🔍 Error details: $stackTrace');
                          return Container(
                            height: 150.h,
                            width: double.infinity,
                            color: AppColors.grey.withOpacity(0.3),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.business,
                                  size: 48,
                                  color: AppColors.grey,
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  'Image not available',
                                  style: TextStyle(
                                    color: AppColors.grey,
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ],
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
            print('❌ Logo load error for ${business.name}: $error');
            print('📍 Logo URL: $logoUrl');
            return Icon(
              Icons.business,
              color: AppColors.primary,
              size: 20,
            );
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return SizedBox(
              width: 40.w,
              height: 40.h,
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
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
