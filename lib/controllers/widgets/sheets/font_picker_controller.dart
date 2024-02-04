import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constants.dart';
import '../../../theme/app_theme_state.dart';
import '../shared/app_theme_controller.dart';

class FontPickerController {
  void onTapFont(WidgetRef ref, Font font) async {
    final withinFreeTier = Font.values.indexOf(font) <= IntegerConstants.freeTierFontLimit;
    final value = withinFreeTier || await ref.read(appThemeController.notifier).isPremiumUser(ref.context);

    if (value) {
      ref.read(appThemeController.notifier).setFont(font);
      Navigator.pop(ref.context);
    }
  }
}
