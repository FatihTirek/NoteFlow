import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../controllers/main_controller.dart';
import '../../i18n/localizations.dart';
import '../shared/app_text_button.dart';

class FeedBackDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final textTheme = Theme.of(context).textTheme;

    return AlertDialog(
      buttonPadding: EdgeInsets.zero,
      contentPadding: const EdgeInsets.only(top: 12),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      title: Text(
        AppLocalizations.instance.w27,
        style: textTheme.titleMedium!.copyWith(color: primaryColor),
      ),
      content: SizedBox(
        width: 296,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              onTap: reportBug,
              title: Text(AppLocalizations.instance.w28, style: textTheme.bodyLarge),
              contentPadding: const EdgeInsets.symmetric(horizontal: 24),
            ),
            ListTile(
              onTap: requestFeature,
              title: Text(AppLocalizations.instance.w29, style: textTheme.bodyLarge),
              contentPadding: const EdgeInsets.symmetric(horizontal: 24),
            ),
            ListTile(
              onTap: translate,
              title: Text(AppLocalizations.instance.w30, style: textTheme.bodyLarge),
              contentPadding: const EdgeInsets.symmetric(horizontal: 24),
            ),
            ListTile(
              onTap: contribute,
              title: Text(AppLocalizations.instance.w31, style: textTheme.bodyLarge),
              contentPadding: const EdgeInsets.symmetric(horizontal: 24),
            ),
          ],
        ),
      ),
      actions: [
        AppTextButton(
          textColor: primaryColor,
          text: AppLocalizations.instance.w1,
          onPressed: () => Navigator.pop(context),
          appTextButtonSize: AppTextButtonSize.Small,
        )
      ],
    );
  }

  void reportBug() {
    final info = 'App Version: $appVersion\nAndroid Version: '
        '${androidDeviceInfo.version.release}\nDevice: ${androidDeviceInfo.brand} '
        '${androidDeviceInfo.model} (${androidDeviceInfo.product})';

    final emailUri = Uri(
      scheme: 'mailto',
      path: 'noteflowhelp@gmail.com',
      query: 'subject=Bug/Issue Report\n\n$info',
    );

    launchUrl(Uri.parse(emailUri.toString()));
  }

  void requestFeature() {
    final emailUri = Uri(
      scheme: 'mailto',
      path: 'noteflowhelp@gmail.com',
      query: 'subject=Feature Suggestion',
    );

    launchUrl(Uri.parse(emailUri.toString()));
  }

  void translate() {
    final emailUri = Uri(
      scheme: 'mailto',
      path: 'noteflowhelp@gmail.com',
      query: 'subject=Translation Error',
    );

    launchUrl(Uri.parse(emailUri.toString()));
  }

  void contribute() {
    final emailUri = Uri(
      scheme: 'mailto',
      path: 'noteflowhelp@gmail.com',
      query: 'subject=Translation Contribution',
    );

    launchUrl(Uri.parse(emailUri.toString()));
  }
}
