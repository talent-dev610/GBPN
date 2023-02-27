import 'package:flutter/material.dart';
import 'package:gbpn_messages/consts/colors.dart';
import 'package:gbpn_messages/consts/compose_new.dart';
import 'package:gbpn_messages/event/new_compose_pressed_event.dart';
import 'package:gbpn_messages/util/globals.dart';
import 'dart:math' as math;

import 'package:gbpn_messages/widget/bottom_bar/expandable_fab.dart';

import 'action_button.dart';

class DiamondBottomNavbar extends StatelessWidget {
  final List<IconData> itemIcons;
  final IconData centerIcon;
  final int selectedIndex;
  final Function(int) onItemPressed;
  final VoidCallback onComposePressed;
  final double? height;
  final Color selectedColor;
  final Color selectedLightColor;
  final Color unselectedColor;
  final Color activeItemColor;
  final Color deactiveItemColor;
  const DiamondBottomNavbar({
    Key? key,
    required this.itemIcons,
    required this.centerIcon,
    required this.selectedIndex,
    required this.onItemPressed,
    required this.onComposePressed,
    this.height,
    this.activeItemColor = Colors.yellow,
    this.deactiveItemColor = Colors.white,
    this.selectedColor = const Color(0xff46BDFA),
    this.unselectedColor = const Color(0xffB5C8E7),
    this.selectedLightColor = const Color(0xff77E2FE),
  })  : assert(itemIcons.length == 4 || itemIcons.length == 2,
  "Item must equal 4 or 2"),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig.initSize(context);
    final height = this.height ?? getRelativeHeight(0.076);
    return SizedBox(
      height: height + getRelativeHeight(0.025),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: height,
              decoration: BoxDecoration(
                  color: kPrimaryDark,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 3,
                        offset: const Offset(0, -4)
                    )
                  ]
              ),
              child: Padding(
                padding:
                EdgeInsets.symmetric(horizontal: getRelativeWidth(0.05)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Row(
                        mainAxisAlignment: itemIcons.length == 4
                            ? MainAxisAlignment.spaceBetween
                            : MainAxisAlignment.center,
                        children: [
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              customBorder: const CircleBorder(),
                              onTap: () {
                                onItemPressed(0);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Icon(
                                  itemIcons[0],
                                  color: selectedIndex == 0
                                      ? activeItemColor
                                      : deactiveItemColor,
                                ),
                              ),
                            ),
                          ),
                          if (itemIcons.length == 4)
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                customBorder: const CircleBorder(),
                                onTap: () {
                                  onItemPressed(1);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Icon(
                                    itemIcons[1],
                                    color: selectedIndex == 1
                                        ? activeItemColor
                                        : deactiveItemColor,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const Spacer(flex: 2),
                    Expanded(
                      flex: 2,
                      child: Row(
                        mainAxisAlignment: itemIcons.length == 4
                            ? MainAxisAlignment.spaceBetween
                            : MainAxisAlignment.center,
                        children: [
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              customBorder: const CircleBorder(),
                              onTap: () {
                                onItemPressed(itemIcons.length == 4 ? 2 : 1);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Icon(
                                  itemIcons[itemIcons.length == 4 ? 2 : 1],
                                  color: selectedIndex ==
                                      (itemIcons.length == 4 ? 2 : 1)
                                      ? activeItemColor
                                      : deactiveItemColor,
                                ),
                              ),
                            ),
                          ),
                          if (itemIcons.length == 4)
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                customBorder: const CircleBorder(),
                                onTap: () {
                                  onItemPressed(3);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Icon(
                                    itemIcons[3],
                                    color: selectedIndex == 3
                                        ? activeItemColor
                                        : deactiveItemColor,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.topCenter,
              child: Transform.rotate(
                angle: -math.pi / 4,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: onComposePressed,
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 25,
                            offset: const Offset(0, 3),
                            color: selectedColor.withOpacity(0.75),
                          )
                        ],
                        borderRadius:
                        const BorderRadius.all(Radius.circular(18)),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            selectedLightColor,
                            selectedColor,
                          ],
                        ),
                      ),
                      height: getDiamondSize(),
                      width: getDiamondSize(),
                      child: Center(
                          child: Transform.rotate(
                            angle: math.pi / 4,
                            child: Icon(
                              centerIcon,
                              color: Colors.white,
                            ),
                          )),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class SizeConfig {
  static double screenWidth = 0;
  static double screenHeight = 0;

  static initSize(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    screenWidth = mediaQuery.size.width;
    screenHeight = mediaQuery.size.height;
  }
}

double getRelativeHeight(double percentage) {
  return percentage * SizeConfig.screenHeight;
}

double getRelativeWidth(double percentage) {
  return percentage * SizeConfig.screenWidth;
}

double getDiamondSize() {
  var width = SizeConfig.screenWidth;
  if (width > 1000) {
    return 0.045 * SizeConfig.screenWidth;
  } else if (width > 900) {
    return 0.055 * SizeConfig.screenWidth;
  } else if (width > 700) {
    return 0.065 * SizeConfig.screenWidth;
  } else if (width > 500) {
    return 0.075 * SizeConfig.screenWidth;
  } else {
    return 0.135 * SizeConfig.screenWidth;
  }
}
