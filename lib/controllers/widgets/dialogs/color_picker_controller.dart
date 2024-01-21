import 'package:flutter/material.dart';

import '../../../widgets/dialogs/color_picker.dart';

class ColorPickerController {
  static const List<int> _indexPrimary = [100, 200, 300, 400, 500, 600, 700, 800, 900];
  static const List<int> _indexAccent = [100, 200, 400, 700];

  late ValueNotifier<int> red;
  late ValueNotifier<int> blue;
  late ValueNotifier<int> green;
  late ValueNotifier<Color> accentColor;
  late ValueNotifier<Color> primaryColor;
  late ValueNotifier<ColorPickerMode> pickerMode;
  late ValueNotifier<MaterialColor> primarySwatchColor;
  late ValueNotifier<MaterialAccentColor> accentSwatchColor;

  ColorPickerController(Color color) {
    final isPrimary = _isPrimaryColor(color);
    final isAccent = isPrimary ? false : _isAccentColor(color);

    red = ValueNotifier(color.red);
    blue = ValueNotifier(color.blue);
    green = ValueNotifier(color.green);
    primaryColor = ValueNotifier(isPrimary ? color : Colors.red.shade700);
    accentColor = ValueNotifier(isAccent ? color : Colors.redAccent.shade700);
    primarySwatchColor = ValueNotifier(isPrimary ? _getPrimarySwatch(color) : Colors.red);
    accentSwatchColor = ValueNotifier(isAccent ? _getAccentSwatch(color) : Colors.redAccent);
    pickerMode = ValueNotifier(
      isPrimary
          ? ColorPickerMode.Primary
          : isAccent
              ? ColorPickerMode.Accent
              : ColorPickerMode.Custom,
    );
  }

  void onValueChanged(ColorPickerMode? value) => pickerMode.value = value!;

  void onTapColor(Color color, bool material) {
    switch (pickerMode.value) {
      case ColorPickerMode.Primary:
        if (material) primarySwatchColor.value = color as MaterialColor;
        primaryColor.value = material ? (color as MaterialColor).shade700 : color;
        break;
      case ColorPickerMode.Accent:
        if (material) accentSwatchColor.value = color as MaterialAccentColor;
        accentColor.value = material ? (color as MaterialAccentColor).shade700 : color;
        break;
      case ColorPickerMode.Custom:
        break;
    }
  }

  void onTapDone(BuildContext context) {
    Color color;

    switch (pickerMode.value) {
      case ColorPickerMode.Primary:
        color = primaryColor.value;
        break;
      case ColorPickerMode.Accent:
        color = accentColor.value;
        break;
      case ColorPickerMode.Custom:
        color = Color.fromRGBO(red.value, green.value, blue.value, 1);
        break;
    }

    Navigator.pop(context, color);
  }

  List<Color> getCurrentPrimaryShades() {
    return [
      primarySwatchColor.value.shade100,
      primarySwatchColor.value.shade200,
      primarySwatchColor.value.shade300,
      primarySwatchColor.value.shade400,
      primarySwatchColor.value.shade500,
      primarySwatchColor.value.shade600,
      primarySwatchColor.value.shade700,
      primarySwatchColor.value.shade800,
      primarySwatchColor.value.shade900,
    ];
  }

  List<Color> getCurrentAccentShades() {
    return [
      accentSwatchColor.value.shade100,
      accentSwatchColor.value.shade200,
      accentSwatchColor.value.shade400,
      accentSwatchColor.value.shade700,
    ];
  }

  bool _isPrimaryColor(Color color) {
    for (final primary in Colors.primaries) {
      for (final i in _indexPrimary) {
        if (primary[i]!.value == color.value) return true;
      }
    }

    return false;
  }

  bool _isAccentColor(Color color) {
    for (final accent in Colors.accents) {
      for (final int i in _indexAccent) {
        if (accent[i]!.value == color.value) return true;
      }
    }

    return false;
  }

  MaterialColor _getPrimarySwatch(Color color) {
    for (final swatch in Colors.primaries) {
      for (final int i in _indexPrimary) {
        if (swatch[i]!.value == color.value) return swatch;
      }
    }

    throw UnimplementedError();
  }

  MaterialAccentColor _getAccentSwatch(Color color) {
    for (final swatch in Colors.accents) {
      for (final int i in _indexAccent) {
        if (swatch[i]!.value == color.value) return swatch;
      }
    }

    throw UnimplementedError();
  }
}
