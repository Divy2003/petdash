import 'package:flutter/material.dart';
import 'package:petcare/features/screen/business/Screen/order/widgets/ordercard.dart';

import '../../../../../utlis/constants/image_strings.dart';
import '../../model/ordermodel.dart';


class OrderScreen extends StatelessWidget {
  final List<OrderModel> orders = [
    OrderModel(
      imageUrl: AppImages.products1,
      name: 'Royal Canin Medium Breed Adult Dry Dog Food.',
      price: 138.74,
      quantity: 2,
      status: 'paid',
    ),
    OrderModel(
      imageUrl: AppImages.products1,
      name: 'Royal Canin Digestive Care Dog Food.',
      price: 120.50,
      quantity: 1,
      status: 'cancelled',
    ),
    // Add more orders as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('New Orders')),
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          return OrderCard(order: orders[index]);
        },
      ),
    );
  }
}