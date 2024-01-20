import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_theme_state.dart';

class AppTheme {
  static const _iconColorDark = Color(0xFFEEEEEE);
  static const _iconColorLight = Color(0xFF242424);
  static const _primaryColorDark = Color(0xFFFFC400);
  static const _primaryColorLight = Color(0xFF0026CA);
  static const _backgroundDark = Color(0xFF161819);
  static const _backgroundLight = Color(0xFFFAFAFA);
  static const _surfaceDark = Color(0xFF191D1E);
  static const _surfaceLight = Color(0xFFFFFFFF);
  static const _onSurfaceDark = Color(0xff272A2A);
  static const _onSurfaceLight = Color(0xffE9E9E9);
  static const _outlineDark = Color(0xFF272A2A);
  static const _outlineLight = Color(0xFFDBDBDB);

  static const _highEmphasiseDark = Color(0xFFEEEEEE);
  static const _highEmphasiseLight = Color(0xFF242424);
  static const _mediumEmphasiseDark = Color(0xFFC8C8C8);
  static const _mediumEmphasiseLight = Color(0xFF545454);
  static const _lowEmphasiseDark = Color(0xFFAAAAAA);
  static const _lowEmphasiseLight = Color(0xFF6C6C6C);
  static const _inactiveDark = Color(0x7AF0F0F0);
  static const _inactiveLight = Color(0x7A242424);

  static const _onMediumEmphasiseDark = Color(0xFFD2D2D2);
  static const _onMediumEmphasiseLight = Color(0xFF303030);
  static const _onLowEmphasiseDark = Color(0xFFBEBEBE);
  static const _onLowEmphasiseLight = Color(0xFF3C3C3C);
  static const _onInactiveDark = Color(0x8FF0F0F0);
  static const _onInactiveLight = Color(0x8F242424);

  static Color onMediumEmphasise(BuildContext context, [bool system = false]) =>
      (system ? MediaQuery.of(context).platformBrightness : Theme.of(context).brightness) == Brightness.light
          ? _onMediumEmphasiseLight
          : _onMediumEmphasiseDark;

