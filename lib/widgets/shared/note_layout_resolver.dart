import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../controllers/widgets/shared/app_theme_controller.dart';
import '../../models/note.dart';
import '../cards/note_card.dart';

class NoteLayoutResolver extends ConsumerWidget {
  final List<Note> notes;
  final bool hasAnimation;
  final EdgeInsets padding;

  const NoteLayoutResolver(
    this.notes, {
    this.hasAnimation = false,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isGridView = ref.watch(appThemeController.select((state) => state.isGridView));

    Widget widget;

    if (isGridView)
      widget = MasonryGridView.extent(
        padding: padding,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        maxCrossAxisExtent: 200,
        itemCount: notes.length,
        itemBuilder: (_, index) => NoteCard(notes[index]),
      );
    else
      widget = ListView.separated(
        itemCount: notes.length,
        padding: const EdgeInsets.all(16),
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (_, index) => NoteCard(notes[index], isGridView: false),
      );

    if (!hasAnimation) return widget;
    return PageTransitionSwitcher(
      child: widget,
      reverse: !isGridView,
      transitionBuilder: (child, animation, secondaryAnimation) => SharedAxisTransition(
        child: child,
        animation: animation,
        secondaryAnimation: secondaryAnimation,
        transitionType: SharedAxisTransitionType.vertical,
        fillColor: Theme.of(context).scaffoldBackgroundColor,
      ),
    );
  }
}
