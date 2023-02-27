import 'package:flutter/material.dart'
    hide RefreshIndicator, RefreshIndicatorState;
import 'package:shimmer/shimmer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PTRHeader extends RefreshIndicator {
  final Color baseColor, highlightColor;
  final Widget text;
  final Duration period;
  final ShimmerDirection direction;
  final Function? outerBuilder;

  const PTRHeader(
      {Key? key,
      required this.text,
      this.baseColor = Colors.grey,
      this.highlightColor = Colors.white,
      this.outerBuilder,
      this.period = const Duration(milliseconds: 1000),
      this.direction = ShimmerDirection.ltr})
      : super(key: key, height: 30);

  @override
  State<PTRHeader> createState() => _PTRHeaderState();
}

class _PTRHeaderState extends RefreshIndicatorState<PTRHeader>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _fadeController;

  @override
  void initState() {
    _scaleController = AnimationController(vsync: this);
    _fadeController = AnimationController(vsync: this);
    super.initState();
  }

  @override
  void onOffsetChange(double offset) {
    if (!floating) {
      _scaleController.value = offset / configuration!.headerTriggerDistance;
      _fadeController.value = offset / configuration!.footerTriggerDistance;
    }
  }

  @override
  Widget buildContent(BuildContext context, RefreshStatus mode) {
    // TODO: implement buildContent

    final Widget body = ScaleTransition(
      scale: _scaleController,
      child: FadeTransition(
        opacity: _fadeController,
        child: mode == RefreshStatus.refreshing
            ? Shimmer.fromColors(
                period: widget.period,
                direction: widget.direction,
                baseColor: widget.baseColor,
                highlightColor: widget.highlightColor,
                child: Center(
                  child: widget.text,
                ),
              )
            : Center(
                child: widget.text,
              ),
      ),
    );
    return widget.outerBuilder != null
        ? widget.outerBuilder!(body)
        : Container(
            alignment: Alignment.center,
            child: body,
            decoration: const BoxDecoration(color: Colors.transparent),
          );
  }
}
