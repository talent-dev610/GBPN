import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyBackButton extends StatelessWidget {
  const MyBackButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isIos = Theme.of(context).platform == TargetPlatform.iOS;
    return isIos ?
    CupertinoButton(
      padding: const EdgeInsets.all(0),
      child: Icon(CupertinoIcons.back, color: Theme.of(context).accentColor),
      onPressed: () => Navigator.of(context).pop(),
    ) : BackButton(color: Theme.of(context).accentColor, );
  }
}
