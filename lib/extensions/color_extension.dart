import 'package:flutter/material.dart';

extension ColorX on Color {
  Color getOnTextColor() {
    return ThemeData.estimateBrightnessForColor(this) == Brightness.dark
        ? Colors.white
        : Colors.black;
  }
}
