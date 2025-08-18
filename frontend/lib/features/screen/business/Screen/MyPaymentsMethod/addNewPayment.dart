import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../../common/widgets/Button/primarybutton.dart';
import '../../../../../common/widgets/appbar/appbar.dart';
import '../../../../../utlis/constants/colors.dart';
import '../../../../../utlis/constants/image_strings.dart';
import '../../model/cardModel.dart';

class AddCardScreen extends StatefulWidget {
  final Function(CardModel) onSave;

  const AddCardScreen({super.key, required this.onSave});

  @override
  State<AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final nameController = TextEditingController();
  final numberController = TextEditingController();
  final expController = TextEditingController();
  final cvvController = TextEditingController();
  final zipController = TextEditingController();

  // Focus Nodes
  final nameFocus = FocusNode();
  final numberFocus = FocusNode();
  final expFocus = FocusNode();
  final cvvFocus = FocusNode();
  final zipFocus = FocusNode();

  String cardBrand = '';

  // Dispose focus nodes
  @override
  void dispose() {
    nameController.dispose();
    numberController.dispose();
    expController.dispose();
    cvvController.dispose();
    zipController.dispose();

    nameFocus.dispose();
    numberFocus.dispose();
    expFocus.dispose();
    cvvFocus.dispose();
    zipFocus.dispose();
    super.dispose();
  }

  String getBrand(String number) {
    if (number.startsWith('4')) return 'Visa';
    if (number.startsWith('5')) return 'Mastercard';
    return 'Unknown';
  }

  void saveCard() {
    if (_formKey.currentState!.validate()) {
      if (cardBrand != 'Visa' && cardBrand != 'Mastercard') {
        Get.snackbar(
          "Error",
          'Only Visa and Mastercard cards are supported.',
          backgroundColor: AppColors.error,
          colorText: AppColors.white,
        );
        return;
      }

      final rawNumber = numberController.text.replaceAll(' ', '');
      widget.onSave(CardModel(
        id: '',
        name: nameController.text,
        last4: rawNumber.substring(rawNumber.length - 4),
        exp: expController.text,
        brand: cardBrand,
      ));
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    super.initState();
    numberController.addListener(() {
      final brand = getBrand(numberController.text.replaceAll(' ', ''));
      setState(() {
        cardBrand = brand;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget? getCardLogo() {
      switch (cardBrand) {
        case 'Visa':
          return Image.asset(AppImages.visa, width: 40);
        case 'Mastercard':
          return Image.asset(AppImages.masterCard, width: 40);
        default:
          return null;
      }
    }

    return Scaffold(
      appBar: CustomAppBar(title: 'Add New Card'),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16).add(MediaQuery.of(context).viewInsets),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                focusNode: nameFocus,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(numberFocus),
                decoration: InputDecoration(
                  labelText: "Name on card",
                  labelStyle: TextStyle(
                    color: AppColors.primary,
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: AppColors
                            .primary), // 🔲 black underline when focused
                  ),
                ),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                focusNode: numberFocus,
                textInputAction: TextInputAction.next,
                controller: numberController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(19),
                  _CardNumberInputFormatter(),
                ],
                onFieldSubmitted: (_) =>
                    FocusScope.of(context).requestFocus(expFocus),
                decoration: InputDecoration(
                  labelStyle: TextStyle(
                    color: AppColors.primary,
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: AppColors
                            .primary), // 🔲 black underline when focused
                  ),
                  labelText: "Card number",
                  suffixIcon: getCardLogo() != null
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: getCardLogo(),
                        )
                      : null,
                ),
                validator: (v) {
                  if (v == null || v.replaceAll(' ', '').length != 16) {
                    return 'Enter valid 16-digit number';
                  }

                  final brand = getBrand(v.replaceAll(' ', ''));
                  if (brand != 'Visa' && brand != 'Mastercard') {
                    return 'Only Visa and Mastercard are supported';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      focusNode: expFocus,
                      textInputAction: TextInputAction.next,
                      controller: expController,
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).requestFocus(cvvFocus),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(6),
                        _ExpiryDateInputFormatter(),
                      ],
                      decoration: InputDecoration(
                        labelStyle: TextStyle(
                          color: AppColors.primary,
                        ),
                        labelText: "Expiry Date",
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: AppColors
                                  .primary), // 🔲 black underline when focused
                        ),
                      ),
                      validator: (v) => v == null ||
                              !RegExp(r"^(0[1-9]|1[0-2])\/20[2-9]\d$")
                                  .hasMatch(v)
                          ? 'Invalid MM/YYYY'
                          : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      focusNode: cvvFocus,
                      textInputAction: TextInputAction.next,
                      controller: cvvController,
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).requestFocus(zipFocus),
                      obscureText: true,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(3),
                      ],
                      decoration: InputDecoration(
                        labelStyle: TextStyle(
                          color: AppColors.primary,
                        ),
                        labelText: "CVV",
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: AppColors
                                  .primary), // 🔲 black underline when focused
                        ),
                      ),
                      validator: (v) =>
                          v == null || v.length != 3 ? 'Invalid CVV' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: zipController,
                focusNode: zipFocus,
                onFieldSubmitted: (_) => saveCard(),
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelStyle: TextStyle(
                    color: AppColors.primary,
                  ),
                  labelText: "Zip code",
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: AppColors
                            .primary), // 🔲 black underline when focused
                  ),
                ),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 30),
              PrimaryButton(
                title: 'Save',
                onPressed: saveCard,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final digitsOnly = newValue.text.replaceAll(RegExp(r'\D'), '');
    final newString = digitsOnly
        .replaceAllMapped(
          RegExp(r".{1,4}"),
          (match) => "${match.group(0)} ",
        )
        .trimRight();

    return TextEditingValue(
      text: newString,
      selection: TextSelection.collapsed(offset: newString.length),
    );
  }
}

class _ExpiryDateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var digitsOnly = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (digitsOnly.length >= 3) {
      digitsOnly = '${digitsOnly.substring(0, 2)}/${digitsOnly.substring(2)}';
    }
    return TextEditingValue(
      text: digitsOnly,
      selection: TextSelection.collapsed(offset: digitsOnly.length),
    );
  }
}
