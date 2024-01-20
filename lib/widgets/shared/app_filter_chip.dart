import 'package:flutter/material.dart';

class AppFilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final void Function(bool value)? onSelected;

  const AppFilterChip({
    required this.label,
    this.onSelected,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final primaryColor = Theme.of(context).primaryColor;

    return GestureDetector(
      onTap: () => onSelected?.call(!selected),
      child: Material(
        color: selected ? primaryColor.withOpacity(.16) : colorScheme.surface,
        textStyle: Theme.of(context)
            .textTheme
            .bodyMedium!
            .copyWith(color: selected ? primaryColor : null),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            width: 1.25,
            color: selected ? primaryColor : colorScheme.outline,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
