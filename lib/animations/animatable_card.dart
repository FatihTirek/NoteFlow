import 'package:flutter/material.dart';

import 'animatable_card_entrance_controller.dart';

class AnimatableCard extends StatefulWidget {
  final String id;
  final Widget child;
  final AnimationController exitAnimController;

  const AnimatableCard({
    required this.id,
    required this.child,
    required this.exitAnimController,
  });

  @override
  State<AnimatableCard> createState() => _AnimatableCardState();
}

class _AnimatableCardState extends State<AnimatableCard> with SingleTickerProviderStateMixin {
  final controller = AnimatableCardEntranceController.instance;

  late AnimationController entranceAnimController;

  @override
  void initState() {
    super.initState();
    entranceAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    if (controller.contains(widget.id))
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await entranceAnimController.forward();
        controller.remove(widget.id);
      });
    else
      entranceAnimController.value = 1.0;
  }

  @override
  void dispose() {
    entranceAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: fadeEnterAnimation(),
      child: FadeTransition(
        opacity: fadeExitAnimation(),
        child: SizeTransition(
          sizeFactor: sizeEnterAnimation(),
          child: SizeTransition(
            sizeFactor: sizeExitAnimation(),
            child: ScaleTransition(
              scale: scaleAnimation(),
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }

  Animation<double> fadeEnterAnimation() {
    return CurveTween(curve: const Interval(0.5, 0.8)).animate(entranceAnimController);
  }

  Animation<double> fadeExitAnimation() {
    return Tween(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: widget.exitAnimController,
        curve: Interval(0.0, 0.5, curve: Curves.ease),
      ),
    );
  }

  Animation<double> scaleAnimation() {
    return Tween<double>(begin: 0.80, end: 1.00)
        .chain(CurveTween(curve: Curves.ease))
        .animate(entranceAnimController);
  }

  Animation<double> sizeEnterAnimation() {
    return Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: entranceAnimController,
        curve: Interval(0.0, 0.5, curve: Curves.ease),
      ),
    );
  }

  Animation<double> sizeExitAnimation() {
    return Tween(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: widget.exitAnimController,
        curve: Interval(0.5, 1.0, curve: Curves.ease),
      ),
    );
  }
}
