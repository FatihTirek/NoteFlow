import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/views/search_view_controller.dart';
import '../controllers/widgets/shared/contextual_appbar_controller.dart';
import '../i18n/localizations.dart';
import '../theme/app_theme.dart';
import '../widgets/shared/contextual_app_bar.dart';
import '../widgets/shared/app_context_menu.dart';
import '../widgets/shared/note_layout_resolver.dart';

class SearchView extends ConsumerStatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends ConsumerState<SearchView> {
  late SearchViewController controller;

  @override
  void initState() {
    super.initState();
    controller = SearchViewController(ref);
    controller.initState(mounted);

    KeyboardVisibilityController().onChange.listen((visible) {
      if (!visible && mounted) FocusScope.of(context).unfocus();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bodyLarge = Theme.of(context).textTheme.bodyLarge!;
    final active = ref.watch(contextualBarController.select((state) => state.active));

    return PopScope(
      canPop: !active,
      onPopInvoked: (_) => ref.read(contextualBarController.notifier).closeBarIfNeeded(),
      child: Scaffold(
        appBar: active
            ? ContextualAppBar(controller.cachedAllNotes) as PreferredSizeWidget
            : AppBar(
                leading: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.arrow_back_rounded),
                ),
                title: TextField(
                  autofocus: true,
                  style: bodyLarge,
                  onChanged: controller.onChanged,
                  cursorColor: Theme.of(context).primaryColor,
                  textAlignVertical: TextAlignVertical.bottom,
                  controller: controller.textEditingController,
                  decoration: InputDecoration(
                    filled: true,
                    isDense: true,
                    hintText: AppLocalizations.instance.w16,
                    fillColor: Theme.of(context).colorScheme.onSurface,
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    hintStyle: bodyLarge.copyWith(color: AppTheme.lowEmphasise(context)),
                    border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(8)),
                  ),
                  contextMenuBuilder: (_, editableTextState) => AppContextMenu(editableTextState),
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
              ),
        body: ValueListenableBuilder(
          valueListenable: controller.searchedNotes,
          builder: (_, value, __) => NoteLayoutResolver(value),
        ),
      ),
    );
  }
}
