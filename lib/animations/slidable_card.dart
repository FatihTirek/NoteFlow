import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../extensions/iterable_extension.dart';

class SlidableCard extends ConsumerStatefulWidget {
  final Widget child;
  final List<SlidableCardAction> actions;

  const SlidableCard({required this.child, required this.actions});

  @override
  _SlidableCardState createState() => _SlidableCardState();
}

class _SlidableCardState extends ConsumerState<SlidableCard> with SingleTickerProviderStateMixin {
  late AnimationController controller;

  double begin = 0;
  double end = 0;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final value = begin.abs() / 224;
    final animation = Tween(end: end == 0 ? 0.0 : 1.0, begin: 0.5 + (value > 0.5 ? 0.5 : value))
        .animate(CurvedAnimation(parent: controller, curve: Curves.ease));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.centerRight,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: widget.actions
                .map<Widget>(
                  (child) => FadeTransition(
                    opacity: animation,
                    child: ScaleTransition(
                      scale: animation,
                      child: GestureDetector(
                        child: child,
                        onTap: () {
                          resetAnimation();
                          child.onTap();
                        },
                      ),
                    ),
                  ),
                )
                .intersperse(const SizedBox(width: 8))
                .toList(),
          ),
          AnimatedBuilder(
            animation: controller,
            child: GestureDetector(
              child: widget.child,
              onHorizontalDragEnd: onDragEnd,
              onHorizontalDragUpdate: onDragUpdate,
            ),
            builder: (_, child) => Transform.translate(
              offset: Offset(translate().value, 0),
              child: child,
            ),
          ),
        ],
      ),
    );
  }

  void onDragEnd(DragEndDetails details) async {
    if ((begin <= -24 && end == 0) || (begin <= -80 && end == -112)) {
      setState(() {
        end = -112;
      });
      await controller.forward();
      setState(() {
        begin = -112;
      });
      controller.reset();
    } else {
      resetAnimation();
    }
  }

  void onDragUpdate(DragUpdateDetails details) {
    if (begin <= 0) {
      final value = begin + details.primaryDelta!;

      setState(() {
        if (value > 0)
          begin = 0;
        else
          begin = value;
      });
    }
  }

  void resetAnimation() async {
    setState(() {
      end = 0;
    });
    await controller.forward();
    setState(() {
      begin = 0;
    });
    controller.reset();
  }

  Animation<double> translate() {
    return Tween(begin: begin, end: end).animate(
      CurvedAnimation(
        curve: Curves.ease,
        parent: controller,
      ),
    );
  }
}

class SlidableCardAction extends StatelessWidget {
  final Icon icon;
  final VoidCallback onTap;
  final BorderSide borderSide;
  final Color backgroundColor;

  const SlidableCardAction({
    required this.icon,
    required this.onTap,
    required this.borderSide,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      shape: CircleBorder(side: borderSide),
      child: Padding(padding: const EdgeInsets.all(12), child: icon),
    );
  }
}
