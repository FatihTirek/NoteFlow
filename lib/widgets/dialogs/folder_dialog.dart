import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/widgets/dialogs/folder_dialog_controller.dart';
import '../../i18n/localizations.dart';
import '../../models/folder.dart';
import '../../theme/app_theme.dart';
import '../shared/app_context_menu.dart';
import '../shared/app_text_button.dart';

class FolderDialog extends ConsumerStatefulWidget {
  final Folder? folder;

  const FolderDialog({this.folder});

  @override
  _FolderDialogState createState() => _FolderDialogState();
}

class _FolderDialogState extends ConsumerState<FolderDialog> {
  late FolderDialogController controller;

  @override
  void initState() {
    super.initState();
    controller = FolderDialogController(ref, widget.folder);
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
        title: Text(
          widget.folder != null
              ? AppLocalizations.instance.w21
              : AppLocalizations.instance.w4,
          style: textTheme.titleMedium!.copyWith(color: primaryColor),
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
                labelText: AppLocalizations.instance.w3,
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
            onPressed: () => controller.onTapDone(widget.folder),
          ),
        ],
      ),
    );
  }
}
