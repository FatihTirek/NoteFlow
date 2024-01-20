import 'package:flutter/material.dart';

extension TextStyleX on TextStyle {
  double getSingleLineTextHeight(BuildContext context) {
    final painter = TextPainter(
      text: TextSpan(text: 'Text', style: this),
      maxLines: 1,
      textDirection: TextDirection.ltr,
      textScaler: MediaQuery.of(context).textScaler,
    )..layout();

    return painter.size.height;
  }
}
