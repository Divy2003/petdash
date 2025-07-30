import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dotted_border/dotted_border.dart';

class MultipleImagePicker extends StatefulWidget {
  const MultipleImagePicker({Key? key}) : super(key: key);

  @override
  State<MultipleImagePicker> createState() => _MultipleImagePickerState();
}

class _MultipleImagePickerState extends State<MultipleImagePicker> {
  final List<XFile> _images = [];
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final List<XFile>? pickedFiles = await _picker.pickMultiImage();

    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      setState(() {
        _images.addAll(pickedFiles);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Upload Images"),
        const SizedBox(height: 8),

        GestureDetector(
          onTap: _pickImage,
          child: DottedBorder(
            borderType: BorderType.RRect,
            radius: const Radius.circular(10),
            dashPattern: const [6, 4],
            color: Colors.blue,
            child: Container(
              height: 100,
              width: double.infinity,
              alignment: Alignment.center,
              child: Text(
                'Attach images',
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: Colors.blue,
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Show selected images
        if (_images.isNotEmpty)
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _images.map((img) {
              return Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      File(img.path),
                      height: 80,
                      width: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: -6,
                    right: -6,
                    child: IconButton(
                      icon: const Icon(Icons.cancel, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          _images.remove(img);
                        });
                      },
                    ),
                  )
                ],
              );
            }).toList(),
          ),
      ],
    );
  }
}
