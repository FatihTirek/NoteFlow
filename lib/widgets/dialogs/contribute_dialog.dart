import 'package:flutter/material.dart';

import '../../i18n/localizations.dart';
import '../shared/app_text_button.dart';

class ContributeDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return AlertDialog(
      contentPadding: EdgeInsets.fromLTRB(24, 20, 24, 0),
      title: Text(
        AppLocalizations.instance.w73,
        style: Theme.of(context).textTheme.titleMedium!.copyWith(color: primaryColor),
      ),
      content: SizedBox(
        width: 296,
        child: Text(
          AppLocalizations.instance.w75,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
      actions: [
        AppTextButton(
          textColor: primaryColor,
          text: AppLocalizations.instance.w74,
          onPressed: () => Navigator.pop(context),
          appTextButtonSize: AppTextButtonSize.Small,
        ),
      ],
    );
  }
}
