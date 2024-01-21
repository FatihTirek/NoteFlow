import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/widgets/shared/contextual_appbar_controller.dart';
import '../../i18n/localizations.dart';
import '../../models/note.dart';
import '../../theme/app_theme.dart';

enum _PopUpMenuOption { Move, Delete }

class ContextualAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final List<Note> notes;
  final bool sliver;

  const ContextualAppBar(this.notes, {this.sliver = false});

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(contextualBarController.notifier);
    final textTheme = Theme.of(context).textTheme;

    if (sliver) {
      return SliverAppBar(
        pinned: true,
        forceElevated: false,
        actions: buildActions(ref),
        leading: IconButton(icon: Icon(Icons.clear_rounded), onPressed: controller.closeBar),
        title: Text(ref.watch(contextualBarController).notes.length.toString(), style: textTheme.titleLarge),
      );
    }

    return AppBar(
      actions: buildActions(ref),
      leading: IconButton(icon: Icon(Icons.clear_rounded), onPressed: controller.closeBar),
      title: Text(ref.watch(contextualBarController).notes.length.toString(), style: textTheme.titleLarge),
    );
  }

  List<Widget> buildActions(WidgetRef ref) {
    final textTheme = Theme.of(ref.context).textTheme;

    return [
      IconButton(
        icon: Icon(Icons.select_all_outlined),
        onPressed: () => ref.read(contextualBarController.notifier).onTapSelectAll(notes),
      ),
      IconButton(
        icon: Icon(Icons.push_pin_outlined),
        onPressed: ref.read(contextualBarController.notifier).onTapPin,
      ),
      PopupMenuButton(
        icon: Icon(Icons.more_vert_outlined),
        onSelected: (option) {
          switch (option) {
            case _PopUpMenuOption.Move:
              ref.read(contextualBarController.notifier).onTapMove(ref);
              break;
            case _PopUpMenuOption.Delete:
              ref.read(contextualBarController.notifier).onTapDelete(ref);
              break;
          }
        },
        itemBuilder: (_) => [
          PopupMenuItem(
            value: _PopUpMenuOption.Move,
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: ListTile(
              dense: true,
              horizontalTitleGap: 0,
              title: Text(AppLocalizations.instance.w23, style: textTheme.labelMedium),
              leading: Icon(Icons.drive_file_move_outlined, color: AppTheme.lowEmphasise(ref.context)),
            ),
          ),
          PopupMenuItem(
            value: _PopUpMenuOption.Delete,
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: ListTile(
              dense: true,
              horizontalTitleGap: 0,
              title: Text(AppLocalizations.instance.w24, style: textTheme.labelMedium),
              leading: Icon(Icons.delete_outline_rounded, color: AppTheme.lowEmphasise(ref.context)),
            ),
          ),
        ],
      ),
    ];
  }
}
