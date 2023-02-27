import 'dart:async';

import 'package:flutter/material.dart';

class DialButton extends StatefulWidget {
  final Key? key;
  final String? title;
  final String? subtitle;
  final Color? color;
  final Color? textColor;
  final IconData? icon;
  final Color? iconColor;
  final ValueSetter<String?>? onTap;
  final bool? shouldAnimate;

  // ignore: use_key_in_widget_constructors
  const DialButton({this.key, this.title, this.subtitle, this.color, this.textColor, this.icon, this.iconColor, this.shouldAnimate, this.onTap});

  @override
  _DialButtonState createState() => _DialButtonState();
}

class _DialButtonState extends State<DialButton> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _colorTween;
  Timer? _timer;

  @override
  void initState() {
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _colorTween = ColorTween(begin: widget.color ?? Colors.white24, end: Colors.white).animate(_animationController);

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
    if ((widget.shouldAnimate == null || widget.shouldAnimate!) && _timer != null) _timer!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var sizeFactor = screenSize.height * 0.09852217;

    return GestureDetector(
      onTap: () {
        if (widget.onTap != null) widget.onTap!(widget.title);

        if (widget.shouldAnimate == null || widget.shouldAnimate!) {
          if (_animationController.status == AnimationStatus.completed) {
            _animationController.reverse();
          } else {
            _animationController.forward();
            _timer = Timer(const Duration(milliseconds: 200), () {
              setState(() {
                _animationController.reverse();
              });
            });
          }
        }
      },
      child: ClipOval(
          child: AnimatedBuilder(
              animation: _colorTween,
              builder: (context, child) => Container(
                    color: _colorTween.value,
                    height: sizeFactor,
                    width: sizeFactor,
                    child: Center(
                        child: widget.icon == null
                            ? widget.subtitle != null
                                ? Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      const SizedBox(height: 8),
                                      Text(
                                        widget.title!,
                                        style: TextStyle(fontSize: sizeFactor / 2, color: widget.textColor ?? Colors.black),
                                      ),
                                      Text(widget.subtitle!, style: TextStyle(color: widget.textColor ?? Colors.black))
                                    ],
                                  )
                                : Padding(
                                    padding: EdgeInsets.only(top: widget.title == "*" ? 10 : 0),
                                    child: Text(
                                      widget.title!,
                                      style: TextStyle(fontSize: widget.title == "*" && widget.subtitle == null ? screenSize.height * 0.0862069 : sizeFactor / 2, color: widget.textColor ?? Colors.black),
                                    ))
                            : Icon(widget.icon, size: sizeFactor / 2, color: widget.iconColor ?? Colors.white)),
                  ))),
    );
  }
}
