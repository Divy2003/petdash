import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../common/widgets/Button/primarybutton.dart';
import '../../../../../common/widgets/appbar/appbar.dart';
import '../../../../../utlis/constants/colors.dart';
import '../../../../../utlis/constants/size.dart';

class AddNewServices extends StatefulWidget {
  const AddNewServices({super.key});

  @override
  State<AddNewServices> createState() => _AddNewServicesState();
}


class _AddNewServicesState extends State<AddNewServices> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _serviceIncludedController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  bool isCat = true;
  bool isDog = true;
  final picker = ImagePicker();
  List<File> _images = [];

  Future<void> pickImages() async {
    final picked = await picker.pickMultiImage();
    if (picked.isNotEmpty) {
      setState(() {
        _images = picked.map((img) => File(img.path)).toList();
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Add New Service'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTextField("Title", _titleController),
              SizedBox(height: 16),
              buildTextField("Description", _descController),
              SizedBox(height: 16),
              buildTextField("Service Included", _serviceIncludedController, maxLines: 4),
              SizedBox(height: 16),
              buildTextField("Notes", _notesController),
              SizedBox(height: 16),
              Text("Prices", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              SizedBox(height: 8),
              Row(
                children: [
                  Text("Cats"),
                  Switch(
                    value: isCat,
                    onChanged: (value) {
                      setState(() {
                        isCat = value;
                      });
                    },
                  ),
                  Spacer(),
                  Text("Dogs"),
                  Switch(
                    value: isDog,
                    onChanged: (value) {
                      setState(() {
                        isDog = value;
                      });
                    },
                  ),
                ],
              ),
              if (isCat) priceSelector("Cats"),
              if (isDog) priceSelector("Dogs"),
              SizedBox(height: 16),
              Text("Upload Images", style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              GestureDetector(
                  onTap: pickImages,
                  child: DottedBorder(
                    borderType: BorderType.RRect,
                    radius: Radius.circular(10),
                    dashPattern: [6, 4],
                    color: AppColors.dottedColor,
                    child: Container(
                      height: 100,
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: Text(
                        'Attach Images',
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: AppColors.dottedColor,
                        ),
                      ),
                    ),
                  )
              ),
              const SizedBox(height: 10),

              if (_images.isNotEmpty)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _images
                      .map((file) => Image.file(file, width: 60, height: 60, fit: BoxFit.cover))
                      .toList(),
                ),

              SizedBox(height: 24),
              PrimaryButton(title: 'Save',onPressed: (){},),
            ],
          ),
        ),
      ),
    );

  }
  Widget buildTextField(String label, TextEditingController controller, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          decoration:InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg),
              borderSide: BorderSide(
                color: AppColors.textPrimaryColor,
                width: 2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.borderRadiusLg),
              borderSide: BorderSide(
                color: AppColors.textPrimaryColor,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget priceSelector(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.w600)),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            sizeButton("Small"),
            sizeButton("Medium"),
            sizeButton("Large"),
          ],
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget sizeButton(String size) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4),
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(child: Text(size)),
      ),
    );
  }

}
