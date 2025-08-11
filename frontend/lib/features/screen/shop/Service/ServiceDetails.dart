import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:petcare/common/widgets/progessIndicator/threedotindicator.dart';
import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../utlis/constants/colors.dart';
import '../../../../utlis/constants/size.dart';
import '../../../../utlis/helpers/image_helper.dart';
import '../../../../models/business_model.dart';
import '../../../../services/BusinessServices/business_service.dart';
import 'ServicesSelectPetAndReview/ServiceSelectPetandReview.dart';
import 'ServicesSelectPetAndReview/widgets/curvedheaderwidgets.dart';
import 'ServicesSubDeatils.dart';
import '../../../../services/location_service.dart';

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
      final result = await BusinessService.getBusinessProfileWithServices(widget.businessId!);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: businessProfile?.name ?? widget.providerName),
      body: isLoading
          ? const Center(child: ThreeDotIndicator())
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

              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Service Partner Details',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontSize: AppSizes.fontSizeMd,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(height: AppSizes.sm),

                  // Address
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.location_on_outlined, color: AppColors.primary),
                      SizedBox(width: AppSizes.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              businessProfile?.address?.fullAddress ??
                                  "4140 Parker Rd. Allentown, Hawaii 81063",
                              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            FutureBuilder<double?>(
                              future: businessProfile?.address != null
                                  ? LocationService.getDistanceToAddressInMiles(
                                      businessProfile!.address!.fullAddress,
                                    )
                                  : Future.value(null),
                              builder: (context, snapshot) {
                                final miles = snapshot.data;
                                final text = miles == null
                                    ? ''
                                    : '(${miles.toStringAsFixed(1)} miles away from your location)';
                                return Text(
                                  text,
                                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: AppColors.cart,
                                  ),
                                );
                              },
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
                      Icon(Icons.storefront_outlined, color: AppColors.primary),
                      SizedBox(width: AppSizes.sm),
                      Text(
                        businessProfile?.openStatus ??
                            "Open at 10 AM - 7PM (Closed on Sat-Sun)",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSizes.sm),

                  // Phone
                  Row(
                    children: [
                      Icon(Icons.phone_outlined, color: AppColors.primary),
                      SizedBox(width: AppSizes.sm),
                      Text(
                        businessProfile?.phone ?? "787874545",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
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
                  borderRadius: BorderRadius.circular(AppSizes.borderRadiusMd),
                ),
                child: Center(
                  child: Text(
                    'Save as Primary',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
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
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
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
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: AppColors.secondary,
                ),
              ),
            ),
            SizedBox(height: AppSizes.spaceBtwSections/2),
            _buildServicesList(),
          ],
        ),
      ),
    );
  }

  Widget _buildServicesList() {
    if (servicesByCategory.isEmpty) {
      return Padding(
        padding: EdgeInsets.all(AppSizes.md),
        child: Text(
          "No services available.",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }

    List<Widget> serviceWidgets = [];

    servicesByCategory.forEach((categoryName, categoryData) {
      List<dynamic> services = [];
      if (categoryData is List) {
        services = categoryData;
      } else if (categoryData is Map && categoryData['services'] is List) {
        services = categoryData['services'];
      }

      if (services.isNotEmpty) {
        // Add category header (REMOVED 'Hair cutting')
        if (categoryName.toLowerCase() != 'hair cutting') {
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
        }

        // Add services
        for (var service in services) {
          serviceWidgets.add(_buildServiceCard(service));
        }
      }
    });

    return Column(children: serviceWidgets);
  }

  Widget _buildServiceCard(Map<String, dynamic> service) {
    return GestureDetector(
      onTap: () {
        if (service['_id'] != null) {
          Get.to(() => ServicesSubDetails(serviceId: service['_id']));
        } else {
          Get.to(() => ServicesSubDetails(serviceData: service));
        }
      },
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
              Container(
                width: 60.w,
                height: 60.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  color: AppColors.primary.withOpacity(0.1),
                ),
                child: service['images'] != null && (service['images'] as List).isNotEmpty
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: Image.network(
                    ImageHelper.getFirstImageUrl(service['images']),
                    width: 60.w,
                    height: 60.h,
                    fit: BoxFit.cover,
                  ),
                )
                    : Icon(Icons.pets, color: AppColors.primary, size: 30.sp),
              ),
              SizedBox(width: AppSizes.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service['title'] ?? 'MyServices',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.secondary,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      service['description'] ?? 'No description available',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: AppColors.secondary,
                        height: 1.2,
                      ),
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

  Widget _buildErrorWidget() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSizes.md),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: AppColors.error),
            SizedBox(height: AppSizes.md),
            Text(
              'Failed to load business details',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.error),
            ),
            SizedBox(height: AppSizes.sm),
            Text(
              error ?? 'Unknown error occurred',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSizes.lg),
            ElevatedButton(
              onPressed: _loadBusinessProfile,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
