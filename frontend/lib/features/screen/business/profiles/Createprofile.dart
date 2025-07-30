import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../utlis/constants/size.dart';

class CreateProfile extends StatefulWidget {
  const CreateProfile({super.key});

  @override
  State<CreateProfile> createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Create Profile'),

      body: SingleChildScrollView(
        child: Padding(
          padding:  EdgeInsets.all(AppSizes.md),
          child: Column(
            children: [
              // TODO: Add form fields
            ],
          ),
        ),
      ),
    );
  }
}
