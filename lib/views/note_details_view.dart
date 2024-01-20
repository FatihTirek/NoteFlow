import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/views/note_details_view_controller.dart';
import '../controllers/widgets/shared/app_theme_controller.dart';
import '../i18n/localizations.dart';
import '../models/note.dart';
import '../theme/app_theme.dart';
import '../utils.dart';
import '../widgets/shared/app_context_menu.dart';

enum _PopUpMenuOption { Pin, Share, Delete }

class NoteDetailsView extends ConsumerStatefulWidget {
  final Note? note;
  final String? folderID;

  const NoteDetailsView({this.note, this.folderID});

  @override
  _NoteDetailsViewState createState() => _NoteDetailsViewState();
}

class _NoteDetailsViewState extends ConsumerState<NoteDetailsView>
    with SingleTickerProviderStateMixin, Utils {
  late NoteDetailsViewController controller;

  final titleFocus = FocusNode();
  final contentFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    controller = NoteDetailsViewController(
      ref,
      widget.note,
      widget.folderID,
      AnimationController(
        value: 1.0,
        vsync: this,
        duration: const Duration(milliseconds: 200),
      ),
    );

    KeyboardVisibilityController().onChange.listen((visible) {
      if (!visible && mounted && (titleFocus.hasFocus || contentFocus.hasFocus))
        controller.onKeyboardClose();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller.selectedBackgroundIndex,
      builder: (_, value, __) {
        final backgroundColor = getNoteBackgroundColor(ref, value);

        return Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: backgroundColor,
          body: buildBody(backgroundColor),
          appBar: buildAppBar(backgroundColor),
        );
      },
    );
  }

  PreferredSizeWidget buildAppBar(Color backgroundColor) {
    return AppBar(
      shape: const RoundedRectangleBorder(),
      backgroundColor: Colors.transparent,
      systemOverlayStyle:
          ThemeData.estimateBrightnessForColor(backgroundColor) == Brightness.light
              ? SystemUiOverlayStyle.dark
              : SystemUiOverlayStyle.light,
      leading: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: IconButton(
          onPressed: controller.onTapExit,
          icon: Icon(Icons.arrow_back_rounded),
        ),
      ),
      actions: [
        ValueListenableBuilder(
          valueListenable: controller.anyFocus,
          child: buildPopUpMenu(),
          builder: (_, value, child) {
            if (value) {
              return FadeScaleTransition(
                animation: controller.animationController,
                child: AnimatedBuilder(
                  animation: Listenable.merge([
                    titleFocus,
                    controller.titleHistoryController,
                    controller.contentHistoryController,
                  ]),
                  builder: (_, child) {
                    final current = titleFocus.hasFocus
                        ? controller.titleHistoryController
                        : controller.contentHistoryController;

                    return Row(
                      children: [
                        IconButton(
                          iconSize: 28,
                          icon: Icon(Icons.undo_rounded),
                          disabledColor: controller.selectedBackgroundIndex.value != null
                              ? AppTheme.onInactive(context)
                              : AppTheme.inactive(context),
                          onPressed: current.value.canUndo ? current.undo : null,
                        ),
                        IconButton(
                          iconSize: 28,
                          icon: Icon(Icons.redo_rounded),
                          disabledColor: controller.selectedBackgroundIndex.value != null
                              ? AppTheme.onInactive(context)
                              : AppTheme.inactive(context),
                          onPressed: current.value.canRedo ? current.redo : null,
                        ),
                        child!
                      ],
                    );
                  },
                  child: IconButton(
                    onPressed: controller.onKeyboardClose,
                    icon: Icon(Icons.done_outline_rounded, size: 22),
                  ),
                ),
              );
            }

            return FadeScaleTransition(
              animation: controller.animationController,
              child: Row(
                children: [
                  IconButton(
                    onPressed: controller.onTapReminder,
                    icon: ValueListenableBuilder(
                      valueListenable: controller.selectedReminder,
                      builder: (_, value, __) => Icon(
                        value?.isAfter(DateTime.now()) ?? false
                            ? Icons.notifications_active
                            : Icons.notifications_none_rounded,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: controller.onTapBackground,
                    icon: Icon(Icons.color_lens_outlined),
                  ),
                  IconButton(
                    onPressed: controller.onTapLabel,
                    icon: ValueListenableBuilder(
                      valueListenable: controller.selectedLabelIDs,
                      builder: (_, value, __) => Icon(
                        value.isNotEmpty ? Icons.label_rounded : Icons.label_outline,
                        size: 26,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: controller.onTapFolder,
                    icon: ValueListenableBuilder(
                      valueListenable: controller.selectedFolderID,
                      builder: (_, value, __) => Icon(
                        value != null ? Icons.folder_rounded : Icons.folder_open_rounded,
                      ),
                    ),
                  ),
                  child!,
                ],
              ),
            );
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget buildBody(Color backgroundColor) {
    final textTheme = Theme.of(context).textTheme;
    final primaryColor = Theme.of(context).primaryColor;
    final showLabels = ref.watch(appThemeController.select((state) => state.showLabels));
    final backgroundColor =
        getOnNoteBackgroundColor(ref, controller.selectedBackgroundIndex.value);

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
          sliver: SliverToBoxAdapter(
            child: ValueListenableBuilder(
              valueListenable: controller.selectedTitleColor,
              builder: (_, value, __) => TextField(
                maxLines: null,
                focusNode: titleFocus,
                cursorColor: primaryColor,
                onTap: controller.onTapTextField,
                controller: controller.titleController,
                undoController: controller.titleHistoryController,
                style: textTheme.headlineMedium!.copyWith(color: value),
                decoration: InputDecoration.collapsed(
                  hintText: AppLocalizations.instance.w6,
                  hintStyle: textTheme.headlineMedium,
                ),
                contextMenuBuilder: (_, editableTextState) =>
                    AppContextMenu(editableTextState),
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
          sliver: ValueListenableBuilder(
            valueListenable: controller.selectedLabelIDs,
            child: ValueListenableBuilder(
              valueListenable: controller.selectedContentColor,
              builder: (_, value, __) => TextField(
                maxLines: null,
                focusNode: contentFocus,
                cursorColor: primaryColor,
                onTap: controller.onTapTextField,
                controller: controller.contentController,
                undoController: controller.contentHistoryController,
                style: textTheme.titleSmall!.copyWith(
                  color: value ??
                      (controller.selectedBackgroundIndex.value != null
                          ? AppTheme.onMediumEmphasise(context)
                          : AppTheme.mediumEmphasise(context)),
                ),
                decoration: InputDecoration.collapsed(
                  hintText: AppLocalizations.instance.w7,
                  hintStyle: textTheme.titleSmall!.copyWith(
                    color: controller.selectedBackgroundIndex.value != null
                        ? AppTheme.onMediumEmphasise(context)
                        : AppTheme.mediumEmphasise(context),
                  ),
                ),
                contextMenuBuilder: (_, editableTextState) =>
                    AppContextMenu(editableTextState),
              ),
            ),
            builder: (_, value, child) => value.isNotEmpty && showLabels
                ? SliverToBoxAdapter(child: child)
                : SliverFillRemaining(hasScrollBody: false, child: child),
          ),
        ),
        if (showLabels)
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            sliver: SliverToBoxAdapter(
              child: ValueListenableBuilder(
                valueListenable: controller.selectedLabelIDs,
                builder: (_, __, ___) => Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    ...controller.getCurrentLabels().map(
                          (label) => Material(
                            color: backgroundColor,
                            textStyle: textTheme.bodySmall,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              child: Text(
                                label.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                          ),
                        ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget buildPopUpMenu() {
    final labelMedium = Theme.of(context).textTheme.labelMedium!;

    return PopupMenuButton(
      tooltip: '',
      icon: Icon(Icons.more_vert_outlined),
      onSelected: (option) {
        switch (option) {
          case _PopUpMenuOption.Pin:
            controller.onTapPin();
            break;
          case _PopUpMenuOption.Share:
            controller.onTapShare();
            break;
          case _PopUpMenuOption.Delete:
            controller.onTapDelete();
            break;
        }
      },
      itemBuilder: (_) => [
        PopupMenuItem(
          value: _PopUpMenuOption.Pin,
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: ListTile(
            dense: true,
            horizontalTitleGap: 0,
            leading: Icon(
              controller.pinned.value ? Icons.push_pin_sharp : Icons.push_pin_outlined,
              color: AppTheme.lowEmphasise(context),
            ),
            title: Text(
              controller.pinned.value
                  ? AppLocalizations.instance.w84
                  : AppLocalizations.instance.w85,
              style: labelMedium,
            ),
          ),
        ),
        PopupMenuItem(
          value: _PopUpMenuOption.Share,
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: ListTile(
            dense: true,
            horizontalTitleGap: 0,
            title: Text(AppLocalizations.instance.w71, style: labelMedium),
            leading: Icon(
              Icons.share_outlined,
              color: AppTheme.lowEmphasise(context),
            ),
          ),
        ),
        PopupMenuItem(
          value: _PopUpMenuOption.Delete,
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: ListTile(
            dense: true,
            horizontalTitleGap: 0,
            title: Text(AppLocalizations.instance.w24, style: labelMedium),
            leading: Icon(
              Icons.delete_outline_rounded,
              color: AppTheme.lowEmphasise(context),
            ),
          ),
        ),
      ],
    );
  }
}
