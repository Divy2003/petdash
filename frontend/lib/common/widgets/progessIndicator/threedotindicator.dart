
import 'package:flutter/material.dart';

import '../../../utlis/constants/colors.dart';

class ThreeDotIndicator extends StatefulWidget {
  const ThreeDotIndicator({super.key});

  @override
  _ThreeDotIndicatorState createState() => _ThreeDotIndicatorState();
}

class _ThreeDotIndicatorState extends State<ThreeDotIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation1;
  late Animation<double> _animation2;
  late Animation<double> _animation3;

  @override
  void initState() {
    super.initState();

    _controller =
    AnimationController(vsync: this, duration: const Duration(milliseconds: 1000))
      ..repeat();

    _animation1 = Tween<double>(begin: 0, end: 8).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.33, curve: Curves.easeInOut)),
    );
    _animation2 = Tween<double>(begin: 0, end: 8).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.33, 0.66, curve: Curves.easeInOut)),
    );
    _animation3 = Tween<double>(begin: 0, end: 8).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.66, 1.0, curve: Curves.easeInOut)),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildDot(Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Transform.translate(
          offset: Offset(0, -animation.value),
          child: Dot(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildDot(_animation1),
        _buildDot(_animation2),
        _buildDot(_animation3),
      ],
    );
  }
}

class Dot extends StatelessWidget {
  const Dot({super.key});

  @override
  Widget build(BuildContext context) {
    return  CircleAvatar(
      radius: 6,
      backgroundColor: AppColors.primary,
    );
  }
}
