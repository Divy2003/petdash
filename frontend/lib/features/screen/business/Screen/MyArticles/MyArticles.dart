import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petcare/features/screen/business/Screen/MyArticles/widgets/myarticlescard.dart';
import '../../../../../common/widgets/Button/primarybutton.dart';
import '../../../../../common/widgets/appbar/appbar.dart';
import '../../../../../utlis/constants/colors.dart';
import '../../../../../utlis/constants/image_strings.dart';
import '../../../../../utlis/constants/size.dart';
import 'AddNewArticles.dart';
import 'EditArticlesdetails.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyArticles extends StatefulWidget {
  const MyArticles({super.key});

  @override
  State<MyArticles> createState() => _MyArticlesState();
}

class _MyArticlesState extends State<MyArticles> {
  List<Map<String, dynamic>> allArticles = [
    {
      'title': 'How to Adopt Outdoor Cats',
      'date': '5/20',
      'image': AppImages.dog2,
    },
    {
      'title': 'Dog Keeping You Up All Night?',
      'date': '5/20',
      'image': AppImages.dog2,
    },
    {
      'title': 'How to Adopt Outdoor Cats',
      'date': '5/20',
      'image': AppImages.dog1,
    },
    {
      'title': 'How to Adopt Outdoor Cats',
      'date': '5/20',
      'image': AppImages.dog1,
    },
  ];

  late List<Map<String, dynamic>> displayedArticles;

  @override
  void initState() {
    super.initState();
    displayedArticles = List.from(allArticles);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'My Articles'),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 16.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sort & Filter Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: _showSortDialog,
                    child: Row(
                      children: [
                        Icon(Icons.sort, color: Colors.grey, size: 20.sp),
                        SizedBox(width: 4.w),
                        const Text('Sort', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: _showFilterDialog,
                    child: Row(
                      children: [
                        Icon(Icons.filter_list,
                            color: Colors.grey,
                            size: 20.sp),
                        SizedBox(width: 4.w),
                        const Text('Filter', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSizes.spaceBtwItems.h),

              // Create Button
              PrimaryButton(
                title: 'Create New Article',
                onPressed: () => Get.to(() => const AddNewArticles()),
              ),
              SizedBox(height: AppSizes.spaceBtwSections.h),

              // Grid View of Articles
              GridView.builder(
                itemCount: displayedArticles.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: 220.h,
                  crossAxisSpacing: 16.w,
                  mainAxisSpacing: 16.h,
                ),
                itemBuilder: (context, index) {
                  final article = displayedArticles[index];
                  return ArticleCard(
                    title: article['title'],
                    date: article['date'],
                    imageUrl: article['image'],
                    onDelete: () {
                      setState(() {
                        displayedArticles.removeAt(index);
                      });
                    },
                    onEdit: () => Get.to(() => const EditArticlesDetails()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _sortProducts(bool ascending) {
    setState(() {
      displayedArticles.sort((a, b) =>
      ascending ? a['title'].compareTo(b['title']) : b['title'].compareTo(a['title']));
    });
  }

  void _filterProducts(String keyword) {
    setState(() {
      displayedArticles = allArticles
          .where((p) => p['title'].toLowerCase().contains(keyword.toLowerCase()))
          .toList();
    });
  }

  void _resetFilter() {
    setState(() {
      displayedArticles = List.from(allArticles);
    });
  }

  void _showSortDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.white,
        title:  Text("Sort by Title",
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
          color: AppColors.primary,
        ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _sortProducts(true);
              Navigator.pop(context);
            },
            child: Text(
                "A-Z",
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              _sortProducts(false);
              Navigator.pop(context);
            },
            child:  Text("Z-A",
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: AppColors.primary,
                fontWeight: FontWeight.w500,
            ),),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    String keyword = '';
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      builder: (_) {
        return Padding(
          padding: EdgeInsets.all(12.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
               Text(
                  "Filter by Keyword",
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: AppColors.primary,
                ),
              ),
              SizedBox(height: 10.h),
              TextField(
                decoration: const InputDecoration(hintText: 'Enter keyword...'),
                onChanged: (value) => keyword = value,
              ),
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      side: BorderSide(color: AppColors.white),
                      elevation: 0,
                    ),
                    onPressed: () {
                      _resetFilter();
                      Navigator.pop(context);
                    },
                    child:  Text(
                      "Reset",
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.white,
                      side: BorderSide(color: AppColors.textPrimaryColor),
                      elevation: 0,
                    ),
                    onPressed: () {
                      _filterProducts(keyword);
                      Navigator.pop(context);
                    },
                    child:  Text("Apply",
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
