import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'controllers/main_controller.dart';
import 'controllers/widgets/shared/app_theme_controller.dart';
import 'i18n/localizations.dart';
import 'theme/app_theme.dart';
import 'utils.dart';

const isDebug = true;

late Image preImageFolder;
late Image preImagePinDark;
late Image preImagePinLight;

void main() async {
  GoogleFonts.config.allowRuntimeFetching = isDebug;
  await NoteFlowController.initializeApp(isDebug);
  runApp(ProviderScope(child: NoteFlow()));
}

class NoteFlow extends ConsumerStatefulWidget {
  @override
  _NoteFlowState createState() => _NoteFlowState();
}

class _NoteFlowState extends ConsumerState<NoteFlow> with Utils {
  late NoteFlowController controller;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );

    WidgetsBinding.instance.platformDispatcher.onPlatformBrightnessChanged = () {
      WidgetsBinding.instance.handlePlatformBrightnessChanged();
      setState(() {});
    };

    controller = NoteFlowController();
    controller.initState(ref);
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(appThemeController.select((state) => state.themeMode));
    final language = ref.watch(appThemeController.select((state) => state.language));
    final font = ref.watch(appThemeController.select((state) => state.font));

    preImageFolder = Image.asset('assets/img/folder.png', width: 48, height: 48);
    preImagePinDark = Image.asset('assets/img/pin_dark.png', width: 25.6, height: 25.6);
    preImagePinLight = Image.asset('assets/img/pin_light.png', width: 25.6, height: 25.6);
    precacheImage(preImageFolder.image, context);
    precacheImage(preImagePinDark.image, context);
    precacheImage(preImagePinLight.image, context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: getUIStyle(themeMode),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: themeMode,
        navigatorKey: navigator,
        home: controller.getWidget(ref),
        locale: controller.getLocale(language),
        onGenerateTitle: (context) => 'NoteFlow',
        localizationsDelegates: [
          AppLocalizationsDelegate(),
          GlobalCupertinoLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        theme: AppTheme.merge(AppTheme.lightTheme, font),
        darkTheme: AppTheme.merge(AppTheme.darkTheme, font),
        supportedLocales: AppLocalizationsDelegate.locales.map((e) => Locale(e)),
      ),
    );
  }
}
