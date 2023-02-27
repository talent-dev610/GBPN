import 'dart:async';

import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class OverlayUtils {
  static Timer? _toastTimer;
  static OverlayEntry? _overlayEntry;

  static void overlay(
      {required BuildContext context,
        required Widget child,
        required Alignment alignment,
        required Duration duration}) {
    if(_overlayEntry == null)
      if (_toastTimer == null || !_toastTimer!.isActive) {
        _overlayEntry = createOverlayEntry(context, child, alignment);
        Overlay.of(context)!.insert(_overlayEntry!);
      }
  }

  static removeOverlay() {
    if(_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
  }

  static hasOverlay() => _overlayEntry != null;


  static OverlayEntry createOverlayEntry(
      BuildContext context, Widget child, Alignment alignment) {
    return OverlayEntry(
      builder: (context) => Align(
        alignment: alignment,
        child:
        ToastMessageAnimation(
          Material(
            color: Colors.transparent,
            child: child,
          ),
        ),
      ),
    );
  }
}

class ToastMessageAnimation extends StatelessWidget {
  final Widget child;
  ToastMessageAnimation(this.child);
  @override
  Widget build(BuildContext context) {
    final tween = MultiTween()
      ..add("translateY", Tween(begin: -100.0, end: 0), const Duration(milliseconds: 250), Curves.easeOut)
      ..add("opacity", Tween(begin: 0.0, end: 1.0), const Duration(milliseconds: 500));

    return PlayAnimation<MultiTweenValues>(
      duration: tween.duration,
      tween: tween,
      child: child,
      builder: (context, child, animation) => Opacity(
        opacity: animation.get("opacity"),
        child: Transform.translate(
            offset: Offset(0, animation.get("translateY").toDouble()), child: child),
      ),
    );
  }
}
