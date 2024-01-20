import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'controllers/widgets/shared/app_theme_controller.dart';
import 'controllers/main_controller.dart';
import 'constants.dart';
import 'theme/app_theme.dart';

mixin Utils {
  Color getNoteBackgroundColor(WidgetRef ref, int? index, [bool onlySystem = false]) {
    if (index != null) {
      if (onlySystem) {
        return MediaQuery.of(ref.context).platformBrightness == Brightness.light
            ? ColorConstants.noteBackgroundsLight[index]
            : ColorConstants.noteBackgroundsDark[index];
      }

      switch (ref.read(appThemeController).themeMode) {
        case ThemeMode.system:
          return MediaQuery.of(ref.context).platformBrightness == Brightness.light
              ? ColorConstants.noteBackgroundsLight[index]
              : ColorConstants.noteBackgroundsDark[index];
        case ThemeMode.light:
          return ColorConstants.noteBackgroundsLight[index];
        case ThemeMode.dark:
          return ColorConstants.noteBackgroundsDark[index];
      }
    }

    return Theme.of(ref.context).colorScheme.surface;
  }

  Color getOnNoteBackgroundColor(WidgetRef ref, int? index) {
    if (index != null) {
      switch (ref.read(appThemeController).themeMode) {
        case ThemeMode.system:
          return MediaQuery.of(ref.context).platformBrightness == Brightness.light
              ? ColorConstants.onNoteBackgroundsLight[index]
              : ColorConstants.onNoteBackgroundsDark[index];
        case ThemeMode.light:
          return ColorConstants.onNoteBackgroundsLight[index];
        case ThemeMode.dark:
          return ColorConstants.onNoteBackgroundsDark[index];
      }
    }

    return Theme.of(ref.context).colorScheme.onSurface;
  }

  SystemUiOverlayStyle getUIStyle(ThemeMode themeMode) {
    final lightStyle = SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarContrastEnforced: false,
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: AppTheme.lightTheme.colorScheme.surface,
      systemNavigationBarDividerColor: AppTheme.lightTheme.colorScheme.outline,
    );

    final darkStyle = SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarContrastEnforced: false,
      systemNavigationBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppTheme.darkTheme.colorScheme.surface,
      systemNavigationBarDividerColor: AppTheme.darkTheme.colorScheme.outline,
    );

    switch (themeMode) {
      case ThemeMode.system:
        if (WidgetsBinding.instance.platformDispatcher.platformBrightness ==
            Brightness.light)
          return lightStyle;
        else
          return darkStyle;
      case ThemeMode.light:
        return lightStyle;
      case ThemeMode.dark:
        return darkStyle;
    }
  }

  Future<dynamic> showSheet(BuildContext context, Widget widget) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 504),
          child: widget,
        );
      },
      scrollControlDisabledMaxHeightRatio: 0.86,
      constraints: BoxConstraints(maxWidth: 480),
      backgroundColor: Theme.of(context).colorScheme.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
    );
  }

  void showToast(String message, {bool short = true}) =>
      channelMain.invokeMethod('showToast', {'message': message, 'short': short});

  Future goToView(Widget view, {bool replace = false}) {
    final route = PageRouteBuilder(
      pageBuilder: (_, __, ___) => view,
      transitionsBuilder: (context, animation, secondaryAnimation, child) =>
          SharedAxisTransition(
        child: child,
        animation: animation,
        secondaryAnimation: secondaryAnimation,
        transitionType: SharedAxisTransitionType.scaled,
        fillColor: Theme.of(context).scaffoldBackgroundColor,
      ),
    );

    return replace
        ? navigator.currentState!.pushReplacement(route)
        : navigator.currentState!.push(route);
  }
}
