import 'package:flutter/material.dart';

class AppContextMenu extends StatelessWidget {
  final EditableTextState editableTextState;

  const AppContextMenu(this.editableTextState);

  @override
  Widget build(BuildContext context) {
    final localizations = MaterialLocalizations.of(context);
    final totalItems = editableTextState.selectAllEnabled ? 4 : 3;
    final backgroundColor = Theme.of(context).brightness == Brightness.light
        ? Theme.of(context).colorScheme.surface
        : Theme.of(context).colorScheme.onSurface;

    final items = [
      {
        'text': localizations.cutButtonLabel,
        'onPressed': editableTextState.cutSelection,
      },
      {
        'text': localizations.copyButtonLabel,
        'onPressed': editableTextState.copySelection,
      },
      {
        'text': localizations.pasteButtonLabel,
        'onPressed': editableTextState.pasteText,
      },
      {
        'text': localizations.selectAllButtonLabel,
        'onPressed': editableTextState.selectAll,
      },
    ];

    return AdaptiveTextSelectionToolbar(
      anchors: editableTextState.contextMenuAnchors,
      children: [
        ...List.generate(
          totalItems,
          (index) => TextButton(
            onPressed: () => (items[index]['onPressed'] as void Function(SelectionChangedCause))
                    .call(SelectionChangedCause.toolbar),
            child: Text(
              items[index]['text'] as String,
              style: Theme.of(context).textTheme.labelMedium,
            ),
            style: TextButton.styleFrom(
              minimumSize: const Size(48, 48),
              backgroundColor: backgroundColor,
              shape: const RoundedRectangleBorder(),
              foregroundColor: Theme.of(context).textTheme.labelMedium!.color,
              padding: TextSelectionToolbarTextButton.getPadding(index, totalItems),
            ),
          ),
        ),
      ],
    );
  }
}
