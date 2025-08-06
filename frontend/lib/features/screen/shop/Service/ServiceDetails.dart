import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../utlis/constants/colors.dart';
import '../../../../utlis/constants/image_strings.dart';
import '../../../../utlis/constants/size.dart';
import '../../../../utlis/app_config/app_config.dart';
import '../../../../models/business_model.dart';
import '../../../../services/BusinessServices/business_service.dart';
import 'ServicesSelectPetAndReview/ServiceSelectPetandReview.dart';
import 'ServicesSelectPetAndReview/widgets/curvedheaderwidgets.dart';
import 'ServicesSubDeatils.dart';

class ServiceDetails extends StatefulWidget {
  final String providerName;
  final String? businessId;

  const ServiceDetails({
    super.key,
    required this.providerName,
    this.businessId,
  });

  @override
  State<ServiceDetails> createState() => _ServiceDetailsState();
}

class _ServiceDetailsState extends State<ServiceDetails> {
  BusinessModel? businessProfile;
  Map<String, dynamic> servicesByCategory = {};
  bool isLoading = false;
  String? error;

  @override
  void initState() {
    super.initState();
    if (widget.businessId != null) {
      _loadBusinessProfile();
    }
  }

  Future<void> _loadBusinessProfile() async {
    if (widget.businessId == null) return;

    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      print(
          '🔍 ServiceDetails: Loading business profile for ID: ${widget.businessId}');
      final result = await BusinessService.getBusinessProfileWithServices(
          widget.businessId!);

      print('📥 ServiceDetails: API response received');
      print('🏢 Business: ${result['business']?.name ?? 'No business data'}');
      print(
          '🛠️ Services by category: ${result['servicesByCategory']?.keys.toList() ?? 'No services'}');

      if (result['servicesByCategory'] != null) {
        result['servicesByCategory'].forEach((category, services) {
          print(
              '📂 Category: $category - ${services is List ? services.length : 0} services');
        });
      }

      if (mounted) {
        setState(() {
          businessProfile = result['business'];
          servicesByCategory = result['servicesByCategory'] ?? {};
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          error = e.toString();
          isLoading = false;
        });
      }
    }
  }

  final List<Map<String, dynamic>> salonMenu = [
    {
      'title': 'Bath & Full haircut',
      'description':
          'For dogs who need a bath, haircut & extra attention to their pads to help reduce shedding',
      'price': '\$45',
      'image': AppImages.store1,
    },
    {
      'title': 'Bath & haircut with Furminator',
      'description':
          'For dogs who need a bath, haircut & extra attention to their pads to help reduce shedding',
      'price': '\$55',
      'image': AppImages.store2,
    },
    {
      'title': 'Bath & Brush with Furminator',
      'description':
          'For dogs who need a bath, haircut & extra attention to their pads to help reduce shedding',
      'price': '\$65',
      'image': AppImages.store1,
    },
    {
      'title': 'Bath & Brush',
      'description': 'For dogs who need a bath & brush to maintain their coat',
      'price': '\$35',
      'image': AppImages.store2,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: businessProfile?.name ?? widget.providerName),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
              ? _buildErrorWidget()
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.to(() => ServiceSelectPetAndReview());
                        },
                        child: CurvedHeaderWidget(
                          businessProfile: businessProfile,
                          rating: businessProfile?.rating ?? 4.5,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Service Partner Details
                            Text(
                              'Service Partner Details',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                    fontSize: AppSizes.fontSizeMd,
                                    color: AppColors.primary,
                                  ),
                            ),
                            SizedBox(height: AppSizes.sm),

                            // Address
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.location_on_outlined,
                                    color: AppColors.primary),
                                SizedBox(width: AppSizes.sm),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        businessProfile?.address?.fullAddress ??
                                            "4140 Parker Rd. Allentown, Hawaii 81063",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(color: AppColors.primary),
                                      ),
                                      SizedBox(height: 4.h),
                                      Text(
                                        "(${businessProfile?.distanceDisplay ?? '20 miles away'} from your location)",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                              color: Color(0xFF4552CB),
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: AppSizes.sm),

                            // Store Time
                            Row(
                              children: [
                                Icon(Icons.storefront_outlined,
                                    color: AppColors.primary),
                                SizedBox(width: AppSizes.sm),
                                Text(
                                  businessProfile?.openStatus ??
                                      "Open at 10 AM - 7PM (Closed on sat-sun)",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        color: AppColors.primary,
                                      ),
                                ),
                              ],
                            ),
                            SizedBox(height: AppSizes.sm),

                            // Phone
                            Row(
                              children: [
                                Icon(Icons.phone_outlined,
                                    color: AppColors.primary),
                                SizedBox(width: AppSizes.sm),
                                Text(
                                  businessProfile?.phone ?? "(406) 555-0120",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        color: AppColors.primary,
                                      ),
                                ),
                              ],
                            ),
                            SizedBox(height: AppSizes.spaceBtwSections),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Container(
                          width: double.infinity,
                          height: 50.h,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius:
                                BorderRadius.circular(AppSizes.borderRadiusMd),
                          ),
                          child: Center(
                            child: Text(
                              'Save as Primary',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    color: AppColors.white,
                                  ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: AppSizes.spaceBtwSections),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          children: [
                            Container(
                              width: 60.w,
                              height: 60.h,
                              decoration: BoxDecoration(
                                color: AppColors.textPrimaryColor,
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Icon(
                                Icons.pets,
                                color: Colors.grey[600],
                                size: 30.r,
                              ),
                            ),
                            SizedBox(width: AppSizes.sm),
                            Text(
                              'Select Pet',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    color: AppColors.secondary,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: AppSizes.spaceBtwSections),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          'Services',
                          style:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
                                    color: AppColors.secondary,
                                  ),
                        ),
                      ),
                      _buildServicesList(),
                    ],
                  ),
                ),
    );
  }

  Widget _buildServicesList() {
    if (servicesByCategory.isEmpty) {
      return _buildFallbackServicesList();
    }

    List<Widget> serviceWidgets = [];

    servicesByCategory.forEach((categoryName, services) {
      if (services is List && services.isNotEmpty) {
        // Add category header
        serviceWidgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Text(
              categoryName,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        );

        // Add services for this category
        for (var service in services) {
          serviceWidgets.add(_buildServiceCard(service));
        }
      }
    });

    if (serviceWidgets.isEmpty) {
      return _buildFallbackServicesList();
    }

    return Column(children: serviceWidgets);
  }

  Widget _buildServiceCard(Map<String, dynamic> service) {
    return GestureDetector(
      onTap: () => Get.to(() => ServicesSubDetails()),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Container(
          margin: EdgeInsets.only(bottom: AppSizes.md),
          padding: EdgeInsets.all(AppSizes.md),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(AppSizes.cardRadiusMd),
            border: Border.all(color: AppColors.textPrimaryColor),
          ),
          child: Row(
            children: [
              // Service image or placeholder
              Container(
                width: 60.w,
                height: 60.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  color: AppColors.primary.withValues(alpha: 0.1),
                ),
                child: service['images'] != null &&
                        (service['images'] as List).isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child: Image.network(
                          '${AppConfig.baseFileUrl}/${service['images'][0]}',
                          width: 60.w,
                          height: 60.h,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.pets,
                              color: AppColors.primary,
                              size: 30.sp,
                            );
                          },
                        ),
                      )
                    : Icon(
                        Icons.pets,
                        color: AppColors.primary,
                        size: 30.sp,
                      ),
              ),
              SizedBox(width: AppSizes.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service['title'] ?? 'Service',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.secondary,
                          ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      service['description'] ?? 'No description available',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: AppColors.secondary,
                            height: 1.2,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Starting from \$${service['price'] ?? '0'}',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: AppColors.secondary,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFallbackServicesList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: salonMenu.length,
      itemBuilder: (context, index) {
        final item = salonMenu[index];
        return GestureDetector(
          onTap: () => Get.to(() => ServicesSubDetails()),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Container(
              margin: EdgeInsets.only(bottom: AppSizes.md),
              padding: EdgeInsets.all(AppSizes.md),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(AppSizes.cardRadiusMd),
                border: Border.all(color: AppColors.textPrimaryColor),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: Image.asset(
                      item['image'],
                      width: 60.w,
                      height: 60.h,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: AppSizes.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['title'],
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.secondary,
                                  ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          item['description'],
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: AppColors.secondary,
                                    height: 1.2,
                                  ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'Starting from ${item['price']}',
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    color: AppColors.secondary,
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Padding(
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
              'Failed to load business details',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.error,
                  ),
            ),
            SizedBox(height: AppSizes.sm),
            Text(
              error ?? 'Unknown error occurred',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSizes.lg),
            ElevatedButton(
              onPressed: () {
                _loadBusinessProfile();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom clipper for top curve
class TopCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 40);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 40,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
