import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../widgets/dialogs/color_picker.dart';

class NoteBackgroundPickerController {
  final WidgetRef ref;

  late ValueNotifier<bool> showButtons;
  late ValueNotifier<Color?> selectedTitleColor;
  late ValueNotifier<Color?> selectedContentColor;
  late ValueNotifier<int?> selectedBackgroundIndex;

  NoteBackgroundPickerController(
    this.ref,
    Color? titleColor,
    Color? contentColor,
    int? backgroundIndex,
  ) {
    selectedTitleColor = ValueNotifier(titleColor);
    selectedContentColor = ValueNotifier(contentColor);
    showButtons = ValueNotifier(backgroundIndex == null);
    selectedBackgroundIndex = ValueNotifier(backgroundIndex);
  }

  void onTapCard(int? index) async {
    selectedBackgroundIndex.value = index;

    if (index == null) {
      if (!showButtons.value) showButtons.value = true;
    } else {
      onTapDone(backgroundOnly: true);
    }
  }

  void openColorPicker(ValueNotifier<Color?> notifier) async {
    final value = await showModal(
      context: ref.context,
      builder: (_) => ColorPicker(color: notifier.value),
    );

    if (value != null) notifier.value = value;
  }

  void onTapReset() {
    selectedTitleColor.value = null;
    selectedContentColor.value = null;
  }

  void onTapDone({bool backgroundOnly = false}) {
    Navigator.pop(
      ref.context,
      {
        'backgroundIndex': selectedBackgroundIndex.value,
        'titleColor': backgroundOnly ? null : selectedTitleColor.value,
        'contentColor': backgroundOnly ? null : selectedContentColor.value,
      },
    );
  }
}
