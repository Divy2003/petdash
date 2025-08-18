import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dotted_border/dotted_border.dart';
class SingleImagePicker extends StatefulWidget {
  final Function(String path)? onImagePicked;

  const SingleImagePicker({super.key, this.onImagePicked});

  @override
  State<SingleImagePicker> createState() => _SingleImagePickerState();
}

class _SingleImagePickerState extends State<SingleImagePicker> {
  XFile? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = pickedFile;
      });

      if (widget.onImagePicked != null) {
        widget.onImagePicked!(pickedFile.path);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Upload Image"),
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
                'Attach image',
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: Colors.blue,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        if (_image != null)
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  File(_image!.path),
                  height: 100,
                  width: 100,
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
                      _image = null;
                    });
                    if (widget.onImagePicked != null) {
                      widget.onImagePicked!(""); // clear
                    }
                  },
                ),
              )
            ],
          ),
      ],
    );
  }
}
