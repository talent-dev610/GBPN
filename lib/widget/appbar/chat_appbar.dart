import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gbpn_messages/bloc/app_bloc.dart';
import 'package:gbpn_messages/bloc/bloc.dart';
import 'package:gbpn_messages/consts/colors.dart';
import 'package:gbpn_messages/model/conversation_model.dart';
import 'package:gbpn_messages/model/user_model.dart';
import 'package:gbpn_messages/screen/home/call/calling_screen.dart';
import 'package:gbpn_messages/util/overlay_utils.dart';
import 'package:gbpn_messages/widget/button/back_button.dart';

class ChatAppbar extends StatefulWidget {
  final String phoneNumber;

  const ChatAppbar({Key? key, required this.phoneNumber}) : super(key: key);

  @override
  State<ChatAppbar> createState() => _ChatAppbarState();
}

class _ChatAppbarState extends State<ChatAppbar> with SingleTickerProviderStateMixin {

  late AnimationController _animationController;
  late Animation<double> _animation;
  late Timer _timer;
  bool _collapsed = false, _tapped = false;
  late UserModel _user;

  @override
  void initState() {
    super.initState();
    _user = (AppBloc.authBloc.state as AuthLoggedInState).user;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = Tween(begin: 1.0, end: 0.0).animate(_animationController);
    _timer = Timer(const Duration(seconds: 3), () {
      collapse();
    });
  }

  @override
  void dispose() {
    _animationController.removeListener(() { });
    _animationController.dispose();
    _timer.cancel();
    super.dispose();
  }

  void collapse() {
    _animationController.forward();
    Future.delayed(const Duration(milliseconds: 300)).then((value) {
      if (mounted) setState(() => _collapsed = true);
    });
  }

  void toggle() {
    setState(() {
      _tapped = !_tapped;
    });
  }

  void goToContactDetails() {
    print("==");
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: kPrimaryDark,
      elevation: 6,
      leading: const MyBackButton(),
      centerTitle: false,
      title: CupertinoButton(
        padding: const EdgeInsets.all(0),
        onPressed: goToContactDetails,
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(widget.phoneNumber.replaceAll('+', '').replaceAllMapped(RegExp(r'1(\d{3})(\d{3})(\d+)'), (Match m) => "(${m[1]}) ${m[2]}-${m[3]}"), style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                )),
              ],
            ),
          ],
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 20, top: 5, bottom: 5),
          child: Wrap(
            children: [
              CupertinoButton(
                onPressed: makeVoiceCall,
                padding: const EdgeInsets.all(0),
                child: Icon(Icons.call, color: Theme.of(context).accentColor),
                // Avatar(imageUrl: widget.peer.imageUrl, radius: 23, color: kBlackColor3),
              ),
              /*CupertinoButton(
                onPressed: makeVideoCall,
                padding: const EdgeInsets.all(0),
                child: Icon(Icons.video_call,
                    color: Theme.of(context).accentColor),
                // Avatar(imageUrl: widget.peer.imageUrl, radius: 23, color: kBlackColor3),
              ),*/
            ],
          ),
        ),
      ],
    );
  }

  void makeVoiceCall() {
    /*OverlayUtils.overlay(
      context: context,
      alignment: Alignment.topCenter,
      child: CallingScreen(initialNumber: widget.phoneNumber,),
      duration: Duration(seconds: 5),
    );*/
    Navigator.push(context, MaterialPageRoute(builder: (context) => CallingScreen(initialNumber: widget.phoneNumber),));
  }

  void makeVideoCall() {
    OverlayUtils.overlay(
      context: context,
      alignment: Alignment.topCenter,
      child: CallingScreen(),
      duration: Duration(seconds: 5),
    );
  }
}
