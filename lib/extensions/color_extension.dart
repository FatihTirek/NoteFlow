import 'package:flutter/material.dart';

extension ColorX on Color {
  String getHexValue() => '#${this.value.toRadixString(16).padLeft(6, '0')}';

  Color getOnTextColor() {
    return ThemeData.estimateBrightnessForColor(this) == Brightness.dark
        ? Colors.white
        : Colors.black;
  }
}
