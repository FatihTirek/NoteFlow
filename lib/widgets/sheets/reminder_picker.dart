import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/widgets/sheets/reminder_picker_controller.dart';
import '../../extensions/color_extension.dart';
import '../../extensions/datetime_extension.dart';
import '../../i18n/localizations.dart';
import '../../utils.dart';
import '../shared/app_text_button.dart';

class ReminderPicker extends ConsumerStatefulWidget {
  final DateTime? reminder;

  const ReminderPicker({this.reminder});

  @override
  _ReminderPickerState createState() => _ReminderPickerState();
}

class _ReminderPickerState extends ConsumerState<ReminderPicker> with Utils {
  late ReminderPickerController controller;

  final now = DateTime.now();

  @override
  void initState() {
    super.initState();
    controller = ReminderPickerController(widget.reminder);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final active = widget.reminder?.isAfter(now) ?? false;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(overscroll: false),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppLocalizations.instance.w18,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 24),
              buildPickers(),
              if (active) buildCancelNotificationButton(),
              SizedBox(height: active ? 12 : 24),
              buildButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCancelNotificationButton() {
    final primaryColor = Theme.of(context).primaryColor;

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: SizedBox(
        width: double.infinity,
        child: AppTextButton(
          backgroundColor: primaryColor,
          text: AppLocalizations.instance.w127,
          textColor: primaryColor.getOnTextColor(),
          onPressed: () => controller.onCancelNotification(context),
        ),
      ),
    );
  }

  Widget buildButtons() {
    final primaryColor = Theme.of(context).primaryColor;

    return Row(
      children: [
        Expanded(
          child: AppTextButton(
            text: AppLocalizations.instance.w1,
            onPressed: () => controller.onTapCancel(context),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: AppTextButton(
            backgroundColor: primaryColor,
            text: AppLocalizations.instance.w2,
            textColor: primaryColor.getOnTextColor(),
            onPressed: () => controller.onTapDone(context),
          ),
        )
      ],
    );
  }

  Widget buildPickers() {
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      height: 120,
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: ListWheelScrollView.useDelegate(
              itemExtent: 40,
              perspective: 0.005,
              overAndUnderCenterOpacity: .4,
              controller: controller.dateController,
              onSelectedItemChanged: controller.onDateChanged,
              childDelegate: ListWheelChildBuilderDelegate(
                childCount: DateTime(now.year + 5, 1, 1).difference(now).inDays,
                builder: (_, index) {
                  final date = now.add(Duration(days: index));
                  final style = date.year != now.year 
                      ? textTheme.headlineSmall 
                      : textTheme.headlineMedium;

                  return Text(
                    date.toLocalizedText(context, todayAsText: true, shortenedYear: true),
                    style: style,
                  );
                },
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: ListWheelScrollView.useDelegate(
              itemExtent: 40,
              perspective: 0.005,
              overAndUnderCenterOpacity: .4,
              controller: controller.hourController,
              onSelectedItemChanged: controller.onHourChanged,
              childDelegate: ListWheelChildBuilderDelegate(
                childCount: 24,
                builder: (_, index) => Text(
                  index.toString().padLeft(2, '0'),
                  style: textTheme.headlineMedium,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: ListWheelScrollView.useDelegate(
              itemExtent: 40,
              perspective: 0.005,
              overAndUnderCenterOpacity: .4,
              controller: controller.minuteController,
              onSelectedItemChanged: controller.onMinuteChanged,
              childDelegate: ListWheelChildBuilderDelegate(
                childCount: 12,
                builder: (_, index) => Text(
                  (index * 5).toString().padLeft(2, '0'),
                  style: textTheme.headlineMedium,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
