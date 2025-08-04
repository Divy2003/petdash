import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../../../../utlis/app_config/app_config.dart';
import '../../../../../utlis/constants/size.dart';
import '../../../../../utlis/constants/colors.dart';
import '../../../../../provider/category_provider.dart';
import '../../../../../services/petowerServices/category_service.dart';

import '../../Service/ServicesList.dart';
import 'service_tile.dart';

class ServiceGrid extends StatefulWidget {
  const ServiceGrid({super.key});

  @override
  State<ServiceGrid> createState() => _ServiceGridState();
}

class _ServiceGridState extends State<ServiceGrid> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CategoryProvider>().loadCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryProvider>(
      builder: (context, categoryProvider, child) {
        if (categoryProvider.isLoading) {
          return _buildLoadingGrid();
        }

        if (categoryProvider.error != null) {
          return _buildErrorGrid(categoryProvider);
        }

        if (categoryProvider.hasCategories) {
          return _buildCategoryGrid(categoryProvider.categories);
        }

        return _buildFallbackGrid(categoryProvider);
      },
    );
  }

  Widget _buildLoadingGrid() {
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 2,
      crossAxisSpacing: AppSizes.gridViewSpacing,
      mainAxisSpacing: AppSizes.gridViewSpacing,
      children: List.generate(6, (index) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.grey.withOpacity(0.3),
            borderRadius: BorderRadius.circular(AppSizes.cardRadiusMd),
          ),
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      }),
    );
  }

  Widget _buildErrorGrid(CategoryProvider categoryProvider) {
    return Container(
      padding: EdgeInsets.all(AppSizes.md),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: AppColors.error,
          ),
          SizedBox(height: AppSizes.sm),
          Text(
            'Failed to load services',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.error,
            ),
          ),
          SizedBox(height: AppSizes.xs),
          Text(
            categoryProvider.error ?? 'Unknown error',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSizes.md),
          ElevatedButton(
            onPressed: () {
              categoryProvider.clearError();
              categoryProvider.loadCategories();
            },
            child: const Text('Retry'),
          ),
          SizedBox(height: AppSizes.sm),
          TextButton(
            onPressed: () => _buildFallbackGrid(categoryProvider),
            child: const Text('Use Offline Mode'),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryGrid(categories) {
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 2,
      crossAxisSpacing: AppSizes.gridViewSpacing,
      mainAxisSpacing: AppSizes.gridViewSpacing,
      children: categories.map<Widget>((category) {
        final imageUrl = '${AppConfig.baseFileUrl}${category.image}';

        return GestureDetector(
          onTap: () {
            Get.to(() => ServicesList(category: category));
          },
          child: ServiceTile(
            title: category.name,
            color: Color(CategoryService.getColorForCategory(category.name)),
            iconPath: imageUrl,
            isNetwork: true,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFallbackGrid(CategoryProvider categoryProvider) {
    final fallbackCategories = categoryProvider.getFallbackCategories();

    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 2,
      crossAxisSpacing: AppSizes.gridViewSpacing,
      mainAxisSpacing: AppSizes.gridViewSpacing,
      children: fallbackCategories.map<Widget>((service) {
        return GestureDetector(
          onTap: () {
            Get.to(() => ServicesList(categoryName: service['title']));
          },
          child: ServiceTile(
            title: service['title'],
            color: service['color'],
            iconPath: service['icon'],
            isNetwork: false,
          ),
        );
      }).toList(),
    );
  }
}
