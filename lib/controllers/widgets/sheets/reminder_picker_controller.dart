import 'package:flutter/material.dart';

class ReminderPickerController {
  final DateTime? reminder;

  late FixedExtentScrollController minuteController;
  late FixedExtentScrollController dateController;
  late FixedExtentScrollController hourController;

  late DateTime date;
  late int minute;
  late int hour;

  final now = DateTime.now();

  ReminderPickerController(this.reminder) {
    minute = reminder?.minute ?? (now.minute ~/ 5 == 11 ? 0 : (now.minute ~/ 5 + 1) * 5);
    hour = reminder?.hour ?? (now.minute ~/ 5 == 11 ? now.hour + 1 : now.hour);
    date = reminder ?? now;

    dateController = FixedExtentScrollController(initialItem: date.difference(now).inDays);
    minuteController = FixedExtentScrollController(initialItem: minute ~/ 5);
    hourController = FixedExtentScrollController(initialItem: hour);
  }

  void dispose() {
    dateController.dispose();
    hourController.dispose();
    minuteController.dispose();
  }

  void onHourChanged(int value) => hour = value;

  void onMinuteChanged(int value) => minute = value * 5;

  void onDateChanged(int value) => date = now.add(Duration(days: value));

  void onTapDone(BuildContext context) => Navigator.pop(context, DateTime(date.year, date.month, date.day, hour, minute));

  void onTapCancel(BuildContext context) => Navigator.pop(context);

  void onCancelNotification(BuildContext context) => Navigator.pop(context, 'clear');
}
