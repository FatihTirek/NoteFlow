import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../i18n/localizations.dart';
import '../../utils.dart';
import '../widgets/shared/app_theme_controller.dart';

class PremiumViewController with Utils {
  void initState(WidgetRef ref) {
    ref.listenManual(appThemeController, (previous, next) {
      if (previous?.isPremium != next.isPremium) Navigator.pop(ref.context);
    });
  }

  void onTapBuy() async {
    final details = await InAppPurchase.instance.queryProductDetails({'premium'});

    if (details.productDetails.isEmpty) {
      showToast(AppLocalizations.instance.w124);
      showToast(AppLocalizations.instance.w125);

      if (details.error != null) showToast(AppLocalizations.instance.m1(details.error!.code));

      return;
    }

    InAppPurchase.instance.buyNonConsumable(
      purchaseParam: PurchaseParam(productDetails: details.productDetails.first),
    );
  }

  void onTapRestore() => InAppPurchase.instance.restorePurchases();
}
