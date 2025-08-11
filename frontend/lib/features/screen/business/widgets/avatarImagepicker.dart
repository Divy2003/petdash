import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AvatarImagePicker extends StatefulWidget {
  final void Function(File? file) onChanged;
  final String? initialImageUrl;
  final double radius;

  const AvatarImagePicker({
    super.key,
    required this.onChanged,
    this.initialImageUrl,
    this.radius = 40,
  });

  @override
  State<AvatarImagePicker> createState() => _AvatarImagePickerState();
}

class _AvatarImagePickerState extends State<AvatarImagePicker> {
  File? _selectedImage;

  Future<void> _pick(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source, imageQuality: 85);
    if (picked != null) {
      setState(() => _selectedImage = File(picked.path));
      widget.onChanged(_selectedImage);
    }
  }

  void _showPickerSheet() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.pop(ctx);
                _pick(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Camera'),
              onTap: () {
                Navigator.pop(ctx);
                _pick(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider? background;
    if (_selectedImage != null) {
      background = FileImage(_selectedImage!);
    } else if (widget.initialImageUrl != null && widget.initialImageUrl!.isNotEmpty) {
      background = NetworkImage(widget.initialImageUrl!);
    }

    return GestureDetector(
      onTap: _showPickerSheet,
      child: CircleAvatar(
        radius: widget.radius,
        backgroundColor: Colors.grey[300],
        backgroundImage: background,
        child: background == null
            ? const Icon(Icons.camera_alt, size: 30, color: Colors.black54)
            : null,
      ),
    );
  }
}
