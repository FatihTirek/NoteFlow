import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utils.dart';
import '../shared/app_theme_controller.dart';

class ThemePickerController with Utils {
  final WidgetRef ref;

  late ValueNotifier<ThemeMode> themeMode;

  ThemePickerController(this.ref) {
    themeMode = ValueNotifier(ref.read(appThemeController).themeMode);
  }

  void onChanged(ThemeMode? value) => themeMode.value = value!;

  void onTapDone() {
    if (themeMode.value != ref.read(appThemeController).themeMode) {
      SystemChrome.setSystemUIOverlayStyle(getUIStyle(themeMode.value));
      ref.read(appThemeController.notifier).setThemeMode(themeMode.value);
    }

    Navigator.pop(ref.context);
  }
}
