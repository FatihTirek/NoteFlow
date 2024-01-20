import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../theme/app_theme_state.dart';
import '../../../widgets/dialogs/contribute_dialog.dart';
import '../shared/app_theme_controller.dart';

class LanguagePickerController {
  final WidgetRef ref;

  late ValueNotifier<Language> language;

  LanguagePickerController(this.ref) {
    language = ValueNotifier(ref.read(appThemeController).language);
  }

  void showContributeDialog() =>
      showModal(context: ref.context, builder: (_) => ContributeDialog());

  void onChanged(Language? value) => language.value = value!;

  void onTapDone() {
    ref.read(appThemeController.notifier).setLanguage(language.value);
    Navigator.pop(ref.context);
  }
}
