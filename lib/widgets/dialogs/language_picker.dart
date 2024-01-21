import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/widgets/dialogs/language_picker_controller.dart';
import '../../controllers/widgets/shared/app_theme_controller.dart';
import '../../i18n/localizations.dart';
import '../../theme/app_theme_state.dart';
import '../shared/app_text_button.dart';

class LanguagePicker extends ConsumerWidget {
  final LanguagePickerController controller;

  LanguagePicker(WidgetRef ref) : controller = LanguagePickerController(ref);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final primaryColor = Theme.of(context).primaryColor;

    return AlertDialog(
      contentPadding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            AppLocalizations.instance.w32,
            style: textTheme.titleMedium!.copyWith(color: primaryColor),
          ),
          GestureDetector(
            onTap: controller.showContributeDialog,
            child: Icon(Icons.info_outline),
          ),
        ],
      ),
      content: SizedBox(
        width: 296,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: Language.values.length,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (_, index) => Theme(
            data: Theme.of(context).copyWith(
              splashColor: primaryColor.withOpacity(.12),
              highlightColor: primaryColor.withOpacity(.12),
            ),
            child: ValueListenableBuilder(
              valueListenable: controller.language,
              builder: (_, value, child) => RadioListTile<Language>(
                title: child,
                groupValue: value,
                onChanged: controller.onChanged,
                contentPadding: EdgeInsets.zero,
                value: Language.values[index],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              ),
              child: Text(
                ref.read(appThemeController.notifier).getLanguage(Language.values[index]),
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
