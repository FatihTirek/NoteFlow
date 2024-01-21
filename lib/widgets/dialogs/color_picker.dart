import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../controllers/widgets/dialogs/color_picker_controller.dart';
import '../../extensions/color_extension.dart';
import '../../i18n/localizations.dart';
import '../shared/app_text_button.dart';

enum ColorPickerMode { Primary, Accent, Custom }

class ColorPicker extends StatelessWidget {
  final ColorPickerController controller;
  final Color color;

  ColorPicker({Color? color})
      : this.color = color ?? const Color(0xFFD32F2F),
        this.controller = ColorPickerController(color ?? const Color(0xFFD32F2F));

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ScrollConfiguration(
      behavior: const ScrollBehavior().copyWith(overscroll: false),
      child: AlertDialog(
        title: Text(
          AppLocalizations.instance.w103,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(color: color),
        ),
        content: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 264),
            child: ValueListenableBuilder(
              child: const SizedBox(height: 16),
              valueListenable: controller.pickerMode,
              builder: (_, value, child) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CupertinoSlidingSegmentedControl<ColorPickerMode>(
                    backgroundColor: colorScheme.brightness == Brightness.light
                        ? colorScheme.onSurface
                        : colorScheme.surface,
                    onValueChanged: controller.onValueChanged,
                    padding: EdgeInsets.zero,
                    thumbColor: color,
                    groupValue: value,
                    children: {
                      ColorPickerMode.Primary: AnimatedDefaultTextStyle(
                        child: Text(AppLocalizations.instance.w76),
                        duration: kThemeAnimationDuration,
                        style: getStyle(context, ColorPickerMode.Primary),
                      ),
                      ColorPickerMode.Accent: AnimatedDefaultTextStyle(
                        child: Text(AppLocalizations.instance.w77),
                        duration: kThemeAnimationDuration,
                        style: getStyle(context, ColorPickerMode.Accent),
                      ),
                      ColorPickerMode.Custom: AnimatedDefaultTextStyle(
                        child: Text(AppLocalizations.instance.w78),
                        duration: kThemeAnimationDuration,
                        style: getStyle(context, ColorPickerMode.Custom),
                      ),
                    },
                  ),
                  child!,
                  buildColorView(context),
                ],
              ),
            ),
          ),
        ),
        actions: [
          AppTextButton(
            text: AppLocalizations.instance.w1,
            onPressed: () => Navigator.pop(context),
            appTextButtonSize: AppTextButtonSize.Small,
          ),
          AppTextButton(
            textColor: color,
            text: AppLocalizations.instance.w2,
            appTextButtonSize: AppTextButtonSize.Small,
            onPressed: () => controller.onTapDone(context),
          ),
        ],
      ),
    );
  }

  Widget buildColorView(BuildContext context) {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;

    switch (controller.pickerMode.value) {
      case ColorPickerMode.Primary:
        return ValueListenableBuilder(
          child: const SizedBox(height: 16),
          valueListenable: controller.primaryColor,
          builder: (_, __, child) => Column(
            children: [
              Wrap(
                spacing: 4,
                runSpacing: 4,
                children: Colors.primaries
                    .map((color) => buildColorBox(context, color, controller.primarySwatchColor.value.shade500, true))
                    .toList(),
              ),
              child!,
              Wrap(
                spacing: 4,
                runSpacing: 4,
                children: controller
                    .getCurrentPrimaryShades()
                    .map((color) => buildColorBox(context, color, controller.primaryColor.value, false))
                    .toList(),
              ),
            ],
          ),
        );
      case ColorPickerMode.Accent:
        return ValueListenableBuilder(
          child: const SizedBox(height: 16),
          valueListenable: controller.accentColor,
          builder: (_, __, child) => Column(
            children: [
              Wrap(
                spacing: 4,
                runSpacing: 4,
                children: Colors.accents
                    .map((color) => buildColorBox(context, color, controller.accentSwatchColor.value.shade200, true))
                    .toList(),
              ),
              child!,
              Wrap(
                spacing: 4,
                runSpacing: 4,
                children: controller
                    .getCurrentAccentShades()
                    .map((color) => buildColorBox(context, color, controller.accentColor.value, false))
                    .toList(),
              ),
            ],
          ),
        );
      case ColorPickerMode.Custom:
        return AnimatedBuilder(
          child: const SizedBox(height: 8),
          animation: Listenable.merge([
            controller.red,
            controller.blue,
            controller.green,
          ]),
          builder: (_, child) => Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: SizedBox(
                  width: 64,
                  height: 64,
                  child: Material(
                    elevation: 1,
                    shape: CircleBorder(),
                    color: Color.fromRGBO(
                      controller.red.value,
                      controller.green.value,
                      controller.blue.value,
                      1,
                    ),
                  ),
                ),
              ),
              buildSlider(Colors.red, controller.red),
              buildSlider(Colors.green, controller.green),
              buildSlider(Colors.blue, controller.blue),
              child!,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('R: ${controller.red.value}', style: bodyMedium),
                  const SizedBox(width: 12),
                  Text('G: ${controller.green.value}', style: bodyMedium),
                  const SizedBox(width: 12),
                  Text('B: ${controller.blue.value}', style: bodyMedium),
                ],
              ),
            ],
          ),
        );
    }
  }

  Widget buildSlider(Color color, ValueNotifier<int> notifier) {
    return SliderTheme(
      data: SliderThemeData(
        thumbColor: color,
        overlayColor: color.withOpacity(.12),
        activeTrackColor: color.withOpacity(.84),
        inactiveTrackColor: color.withOpacity(.42),
      ),
      child: Slider(
        min: 0,
        max: 255,
        value: notifier.value.toDouble(),
        onChanged: (value) => notifier.value = value.toInt(),
      ),
    );
  }

  Widget buildColorBox(BuildContext context, Color color, Color current, bool material) {
    return GestureDetector(
      onTap: () => controller.onTapColor(color, material),
      child: Container(
        width: 36,
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(1),
          border: Theme.of(context).brightness == Brightness.light
              ? Border.all(width: 1.25, color: Colors.black)
              : null,
        ),
        child: current.value == color.value
            ? Icon(Icons.done_outline_rounded, color: color.getOnTextColor())
            : null,
      ),
    );
  }

  TextStyle getStyle(BuildContext context, ColorPickerMode pickerMode) {
    final labelSmall = Theme.of(context).textTheme.labelSmall!;

    if (controller.pickerMode.value == pickerMode)
      return labelSmall.copyWith(color: color.getOnTextColor());

    return labelSmall;
  }
}
