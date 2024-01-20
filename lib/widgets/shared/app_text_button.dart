import 'package:flutter/material.dart';

enum AppTextButtonSize { Default, Small }

class AppTextButton extends StatelessWidget {
  final String text;
  final Color? textColor;
  final Color? backgroundColor;
  final VoidCallback onPressed;
  final AppTextButtonSize appTextButtonSize;

  const AppTextButton({
    required this.text,
    required this.onPressed,
    this.textColor,
    this.backgroundColor,
    this.appTextButtonSize = AppTextButtonSize.Default,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    switch (appTextButtonSize) {
      case AppTextButtonSize.Default:
        final textStyle = textColor != null
            ? textTheme.labelLarge!.copyWith(color: textColor)
            : textTheme.labelLarge!;

        return TextButton(
          onPressed: onPressed,
          child: Text(text, style: textStyle),
          style: TextButton.styleFrom(
            visualDensity: VisualDensity(horizontal: 1, vertical: 1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: backgroundColor == null
                  ? BorderSide(color: colorScheme.outline, width: 1.25)
                  : BorderSide.none,
            ),
            foregroundColor: textStyle.color!.withOpacity(.12),
            backgroundColor:
                backgroundColor != null ? backgroundColor : colorScheme.surface,
          ),
        );
      case AppTextButtonSize.Small:
        return TextButton(
          onPressed: onPressed,
          child: Text(
            text,
            style: textTheme.labelMedium!.copyWith(color: textColor),
          ),
          style: TextButton.styleFrom(
            foregroundColor: textColor?.withOpacity(.12) ?? Theme.of(context).splashColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          ),
        );
    }
  }
}
