import 'package:flutter/material.dart';

class BounceableAppBar extends StatelessWidget implements PreferredSizeWidget {
  final PreferredSizeWidget primary;
  final PreferredSizeWidget secondary;
  final AnimationController controller;

  const BounceableAppBar({
    required this.primary,
    required this.secondary,
    required this.controller,
  });

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      child: secondary,
      animation: controller,
      builder: (_, child) {
        if (controller.value <= 0.36) return Opacity(opacity: exit().value, child: primary);

        return Opacity(
          opacity: entrance().value,
          child: Transform.translate(
            offset: Offset(0, slide(context).value),
            child: child,
          ),
        );
      },
    );
  }

  Animation<double> exit() {
    return Tween(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: controller,
        reverseCurve: Curves.linearToEaseOut,
        curve: Interval(0.0, 0.36, curve: Curves.linear),
      ),
    );
  }

  Animation<double> entrance() {
    return Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(0.36, 1.0, curve: Curves.ease),
      ),
    );
  }

  Animation<double> slide(BuildContext context) {
    final begin = MediaQuery.of(context).padding.top + kToolbarHeight;

    return Tween(begin: -begin, end: 0.0).animate(
      CurvedAnimation(
        parent: controller,
        reverseCurve: Curves.ease,
        curve: Interval(0.36, 1.0, curve: Curves.bounceOut),
      ),
    );
  }
}
