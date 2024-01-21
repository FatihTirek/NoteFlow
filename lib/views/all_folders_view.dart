import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../animations/bouncing_app_bar_animator.dart';
import '../controllers/views/all_folders_view_controller.dart';
import '../controllers/widgets/shared/app_theme_controller.dart';
import '../i18n/localizations.dart';
import '../widgets/cards/folder_card.dart';
import '../widgets/shared/app_context_menu.dart';

class AllFoldersView extends ConsumerStatefulWidget {
  @override
  _AllFoldersViewState createState() => _AllFoldersViewState();
}

class _AllFoldersViewState extends ConsumerState<AllFoldersView> with SingleTickerProviderStateMixin {
  late AllFoldersViewController controller;

  @override
  void initState() {
    super.initState();
    controller = AllFoldersViewController(
      ref,
      AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 600),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final folderSortType = ref.watch(appThemeController.select((state) => state.folderSortType));

    return ValueListenableBuilder(
      valueListenable: controller.searchMode,
      builder: (_, value, child) => PopScope(
        child: child!,
        canPop: !value,
        onPopInvoked: (_) => controller.closeSearchBarIfOpened(),
      ),
      child: Scaffold(
        appBar: BouncingAppBarAnimator(
          main: buildAppBar(),
          other: buildSearchBar(),
          controller: controller.animationController,
        ),
        body: AnimatedBuilder(
          animation: Listenable.merge([
            controller.listenable,
            controller.searchMode,
            controller.searchedFolders,
          ]),
          builder: (_, __) {
            final folders = controller.searchMode.value
                ? controller.searchedFolders.value
                : controller.getAllFolders(folderSortType);

            return ListView.separated(
              itemCount: folders.length,
              padding: const EdgeInsets.symmetric(vertical: 16),
              itemBuilder: (_, index) => FolderCard(folders[index]),
              separatorBuilder: (_, __) => const SizedBox(height: 8),
            );
          },
        ),
      ),
    );
  }

  PreferredSizeWidget buildSearchBar() {
    final titleMedium = Theme.of(context).textTheme.titleMedium!;
    final primaryColor = Theme.of(context).primaryColor;

    return AppBar(
      leading: IconButton(
        onPressed: controller.onSearchBarClose,
        icon: Icon(Icons.arrow_back_rounded),
      ),
      title: TextField(
        autofocus: true,
        style: titleMedium,
        cursorColor: primaryColor,
        onChanged: controller.onChanged,
        controller: controller.textEditingController,
        contextMenuBuilder: (_, editableTextState) => AppContextMenu(editableTextState),
        decoration: InputDecoration.collapsed(
          hintText: AppLocalizations.instance.w12,
          hintStyle: titleMedium.copyWith(color: primaryColor),
        ),
      ),
      actions: [
        ValueListenableBuilder(
          valueListenable: controller.showClearButton,
          builder: (_, value, child) {
            if (value) return child!;
            return const SizedBox.shrink();
          },
          child: IconButton(
            onPressed: controller.onTapClear,
            icon: Icon(Icons.clear_rounded),
          ),
        )
      ],
    );
  }

  PreferredSizeWidget buildAppBar() {
    return AppBar(
      title: Text(
        AppLocalizations.instance.w11,
        style: Theme.of(context).textTheme.titleLarge,
      ),
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Icon(Icons.arrow_back_rounded),
      ),
      actions: [
        IconButton(
          onPressed: controller.onSearchBarOpen,
          icon: Icon(Icons.search_outlined),
        ),
        IconButton(
          onPressed: controller.showSortPicker,
          icon: Icon(Icons.sort_outlined),
        ),
        IconButton(
          onPressed: controller.showFolderDialog,
          icon: Icon(Icons.create_new_folder_outlined),
        ),
      ],
    );
  }
}
