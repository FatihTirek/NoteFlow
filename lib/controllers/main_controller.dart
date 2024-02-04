import 'dart:convert';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:timezone/data/latest.dart' as timezone;

import '../constants.dart';
import '../utils.dart';
import '../views/home_view.dart';
import '../views/note_view.dart';
import '../firebase_options.dart';
import '../i18n/localizations.dart';
import '../theme/app_theme_state.dart';
import '../models/single_note_widget_launch_details.dart';
import '../models/note.dart';
import '../services/folder_service.dart';
import '../services/label_service.dart';
import '../services/note_service.dart';
import '../services/single_note_widget_service.dart';
import '../services/theme_service.dart';
import 'widgets/shared/app_theme_controller.dart';

late String appVersion;
// late bool canAuthenticateWithFingerprint;
late AndroidDeviceInfo androidDeviceInfo;
late NotificationAppLaunchDetails? notificationAppLaunchDetails;
late SingleNoteWidgetLaunchDetails singleNoteWidgetLaunchDetails;

final GlobalKey<NavigatorState> navigator = GlobalKey<NavigatorState>();
final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> _onReceiveNotification(NotificationResponse response) async {
  Note note;

  final data = jsonDecode(response.payload!);

  if (data is Map)
    note = Note.fromMap(data);
  else
    note = GetIt.I<NoteService>().get(data);

  navigator.currentState?.push(MaterialPageRoute(builder: (_) => NoteView(note: note)));
}

class NoteFlowController with Utils {
  final _productIDs = ['premium', 'donation'];
  final _statuses = [PurchaseStatus.purchased, PurchaseStatus.restored];

  static Future<void> initializeApp() async {
    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

    timezone.initializeTimeZones();
    await flutterLocalNotificationsPlugin.initialize(
      InitializationSettings(
        iOS: null,
        macOS: null,
        android: AndroidInitializationSettings('ic_stat_app'),
      ),
      onDidReceiveNotificationResponse: _onReceiveNotification,
    );

    GetIt.I.registerSingleton(NoteService());
    GetIt.I.registerSingleton(LabelService());
    GetIt.I.registerSingleton(ThemeService());
    GetIt.I.registerSingleton(FolderService());
    GetIt.I.registerSingleton(SingleNoteWidgetService());

    await Hive.initFlutter();
    await GetIt.I<NoteService>().init();
    await GetIt.I<LabelService>().init();
    await GetIt.I<ThemeService>().init();
    await GetIt.I<FolderService>().init();
    await GetIt.I<FolderService>().migrateIfNeeded();

    androidDeviceInfo = await DeviceInfoPlugin().androidInfo;
    appVersion = await channelMain.invokeMethod('getAppVersion');
    singleNoteWidgetLaunchDetails = await GetIt.I<SingleNoteWidgetService>().getLaunchDetails();
    notificationAppLaunchDetails = await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  }

  void initState(WidgetRef ref) {
    GetIt.I<SingleNoteWidgetService>().unlockWidgetIfDonatedBefore(ref);
    GetIt.I<SingleNoteWidgetService>().updateAppWidgetIfThemeChanged(ref);

    InAppPurchase.instance.purchaseStream.listen((event) {
      event.forEach((details) async {
        if (details.status == PurchaseStatus.canceled) return;

        if (details.error != null) {
          showToast(AppLocalizations.instance.m1(details.error!.code));
          return;
        }

        if (details.status == PurchaseStatus.pending) {
          showToast(AppLocalizations.instance.w120);
          return;
        }

        final json = jsonDecode(details.verificationData.localVerificationData);
        final isValidProductID = _productIDs.contains(details.productID);
        final isValidStatus = _statuses.contains(details.status);
        final isValidPurchase = json['purchaseState'] == 0;

        if (isValidProductID && isValidStatus && isValidPurchase) {
          ref.read(appThemeController.notifier).upgradePremium();

          if (details.pendingCompletePurchase) await InAppPurchase.instance.completePurchase(details);
          if (details.status == PurchaseStatus.restored) showToast(AppLocalizations.instance.w121);

          showToast(AppLocalizations.instance.w122);
        }
      });
    });
  }

  Widget getWidget(WidgetRef ref) {
    Widget view;

    if (notificationAppLaunchDetails!.didNotificationLaunchApp) {
      final payload = jsonDecode(notificationAppLaunchDetails!.notificationResponse!.payload!);
      view = NoteView(note: payload is Map ? Note.fromMap(payload) : GetIt.I<NoteService>().get(payload));
    } else {
      switch (singleNoteWidgetLaunchDetails.launchAction) {
        case SingleNoteWidgetLaunchAction.Show:
          final noteID = singleNoteWidgetLaunchDetails.launchedNoteID!;
          view = NoteView(note: GetIt.I<NoteService>().get(noteID));
          break;
        case SingleNoteWidgetLaunchAction.Add:
          view = NoteView();
          break;
        default:
          view = HomeView();
          break;
      }
    }

    return view;
  }

  Locale getLocale(Language language) {
    final locales = AppLocalizationsDelegate.locales;

    switch (language) {
      case Language.English:
        return Locale(locales[0]);
      case Language.Turkish:
        return Locale(locales[1]);
    }
  }
}
