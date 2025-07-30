import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:petcare/common/widgets/appbar/appbar.dart';
import '../../../../../common/widgets/Button/primarybutton.dart';
import '../../../../../utlis/constants/size.dart';
import '../../widgets/ImagePicker.dart';
import '../../widgets/custom_text_field.dart';

class EditArticlesDetails extends StatefulWidget {
  const EditArticlesDetails({super.key});

  @override
  State<EditArticlesDetails> createState() => _EditArticlesDetailsState();
}

class _EditArticlesDetailsState extends State<EditArticlesDetails> {
  // Controllers
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();
  final TextEditingController _recommendedProductsController = TextEditingController();

  // Focus Nodes
  final FocusNode _titleFocus = FocusNode();
  final FocusNode _categoryFocus = FocusNode();
  final FocusNode _bodyFocus = FocusNode();
  final FocusNode _tagsFocus = FocusNode();
  final FocusNode _recommendedProductsFocus = FocusNode();

  @override
  void dispose() {
    _titleController.dispose();
    _categoryController.dispose();
    _bodyController.dispose();
    _tagsController.dispose();
    _recommendedProductsController.dispose();

    _titleFocus.dispose();
    _categoryFocus.dispose();
    _bodyFocus.dispose();
    _tagsFocus.dispose();
    _recommendedProductsFocus.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Edit Articles'),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: AppSizes.defaultPaddingHorizontal,
          vertical: AppSizes.defaultPaddingVertical,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            CustomTextField(
              label: 'Title',
              controller: _titleController,
              focusNode: _titleFocus,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: () =>
                  FocusScope.of(context).requestFocus(_categoryFocus),
              maxLines: 1,
            ),
            SizedBox(height: AppSizes.spaceBtwItems),

            // Category
            CustomTextField(
              label: 'Category',
              controller: _categoryController,
              focusNode: _categoryFocus,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: () =>
                  FocusScope.of(context).requestFocus(_bodyFocus),
              maxLines: 2,
            ),
            SizedBox(height: AppSizes.spaceBtwItems),

            // Body
            CustomTextField(
              label: 'Body',
              controller: _bodyController,
              focusNode: _bodyFocus,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: () =>
                  FocusScope.of(context).requestFocus(_tagsFocus),
              maxLines: 9,
            ),
            SizedBox(height: AppSizes.spaceBtwItems),

            // Tags
            CustomTextField(
              label: 'Tags',
              controller: _tagsController,
              focusNode: _tagsFocus,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: () =>
                  FocusScope.of(context).requestFocus(_recommendedProductsFocus),
            ),
            SizedBox(height: AppSizes.spaceBtwItems),

            // Recommended Products
            CustomTextField(
              label: 'Recommended Products',
              controller: _recommendedProductsController,
              focusNode: _recommendedProductsFocus,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: () => FocusScope.of(context).unfocus(),
            ),
            SizedBox(height: AppSizes.spaceBtwSections),

            // Image Picker
            const MultipleImagePicker(),
            SizedBox(height: AppSizes.spaceBtwSections),

            // Save Button
            PrimaryButton(
              title: 'Save',
              onPressed: () {
                // TODO: Implement save logic
              },
            ),
          ],
        ),
      ),
    );
  }
}
