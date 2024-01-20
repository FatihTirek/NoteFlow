import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import '../../../services/note_widget_service.dart';
import '../../../views/premium_view.dart';
import '../../../i18n/localizations.dart';
import '../../../theme/app_theme_state.dart';
import '../../../services/theme_service.dart';
import '../../../services/folder_service.dart';

class AppThemeController extends AutoDisposeNotifier<AppThemeState> {
  @override
  AppThemeState build() {
    final appThemeState = GetIt.I<ThemeService>().get();

    if (appThemeState == null) {
      final locales = AppLocalizationsDelegate.locales;
      final systemLocale = Platform.localeName.substring(0, 2);
      final languageCode =
          locales.firstWhere((e) => e == systemLocale, orElse: () => locales.first);
      final language = Language.values[locales.indexOf(languageCode)];

      return AppThemeState(language: language);
    }

    return appThemeState;
  }

  Future<bool> isPremiumUser(BuildContext context) async {
    if (!state.isPremium) {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => PremiumView()),
      );

      return state.isPremium;
    }

    return true;
  }

  String getCurrentFont() => getFont(state.font);

  String getCurrentTheme() => getTheme(state.themeMode);

  String getCurrentLanguage() => getLanguage(state.language);

  String getCurrentNoteSortType() => getNoteSortType(state.noteSortType);

  String getCurrentStartupFolderName() {
    if (state.startupFolderID != null)
      return GetIt.I<FolderService>().get(state.startupFolderID!).name;
    else
      return AppLocalizations.instance.w5;
  }

  String getFont(Font font) => font.toString().substring(5);

  String getTheme(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.system:
        return AppLocalizations.instance.w67;
      case ThemeMode.light:
        return AppLocalizations.instance.w69;
      case ThemeMode.dark:
        return AppLocalizations.instance.w68;
    }
  }

  String getLanguage(Language language) {
    switch (language) {
      case Language.English:
        return 'English';
      case Language.Turkish:
        return 'Türkçe';
    }
  }

  String getNoteSortType(NoteSortType noteSortType) {
    switch (noteSortType) {
      case NoteSortType.CreatedNF:
        return AppLocalizations.instance.w98;
      case NoteSortType.CreatedOF:
        return AppLocalizations.instance.w99;
      case NoteSortType.EditedNF:
        return AppLocalizations.instance.w38;
      case NoteSortType.EditedOF:
        return AppLocalizations.instance.w39;
      case NoteSortType.Pinned:
        return AppLocalizations.instance.w89;
    }
  }

  void setThemeMode(ThemeMode themeMode) {
    if (themeMode != state.themeMode) _update(state.copyWith(themeMode: themeMode));
  }

  void setStartupFolderID(String? startupFolderID) {
    if (startupFolderID != state.startupFolderID) {
      _update(
        state.copyWith(
          startupFolderID: startupFolderID,
          acceptNullStartupFolderID: startupFolderID == null,
        ),
      );
    }
  }

  void setTitleOnly(bool titleOnly) {
    if (titleOnly != state.titleOnly) _update(state.copyWith(titleOnly: titleOnly));
  }

  void setShowLabels(bool showLabels) {
    if (showLabels != state.showLabels) _update(state.copyWith(showLabels: showLabels));
  }

  void setLabelSortType(LabelSortType labelSortType) {
    if (labelSortType != state.labelSortType)
      _update(state.copyWith(labelSortType: labelSortType));
  }

  void setFolderSortType(FolderSortType folderSortType) {
    if (folderSortType != state.folderSortType)
      _update(state.copyWith(folderSortType: folderSortType));
  }

  void setNoteSortType(NoteSortType noteSortType) {
    if (noteSortType != state.noteSortType)
      _update(state.copyWith(noteSortType: noteSortType));
  }

  void setLanguage(Language language) {
    if (language != state.language) _update(state.copyWith(language: language));
  }

  void setIsGridView() => _update(state.copyWith(isGridView: !state.isGridView));

  void setSoundUri(String soundUri) {
    if (soundUri != state.soundUri) _update(state.copyWith(soundUri: soundUri));
  }

  void setFont(Font font) {
    if (font != state.font) _update(state.copyWith(font: font));
  }

  void upgradePremium() {
    _update(state.copyWith(isPremium: true));
    GetIt.I<NoteWidgetService>().unlockWidget();
  }

  void _update(AppThemeState appThemeState) {
    GetIt.I<ThemeService>().write(appThemeState);
    state = appThemeState;
  }
}

final appThemeController =
    NotifierProvider.autoDispose<AppThemeController, AppThemeState>(
        () => AppThemeController());