  static Color onLowEmphasise(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light
          ? _onLowEmphasiseLight
          : _onLowEmphasiseDark;

  static Color onInactive(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light
          ? _onInactiveLight
          : _onInactiveDark;

  static Color highEmphasise(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light
          ? _highEmphasiseLight
          : _highEmphasiseDark;

  static Color mediumEmphasise(BuildContext context, [bool system = false]) =>
      (system ? MediaQuery.of(context).platformBrightness : Theme.of(context).brightness) == Brightness.light
          ? _mediumEmphasiseLight
          : _mediumEmphasiseDark;

  static Color lowEmphasise(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light
          ? _lowEmphasiseLight
          : _lowEmphasiseDark;

  static Color inactive(BuildContext context) =>
      Theme.of(context).brightness == Brightness.light
          ? _inactiveLight
          : _inactiveDark;

    static final darkTheme = ThemeData(
    useMaterial3: false,
    brightness: Brightness.dark,
    primaryColor: _primaryColorDark,
    splashColor: _iconColorDark.withOpacity(.12),
    highlightColor: _iconColorDark.withOpacity(.12),
    unselectedWidgetColor: _inactiveDark,
    scaffoldBackgroundColor: _backgroundDark,
    colorScheme: ColorScheme.dark(
      background: _backgroundDark,
      surface: _surfaceDark,
      onSurface: _onSurfaceDark,
      outline: _outlineDark,
      primary: _primaryColorDark,
      secondary: _primaryColorDark,
    ),
    appBarTheme: AppBarTheme(
      elevation: 0,
      color: _surfaceDark,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      shape: Border(bottom: BorderSide(color: _outlineDark, width: 1.25)),
    ),
    dialogTheme: DialogTheme(
      backgroundColor: _backgroundDark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    ),
    popupMenuTheme: PopupMenuThemeData(
      iconColor: _iconColorDark,
      color: _onSurfaceDark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    ),
    radioTheme: RadioThemeData(
      fillColor: MaterialStateProperty.all(_primaryColorDark),
      overlayColor: MaterialStateProperty.all(Colors.transparent),
    ),
    textSelectionTheme: TextSelectionThemeData(
      selectionColor: _primaryColorDark.withOpacity(.24),
      selectionHandleColor: _primaryColorDark,
    ),
    iconTheme: IconThemeData(color: _iconColorDark),
    tooltipTheme: TooltipThemeData(
      height: 0,
      waitDuration: Duration.zero,
      triggerMode: TooltipTriggerMode.manual,
      decoration: BoxDecoration(color: Colors.transparent),
    ),
  );

  static final lightTheme = ThemeData(
    useMaterial3: false,
    brightness: Brightness.light,
    primaryColor: _primaryColorLight,
    splashColor: _iconColorLight.withOpacity(.12),
    highlightColor: _iconColorLight.withOpacity(.12),
    unselectedWidgetColor: _inactiveLight,
    scaffoldBackgroundColor: _backgroundLight,
    colorScheme: ColorScheme.light(
      background: _backgroundLight,
      surface: _surfaceLight,
      onSurface: _onSurfaceLight,
      outline: _outlineLight,
      primary: _primaryColorLight,
      secondary: _primaryColorLight,
    ),
    appBarTheme: AppBarTheme(
      elevation: 0,
      color: _surfaceLight,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      shape: Border(bottom: BorderSide(color: _outlineLight, width: 1.25)),
    ),
    dialogTheme: DialogTheme(
      backgroundColor: _backgroundLight,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    ),
    popupMenuTheme: PopupMenuThemeData(
      iconColor: _iconColorLight,
      color: _surfaceLight,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    ),
    radioTheme: RadioThemeData(
      fillColor: MaterialStateProperty.all(_primaryColorLight),
      overlayColor: MaterialStateProperty.all(Colors.transparent),
    ),
    textSelectionTheme: TextSelectionThemeData(
      selectionColor: _primaryColorLight.withOpacity(.24),
      selectionHandleColor: _primaryColorLight,
    ),
    iconTheme: IconThemeData(color: _iconColorLight),
    tooltipTheme: TooltipThemeData(
      height: 0,
      waitDuration: Duration.zero,
      triggerMode: TooltipTriggerMode.manual,
      decoration: BoxDecoration(color: Colors.transparent),
    ),
  );

  static TextStyle _headlineLarge(Font font) {
    switch (font) {
      case Font.JosefinSans:
        return GoogleFonts.josefinSans(
          fontWeight: FontWeight.w600,
          fontSize: 27.5,
          height: 1.25,
        );
      case Font.PtSans:
        return GoogleFonts.ptSans(
          fontWeight: FontWeight.w600,
          fontSize: 27,
        );
      case Font.Rubik:
        return GoogleFonts.rubik(
          fontWeight: FontWeight.w500,
          fontSize: 26,
          height: 1.3,
        );
      case Font.SourceSans:
        return GoogleFonts.sourceSans3(
          fontWeight: FontWeight.w600,
          fontSize: 27.5,
        );
      case Font.FiraSans:
        return GoogleFonts.firaSans(
          fontWeight: FontWeight.w500,
          fontSize: 26.5,
          height: 1.25,
        );
      case Font.OpenSans:
        return GoogleFonts.openSans(
          fontWeight: FontWeight.w600,
          fontSize: 26,
        );
      case Font.QuickSand:
        return GoogleFonts.quicksand(
          fontWeight: FontWeight.w600,
          fontSize: 26.5,
        );
      case Font.IBMPlexSans:
        return GoogleFonts.ibmPlexSans(
          fontWeight: FontWeight.w500,
          fontSize: 27,
        );
      case Font.Kanit:
        return GoogleFonts.kanit(
          fontWeight: FontWeight.w500,
          fontSize: 27,
          height: 1.35,
        );
    }
  }

  static TextStyle _headlineMedium(Font font) {
    switch (font) {
      case Font.JosefinSans:
        return GoogleFonts.josefinSans(
          fontWeight: FontWeight.w600,
          fontSize: 22.5,
          height: 1.25,
        );
      case Font.PtSans:
        return GoogleFonts.ptSans(
          fontWeight: FontWeight.w600,
          fontSize: 22,
        );
      case Font.Rubik:
        return GoogleFonts.rubik(
          fontWeight: FontWeight.w500,
          fontSize: 21,
          height: 1.3,
        );
      case Font.SourceSans:
        return GoogleFonts.sourceSans3(
          fontWeight: FontWeight.w600,
          fontSize: 22.5,
        );
      case Font.FiraSans:
        return GoogleFonts.firaSans(
          fontWeight: FontWeight.w500,
          fontSize: 21.5,
          height: 1.25,
        );
      case Font.OpenSans:
        return GoogleFonts.openSans(
          fontWeight: FontWeight.w600,
          fontSize: 21,
        );
      case Font.QuickSand:
        return GoogleFonts.quicksand(
          fontWeight: FontWeight.w600,
          fontSize: 21.5,
        );
      case Font.IBMPlexSans:
        return GoogleFonts.ibmPlexSans(
          fontWeight: FontWeight.w500,
          fontSize: 22,
        );
      case Font.Kanit:
        return GoogleFonts.kanit(
          fontWeight: FontWeight.w500,
          fontSize: 22,
          height: 1.35,
        );
    }
  }

  static TextStyle _headlineSmall(Font font) {
    switch (font) {
      case Font.JosefinSans:
        return GoogleFonts.josefinSans(
          fontWeight: FontWeight.w600,
          fontSize: 21.5,
          height: 1.25,
        );
      case Font.PtSans:
        return GoogleFonts.ptSans(
          fontWeight: FontWeight.w600,
          fontSize: 21,
        );
      case Font.Rubik:
        return GoogleFonts.rubik(
          fontWeight: FontWeight.w500,
          fontSize: 20,
          height: 1.3,
        );
      case Font.SourceSans:
        return GoogleFonts.sourceSans3(
          fontWeight: FontWeight.w600,
          fontSize: 21.5,
        );
      case Font.FiraSans:
        return GoogleFonts.firaSans(
          fontWeight: FontWeight.w500,
          fontSize: 20.5,
          height: 1.25,
        );
      case Font.OpenSans:
        return GoogleFonts.openSans(
          fontWeight: FontWeight.w600,
          fontSize: 20,
        );
      case Font.QuickSand:
        return GoogleFonts.quicksand(
          fontWeight: FontWeight.w600,
          fontSize: 20.5,
        );
      case Font.IBMPlexSans:
        return GoogleFonts.ibmPlexSans(
          fontWeight: FontWeight.w500,
          fontSize: 21,
        );
      case Font.Kanit:
        return GoogleFonts.kanit(
          fontWeight: FontWeight.w500,
          fontSize: 21,
          height: 1.35,
        );
    }
  }

  static TextStyle _titleLarge(Font font) {
    switch (font) {
      case Font.JosefinSans:
        return GoogleFonts.josefinSans(
          fontWeight: FontWeight.w600,
          fontSize: 19.5,
          height: 1.25,
        );
      case Font.PtSans:
        return GoogleFonts.ptSans(
          fontWeight: FontWeight.w600,
          fontSize: 19,
        );
      case Font.Rubik:
        return GoogleFonts.rubik(
          fontWeight: FontWeight.w500,
          fontSize: 18,
          height: 1.3,
        );
      case Font.SourceSans:
        return GoogleFonts.sourceSans3(
          fontWeight: FontWeight.w600,
          fontSize: 19.5,
        );
      case Font.FiraSans:
        return GoogleFonts.firaSans(
          fontWeight: FontWeight.w500,
          fontSize: 18.5,
          height: 1.25,
        );
      case Font.OpenSans:
        return GoogleFonts.openSans(
          fontWeight: FontWeight.w600,
          fontSize: 18,
        );
      case Font.QuickSand:
        return GoogleFonts.quicksand(
          fontWeight: FontWeight.w600,
          fontSize: 18.5,
        );
      case Font.IBMPlexSans:
        return GoogleFonts.ibmPlexSans(
          fontWeight: FontWeight.w500,
          fontSize: 19,
        );
      case Font.Kanit:
        return GoogleFonts.kanit(
          fontWeight: FontWeight.w500,
          fontSize: 19,
          height: 1.35,
        );
    }
  }

  static TextStyle _titleMedium(Font font) {
    switch (font) {
      case Font.JosefinSans:
        return GoogleFonts.josefinSans(
          fontWeight: FontWeight.w600,
          fontSize: 18.5,
          height: 1.25,
        );
      case Font.PtSans:
        return GoogleFonts.ptSans(
          fontWeight: FontWeight.w600,
          fontSize: 18,
        );
      case Font.Rubik:
        return GoogleFonts.rubik(
          fontWeight: FontWeight.w500,
          fontSize: 17,
          height: 1.3,
        );
      case Font.SourceSans:
        return GoogleFonts.sourceSans3(
          fontWeight: FontWeight.w600,
          fontSize: 18.5,
        );
      case Font.FiraSans:
        return GoogleFonts.firaSans(
          fontWeight: FontWeight.w500,
          fontSize: 17.5,
          height: 1.25,
        );
      case Font.OpenSans:
        return GoogleFonts.openSans(
          fontWeight: FontWeight.w600,
          fontSize: 17,
        );
      case Font.QuickSand:
        return GoogleFonts.quicksand(
          fontWeight: FontWeight.w600,
          fontSize: 17.5,
        );
      case Font.IBMPlexSans:
        return GoogleFonts.ibmPlexSans(
          fontWeight: FontWeight.w500,
          fontSize: 18,
        );
      case Font.Kanit:
        return GoogleFonts.kanit(
          fontWeight: FontWeight.w500,
          fontSize: 18,
          height: 1.35,
        );
    }
  }

  static TextStyle _titleSmall(Font font) {
    switch (font) {
      case Font.JosefinSans:
        return GoogleFonts.josefinSans(
          fontWeight: FontWeight.w600,
          fontSize: 17.5,
          height: 1.25,
        );
      case Font.PtSans:
        return GoogleFonts.ptSans(
          fontWeight: FontWeight.w600,
          fontSize: 17,
        );
      case Font.Rubik:
        return GoogleFonts.rubik(
          fontWeight: FontWeight.w500,
          fontSize: 16,
          height: 1.3,
        );
      case Font.SourceSans:
        return GoogleFonts.sourceSans3(
          fontWeight: FontWeight.w600,
          fontSize: 17.5,
        );
      case Font.FiraSans:
        return GoogleFonts.firaSans(
          fontWeight: FontWeight.w500,
          fontSize: 16.5,
          height: 1.25,
        );
      case Font.OpenSans:
        return GoogleFonts.openSans(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        );
      case Font.QuickSand:
        return GoogleFonts.quicksand(
          fontWeight: FontWeight.w600,
          fontSize: 16.5,
        );
      case Font.IBMPlexSans:
        return GoogleFonts.ibmPlexSans(
          fontWeight: FontWeight.w500,
          fontSize: 17,
        );
      case Font.Kanit:
        return GoogleFonts.kanit(
          fontWeight: FontWeight.w500,
          fontSize: 17,
          height: 1.35,
        );
    }
  }

  static TextStyle _bodyLarge(Font font) {
    switch (font) {
      case Font.JosefinSans:
        return GoogleFonts.josefinSans(
          fontWeight: FontWeight.w600,
          fontSize: 16,
          height: 1.25,
        );
      case Font.PtSans:
        return GoogleFonts.ptSans(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        );
      case Font.Rubik:
        return GoogleFonts.rubik(
          fontWeight: FontWeight.w500,
          fontSize: 15,
          height: 1.3,
        );
      case Font.SourceSans:
        return GoogleFonts.sourceSans3(
          fontWeight: FontWeight.w600,
          fontSize: 16.5,
        );
      case Font.FiraSans:
        return GoogleFonts.firaSans(
          fontWeight: FontWeight.w500,
          fontSize: 15.5,
          height: 1.25,
        );
      case Font.OpenSans:
        return GoogleFonts.openSans(
          fontWeight: FontWeight.w600,
          fontSize: 15,
        );
      case Font.QuickSand:
        return GoogleFonts.quicksand(
          fontWeight: FontWeight.w600,
          fontSize: 15.5,
        );
      case Font.IBMPlexSans:
        return GoogleFonts.ibmPlexSans(
          fontWeight: FontWeight.w500,
          fontSize: 16,
        );
      case Font.Kanit:
        return GoogleFonts.kanit(
          fontWeight: FontWeight.w500,
          fontSize: 16,
          height: 1.35,
        );
    }
  }

  static TextStyle _bodyMedium(Font font) {
    switch (font) {
      case Font.JosefinSans:
        return GoogleFonts.josefinSans(
          fontWeight: FontWeight.w600,
          fontSize: 15.5,
          height: 1.25,
        );
      case Font.PtSans:
        return GoogleFonts.ptSans(
          fontWeight: FontWeight.w600,
          fontSize: 15,
        );
      case Font.Rubik:
        return GoogleFonts.rubik(
          fontWeight: FontWeight.w500,
          fontSize: 14,
          height: 1.3,
        );
      case Font.SourceSans:
        return GoogleFonts.sourceSans3(
          fontWeight: FontWeight.w600,
          fontSize: 15.5,
        );
      case Font.FiraSans:
        return GoogleFonts.firaSans(
          fontWeight: FontWeight.w500,
          fontSize: 14.5,
          height: 1.25,
        );
      case Font.OpenSans:
        return GoogleFonts.openSans(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        );
      case Font.QuickSand:
        return GoogleFonts.quicksand(
          fontWeight: FontWeight.w600,
          fontSize: 14.5,
        );
      case Font.IBMPlexSans:
        return GoogleFonts.ibmPlexSans(
          fontWeight: FontWeight.w500,
          fontSize: 15,
        );
      case Font.Kanit:
        return GoogleFonts.kanit(
          fontWeight: FontWeight.w500,
          fontSize: 15,
          height: 1.35,
        );
    }
  }

  static TextStyle _bodySmall(Font font) {
    switch (font) {
      case Font.JosefinSans:
        return GoogleFonts.josefinSans(
          fontWeight: FontWeight.w600,
          fontSize: 14.5,
          height: 1.25,
        );
      case Font.PtSans:
        return GoogleFonts.ptSans(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        );
      case Font.Rubik:
        return GoogleFonts.rubik(
          fontWeight: FontWeight.w500,
          fontSize: 13,
          height: 1.3,
        );
      case Font.SourceSans:
        return GoogleFonts.sourceSans3(
          fontWeight: FontWeight.w600,
          fontSize: 14.25,
        );
      case Font.FiraSans:
        return GoogleFonts.firaSans(
          fontWeight: FontWeight.w500,
          fontSize: 13.5,
          height: 1.25,
        );
      case Font.OpenSans:
        return GoogleFonts.openSans(
          fontWeight: FontWeight.w600,
          fontSize: 13,
        );
      case Font.QuickSand:
        return GoogleFonts.quicksand(
          fontWeight: FontWeight.w600,
          fontSize: 13.75,
        );
      case Font.IBMPlexSans:
        return GoogleFonts.ibmPlexSans(
          fontWeight: FontWeight.w500,
          fontSize: 13.75,
        );
      case Font.Kanit:
        return GoogleFonts.kanit(
          fontWeight: FontWeight.w500,
          fontSize: 14,
          height: 1.35,
        );
    }
  }

  static TextStyle _labelLarge(Font font) {
    switch (font) {
      case Font.JosefinSans:
        return GoogleFonts.josefinSans(
          fontWeight: FontWeight.w600,
          fontSize: 18.5,
          height: 1.25,
        );
      case Font.PtSans:
        return GoogleFonts.ptSans(
          fontWeight: FontWeight.w600,
          fontSize: 18,
        );
      case Font.Rubik:
        return GoogleFonts.rubik(
          fontWeight: FontWeight.w500,
          fontSize: 17,
          height: 1.3,
        );
      case Font.SourceSans:
        return GoogleFonts.sourceSans3(
          fontWeight: FontWeight.w600,
          fontSize: 18.5,
        );
      case Font.FiraSans:
        return GoogleFonts.firaSans(
          fontWeight: FontWeight.w500,
          fontSize: 17.5,
          height: 1.25,
        );
      case Font.OpenSans:
        return GoogleFonts.openSans(
          fontWeight: FontWeight.w600,
          fontSize: 17,
        );
      case Font.QuickSand:
        return GoogleFonts.quicksand(
          fontWeight: FontWeight.w600,
          fontSize: 17.5,
        );
      case Font.IBMPlexSans:
        return GoogleFonts.ibmPlexSans(
          fontWeight: FontWeight.w500,
          fontSize: 18,
        );
      case Font.Kanit:
        return GoogleFonts.kanit(
          fontWeight: FontWeight.w500,
          fontSize: 18,
          height: 1.35,
        );
    }
  }

  static TextStyle _labelMedium(Font font) {
    switch (font) {
      case Font.JosefinSans:
        return GoogleFonts.josefinSans(
          fontWeight: FontWeight.w600,
          fontSize: 16.5,
          height: 1.25,
        );
      case Font.PtSans:
        return GoogleFonts.ptSans(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        );
      case Font.Rubik:
        return GoogleFonts.rubik(
          fontWeight: FontWeight.w500,
          fontSize: 15,
          height: 1.3,
        );
      case Font.SourceSans:
        return GoogleFonts.sourceSans3(
          fontWeight: FontWeight.w600,
          fontSize: 16.5,
        );
      case Font.FiraSans:
        return GoogleFonts.firaSans(
          fontWeight: FontWeight.w500,
          fontSize: 15.5,
          height: 1.25,
        );
      case Font.OpenSans:
        return GoogleFonts.openSans(
          fontWeight: FontWeight.w600,
          fontSize: 15,
        );
      case Font.QuickSand:
        return GoogleFonts.quicksand(
          fontWeight: FontWeight.w600,
          fontSize: 15.5,
        );
      case Font.IBMPlexSans:
        return GoogleFonts.ibmPlexSans(
          fontWeight: FontWeight.w500,
          fontSize: 16,
        );
      case Font.Kanit:
        return GoogleFonts.kanit(
          fontWeight: FontWeight.w500,
          fontSize: 16,
          height: 1.35,
        );
    }
  }

  static TextStyle _labelSmall(Font font) {
    switch (font) {
      case Font.JosefinSans:
        return GoogleFonts.josefinSans(
          fontWeight: FontWeight.w600,
          fontSize: 12.5,
          height: 1.25,
          letterSpacing: 0,
        );
      case Font.PtSans:
        return GoogleFonts.ptSans(
          fontWeight: FontWeight.w600,
          fontSize: 12,
          letterSpacing: 0,
        );
      case Font.Rubik:
        return GoogleFonts.rubik(
          fontWeight: FontWeight.w500,
          fontSize: 11,
          height: 1.3,
          letterSpacing: 0,
        );
      case Font.SourceSans:
        return GoogleFonts.sourceSans3(
          fontWeight: FontWeight.w600,
          fontSize: 12.5,
          letterSpacing: 0,
        );
      case Font.FiraSans:
        return GoogleFonts.firaSans(
          fontWeight: FontWeight.w500,
          fontSize: 11.5,
          height: 1.25,
          letterSpacing: 0,
        );
      case Font.OpenSans:
        return GoogleFonts.openSans(
          fontWeight: FontWeight.w600,
          fontSize: 11,
          letterSpacing: 0,
        );
      case Font.QuickSand:
        return GoogleFonts.quicksand(
          fontWeight: FontWeight.w600,
          fontSize: 11.75,
          letterSpacing: 0,
        );
      case Font.IBMPlexSans:
        return GoogleFonts.ibmPlexSans(
          fontWeight: FontWeight.w500,
          fontSize: 11.75,
          letterSpacing: 0.1,
        );
      case Font.Kanit:
        return GoogleFonts.kanit(
          fontWeight: FontWeight.w500,
          fontSize: 12,
          height: 1.35,
          letterSpacing: 0.1,
        );
    }
  }

  static ThemeData merge(ThemeData themeData, Font font) {
    final color = themeData.brightness == Brightness.light
        ? _highEmphasiseLight
        : _highEmphasiseDark;

    return themeData.copyWith(
      textTheme: TextTheme(
          headlineLarge: _headlineLarge(font).copyWith(color: color),
          headlineMedium: _headlineMedium(font).copyWith(color: color),
          headlineSmall: _headlineSmall(font).copyWith(color: color),
          titleLarge: _titleLarge(font).copyWith(color: color),
          titleMedium: _titleMedium(font).copyWith(color: color),
          titleSmall: _titleSmall(font).copyWith(color: color),
          bodyLarge: _bodyLarge(font).copyWith(color: color),
          bodyMedium: _bodyMedium(font).copyWith(color: color),
          bodySmall: _bodySmall(font).copyWith(color: color),
          labelLarge: _labelLarge(font).copyWith(color: color),
          labelMedium: _labelMedium(font).copyWith(color: color),
          labelSmall: _labelSmall(font).copyWith(color: color)),
    );
  }
}
