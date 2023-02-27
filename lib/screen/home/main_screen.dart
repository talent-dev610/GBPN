import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gbpn_messages/bloc/bloc.dart';
import 'package:gbpn_messages/consts/colors.dart';
import 'package:gbpn_messages/screen/home/call_list_screen.dart';
import 'package:gbpn_messages/screen/home/home_screen.dart';
import 'package:gbpn_messages/screen/home/chat/message_list_screen.dart';
import 'package:gbpn_messages/screen/home/voice_mail_list_screen.dart';
import 'package:gbpn_messages/widget/bottom_bar/diamond_bottom_navbar.dart';
import 'package:gbpn_messages/widget/menu/drawer_menu.dart';

import 'call/calling_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  int _selectedIndex = 0;
  late Widget _selectedWidget;

  @override
  void initState() {
    _selectedWidget = const HomeScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(getScreenTitle(), style: const TextStyle(color: Colors.white),),
        backgroundColor: kPrimaryDark,
      ),
      drawer: const DrawerMenu(),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
                padding: const EdgeInsets.only(bottom: 60),
              child: _selectedWidget,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: DiamondBottomNavbar(
                itemIcons: const [
                  Icons.home,
                  Icons.call,
                  Icons.message,
                  Icons.voicemail,
                ],
                centerIcon: Icons.add,
                selectedIndex: _selectedIndex,
                height: 60,
                onItemPressed: onNavItemPressed,
                onComposePressed: () async {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const CallingScreen(showSMSButton: true)));
                },
              ),
            ),
            BlocBuilder<ConversationBloc, ConversationState>(
                builder: (context, state) {
                  if (state is ConversationInitialState) {
                    return const Center(child: CupertinoActivityIndicator(color: Colors.white),);
                  } else {
                    return Container();
                  }
                },
            )
          ],
        ),
      ),
    );
  }

  void onNavItemPressed(index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        _selectedWidget = const HomeScreen();
      }else if (index == 1) {
        _selectedWidget = const CallListScreen();
      }else if (index == 2) {
        _selectedWidget = const MessageListScreen();
      }else if (index == 3) {
        _selectedWidget = const VoiceMailListScreen();
      }
    });
  }

  String getScreenTitle() {
    if (_selectedIndex == 0) {
      return 'Home';
    }else if (_selectedIndex == 1) {
      return 'Calls';
    }else if (_selectedIndex == 2) {
      return 'Messages';
    }else if (_selectedIndex == 3) {
      return 'Voicemails';
    } else {
      return 'Home';
    }
  }
}
