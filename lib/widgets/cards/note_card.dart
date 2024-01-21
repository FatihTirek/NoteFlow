import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/main_controller.dart';
import '../../controllers/widgets/cards/note_card_controller.dart';
import '../../controllers/widgets/shared/app_theme_controller.dart';
import '../../controllers/widgets/shared/contextual_appbar_controller.dart';
import '../../extensions/color_extension.dart';
import '../../extensions/datetime_extension.dart';
import '../../models/app_widget_launch_details.dart';
import '../../models/note.dart';
import '../../theme/app_theme.dart';
import '../../utils.dart';
import '../../views/note_details_view.dart';

class NoteCard extends ConsumerWidget with Utils {
  final NoteCardController controller;
  final bool isGridView;
  final Note note;

  const NoteCard(this.note, {this.isGridView = true}) : controller = const NoteCardController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final backgroundColor = getNoteBackgroundColor(ref, note.backgroundIndex);
    final tappable = !ref.watch(contextualBarController.select((state) => state.active)) &&
        noteWidgetLaunchDetails.launchAction != NoteWidgetLaunchAction.Select;

    return ClipRRect(
      clipBehavior: Clip.hardEdge,
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          GestureDetector(
            onTap: () => controller.onTapCard(ref, note),
            onLongPress: () => controller.onLongPressCard(ref, note),
            child: OpenContainer(
              openElevation: 0,
              closedElevation: 0,
              tappable: tappable,
              openColor: backgroundColor,
              closedColor: backgroundColor,
              transitionType: ContainerTransitionType.fade,
              openBuilder: (_, __) => NoteDetailsView(note: note),
              transitionDuration: const Duration(milliseconds: 400),
              closedBuilder: (_, __) => _NoteCardBody(note, isGridView, controller),
              closedShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: note.backgroundIndex == null
                    ? BorderSide(width: 1.25, color: Theme.of(context).colorScheme.outline)
                    : BorderSide.none,
              ),
            ),
          ),
          if (note.pinned)
            Positioned(
              top: 0,
              right: 0,
              width: 27,
              height: 27,
              child: Material(
                color: getOnNoteBackgroundColor(ref, note.backgroundIndex),
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8)),
                child: Icon(
                  Icons.push_pin_sharp,
                  size: 15,
                  color: note.backgroundIndex == null 
                      ? Theme.of(context).primaryColor 
                      : backgroundColor.getOnTextColor(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _NoteCardBody extends ConsumerWidget with Utils {
  final Note note;
  final bool isGridView;
  final NoteCardController controller;

  const _NoteCardBody(this.note, this.isGridView, this.controller);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final barState = ref.watch(contextualBarController);
    final showLabels = ref.watch(appThemeController).showLabels;
    final showContent = ref.watch(appThemeController).titleOnly ? note.title.isEmpty : note.content.isNotEmpty;

    final limit = isGridView ? 4 : 8;
    final residuals = note.labelIDs.length - limit;
    final backgroundColor = getOnNoteBackgroundColor(ref, note.backgroundIndex);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (note.title.isNotEmpty)
            Text(
              note.title.toString(),
              softWrap: false,
              maxLines: showContent ? 1 : 5,
              overflow: TextOverflow.ellipsis,
              style: textTheme.bodyLarge!.copyWith(color: note.titleColor),
            ),
          if (showContent && note.title.isNotEmpty) const SizedBox(height: 8),
          if (showContent)
            Text(
              note.content.toString(),
              softWrap: false,
              maxLines: isGridView ? 12 : 6,
              overflow: TextOverflow.ellipsis,
              style: textTheme.bodySmall!.copyWith(
                color: note.contentColor ?? (note.backgroundIndex != null
                        ? AppTheme.onMediumEmphasise(context)
                        : AppTheme.mediumEmphasise(context)),
              ),
            ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                note.created.toLocalizedText(ref.context),
                maxLines: 1,
                softWrap: false,
                overflow: TextOverflow.fade,
                style: textTheme.labelSmall!.copyWith(
                  color: note.backgroundIndex != null 
                      ? AppTheme.onLowEmphasise(context) 
                      : AppTheme.lowEmphasise(context),
                ),
              ),
              if (barState.active)
                Theme(
                  data: Theme.of(context).copyWith(
                    radioTheme: RadioThemeData(
                      fillColor: note.backgroundIndex != null
                          ? MaterialStatePropertyAll(AppTheme.onInactive(context))
                          : MaterialStatePropertyAll(AppTheme.inactive(context)),
                    ),
                  ),
                  child: Radio(
                    value: true,
                    groupValue: barState.notes.contains(note),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                    activeColor: note.backgroundIndex == null
                        ? Theme.of(ref.context).primaryColor
                        : AppTheme.highEmphasise(context),
                    onChanged: (_) => ref.read(contextualBarController.notifier).onTapCard(note),
                  ),
                ),
            ],
          ),
          if (note.labelIDs.isNotEmpty && showLabels) const SizedBox(height: 8),
          if (note.labelIDs.isNotEmpty && showLabels)
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: [
                ...controller
                    .getCurrentLabels(note, limit)
                    .map((label) => buildChip(label.name, backgroundColor, textTheme.labelSmall!)),
                if (residuals.sign == 1) buildChip('+$residuals', backgroundColor, textTheme.labelSmall!)
              ],
            ),
        ],
      ),
    );
  }

  Widget buildChip(String label, Color color, TextStyle style) {
    return Material(
      color: color,
      textStyle: style,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
      ),
    );
  }
}
