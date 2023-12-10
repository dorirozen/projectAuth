import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyColors {
  const MyColors._();
  static const Color primaryColor = Color(0xFF2196F3); // Example primary color
  static const Color accentColor = Color(0xFFFFC107); // Example accent color
  static const Color textColor = Color(0xFFDA1751); // Example text color
  static const Color backgroundColor =
      Color(0xFFFFFFFF); // Example background color
  static const Color errorColor = Color(0xFFE57373); // Example error color
  static const Color schemeColor = Colors.deepPurple; //
  static const LinearGradient someLinear = LinearGradient(
    colors: [Color(0xFFFFC107), Color(0xFFFFA000)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
