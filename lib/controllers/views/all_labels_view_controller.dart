import 'package:animations/animations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import '../../theme/app_theme_state.dart';
import '../../widgets/dialogs/label_dialog.dart';
import '../../widgets/sheets/sort_type_picker.dart';
import '../../models/label.dart';
import '../../services/label_service.dart';
import '../../utils.dart';
import '../widgets/shared/app_theme_controller.dart';

class AllLabelsViewController with Utils {
  final WidgetRef ref;
  final AnimationController animationController;

  late ValueNotifier<bool> searchMode;
  late ValueNotifier<bool> showClearButton;
  late ValueNotifier<List<Label>> searchedLabels;

  late List<Label> cachedAllLabels;
  late TextEditingController textEditingController;

  AllLabelsViewController(this.ref, this.animationController) {
    searchMode = ValueNotifier(false);
    searchedLabels = ValueNotifier([]);
    showClearButton = ValueNotifier(false);
    textEditingController = TextEditingController();
  }

  ValueListenable get listenable => GetIt.I<LabelService>().listenable;

  List<Label> getAllLabels(LabelSortType labelSortType) {
    final labels = GetIt.I<LabelService>().getAllAndSort(labelSortType);

    cachedAllLabels = labels;
    return labels;
  }

  void closeSearchBarIfOpened() {
    if (searchMode.value) onSearchBarClose();
  }

  void dispose() {
    textEditingController.dispose();
    animationController.dispose();
  }

  void showLabelDialog([Label? label]) async {
    if (label == null) {
      final withinFreeTier = cachedAllLabels.length < 5;
      final value = withinFreeTier ||
          await ref.read(appThemeController.notifier).isPremiumUser(ref.context);

      if (value) showModal(context: ref.context, builder: (_) => LabelDialog());
    } else {
      showModal(
        context: ref.context,
        builder: (_) => LabelDialog(label: label),
      );
    }
  }

  void showSortPicker() async {
    final value = await showSheet(ref.context, SortTypePicker(SortTypePickerMode.Label));
    if (value != null) ref.read(appThemeController.notifier).setLabelSortType(value);
  }

  void onSearchBarOpen() async {
    await animationController.forward();
    searchMode.value = true;
    searchedLabels.value = cachedAllLabels;
  }

  void onSearchBarClose() async {
    await animationController.reverse();
    searchMode.value = false;
    onTapClear();
  }

  void onChanged(String text) {
    if (text.isNotEmpty) {
      final labels = GetIt.I<LabelService>().search(text, cachedAllLabels);

      showClearButton.value = true;
      searchedLabels.value = labels;
    } else {
      showClearButton.value = false;
      searchedLabels.value = cachedAllLabels;
    }
  }

  void onTapClear() {
    textEditingController.clear();
    showClearButton.value = false;
    searchedLabels.value = cachedAllLabels;
  }
}
