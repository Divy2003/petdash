import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:petcare/utlis/constants/size.dart';
import '../../../../../common/widgets/Button/primarybutton.dart';
import '../../../../../common/widgets/appbar/appbar.dart';
import '../../../../../utlis/constants/colors.dart';
import '../../../../../utlis/constants/image_strings.dart';
import 'AddNewProducts.dart';
import 'editNewProducts.dart';

class MyProducts extends StatefulWidget {
  const MyProducts({super.key});

  @override
  State<MyProducts> createState() => _MyProductsState();
}

class _MyProductsState extends State<MyProducts> {
  List<Map<String, dynamic>> allProducts = [
    {
      "image": AppImages.products1,
      "title": "Merrick Grain Free with Real Meat + Sweet Potato Dry Dog Food",
      "price": 59.99
    },
    {
      "image": AppImages.products2,
      "title": "Victor Classic - Hi-Pro Plus, Dry Dog Food",
      "price": 49.0
    },
    {
      "image": AppImages.products3,
      "title": "Milk-Bone MaroSnacks Dog Treats for Dogs",
      "price": 20.99
    },
    {
      "image": AppImages.products4,
      "title": "True Chews Natural Dog Treats Premium Jerky Cuts Made with Real Steak",
      "price": 32.0
    },
  ];

  late List<Map<String, dynamic>> displayedProducts;

  @override
  void initState() {
    super.initState();
    displayedProducts = List.from(allProducts);
  }

  void _sortProducts(bool ascending) {
    setState(() {
      displayedProducts.sort((a, b) =>
      ascending ? a['price'].compareTo(b['price']) : b['price'].compareTo(a['price']));
    });
  }

  void _filterProducts(double maxPrice) {
    setState(() {
      displayedProducts = allProducts.where((p) => p['price'] <= maxPrice).toList();
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
                const Text("Filter by Max Price", style: TextStyle(fontWeight: FontWeight.bold)),
                Slider(
                  value: selectedPrice,
                  min: 0,
                  max: 100,
                  divisions: 10,
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
      appBar: CustomAppBar(title: 'My Products'),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.md,
            vertical: AppSizes.sm,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sort and Filter Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: _showSortDialog,
                    child: Icon(Icons.sort, size: 22.sp, color: Colors.grey),
                  ),
                  GestureDetector(
                    onTap: _showFilterDialog,
                    child: Icon(Icons.filter_list, size: 22.sp, color: Colors.grey),
                  ),
                ],
              ),
              SizedBox(height: AppSizes.sm),

              // Add New Product Button
              PrimaryButton(
                title: 'Add New Product',
                onPressed: () {
                  Get.to(() => AddNewProducts());
                },
              ),
              SizedBox(height: AppSizes.md),

              // Product Grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: displayedProducts.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: AppSizes.gridViewSpacing,
                  crossAxisSpacing: AppSizes.gridViewSpacing,
                  childAspectRatio: 0.65,
                ),
                itemBuilder: (context, index) {
                  final product = displayedProducts[index];
                  return Container(
                    padding: EdgeInsets.all(AppSizes.sm),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.textPrimaryColor),
                      borderRadius: BorderRadius.circular(AppSizes.borderRadiusMd),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Image.asset(
                            product['image'],
                            height: AppSizes.productImageSize.h,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(height: AppSizes.md),
                        Text(
                          product['title'],
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "\$${product['price'].toString()}",
                              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    Get.to(() => EditNewProducts());
                                  },
                                  child: Icon(Icons.edit, size: 18.sp, color: Colors.grey),
                                ),
                                SizedBox(width: AppSizes.xs),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      displayedProducts.removeAt(index);
                                      allProducts.removeWhere((element) =>
                                      element['title'] == product['title']);
                                    });
                                  },
                                  child: Icon(Icons.delete, size: 18.sp, color: Colors.redAccent),
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
