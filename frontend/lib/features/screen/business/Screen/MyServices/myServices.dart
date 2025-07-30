import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:petcare/common/widgets/Button/primarybutton.dart';
import 'package:petcare/utlis/constants/colors.dart';
import '../../../../../common/widgets/appbar/appbar.dart';
import '../../../../../utlis/constants/size.dart';
import '../../../../../utlis/app_config/app_config.dart';
import '../../../../../provider/services_provider.dart';
import '../../../../../models/service_model.dart';
import '../../../auth/login/loginscreen.dart';
import 'addnewServices.dart';
import 'editServicesdetails.dart';

class MyServices extends StatefulWidget {
  const MyServices({super.key});

  @override
  State<MyServices> createState() => _MyServicesState();
}

class _MyServicesState extends State<MyServices> {
  @override
  void initState() {
    super.initState();
    // Initialize services if needed when the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ServicesProvider>().initializeIfNeeded();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'My Services'),
      body: Consumer<ServicesProvider>(
        builder: (context, servicesProvider, child) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSizes.defaultPaddingHorizontal,
                vertical: AppSizes.defaultPaddingVertical,
              ),
              child: Column(
                children: [
                  PrimaryButton(
                    title: 'Add New Service',
                    onPressed: servicesProvider.isCreating ? null : () {
                      Get.to(() => const AddNewServices())?.then((_) {
                        // Refresh services when returning from add screen
                        servicesProvider.refreshServices();
                      });
                    },
                  ),
                  SizedBox(height: 20.h),
                  // Show last refresh time if available
                  if (servicesProvider.lastRefreshTime != null)
                    Text(
                      'Last updated: ${_formatRefreshTime(servicesProvider.lastRefreshTime!)}',
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                  SizedBox(height: 20.h),
                  _buildServicesContent(servicesProvider),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildServicesContent(ServicesProvider servicesProvider) {
    if (servicesProvider.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (servicesProvider.error != null) {
      return _buildErrorWidget(servicesProvider);
    }

    if (!servicesProvider.hasServices) {
      return _buildEmptyState();
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: servicesProvider.services.length,
      itemBuilder: (context, index) {
        final service = servicesProvider.services[index];
        return Card(
          elevation: 3,
          margin: EdgeInsets.symmetric(vertical: 8.h),
          color: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.borderRadiusMd),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Service Image (if available)
                if (service.images.isNotEmpty) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: Image.network(
                      '${AppConfig.baseFileUrl}/${service.images.first}',
                      height: 120.h,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 120.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Icon(
                            Icons.image_not_supported,
                            color: Colors.grey[400],
                            size: 40.sp,
                          ),
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          height: 120.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8.r),
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
                  SizedBox(height: 8.h),
                  // Image count indicator
                  if (service.images.length > 1)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        '+${service.images.length - 1} more',
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  SizedBox(height: 12.h),
                ] else ...[
                  // Placeholder for services without images
                  Container(
                    height: 60.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image_outlined,
                          color: Colors.grey[400],
                          size: 24.sp,
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'No images',
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 12.h),
                ],
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        service.title,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              fontSize: 14.sp,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        // Convert ServiceModel to Map for compatibility
                        final serviceMap = {
                          'title': service.title,
                          'description': service.description ?? '',
                          'price': service.price ?? '',
                          'id': service.id,
                        };
                        Get.to(() => EditServicesDetails(service: serviceMap));
                      },
                      child: Icon(
                        Icons.edit_outlined,
                        color: AppColors.primary,
                        size: AppSizes.iconSm,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    InkWell(
                      onTap: servicesProvider.isServiceDeleting(service.id)
                          ? null
                          : () => _showDeleteDialog(context, service, servicesProvider),
                      child: servicesProvider.isServiceDeleting(service.id)
                          ? SizedBox(
                              width: AppSizes.iconSm,
                              height: AppSizes.iconSm,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  const Color(0xFFFB2828),
                                ),
                              ),
                            )
                          : Icon(
                              Icons.delete,
                              color: const Color(0xFFFB2828),
                              size: AppSizes.iconSm,
                            ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Text(
                  service.description ?? '',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 13.sp,
                        color: AppColors.primary,
                      ),
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Text(
                      "Starting from ${service.price ?? 'N/A'}",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontSize: 14.sp,
                            color: AppColors.dottedColor,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    SizedBox(width: 8.w),
                    Icon(
                      Icons.arrow_forward,
                      color: AppColors.dottedColor,
                      size: AppSizes.iconMd,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildErrorWidget(ServicesProvider servicesProvider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64.sp,
            color: Colors.red,
          ),
          SizedBox(height: 16.h),
          Text(
            'Error loading services',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(height: 8.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              _getErrorMessage(servicesProvider.error ?? 'Unknown error'),
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 16.h),
          if (servicesProvider.error?.contains('Authentication failed') == true ||
              servicesProvider.error?.contains('log in again') == true) ...[
            PrimaryButton(
              title: 'Go to Login',
              onPressed: () {
                Get.offAll(() => const LoginScreen());
              },
            ),
            SizedBox(height: 8.h),
          ],
          PrimaryButton(
            title: servicesProvider.isLoading ? 'Loading...' : 'Retry',
            onPressed: servicesProvider.isLoading ? null : () {
              servicesProvider.clearError();
              servicesProvider.refreshServices();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.business_center_outlined,
            size: 64.sp,
            color: AppColors.dottedColor,
          ),
          SizedBox(height: 16.h),
          Text(
            'No Services Yet',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(height: 8.h),
          Text(
            'Add your first service to get started',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, ServiceModel service,
      ServicesProvider servicesProvider) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Delete Service'),
          content: Text('Are you sure you want to delete "${service.title}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                final success =
                    await servicesProvider.deleteService(service.id);
                if (mounted) {
                  if (success) {
                    ScaffoldMessenger.of(this.context).showSnackBar(
                      const SnackBar(
                          content: Text('Service deleted successfully')),
                    );
                  } else {
                    ScaffoldMessenger.of(this.context).showSnackBar(
                      SnackBar(
                          content: Text(servicesProvider.error ??
                              'Failed to delete service')),
                    );
                  }
                }
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  String _getErrorMessage(String error) {
    if (error.contains('HTML instead of JSON')) {
      return 'Server configuration error. The API endpoint is returning a web page instead of data. Please check your server setup.';
    } else if (error.contains('No internet connection')) {
      return 'No internet connection. Please check your network and try again.';
    } else if (error.contains('SocketException') || error.contains('Connection')) {
      return 'Cannot connect to server. Please check if the server is running and your network connection.';
    } else if (error.contains('FormatException')) {
      return 'Server returned invalid data format. This usually means the API endpoint is not configured correctly.';
    } else if (error.contains('404')) {
      return 'API endpoint not found. The services endpoint may not be implemented on the server.';
    } else if (error.contains('401') || error.contains('Unauthorized')) {
      return 'Authentication failed. Please log in again.';
    } else if (error.contains('500')) {
      return 'Server error. Please try again later or contact support.';
    }
    return error;
  }

  String _formatRefreshTime(String timestamp) {
    try {
      final dateTime = DateTime.parse(timestamp);
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inMinutes < 1) {
        return 'Just now';
      } else if (difference.inMinutes < 60) {
        return '${difference.inMinutes}m ago';
      } else if (difference.inHours < 24) {
        return '${difference.inHours}h ago';
      } else {
        return '${difference.inDays}d ago';
      }
    } catch (e) {
      return 'Recently';
    }
  }
}
