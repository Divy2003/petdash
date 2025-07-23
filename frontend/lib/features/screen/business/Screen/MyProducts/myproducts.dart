import 'package:flutter/material.dart';

import '../../../../../common/widgets/Button/primarybutton.dart';
import '../../../../../common/widgets/appbar/appbar.dart';

class MyProducts extends StatefulWidget {
  const MyProducts({super.key});

  @override
  State<MyProducts> createState() => _MyProductsState();
}

class _MyProductsState extends State<MyProducts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'My Products'),

      body: SingleChildScrollView(
        child: Padding(padding:
        EdgeInsets.symmetric(horizontal: 16,vertical: 14),
          child: Column(
            children: [
              PrimaryButton(
                title: 'Add New Product',
                onPressed: () {},
              ),

            ],
          ),
        ),
      )
    );
  }
}
