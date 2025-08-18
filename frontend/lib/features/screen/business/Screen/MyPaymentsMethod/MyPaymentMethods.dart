import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common/widgets/appbar/appbar.dart';
import '../../../../../utlis/constants/colors.dart';
import '../../../../../utlis/constants/image_strings.dart';
import '../../../../../utlis/constants/size.dart';
import '../../model/cardModel.dart';
import 'addNewPayment.dart';

class MyCardScreen extends StatefulWidget {
  const MyCardScreen({super.key});

  @override
  State<MyCardScreen> createState() => _MyCardScreenState();
}

class _MyCardScreenState extends State<MyCardScreen> {
  List<CardModel> cards = [];

  void _addCard(CardModel card) {
    setState(() {
      cards.add(card);
    });
  }

  void _deleteCard(String id) {
    setState(() {
      cards.removeWhere((card) => card.id == id);
    });
  }

  Widget _getCardLogo(String brand) {
    switch (brand.toLowerCase()) {
      case 'visa':
        return Image.asset(AppImages.visa, width: 40);
      case 'mastercard':
        return Image.asset(AppImages.masterCard, width: 40);
      default:
        return const Icon(Icons.credit_card_outlined);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'My Payment Methods'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Card List
          ...cards.map(
                (card) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(AppSizes.borderRadiusSm),
                ),
                child: ListTile(
                  leading: _getCardLogo(card.brand),
                  title: Text("**** **** **** ${card.last4}",
                      style: const TextStyle(color: Colors.white)),
                  subtitle: Text("exp. date ${card.exp}",
                      style: const TextStyle(color: Colors.white70)),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: AppColors.error),
                    onPressed: () => _deleteCard(card.id),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Add New Card
          InkWell(
            onTap: () {
              Get.to(() => AddCardScreen(onSave: _addCard));
            },
            child: Container(
              height: 54,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSizes.borderRadiusMd),
                border: Border.all(color: AppColors.primary),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Icon(Icons.add, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Text("Add New Card",
                        style: TextStyle(color: AppColors.primary)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
