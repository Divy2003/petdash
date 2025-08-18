import 'package:flutter/material.dart';

import '../../../../../common/widgets/Button/primarybutton.dart';
import '../../../../../common/widgets/appbar/appbar.dart';
import '../../../../../utlis/constants/size.dart';
import '../../widgets/custom_text_field.dart';

class AddNewArticles extends StatefulWidget {
  const AddNewArticles({super.key});

  @override
  State<AddNewArticles> createState() => _AddNewArticlesState();
}

class _AddNewArticlesState extends State<AddNewArticles> {
  // Controllers
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();
  final TextEditingController _relatedProductsController = TextEditingController();

  // Focus Nodes
  final FocusNode _titleFocus = FocusNode();
  final FocusNode _categoryFocus = FocusNode();
  final FocusNode _bodyFocus = FocusNode();
  final FocusNode _tagsFocus = FocusNode();
  final FocusNode _relatedProductsFocus = FocusNode();

  @override
  void dispose() {
    _titleController.dispose();
    _categoryController.dispose();
    _bodyController.dispose();
    _tagsController.dispose();
    _relatedProductsController.dispose();

    _titleFocus.dispose();
    _categoryFocus.dispose();
    _bodyFocus.dispose();
    _tagsFocus.dispose();
    _relatedProductsFocus.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Add New Articles'),
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
            SizedBox(height: AppSizes.spaceBtwInputFields),

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
            SizedBox(height: AppSizes.spaceBtwInputFields),

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
            SizedBox(height: AppSizes.spaceBtwInputFields),

            // Tags
            CustomTextField(
              label: 'Tags',
              controller: _tagsController,
              focusNode: _tagsFocus,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: () =>
                  FocusScope.of(context).requestFocus(_relatedProductsFocus),
              maxLines: 1,
            ),
            SizedBox(height: AppSizes.spaceBtwInputFields),

            // Related Products
            CustomTextField(
              label: 'Related Products',
              controller: _relatedProductsController,
              focusNode: _relatedProductsFocus,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: () => FocusScope.of(context).unfocus(),
              maxLines: 1,
            ),
            SizedBox(height: AppSizes.spaceBtwInputFields),

            // Image Picker
            // const MultipleImagePicker(),
            // SizedBox(height: AppSizes.spaceBtwSections),

            // Save Button
            PrimaryButton(
              title: "Save",
              onPressed: () {
                // Handle save logic
              },
            ),
          ],
        ),
      ),
    );
  }
}
