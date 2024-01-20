import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import '../../../views/folder_view.dart';
import '../../../widgets/dialogs/delete_dialog.dart';
import '../../../widgets/dialogs/folder_dialog.dart';
import '../../../i18n/localizations.dart';
import '../../../models/folder.dart';
import '../../../services/folder_service.dart';

class FolderCardController {
  final WidgetRef ref;
  final AnimationController? animationController;

  const FolderCardController(this.ref, {this.animationController});

  void dispose() => animationController!.dispose();

  void onTapCard(Folder folder) {
    Navigator.push(
      ref.context,
      MaterialPageRoute(builder: (_) => FolderView(folder: folder)),
    );
  }

  void onTapDelete(Folder folder) {
    showModal(
      context: ref.context,
      builder: (_) => DeleteDialog(
        title: AppLocalizations.instance.w19,
        content: AppLocalizations.instance.w20,
        onDelete: () async {
          await animationController!.forward();
          GetIt.I<FolderService>().delete(folder.id);
        },
      ),
    );
  }

  void onTapEdit(Folder folder) {
    showModal(
      context: ref.context,
      builder: (_) => FolderDialog(folder: folder),
    );
  }
}
