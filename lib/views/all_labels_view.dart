import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../animations/bouncing_app_bar_animator.dart';
import '../controllers/views/all_labels_view_controller.dart';
import '../controllers/widgets/shared/app_theme_controller.dart';
import '../i18n/localizations.dart';
import '../widgets/shared/app_context_menu.dart';

class AllLabelsView extends ConsumerStatefulWidget {
  @override
  _AllLabelsViewState createState() => _AllLabelsViewState();
}

class _AllLabelsViewState extends ConsumerState<AllLabelsView> with SingleTickerProviderStateMixin {
  late AllLabelsViewController controller;

  @override
  void initState() {
    super.initState();
    controller = AllLabelsViewController(
      ref,
      AnimationController(
        duration: const Duration(milliseconds: 600),
        vsync: this,
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
    final colorScheme = Theme.of(context).colorScheme;
    final labelSortType = ref.watch(appThemeController.select((state) => state.labelSortType));

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
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: AnimatedBuilder(
            animation: Listenable.merge([
              controller.listenable,
              controller.searchMode,
              controller.searchedLabels,
            ]),
            builder: (_, __) {
              final labels = controller.searchMode.value
                  ? controller.searchedLabels.value
                  : controller.getAllLabels(labelSortType);

              return Wrap(
                spacing: 6,
                runSpacing: 6,
                children: labels
                    .map(
                      (label) => GestureDetector(
                        onTap: () => controller.showLabelDialog(label),
                        child: Material(
                          color: colorScheme.surface,
                          textStyle: Theme.of(context).textTheme.bodyMedium,
                          child: Padding(
                            child: Text(label.name),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(color: colorScheme.outline, width: 1.25),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget buildSearchBar() {
    final primaryColor = Theme.of(context).primaryColor;
    final titleMedium = Theme.of(context).textTheme.titleMedium!;

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
        AppLocalizations.instance.w83,
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
          onPressed: controller.showLabelDialog,
          icon: Icon(Icons.new_label_outlined),
        ),
      ],
    );
  }
}
