import 'package:flutter/material.dart';

import '../../i18n/localizations.dart';
import '../shared/app_text_button.dart';

class DeleteDialog extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onDelete;

  const DeleteDialog({
    required this.title,
    required this.content,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final primaryColor = Theme.of(context).primaryColor;

    return AlertDialog(
      title: Text(title, style: textTheme.titleMedium!.copyWith(color: primaryColor)),
      content: Text(content, style: textTheme.bodyLarge),
      actions: [
        AppTextButton(
          text: AppLocalizations.instance.w1,
          onPressed: () => Navigator.pop(context),
          appTextButtonSize: AppTextButtonSize.Small,
        ),
        AppTextButton(
          textColor: primaryColor,
          text: AppLocalizations.instance.w24,
          appTextButtonSize: AppTextButtonSize.Small,
          onPressed: () {
            onDelete();
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
