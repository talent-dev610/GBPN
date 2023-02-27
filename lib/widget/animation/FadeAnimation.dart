import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class FadeAnimation extends StatelessWidget {
  final double delay;
  final Widget child;

  const FadeAnimation(this.delay, this.child, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tween = MultiTween()
    ..add("opacity", Tween(begin: 0.0, end: 1.0), const Duration(milliseconds: 500))
    ..add("translateY", Tween(begin: -30.0, end: 0.0), const Duration(milliseconds: 500), Curves.easeOut);

    return PlayAnimation<MultiTweenValues>(
        delay: Duration(milliseconds: (500 * delay).round()),
        duration: tween.duration,
        child: child,
        builder: (context, child, value) => Opacity(
          opacity: value.get("opacity"),
          child: Transform.translate(
              offset: Offset(0, value.get("translateY")),
              child: child
          ),
        ),
        tween: tween);
  }
}