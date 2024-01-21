import 'package:animations/animations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import '../../../constants.dart';
import '../../../models/folder.dart';
import '../../../services/folder_service.dart';
import '../../../widgets/dialogs/folder_dialog.dart';
import '../shared/app_theme_controller.dart';

class FolderPickerController {
  ValueListenable listenable() => GetIt.I<FolderService>().listenable;

  List<Folder> getAllFolders(WidgetRef ref) => GetIt.I<FolderService>().getAllSorted(ref.read(appThemeController).folderSortType);

  void showFolderDialog(BuildContext context) => showModal(context: context, builder: (_) => FolderDialog());

  void onTapClear(BuildContext context) => Navigator.pop(context, StringConstants.clearFlag);

  void onTapFolder(Folder folder, BuildContext context) => Navigator.pop(context, folder.id);
}
