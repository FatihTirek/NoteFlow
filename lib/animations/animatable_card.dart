import 'package:flutter/material.dart';

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

  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    if (controller.contains(widget.id))
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await animationController.forward();
        controller.remove(widget.id);
      });
    else
      animationController.value = 1;
  }

  @override
  void dispose() {
    animationController.dispose();
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
    return CurveTween(curve: const Interval(0.5, 0.8)).animate(animationController);
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
        .animate(animationController);
  }

  Animation<double> sizeEnterAnimation() {
    return Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
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

class AnimatableCardEntranceController {
  static final _instance = AnimatableCardEntranceController._internal();

  static AnimatableCardEntranceController get instance => _instance;

  AnimatableCardEntranceController._internal();

  final _elements = <String>[];

  void add(String id) => _elements.add(id);
  void remove(String id) => _elements.remove(id);
  bool contains(String id) => _elements.contains(id);
}
