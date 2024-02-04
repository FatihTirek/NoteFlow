import 'package:animations/animations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import '../../../constants.dart';
import '../../../models/label.dart';
import '../../../services/label_service.dart';
import '../../../widgets/dialogs/label_dialog.dart';
import '../shared/app_theme_controller.dart';

class LabelPickerController {
  late ValueNotifier<List<String>> selectedLabelIDs;

  late int _labelsAmount;

  LabelPickerController(List<String>? labelIDs) {
    selectedLabelIDs = ValueNotifier(labelIDs ?? []);
  }

  ValueListenable listenable() => GetIt.I<LabelService>().listenable;

  List<Label> getAllLabels(WidgetRef ref) {
    final labels = GetIt.I<LabelService>().getAllAndSort(ref.read(appThemeController).labelSortType);

    _labelsAmount = labels.length;
    return labels;
  }

  void showLabelDialog(WidgetRef ref) async {
    final withinFreeTier = _labelsAmount < IntegerConstants.freeTierLabelLimit;
    final value = withinFreeTier || await ref.read(appThemeController.notifier).isPremiumUser(ref.context);

    if (value) showModal(context: ref.context, builder: (_) => LabelDialog());
  }

  void onSelected(bool selected, Label label) {
    final value = [...selectedLabelIDs.value];

    if (selected)
      value.add(label.id);
    else
      value.remove(label.id);

    selectedLabelIDs.value = value;
  }

  void onTapDone(BuildContext context) => Navigator.pop(context, selectedLabelIDs.value);
}
