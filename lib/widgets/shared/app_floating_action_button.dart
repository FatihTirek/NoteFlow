import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../extensions/color_extension.dart';
import '../../controllers/widgets/shared/contextual_appbar_controller.dart';
import '../../views/note_view.dart';

class AppFloatingActionButton extends ConsumerStatefulWidget {
  final String? folderID;

  const AppFloatingActionButton({this.folderID});

  @override
  _AnimatedFloatingActionButtonState createState() => _AnimatedFloatingActionButtonState();
}

class _AnimatedFloatingActionButtonState extends ConsumerState<AppFloatingActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      value: 1.0,
      vsync: this,
      duration: kThemeAnimationDuration,
    );

    ref.listenManual(contextualBarController, (previous, next) {
      if (mounted) {
        if (next.active)
          controller.reverse();
        else
          controller.forward();
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return AnimatedBuilder(
      animation: controller,
      builder: (_, child) => FadeScaleTransition(animation: controller, child: child),
      child: Visibility(
        visible: controller.status != AnimationStatus.dismissed,
        child: OpenContainer(
          openElevation: 0,
          closedElevation: 6,
          closedColor: primaryColor,
          openColor: Theme.of(context).colorScheme.surface,
          transitionType: ContainerTransitionType.fadeThrough,
          openBuilder: (_, __) => NoteView(folderID: widget.folderID),
          closedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(64)),
          closedBuilder: (_, __) => SizedBox(
            width: 60,
            height: 60,
            child: Center(
              child: Icon(
                Icons.add_outlined,
                color: primaryColor.getOnTextColor(),
                size: 30,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
