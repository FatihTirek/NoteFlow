import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/widgets/shared/app_theme_controller.dart';
import '../../i18n/localizations.dart';
import '../../theme/app_theme_state.dart';

enum SortTypePickerMode { Folder, Label, Note }

class SortTypePicker extends ConsumerWidget {
  final SortTypePickerMode pickerMode;

  const SortTypePicker(this.pickerMode);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final primaryColor = Theme.of(context).primaryColor;

    final _itemsFolder = [
      {
        'text': AppLocalizations.instance.w96,
        'icon': Icons.sort_by_alpha_outlined,
        'enum': FolderSortType.AlphabeticallyAZ
      },
      {
        'text': AppLocalizations.instance.w97,
        'icon': Icons.sort_by_alpha_outlined,
        'enum': FolderSortType.AlphabeticallyZA
      },
      {
        'text': AppLocalizations.instance.w98,
        'icon': Icons.access_time_outlined,
        'enum': FolderSortType.CreatedNF
      },
      {
        'text': AppLocalizations.instance.w99,
        'icon': Icons.access_time_outlined,
        'enum': FolderSortType.CreatedOF
      },
    ];

    final _itemsLabel = [
      {
        'text': AppLocalizations.instance.w96,
        'icon': Icons.sort_by_alpha_outlined,
        'enum': LabelSortType.AlphabeticallyAZ
      },
      {
        'text': AppLocalizations.instance.w97,
        'icon': Icons.sort_by_alpha_outlined,
        'enum': LabelSortType.AlphabeticallyZA
      },
      {
        'text': AppLocalizations.instance.w98,
        'icon': Icons.access_time_outlined,
        'enum': LabelSortType.CreatedNF
      },
      {
        'text': AppLocalizations.instance.w99,
        'icon': Icons.access_time_outlined,
        'enum': LabelSortType.CreatedOF
      },
    ];

    final _itemsNote = [
      {
        'text': AppLocalizations.instance.w89,
        'icon': Icons.push_pin_sharp,
        'enum': NoteSortType.Pinned
      },
      {
        'text': AppLocalizations.instance.w98,
        'icon': Icons.access_time_outlined,
        'enum': NoteSortType.CreatedNF
      },
      {
        'text': AppLocalizations.instance.w99,
        'icon': Icons.access_time_outlined,
        'enum': NoteSortType.CreatedOF
      },
      {
        'text': AppLocalizations.instance.w38,
        'icon': Icons.timelapse_outlined,
        'enum': NoteSortType.EditedNF
      },
      {
        'text': AppLocalizations.instance.w39,
        'icon': Icons.timelapse_outlined,
        'enum': NoteSortType.EditedOF
      },
    ];

    Object currentSortType;
    List<Map<String, dynamic>> items;

    switch (pickerMode) {
      case SortTypePickerMode.Folder:
        currentSortType = ref.read(appThemeController).folderSortType;
        items = _itemsFolder;
        break;
      case SortTypePickerMode.Label:
        currentSortType = ref.read(appThemeController).labelSortType;
        items = _itemsLabel;
        break;
      case SortTypePickerMode.Note:
        currentSortType = ref.read(appThemeController).noteSortType;
        items = _itemsNote;
        break;
    }

    return ScrollConfiguration(
      behavior: const ScrollBehavior().copyWith(overscroll: false),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                AppLocalizations.instance.w95,
                style: textTheme.titleLarge,
              ),
            ),
            ...items.map((object) {
              final active = currentSortType == object['enum'];
              final color = active ? primaryColor.withOpacity(.16) : null;

              return Theme(
                data: Theme.of(context).copyWith(
                  splashColor: color,
                  highlightColor: color,
                ),
                child: ListTile(
                  tileColor: color,
                  onTap: () => Navigator.pop(context, object['enum']),
                  leading: Icon(
                    object['icon'],
                    color: active ? primaryColor : textTheme.labelSmall!.color,
                  ),
                  title: Text(
                    object['text'],
                    style: active
                        ? textTheme.bodyLarge!.copyWith(color: primaryColor)
                        : textTheme.bodyLarge,
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
