import 'package:backdrop/backdrop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:noteflow/controllers/widgets/shared/app_theme_controller.dart';

import '../constants.dart';
import '../extensions/text_style_extension.dart';
import '../controllers/views/filter_view_controller.dart';
import '../controllers/widgets/shared/contextual_appbar_controller.dart';
import '../i18n/localizations.dart';
import '../models/folder.dart';
import '../widgets/shared/app_filter_chip.dart';
import '../widgets/shared/app_floating_action_button.dart';
import '../widgets/shared/contextual_app_bar.dart';
import '../widgets/shared/note_layout_resolver.dart';

class FilterView extends ConsumerStatefulWidget {
  final Folder? folder;

  const FilterView({this.folder});

  @override
  _FilterViewState createState() => _FilterViewState();
}

class _FilterViewState extends ConsumerState<FilterView> {
  late FilterViewController controller;

  @override
  void initState() {
    super.initState();
    controller = FilterViewController(ref, widget.folder);
  }
  
  @override
  Widget build(BuildContext context) {
    print(controller.cachedCurrentDisplayedNotes);
    final titleLarge = Theme.of(context).textTheme.titleLarge!;
    final background = Theme.of(context).colorScheme.background;
    final active = ref.watch(contextualBarController.select((state) => state.active));

    return PopScope(
      canPop: !active,
      onPopInvoked: (_) => ref.read(contextualBarController.notifier).closeBarIfNeeded(),
      child: BackdropScaffold(
        stickyFrontLayer: true,
        floatingActionButton: widget.folder != null ? AppFloatingActionButton(folderID: widget.folder!.id) : null,
        revealBackLayerAtStart: widget.folder == null,
        frontLayerScrim: Colors.black54,
        backLayerBackgroundColor: background,
        frontLayerBackgroundColor: background,
        frontLayerShape: const RoundedRectangleBorder(),
        appBar: active
            ? ContextualAppBar(controller.cachedCurrentDisplayedNotes)
            : BackdropAppBar(
                automaticallyImplyLeading: false,
                actions: [
                  IconButton(
                    onPressed: () => controller.showSortPicker(ref), 
                    icon: Icon(Icons.sort_outlined), 
                    iconSize: 25,
                    ), 
                  BackdropToggleButton(color: titleLarge.color!),
                  ],
                title: Text(widget.folder?.name ?? AppLocalizations.instance.w86, style: titleLarge),
                leading: IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.arrow_back_outlined)),
              ),
        backLayer: Column(
          mainAxisSize: MainAxisSize.min,
          children: [buildColorListView(ref), buildLabelGridView(ref)],
        ),
        frontLayer: AnimatedBuilder(
          builder: (_, __) => NoteLayoutResolver(controller.getFilteredNotes()),
          animation: Listenable.merge(
            [
              controller.selectedBackgroundIndexes,
              controller.noteListenable(),
              controller.selectedLabelIDs,
              controller.selectedSortType,
            ],
          ),
        ),
      ),
    );
  }

  Widget buildColorListView(WidgetRef ref) {
    return SizedBox(
      height: 64,
      child: ListView.separated(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemCount: ColorConstants.noteBackgroundsLight.length + 1,
        itemBuilder: (_, index) => ValueListenableBuilder(
          valueListenable: controller.selectedBackgroundIndexes,
          builder: (_, value, __) {
            final val = index == 0 ? null : index - 1;
            return buildColorBox(ref, val, value.contains(val));
          },
        ),
      ),
    );
  }

  Widget buildColorBox(WidgetRef ref, int? index, bool contains) {
    return GestureDetector(
      onTap: () => controller.onSelectColor(contains, index),
      child: SizedBox(
        width: 48,
        height: 48,
        child: Material(
          color: controller.getNoteBackgroundColor(ref, index),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: contains
                ? BorderSide(color: Theme.of(ref.context).primaryColor, width: 1.25)
                : index == null
                    ? BorderSide(color: Theme.of(ref.context).colorScheme.outline, width: 1.25)
                    : BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget buildLabelGridView(WidgetRef ref) {
    final bodyMedium = Theme.of(ref.context).textTheme.bodyMedium!;

    return SizedBox(
      height: 2 * (bodyMedium.getSingleLineTextHeight(ref.context) + 16) + 38,
      child: ValueListenableBuilder(
        valueListenable: controller.noteListenable(),
        builder: (_, __, ___) {
          final labels =  ref.read(appThemeController).showOnlyUsedLabelsInFilter 
              ? controller.getOnlyUsedLabels(ref)
              : controller.getAllLabels(ref);

          return MasonryGridView.builder(
            mainAxisSpacing: 6,
            crossAxisSpacing: 6,
            itemCount: labels.length,
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
            padding: const EdgeInsets.all(16),
            gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemBuilder: (_, index) {
              final label = labels[index];

              return ValueListenableBuilder(
                valueListenable: controller.selectedLabelIDs,
                builder: (_, value, __) {
                  final selected = value.contains(label.id);

                  return AppFilterChip(
                    label: label.name,
                    selected: selected,
                    onSelected: (value) => controller.onSelectLabel(value, label),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
