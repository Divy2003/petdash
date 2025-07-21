import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:petcare/features/screen/personal/profile/profileScreen.dart';
import 'package:petcare/features/screen/shop/home/homescreen.dart';

import 'package:petcare/utlis/constants/colors.dart';


class CurvedNavScreen extends StatefulWidget {
  const CurvedNavScreen({super.key});

  @override
  State<CurvedNavScreen> createState() => _CurvedNavScreenState();
}

class _CurvedNavScreenState extends State<CurvedNavScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    Center(child: Text('Cart')),
    Center(child: Text('Cart')),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedIndex,
        backgroundColor: Colors.white,
        color: AppColors.primary,
        buttonBackgroundColor: AppColors.primary,
        height: 60,
        animationDuration: Duration(milliseconds: 300),
        items: [
          CurvedNavigationBarItem(
              child: Icon(Icons.home, color: Colors.white),
              label: 'Home',
              labelStyle: TextStyle(
                color: AppColors.white,
              )),
          CurvedNavigationBarItem(
            child: Icon(Icons.search, color: Colors.white),
            label: 'Search',
            labelStyle: TextStyle(
              color: AppColors.white,
            ),
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.schedule, color: Colors.white),
            label: 'Cart',
            labelStyle: TextStyle(
              color: AppColors.white,
            ),
          ),
          CurvedNavigationBarItem(
            child: Icon(Icons.person, color: Colors.white),
            label: 'Profile',
            labelStyle: TextStyle(
              color: AppColors.white,
            ),
          ),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
