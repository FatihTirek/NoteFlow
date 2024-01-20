import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants.dart';
import '../../controllers/widgets/sheets/note_background_picker_controller.dart';
import '../../extensions/color_extension.dart';
import '../../i18n/localizations.dart';
import '../../utils.dart';
import '../shared/app_text_button.dart';

class NoteBackgroundPicker extends ConsumerStatefulWidget {
  final Color? titleColor;
  final Color? contentColor;
  final int? backgroundIndex;

  const NoteBackgroundPicker({
    this.titleColor,
    this.contentColor,
    this.backgroundIndex,
  });

  @override
  _NoteBackgroundPickerState createState() => _NoteBackgroundPickerState();
}

class _NoteBackgroundPickerState extends ConsumerState<NoteBackgroundPicker>
    with SingleTickerProviderStateMixin, Utils {
  late NoteBackgroundPickerController controller;
  late AnimationController animationController;

  static const _duration = const Duration(milliseconds: 300);

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    controller = NoteBackgroundPickerController(
      ref,
      widget.titleColor,
      widget.contentColor,
      widget.backgroundIndex,
    );
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: _duration,
      curve: Curves.easeInOutBack,
      alignment: Alignment.bottomCenter,
      child: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(overscroll: false),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [buildButtons(), buildListView()],
          ),
        ),
      ),
    );
  }

  Widget buildButtons() {
    final primaryColor = Theme.of(context).primaryColor;
    final textColor = primaryColor.getOnTextColor();

    return ValueListenableBuilder(
      valueListenable: controller.showButtons,
      builder: (_, value, child) => Visibility(visible: value, child: child!),
      child: AnimatedOpacity(
        opacity: 1,
        duration: _duration,
        curve: Curves.easeOut,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
          child: Column(
            children: [
              Row(
                children: [
                  ValueListenableBuilder(
                    valueListenable: controller.selectedTitleColor,
                    builder: (_, __, ___) => Expanded(
                      child: AppTextButton(
                        text: AppLocalizations.instance.w6,
                        textColor: controller.selectedTitleColor.value,
                        onPressed: () =>
                            controller.openColorPicker(controller.selectedTitleColor),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  ValueListenableBuilder(
                    valueListenable: controller.selectedContentColor,
                    builder: (_, __, ___) => Expanded(
                      child: AppTextButton(
                        text: AppLocalizations.instance.w72,
                        textColor: controller.selectedContentColor.value,
                        onPressed: () =>
                            controller.openColorPicker(controller.selectedContentColor),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: AppTextButton(
                      text: AppLocalizations.instance.w126,
                      onPressed: controller.onTapReset,
                      backgroundColor: primaryColor,
                      textColor: textColor,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: AppTextButton(
                      text: AppLocalizations.instance.w2,
                      onPressed: controller.onTapDone,
                      backgroundColor: primaryColor,
                      textColor: textColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildListView() {
    return SizedBox(
      height: 174,
      child: ListView.separated(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemCount: ColorConstants.noteBackgroundsLight.length + 1,
        itemBuilder: (_, index) {
          final value = index == 0 ? null : index - 1;

          return GestureDetector(
            child: buildCard(value),
            onTap: () => controller.onTapCard(value),
          );
        },
      ),
    );
  }

  Widget buildCard(int? index) {
    final backgroundColor = getNoteBackgroundColor(ref, index);

    final lineWidget = Container(
      height: 4,
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        color: backgroundColor.getOnTextColor(),
      ),
    );

    final cardWidget = Container(
      width: 87,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: index == null
            ? Border.all(
                width: 1.25,
                color: Theme.of(context).colorScheme.outline,
              )
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          lineWidget,
          lineWidget,
          lineWidget,
          Row(
            children: [Expanded(child: lineWidget), const SizedBox(width: 12)],
          ),
        ],
      ),
    );

    if (controller.selectedBackgroundIndex.value == index) {
      animationController.repeat(reverse: true);

      return ScaleTransition(
        child: cardWidget,
        scale: Tween(begin: 0.75, end: 1.0).animate(
          CurvedAnimation(
            parent: animationController,
            curve: Curves.elasticOut,
          ),
        ),
      );
    }

    return cardWidget;
  }
}
