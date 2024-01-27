import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/main_controller.dart';
import '../controllers/views/home_view_controller.dart';
import '../controllers/widgets/shared/app_theme_controller.dart';
import '../controllers/widgets/shared/contextual_appbar_controller.dart';
import '../i18n/localizations.dart';
import '../models/app_widget_launch_details.dart';
import '../theme/app_theme.dart';
import '../widgets/shared/app_floating_action_button.dart';
import '../widgets/shared/contextual_app_bar.dart';
import '../widgets/shared/note_layout_resolver.dart';

enum _PopUpMenuOption { Search, Filter, Labels, Folders, Settings }

class HomeView extends ConsumerStatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  late HomeViewController controller;

  @override
  void initState() {
    super.initState();
    controller = HomeViewController(ref);
    controller.initState(mounted);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final primaryColor = Theme.of(context).primaryColor;
    final active = ref.watch(contextualBarController.select((state) => state.active));
    final isGridView = ref.watch(appThemeController.select((state) => state.isGridView));
    final isSelectAction = noteWidgetLaunchDetails.launchAction == NoteWidgetLaunchAction.Select;

    return PopScope(
      canPop: !active,
      onPopInvoked: (_) => ref.read(contextualBarController.notifier).closeBarIfNeeded(),
      child: ValueListenableBuilder(
        valueListenable: controller.allFolders,
        builder: (_, __, ___) {
          return DefaultTabController(
            initialIndex: controller.getStartupFolderIndex(),
            length: controller.allFolders.value.length + 1,
            child: Builder(
              builder: (context) => Scaffold(
                floatingActionButton: isSelectAction ? null : AppFloatingActionButton(),
                body: NestedScrollView(
                  floatHeaderSlivers: true,
                  body: buildTabBarView(active),
                  headerSliverBuilder: (_, __) => [
                    active
                        ? ContextualAppBar(
                            controller.getCurrentNotes(DefaultTabController.of(context).index),
                            sliver: true,
                          )
                        : SliverAppBar(
                            snap: true,
                            pinned: true,
                            floating: true,
                            forceElevated: false,
                            automaticallyImplyLeading: false,
                            title: Text(
                              isSelectAction ? AppLocalizations.instance.w119 : 'NoteFlow',
                              style: textTheme.titleLarge,
                            ),
                            leading: isSelectAction
                                ? IconButton(
                                    onPressed: () => SystemNavigator.pop(),
                                    icon: Icon(Icons.arrow_back_outlined),
                                  )
                                : null,
                            actions: isSelectAction
                                ? null
                                : [
                                    IconButton(
                                      onPressed: controller.showSortPicker,
                                      icon: Icon(Icons.sort_outlined),
                                      iconSize: 25,
                                    ),
                                    IconButton(
                                      iconSize: isGridView ? 26 : 24,
                                      onPressed: ref.read(appThemeController.notifier).setIsGridView,
                                      icon: Icon(isGridView ? Icons.view_list_outlined : Icons.grid_view_outlined),
                                    ),
                                    buildPopUpMenu()
                                  ],
                            bottom: PreferredSize(
                              preferredSize: const Size.fromHeight(49.5),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: TabBar(
                                  isScrollable: true,
                                  indicatorWeight: 3.5,
                                  labelColor: primaryColor,
                                  indicatorColor: primaryColor,
                                  labelStyle: textTheme.titleSmall,
                                  indicatorSize: TabBarIndicatorSize.label,
                                  tabs: [
                                    Tab(text: AppLocalizations.instance.w5),
                                    ...controller.allFolders.value.map((folder) => Tab(text: folder.name)).toList()
                                  ],
                                  unselectedLabelColor: AppTheme.lowEmphasise(context),
                                  overlayColor: MaterialStateProperty.all(Theme.of(context).splashColor),
                                ),
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildPopUpMenu() {
    final items = [
      {
        'enum': _PopUpMenuOption.Search,
        'icon': Icons.search_outlined,
        'text': AppLocalizations.instance.w12,
      },
      {
        'enum': _PopUpMenuOption.Filter,
        'icon': Icons.filter_alt_outlined,
        'text': AppLocalizations.instance.w128,
      },
      {
        'enum': _PopUpMenuOption.Labels,
        'icon': Icons.label_outline,
        'text': AppLocalizations.instance.w83,
      },
      {
        'enum': _PopUpMenuOption.Folders,
        'icon': Icons.folder_open_outlined,
        'text': AppLocalizations.instance.w11,
      },
      {
        'enum': _PopUpMenuOption.Settings,
        'icon': Icons.settings_outlined,
        'text': AppLocalizations.instance.w26,
      },
    ];

    return PopupMenuButton<_PopUpMenuOption>(
      tooltip: '',
      icon: Icon(Icons.more_vert_outlined),
      onSelected: (option) {
        switch (option) {
          case _PopUpMenuOption.Labels:
            controller.goAllLabelsView();
            break;
          case _PopUpMenuOption.Folders:
            controller.goAllFoldersView();
            break;
          case _PopUpMenuOption.Settings:
            controller.goSettingsView();
            break;
          case _PopUpMenuOption.Search:
            controller.goSearchView();
            break;
          case _PopUpMenuOption.Filter:
            controller.goFilterView();
            break;
        }
      },
      itemBuilder: (_) => [
        ...items
            .map(
              (item) => PopupMenuItem(
                value: item['enum'] as _PopUpMenuOption,
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: ListTile(
                  dense: true,
                  horizontalTitleGap: 0,
                  leading: Icon(item['icon'] as IconData, color: AppTheme.lowEmphasise(context)),
                  title: Text(item['text'] as String, style: Theme.of(context).textTheme.labelMedium),
                ),
              ),
            )
            .toList()
      ]..insert(2, PopupMenuDivider()),
    );
  }

  Widget buildTabBarView(bool active) {
    return ValueListenableBuilder(
      valueListenable: controller.allNotes,
      builder: (_, value, __) {
        return TabBarView(
          physics: active ? const NeverScrollableScrollPhysics() : const PageScrollPhysics(),
          children: [
            NoteLayoutResolver(value, hasAnimation: true),
            ...controller.allFolders.value
                .map(
                  (folder) => NoteLayoutResolver(
                    controller.getNotesFromFolderID(folder.id),
                    hasAnimation: true,
                  ),
                )
                .toList()
          ],
        );
      },
    );
  }
}
