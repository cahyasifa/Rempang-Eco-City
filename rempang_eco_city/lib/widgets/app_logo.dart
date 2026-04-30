import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final double height;
  final bool white;

  const AppLogo({
    Key? key,
    this.height = 120, // 🔥 dari 60 → 120
    this.white = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/logo.png',
      height: height,
      fit: BoxFit.contain,
    );
  }
}