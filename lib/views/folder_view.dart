import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/views/folder_view_controller.dart';
import '../controllers/widgets/shared/contextual_appbar_controller.dart';
import '../models/folder.dart';
import '../widgets/shared/app_floating_action_button.dart';
import '../widgets/shared/contextual_app_bar.dart';
import '../widgets/shared/note_layout_resolver.dart';

class FolderView extends ConsumerWidget {
  final FolderViewController controller;
  final Folder folder;

  FolderView({required this.folder}) : controller = FolderViewController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final active = ref.watch(contextualBarController.select((state) => state.active));

    PreferredSizeWidget appbar;

    if (active) {
      appbar = ContextualAppBar(controller.cachedNotes);
    } else {
      appbar = AppBar(
        title: Text(folder.name, style: Theme.of(context).textTheme.titleLarge),
        leading: IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.arrow_back_rounded)),
      );
    }

    return PopScope(
      canPop: !active,
      onPopInvoked: (_) => ref.read(contextualBarController.notifier).closeBarIfNeeded(),
      child: Scaffold(
        appBar: appbar,
        floatingActionButton: AppFloatingActionButton(folderID: folder.id),
        body: ValueListenableBuilder(
          valueListenable: controller.listenable(),
          builder: (_, __, ___) => NoteLayoutResolver(controller.getNotesFromFolderID(ref, folder.id)),
        ),
      ),
    );
  }
}
