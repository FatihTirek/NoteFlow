import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import '../controllers/main_controller.dart';
import '../controllers/views/settings_view_controller.dart';
import '../controllers/widgets/shared/app_theme_controller.dart';
import '../extensions/color_extension.dart';
import '../i18n/localizations.dart';
import '../theme/app_theme.dart';

class SettingsView extends ConsumerStatefulWidget {
  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends ConsumerState<SettingsView> {
  late SettingsViewController controller;

  @override
  void initState() {
    super.initState();
    controller = SettingsViewController(ref);
  }

  @override
  Widget build(BuildContext context) {
    final surface = Theme.of(context).colorScheme.surface;
    final primaryColor = Theme.of(context).primaryColor;
    final localizations = AppLocalizations.instance;
    final textColor = primaryColor.getOnTextColor();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          localizations.w26,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        leading: IconButton(
          onPressed: controller.pop,
          icon: Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildSectionTile(localizations.w33, true),
            !ref.watch(appThemeController).isPremium
                ? ListTile(
                    tileColor: surface,
                    onTap: controller.goPremiumView,
                    title: buildTitle(localizations.w117),
                  )
                : const SizedBox(),
            ListTile(
              tileColor: surface,
              onTap: controller.showThemePicker,
              title: buildTitle(localizations.w34),
              trailing: buildValueText(
                ref.read(appThemeController.notifier).getCurrentTheme(),
              ),
            ),
            ListTile(
              tileColor: surface,
              onTap: controller.showLanguagePicker,
              title: buildTitle(localizations.w36),
              trailing: buildValueText(
                ref.read(appThemeController.notifier).getCurrentLanguage(),
              ),
            ),
            ListTile(
              tileColor: surface,
              onTap: controller.showFontPicker,
              title: buildTitle(localizations.w35),
              trailing: buildValueText(
                ref.read(appThemeController.notifier).getCurrentFont(),
              ),
            ),
            ListTile(
              tileColor: surface,
              onTap: controller.changeStartupFolder,
              title: buildFlexibleTitle(
                localizations.w118,
                ref.read(appThemeController.notifier).getCurrentStartupFolderName(),
              ),
            ),
            buildSectionTile(localizations.w22),
            ListTile(
              tileColor: surface,
              onTap: controller.showSortPicker,
              title: buildFlexibleTitle(
                localizations.w60,
                ref.read(appThemeController.notifier).getCurrentNoteSortType(),
              ),
            ),
            CheckboxListTile(
              activeColor: primaryColor,
              tileColor: surface,
              checkColor: textColor,
              title: buildTitle(localizations.w90),
              value: ref.watch(appThemeController).titleOnly,
              onChanged: (value) =>
                  ref.read(appThemeController.notifier).setTitleOnly(value!),
            ),
            CheckboxListTile(
              activeColor: primaryColor,
              tileColor: surface,
              checkColor: textColor,
              visualDensity: VisualDensity.standard,
              title: buildTitle(localizations.w91),
              value: ref.watch(appThemeController).showLabels,
              onChanged: (value) =>
                  ref.read(appThemeController.notifier).setShowLabels(value!),
            ),
            buildSectionTile(localizations.p3(2)),
            ListTile(
              minVerticalPadding: 12,
              tileColor: surface,
              title: buildTitle(localizations.w55),
              subtitle: buildSubTitle(localizations.w56),
              onTap: controller.ignoreBatteryOptimizations,
            ),
            ListTile(
              tileColor: surface,
              title: buildTitle(localizations.w57),
              onTap: controller.openNotificationSettings,
            ),
            ListTile(
              tileColor: surface,
              title: buildTitle(localizations.w58),
              onTap: controller.changeNotificationSound,
            ),
            buildSectionTile(localizations.w40),
            ListTile(
              minVerticalPadding: 12,
              onTap: controller.onTapBackup,
              tileColor: surface,
              title: buildTitle(localizations.w41),
              subtitle: buildSubTitle(
                androidDeviceInfo.version.sdkInt >= 30
                    ? '${localizations.w42}\n\n${localizations.w102}'
                    : localizations.w42,
              ),
            ),
            ListTile(
              tileColor: surface,
              minVerticalPadding: 12,
              onTap: controller.onTapRestore,
              title: buildTitle(localizations.w43),
              subtitle: buildSubTitle(localizations.w44),
            ),
            buildSectionTile(localizations.w45),
            ListTile(
              tileColor: surface,
              title: buildTitle(localizations.w46),
              onTap: controller.showFeedbackDialog,
            ),
            ListTile(
              tileColor: surface,
              onTap: controller.openStore,
              title: buildTitle(localizations.w54),
              subtitle: buildSubTitle(localizations.w47),
            ),
            ListTile(
              tileColor: surface,
              title: buildTitle('NoteFlow'),
              subtitle: buildSubTitle(localizations.m2(appVersion)),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSectionTile(String title, [bool ignore = false]) {
    final side = BorderSide(
      width: 1.25,
      color: Theme.of(context).colorScheme.outline,
    );

    return ListTile(
      tileColor: Colors.transparent,
      contentPadding: const EdgeInsets.only(top: 4, left: 16),
      shape: Border(top: ignore ? BorderSide.none : side, bottom: side),
      title: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .titleMedium!
            .copyWith(color: Theme.of(context).primaryColor),
      ),
    );
  }

  Widget buildFlexibleTitle(String title, String valueText) {
    return Row(
      children: [
        buildTitle(title),
        const SizedBox(width: 48),
        Flexible(
          child: Align(
            alignment: Alignment.centerRight,
            child: buildValueText(valueText),
          ),
        ),
      ],
    );
  }

  Widget buildTitle(String text) =>
      Text(text, style: Theme.of(context).textTheme.bodyLarge);

  Widget buildValueText(String text) => Text(
        text,
        maxLines: 1,
        softWrap: false,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.bodyMedium,
      );

  Widget buildSubTitle(String text) => Text(
        text,
        style: Theme.of(context)
            .textTheme
            .bodySmall!
            .copyWith(color: AppTheme.lowEmphasise(context)),
      );
}
