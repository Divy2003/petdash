import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:petcare/utlis/constants/size.dart';
import 'package:provider/provider.dart';

import '../../../../common/widgets/Button/primarybutton.dart';
import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../utlis/constants/colors.dart';
import '../../../../utlis/constants/image_strings.dart';
import '../../../../utlis/app_config/app_config.dart';
import '../../../../provider/services_provider.dart';
import '../../../../models/service_model.dart';
import 'appointmentbook/Appointmentbooking.dart';

class ServicesSubDetails extends StatefulWidget {
  final String? serviceId;
  final Map<String, dynamic>? serviceData;

  const ServicesSubDetails({
    super.key,
    this.serviceId,
    this.serviceData,
  });

  @override
  State<ServicesSubDetails> createState() => _ServicesSubDetailsState();
}

class _ServicesSubDetailsState extends State<ServicesSubDetails> {
  ServiceModel? service;
  bool isLoading = false;
  String? error;
  Map<String, dynamic> serviceData = {};

  @override
  void initState() {
    super.initState();
    _loadServiceData();
  }

  Future<void> _loadServiceData() async {
    if (widget.serviceId != null) {
      setState(() {
        isLoading = true;
        error = null;
      });

      try {
        final servicesProvider = context.read<ServicesProvider>();
        await servicesProvider.getServiceById(widget.serviceId!);
        if (mounted) {
          setState(() {
            service = servicesProvider.selectedService;
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
    } else if (widget.serviceData != null) {
      // Use provided service data
      setState(() {
        service = ServiceModel.fromJson(widget.serviceData!);
      });
    }
  }

  // Fallback data for when no service is provided
  Map<String, dynamic> get fallbackServiceData => {
        'title': 'Bath & Full haircut',
        'description':
            'For dogs who need a bath, haircut & extra attention to their pads to help reduce shedding',
        'price': '45',
        'images': [],
        'serviceIncluded':
            'Oxygen-infused bath with shampoo & blow dry\n15-minute brushing\nHaircut & light dematting\nNail trim\nEar cleaning, hair removal & flushing (if needed)\nScissoring feet & pad shaving\nSanitary trim\nAnal gland cleaning\nFURminator low-shed shampoo\nFURminator deShedding™ solution\nUp to 20 minutes of brushing with FURminator Tool',
      };

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: CustomAppBar(title: 'Service Details'),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (error != null) {
      return Scaffold(
        appBar: CustomAppBar(title: 'Service Details'),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: AppColors.error),
              SizedBox(height: 16.h),
              Text('Error loading service details',
                  style: Theme.of(context).textTheme.titleMedium),
              SizedBox(height: 8.h),
              Text(error!,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center),
              SizedBox(height: 16.h),
              PrimaryButton(
                title: 'Retry',
                onPressed: _loadServiceData,
              ),
            ],
          ),
        ),
      );
    }

    // Use service data or fallback
    serviceData = service != null
        ? {
            'title': service!.title,
            'description':
                service!.description ?? fallbackServiceData['description'],
            'price': service!.price ?? fallbackServiceData['price'],
            'images': service!.images,
            'serviceIncluded': service!.serviceIncluded ??
                fallbackServiceData['serviceIncluded'],
          }
        : fallbackServiceData;
    return Scaffold(
      appBar: CustomAppBar(title: serviceData['title'] ?? 'Service Details'),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Image
              _buildServiceImage(),

              SizedBox(height: 11.h),

              /// Title
              Text(
                serviceData['title'] ?? 'Service',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: AppColors.primary,
                      fontSize: AppSizes.fontSizeSm.sp,
                    ),
              ),

              SizedBox(height: 10.h),

              /// Description
              Text(
                serviceData['description'] ?? 'No description available',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: AppColors.primary,
                    ),
              ),

              SizedBox(height: 10.h),

              /// Service Included Title
              Text(
                'Service included:',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: AppColors.primary,
                    ),
              ),

              /// Service List
              _buildServiceIncludedList(),

              SizedBox(height: 10.h),

              /// Info Note
              Text(
                "*Price varies based on breed, coat condition & service time. Book online & see estimated price before your visit.",
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: const Color(0xFF4552CB).withValues(alpha: 0.6),
                    ),
              ),

              SizedBox(height: 30.h),

              /// Estimated Price
              Text(
                'Estimated Price: \$${serviceData['price'] ?? '0'}',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: AppColors.primary,
                    ),
              ),

              SizedBox(height: 30.h),

              /// Book Appointment Button
              PrimaryButton(
                title: 'Book Appointment',
                onPressed: () {
                  // Navigate to booking with required IDs
                  final businessId = service?.businessId ?? '';
                  final serviceId = service?.id ?? (widget.serviceId ?? '');
                  // Note: petId should come from user's selected pet in a future step
                  Get.to(() => AppointmentBooking(
                        businessId: businessId,
                        serviceId: serviceId,
                        petId: '',
                      ));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServiceImage() {
    final images = serviceData['images'] as List<String>? ?? [];

    if (images.isNotEmpty) {
      final imageUrl = '${AppConfig.baseFileUrl}/${images.first}';
      print('🖼️ ServicesSubDetails: Loading image: $imageUrl');

      return Container(
        width: double.infinity,
        height: 130.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg.r),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg.r),
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              print('❌ ServicesSubDetails: Image load error: $error');
              return _buildFallbackImage();
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) {
                print('✅ ServicesSubDetails: Image loaded successfully');
                return child;
              }
              return Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius:
                      BorderRadius.circular(AppSizes.borderRadiusLg.r),
                ),
                child: Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                ),
              );
            },
          ),
        ),
      );
    } else {
      return _buildFallbackImage();
    }
  }

  Widget _buildFallbackImage() {
    return Container(
      width: double.infinity,
      height: 130.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg.r),
        image: DecorationImage(
          image: AssetImage(AppImages.store1),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildServiceIncludedList() {
    final serviceIncluded = serviceData['serviceIncluded'] as String? ?? '';

    if (serviceIncluded.isEmpty) {
      return const SizedBox.shrink();
    }

    // Split by newlines to create list items
    final items = serviceIncluded
        .split('\n')
        .where((item) => item.trim().isNotEmpty)
        .toList();

    return Column(
      children: items
          .map((item) => Padding(
                padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 10.w),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "• ",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: AppColors.primary,
                          ),
                    ),
                    Expanded(
                      child: Text(
                        item.trim(),
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: AppColors.primary,
                            ),
                      ),
                    ),
                  ],
                ),
              ))
          .toList(),
    );
  }
}
