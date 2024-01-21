import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/widgets/dialogs/label_dialog_controller.dart';
import '../../i18n/localizations.dart';
import '../../models/label.dart';
import '../../theme/app_theme.dart';
import '../shared/app_context_menu.dart';
import '../shared/app_text_button.dart';

class LabelDialog extends ConsumerStatefulWidget {
  final Label? label;

  const LabelDialog({this.label});

  @override
  _LabelDialogState createState() => _LabelDialogState();
}

class _LabelDialogState extends ConsumerState<LabelDialog> {
  late LabelDialogController controller;

  @override
  void initState() {
    super.initState();
    controller = LabelDialogController(ref, widget.label);
    KeyboardVisibilityController().onChange.listen((visible) {
      if (!visible && mounted) FocusScope.of(context).unfocus();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final primaryColor = Theme.of(context).primaryColor;

    return ScrollConfiguration(
      behavior: const ScrollBehavior().copyWith(overscroll: false),
      child: AlertDialog(
        scrollable: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.label != null
                  ? AppLocalizations.instance.w80
                  : AppLocalizations.instance.w81,
              style: textTheme.titleMedium!.copyWith(color: primaryColor),
            ),
            if (widget.label != null)
              GestureDetector(
                onTap: () => controller.onTapDelete(widget.label!),
                child: Icon(Icons.delete_outline_rounded),
              ),
          ],
        ),
        content: Focus(
          onFocusChange: controller.onFocusChanged,
          child: ValueListenableBuilder(
            valueListenable: controller.colorize,
            builder: (_, colorize, __) => TextField(
              maxLength: 36,
              autofocus: true,
              cursorColor: primaryColor,
              style: textTheme.bodyLarge,
              controller: controller.textEditingController,
              decoration: InputDecoration(
                filled: true,
                counterStyle: textTheme.bodySmall,
                labelText: AppLocalizations.instance.w82,
                fillColor: Theme.of(context).brightness == Brightness.light
                    ? Theme.of(context).colorScheme.onSurface
                    : Theme.of(context).colorScheme.surface,
                labelStyle: textTheme.bodyLarge!.copyWith(
                  color: !colorize ? AppTheme.lowEmphasise(context) : primaryColor,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: AppTheme.highEmphasise(context).withOpacity(.24),
                    width: 1.25,
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(width: 1.25, color: primaryColor),
                ),
              ),
              contextMenuBuilder: (_, editableTextState) => AppContextMenu(editableTextState),
            ),
          ),
        ),
        actions: [
          AppTextButton(
            text: AppLocalizations.instance.w1,
            onPressed: () => Navigator.pop(context),
            appTextButtonSize: AppTextButtonSize.Small,
          ),
          AppTextButton(
            textColor: primaryColor,
            text: AppLocalizations.instance.w2,
            appTextButtonSize: AppTextButtonSize.Small,
            onPressed: () => controller.onTapDone(widget.label),
          ),
        ],
      ),
    );
  }
}
