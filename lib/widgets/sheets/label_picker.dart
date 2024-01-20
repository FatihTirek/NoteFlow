import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/widgets/sheets/label_picker_controller.dart';
import '../../extensions/color_extension.dart';
import '../../i18n/localizations.dart';
import '../../utils.dart';
import '../shared/app_filter_chip.dart';
import '../shared/app_text_button.dart';

class LabelPicker extends ConsumerWidget with Utils {
  final LabelPickerController controller;
  final List<String>? labelIDs;

  LabelPicker({this.labelIDs}) : controller = LabelPickerController(labelIDs);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final primaryColor = Theme.of(context).primaryColor;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.instance.w94,
                style: Theme.of(ref.context).textTheme.titleLarge,
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () => controller.showLabelDialog(ref),
                    icon: Icon(Icons.new_label_outlined, size: 26),
                  ),
                ],
              ),
            ],
          ),
          Flexible(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.zero,
              child: ValueListenableBuilder(
                valueListenable: controller.listenable(),
                builder: (context, value, child) {
                  final labels = controller.getAllLabels(ref);

                  return Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: labels.map((label) {
                      return ValueListenableBuilder(
                        child: Text(label.name),
                        valueListenable: controller.selectedLabelIDs,
                        builder: (_, value, child) {
                          final selected = value.contains(label.id);

                          return AppFilterChip(
                            label: label.name,
                            selected: selected,
                            onSelected: (value) => controller.onSelected(value, label),
                          );
                        },
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: AppTextButton(
              backgroundColor: primaryColor,
              text: AppLocalizations.instance.w2,
              textColor: primaryColor.getOnTextColor(),
              onPressed: () => controller.onTapDone(context),
            ),
          ),
        ],
      ),
    );
  }
}
