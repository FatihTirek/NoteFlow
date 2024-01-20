import 'package:animations/animations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import '../../theme/app_theme_state.dart';
import '../../widgets/dialogs/folder_dialog.dart';
import '../../widgets/sheets/sort_type_picker.dart';
import '../../models/folder.dart';
import '../../services/folder_service.dart';
import '../../utils.dart';
import '../widgets/shared/app_theme_controller.dart';

class AllFoldersViewController with Utils {
  final WidgetRef ref;
  final AnimationController animationController;

  late ValueNotifier<bool> searchMode;
  late ValueNotifier<bool> showClearButton;
  late ValueNotifier<List<Folder>> searchedFolders;

  late List<Folder> cachedAllFolders;
  late TextEditingController textEditingController;

  AllFoldersViewController(this.ref, this.animationController) {
    searchMode = ValueNotifier(false);
    searchedFolders = ValueNotifier([]);
    showClearButton = ValueNotifier(false);
    textEditingController = TextEditingController();
  }

  ValueListenable get listenable => GetIt.I<FolderService>().listenable;

  List<Folder> getAllFolders(FolderSortType folderSortType) {
    final folders = GetIt.I<FolderService>().getAllSorted(folderSortType);

    cachedAllFolders = folders;
    return folders;
  }

  void closeSearchBarIfOpened() {
    if (searchMode.value) onSearchBarClose();
  }

  void dispose() {
    textEditingController.dispose();
    animationController.dispose();
  }

  void showFolderDialog() =>
      showModal(context: ref.context, builder: (_) => FolderDialog());

  void showSortPicker() async {
    final value = await showSheet(ref.context, SortTypePicker(SortTypePickerMode.Folder));
    if (value != null) ref.read(appThemeController.notifier).setFolderSortType(value);
  }

  void onSearchBarOpen() async {
    await animationController.forward();
    searchMode.value = true;
    searchedFolders.value = cachedAllFolders;
  }

  void onSearchBarClose() async {
    await animationController.reverse();
    searchMode.value = false;
    onTapClear();
  }

  void onChanged(String text) {
    if (text.isNotEmpty) {
      final folders = GetIt.I<FolderService>().search(text, cachedAllFolders);

      showClearButton.value = true;
      searchedFolders.value = folders;
    } else {
      showClearButton.value = false;
      searchedFolders.value = cachedAllFolders;
    }
  }

  void onTapClear() {
    textEditingController.clear();
    showClearButton.value = false;
    searchedFolders.value = cachedAllFolders;
  }
}
