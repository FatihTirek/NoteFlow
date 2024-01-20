import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/widgets/dialogs/theme_picker_controller.dart';
import '../../controllers/widgets/shared/app_theme_controller.dart';
import '../../i18n/localizations.dart';
import '../shared/app_text_button.dart';

class ThemePicker extends ConsumerWidget {
  final ThemePickerController controller;

  ThemePicker(WidgetRef ref) : controller = ThemePickerController(ref);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final primaryColor = Theme.of(context).primaryColor;

    return AlertDialog(
      contentPadding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
      title: Text(
        AppLocalizations.instance.w70,
        style: textTheme.titleMedium!.copyWith(color: primaryColor),
      ),
      content: SizedBox(
        width: 296,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: ThemeMode.values.length,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (_, index) => Theme(
            data: Theme.of(context).copyWith(
              splashColor: primaryColor.withOpacity(.12),
              highlightColor: primaryColor.withOpacity(.12),
            ),
            child: ValueListenableBuilder(
              valueListenable: controller.themeMode,
              builder: (_, value, child) => RadioListTile<ThemeMode>(
                title: child,
                groupValue: value,
                onChanged: controller.onChanged,
                value: ThemeMode.values[index],
                contentPadding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: Text(
                ref.read(appThemeController.notifier).getTheme(ThemeMode.values[index]),
                style: textTheme.bodyLarge,
              ),
            ),
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
          onPressed: controller.onTapDone,
          text: AppLocalizations.instance.w2,
          appTextButtonSize: AppTextButtonSize.Small,
        ),
      ],
    );
  }
}
