import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../../common/widgets/Button/primarybutton.dart';
import 'addNewPayment.dart';


class MyPaymentMethodsScreen extends StatelessWidget {
  final List<Map<String, String>> cards = [
    {
      'type': 'Visa',
      'holder': 'Wade Warren',
      'number': '4111111111111111',
      'isDefault': 'true',
    },
    {
      'type': 'MasterCard',
      'holder': 'Jenny Wilson',
      'number': '5142816465262563',
      'isDefault': 'false',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Payment Methods"),
        leading: BackButton(),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Currently using", style: Theme.of(context).textTheme.titleMedium),
            SizedBox(height: 16),
            ...cards.map((card) => PaymentCardWidget(card: card)).toList(),
            Spacer(),
            PrimaryButton(
              title: "Add New Card",
              onPressed: () {
                Get.to(() => AddNewCardScreen());
                // Add new card logic
              },
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentCardWidget extends StatelessWidget {
  final Map<String, String> card;

  const PaymentCardWidget({required this.card});

  String getMaskedNumber(String number) {
    return '**** **** **** ${number.substring(number.length - 4)}';
  }

  @override
  Widget build(BuildContext context) {
    final isVisa = card['type'] == 'Visa';
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: isVisa ? [Colors.blue.shade700, Colors.blueAccent] : [Colors.deepPurple.shade800, Colors.purpleAccent],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (card['isDefault'] == 'true')
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text("Default", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
            ),
          SizedBox(height: 16),
          Text(
            card['holder'] ?? '',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          SizedBox(height: 8),
          Text(
            getMaskedNumber(card['number']!),
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
