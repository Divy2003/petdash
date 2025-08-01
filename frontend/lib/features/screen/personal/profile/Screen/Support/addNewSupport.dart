import 'package:flutter/material.dart';

import '../../../../../../common/widgets/Button/primarybutton.dart';
import '../../../../../../common/widgets/appbar/appbar.dart';
import '../../../../../../utlis/constants/colors.dart';
import '../../../../../../utlis/constants/size.dart';
import '../../../../business/widgets/ImagePicker.dart';
import '../../../../business/widgets/custom_text_field.dart';


class AddNewSupport extends StatefulWidget {
  const AddNewSupport({super.key});

  @override
  State<AddNewSupport> createState() => _AddNewSupportState();
}

class _AddNewSupportState extends State<AddNewSupport> {

  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  final FocusNode _subjectFocus = FocusNode();
  final FocusNode _messageFocus = FocusNode();

  @override
  void dispose() {
    _subjectController.dispose();
    _messageController.dispose();
    _subjectFocus.dispose();
    _messageFocus.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Support'),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSizes.defaultPaddingHorizontal,
            vertical: AppSizes.defaultPaddingVertical,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                label: 'Subject',
                controller: _subjectController,
                focusNode: _subjectFocus,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: () => FocusScope.of(context).requestFocus(_messageFocus),
                maxLines: 1,
              ),
              SizedBox(height: AppSizes.spaceBtwInputFields),
              CustomTextField(
                label: 'Message',
                controller: _messageController,
                focusNode: _messageFocus,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: () => FocusScope.of(context).unfocus(),
                maxLines: 5,
              ),
              SizedBox(height: AppSizes.spaceBtwInputFields),
              // MultipleImagePicker(),
              SizedBox(height: AppSizes.spaceBtwSections),
              PrimaryButton(title: 'Submit',onPressed: (){},),
            ],
          ),
        ),
      ),
    );
  }
}
