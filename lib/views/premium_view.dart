import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/views/premium_view_controller.dart';
import '../i18n/localizations.dart';
import '../theme/app_theme.dart';
import '../utils.dart';
import '../extensions/color_extension.dart';
import '../widgets/shared/app_text_button.dart';

class PremiumView extends ConsumerStatefulWidget with Utils {
  @override
  _PremiumViewState createState() => _PremiumViewState();
}

class _PremiumViewState extends ConsumerState<PremiumView> {
  late PremiumViewController controller;

  @override
  void initState() {
    super.initState();
    controller = PremiumViewController();
    controller.initState(ref);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        shape: Border.all(color: Colors.transparent),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: IconButton(
              iconSize: 26,
              icon: Icon(Icons.restore_outlined),
              onPressed: controller.onTapRestore,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.diamond_outlined, size: 80, color: primaryColor),
              const SizedBox(height: 12),
              Text(AppLocalizations.instance.w111, textAlign: TextAlign.center, style: textTheme.headlineLarge),
              const SizedBox(height: 24),
              Text(AppLocalizations.instance.w112, textAlign: TextAlign.center, style: textTheme.bodyMedium),
              const SizedBox(height: 16),
              buildTile(context, AppLocalizations.instance.w105),
              buildTile(context, AppLocalizations.instance.w106),
              buildTile(context, AppLocalizations.instance.w107, AppLocalizations.instance.w113),
              const SizedBox(height: 12),
              buildTile(context, AppLocalizations.instance.w108, AppLocalizations.instance.w114),
              const SizedBox(height: 12),
              buildTile(context, AppLocalizations.instance.w109, AppLocalizations.instance.w115),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: AppTextButton(
                  backgroundColor: primaryColor,
                  onPressed: controller.onTapBuy,
                  text: AppLocalizations.instance.w110,
                  textColor: primaryColor.getOnTextColor(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTile(BuildContext context, String title, [String? subtitle]) {
    final textTheme = Theme.of(context).textTheme;

    return ListTile(
      horizontalTitleGap: 0,
      contentPadding: EdgeInsets.zero,
      visualDensity: VisualDensity.standard,
      titleAlignment: ListTileTitleAlignment.center,
      title: Text(title, style: textTheme.bodyLarge),
      leading: Icon(Icons.stars_rounded, size: 28, color: Theme.of(context).primaryColor),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: textTheme.bodySmall!.copyWith(color: AppTheme.lowEmphasise(context)),
            )
          : null,
    );
  }
}
