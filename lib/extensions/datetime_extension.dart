import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../i18n/localizations.dart';

extension DateTimeX on DateTime {
  String toLocalizedText(
    BuildContext context, {
    bool todayAsText = false,
    bool shortenedYear = false,
  }) {
    final now = DateTime.now();
    final today = DateUtils.dateOnly(now);
    final current = DateUtils.dateOnly(this);
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final languageCode = Localizations.localeOf(context).languageCode;

    final withYearFormatter = DateFormat('E MMM d, y', languageCode);
    final withoutYearFormatter = DateFormat('E, MMM d', languageCode);
    final withShortenedYearFormatter = DateFormat('E MMM d, yy', languageCode);

    String result;

    if (current == yesterday)
      result = AppLocalizations.instance.w0;
    else if (current == today)
      result = todayAsText
          ? AppLocalizations.instance.w104
          : TimeOfDay(hour: this.hour, minute: this.minute).format(context);
    else if (current == tomorrow)
      result = AppLocalizations.instance.w123;
    else if (current.year == now.year)
      result = withoutYearFormatter.format(current);
    else
      result = shortenedYear
          ? withShortenedYearFormatter.format(current)
          : withYearFormatter.format(current);

    return result;
  }
}
