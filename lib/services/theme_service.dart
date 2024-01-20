import 'package:hive/hive.dart';

import '../constants.dart';
import '../theme/app_theme_state.dart';

class ThemeService {
  Future init() => Hive.openBox(StringConstants.dbTheme);

  AppThemeState? get() {
    final iterable = Hive.box(StringConstants.dbTheme).values;

    if (iterable.isEmpty) return null;
    return AppThemeState.fromMap(iterable.first);
  }

  void write(AppThemeState appThemeState) =>
      Hive.box(StringConstants.dbTheme).put('Theme_ID', appThemeState.toMap());
}
