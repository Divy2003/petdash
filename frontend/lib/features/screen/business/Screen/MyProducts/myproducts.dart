import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:petcare/common/widgets/progessIndicator/threedotindicator.dart';
import 'package:petcare/common/widgets/Button/primarybutton.dart';
import 'package:petcare/common/widgets/appbar/appbar.dart';
import 'package:petcare/services/BusinessServices/products_services.dart';
import 'package:petcare/utlis/constants/colors.dart';
import 'package:petcare/utlis/constants/size.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../utlis/constants/image_strings.dart';
import '../../model/addproductsmodel.dart';
import 'AddNewProducts.dart';
import 'editNewProducts.dart';

class MyProductsScreen extends StatefulWidget {
  const MyProductsScreen({Key? key}) : super(key: key);

  @override
  State<MyProductsScreen> createState() => _MyProductsScreenState();
}

class _MyProductsScreenState extends State<MyProductsScreen> {
  List<ProductRequest> allProducts = [];
  List<ProductRequest> displayedProducts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';

    final products = await ProductApiService.fetchMyProducts(token);
    setState(() {
      allProducts = products;
      displayedProducts = List.from(allProducts);
      isLoading = false;
    });
  }

  void _deleteProduct(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';

    final success = await ProductApiService.deleteProduct(token, id);
    if (success) {
      _loadProducts(); // refresh list
      Get.snackbar("Success", "Product deleted successfully");
    } else {
      Get.snackbar("Error", "Failed to delete product");
    }
  }

  void _sortProducts(bool ascending) {
    setState(() {
      displayedProducts.sort((a, b) =>
          ascending ? a.price.compareTo(b.price) : b.price.compareTo(a.price));
    });
  }

  void _filterProducts(double maxPrice) {
    setState(() {
      displayedProducts =
          allProducts.where((p) => p.price <= maxPrice).toList();
    });
  }

  void _resetFilter() {
    setState(() {
      displayedProducts = List.from(allProducts);
    });
  }

  void _showSortDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Sort by Price"),
        actions: [
          TextButton(
              onPressed: () {
                _sortProducts(true);
                Navigator.pop(context);
              },
              child: const Text("Low to High")),
          TextButton(
              onPressed: () {
                _sortProducts(false);
                Navigator.pop(context);
              },
              child: const Text("High to Low")),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    double selectedPrice = 50;
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setSheetState) => Padding(
            padding: EdgeInsets.all(AppSizes.md),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Filter by Max Price",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Slider(
                  value: selectedPrice,
                  min: 0,
                  max: 1000,
                  divisions: 20,
                  label: "\$${selectedPrice.toStringAsFixed(0)}",
                  onChanged: (value) {
                    setSheetState(() => selectedPrice = value);
                  },
                ),
                SizedBox(height: AppSizes.md),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _resetFilter();
                        Navigator.pop(context);
                      },
                      child: const Text("Reset"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _filterProducts(selectedPrice);
                        Navigator.pop(context);
                      },
                      child: const Text("Apply"),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "My Products"),
      body: isLoading
          ? const Center(child: ThreeDotIndicator())
          : Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
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
                              InkWell(
                                onTap: _showSortDialog,
                                child: Icon(Icons.sort,
                                    size: AppSizes.iconMd,
                                    color: AppColors.textPrimaryColor),
                              ),
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
                              InkWell(
                                onTap: _showFilterDialog,
                                child: Icon(Icons.filter_list,
                                    size: AppSizes.iconMd,
                                    color: AppColors.textPrimaryColor),
                              ),
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

                  PrimaryButton(
                    title: "Add New Product",
                    onPressed: () async {
                      final result = await Get.to(() => const AddNewProducts());
                      if (result == true) {
                        _loadProducts();
                      }
                    },
                  ),
                  SizedBox(height: AppSizes.md),
                  Expanded(
                    child: GridView.builder(
                      itemCount: displayedProducts.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.75,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemBuilder: (context, index) {
                        final product = displayedProducts[index];
                        final imageUrl =
                            product.images.isNotEmpty ? product.images[0] : '';

                        return Container(
                            height: 250,
                            width: 150,
                            padding: EdgeInsets.all(AppSizes.sm),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: AppColors.textPrimaryColor, width: 1),
                              borderRadius: BorderRadius.circular(
                                  AppSizes.borderRadiusMd),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                imageUrl.startsWith('/') ||
                                        imageUrl.startsWith('file')
                                    ? Center(
                                        child: Image.file(
                                          File(imageUrl),
                                          height: 120,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) =>
                                              const Icon(Icons.broken_image,
                                                  size: 50),
                                        ),
                                      )
                                    : Image.asset(
                                        imageUrl,
                                        height: 120,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) =>
                                            const Icon(Icons.broken_image),
                                      ),
                                SizedBox(height: AppSizes.md),
                                Text(
                                  product.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w500,
                                      ),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: AppSizes.md),
                                Row(
                                  children: [
                                    Text(
                                      "\$${product.price.toStringAsFixed(2)}",
                                     style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                    SizedBox(width: AppSizes.md),
                                    Spacer(),
                                    InkWell(
                                        onTap: () async {
                                          final result = await Get.to(() =>
                                              EditNewProducts(
                                                  product: product));
                                          if (result == true) {
                                            _loadProducts();
                                          }
                                        },
                                        child: Icon(Icons.edit,
                                            size: 18, color: AppColors.textPrimaryColor)),
                                    SizedBox(width: AppSizes.md),
                                    InkWell(
                                        onTap: () {
                                          _deleteProduct(
                                              product.id!); // implement this
                                        },
                                        child: Icon(Icons.delete,
                                            size: 18, color: AppColors.error)),
                                  ],
                                ),
                              ],
                            ));
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
