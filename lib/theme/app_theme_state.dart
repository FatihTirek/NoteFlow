import 'package:flutter/material.dart';

enum Language { English, Turkish }

enum NoteSortType { CreatedNF, CreatedOF, EditedNF, EditedOF, Pinned }

enum LabelSortType { AlphabeticallyAZ, AlphabeticallyZA, CreatedNF, CreatedOF }

enum FolderSortType { AlphabeticallyAZ, AlphabeticallyZA, CreatedNF, CreatedOF }

enum Font { JosefinSans, PtSans, Rubik, SourceSans, FiraSans, OpenSans, QuickSand, IBMPlexSans, Kanit, Righteous }

class AppThemeState {
  final Font font;
  final bool titleOnly;
  final bool isPremium;
  final bool isGridView;
  final bool showLabels;
  final String? soundUri;
  final Language language;
  final ThemeMode themeMode;
  final String? startupFolderID;
  final NoteSortType noteSortType;
  final LabelSortType labelSortType;
  final FolderSortType folderSortType;

  const AppThemeState({
    this.soundUri,
    this.startupFolderID,
    this.isGridView = true,
    this.isPremium = false,
    this.titleOnly = false,
    this.showLabels = true,
    this.font = Font.PtSans,
    this.language = Language.English,
    this.themeMode = ThemeMode.system,
    this.noteSortType = NoteSortType.CreatedNF,
    this.labelSortType = LabelSortType.CreatedNF,
    this.folderSortType = FolderSortType.CreatedNF,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};

    map['isGrid'] = this.isGridView;
    map['soundUri'] = this.soundUri;
    map['appFont'] = this.font.index;
    map['titleOnly'] = this.titleOnly;
    map['isPremium'] = this.isPremium;
    map['showLabels'] = this.showLabels;
    map['language'] = this.language.index;
    map['themeMode'] = this.themeMode.index;
    map['criteria'] = this.noteSortType.index;
    map['startupFolderID'] = this.startupFolderID;
    map['labelSortType'] = this.labelSortType.index;
    map['folderSortType'] = this.folderSortType.index;

    return map;
  }

  factory AppThemeState.fromMap(Map map) {
    final isGridView = map['isGrid'];
    final soundUri = map['soundUri'];
    final titleOnly = map['titleOnly'] ?? false;
    final isPremium = map['isPremium'] ?? false;
    final showLabels = map['showLabels'] ?? true;
    final startupFolderID = map['startupFolderID'];
    final font = Font.values.elementAt(map['appFont']);
    final language = Language.values.elementAt(map['language']);
    final themeMode = ThemeMode.values.elementAt(map['themeMode']);
    final noteSortType = NoteSortType.values.elementAt(map['criteria']);
    final labelSortType = LabelSortType.values.elementAt(map['labelSortType'] ?? 2);
    final folderSortType = FolderSortType.values.elementAt(map['folderSortType'] ?? 2);

    return AppThemeState(
      font: font,
      language: language,
      soundUri: soundUri,
      isPremium: isPremium,
      themeMode: themeMode,
      titleOnly: titleOnly,
      isGridView: isGridView,
      showLabels: showLabels,
      noteSortType: noteSortType,
      labelSortType: labelSortType,
      folderSortType: folderSortType,
      startupFolderID: startupFolderID,
    );
  }

  AppThemeState copyWith({
    Font? font,
    Color? color,
    bool? isLight,
    bool? isPremium,
    bool? titleOnly,
    bool? showLabels,
    bool? isGridView,
    String? soundUri,
    bool? isPurchased,
    Language? language,
    ThemeMode? themeMode,
    String? startupFolderID,
    NoteSortType? noteSortType,
    LabelSortType? labelSortType,
    FolderSortType? folderSortType,
    bool acceptNullStartupFolderID = false,
  }) {
    return AppThemeState(
      font: font ?? this.font,
      language: language ?? this.language,
      soundUri: soundUri ?? this.soundUri,
      isPremium: isPremium ?? this.isPremium,
      titleOnly: titleOnly ?? this.titleOnly,
      themeMode: themeMode ?? this.themeMode,
      isGridView: isGridView ?? this.isGridView,
      showLabels: showLabels ?? this.showLabels,
      noteSortType: noteSortType ?? this.noteSortType,
      labelSortType: labelSortType ?? this.labelSortType,
      folderSortType: folderSortType ?? this.folderSortType,
      startupFolderID: acceptNullStartupFolderID ? null : startupFolderID ?? this.startupFolderID,
    );
  }
}
