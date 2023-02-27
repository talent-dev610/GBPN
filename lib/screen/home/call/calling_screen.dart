import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gbpn_messages/bloc/app_bloc.dart';
import 'package:gbpn_messages/bloc/bloc.dart';
import 'package:gbpn_messages/model/user_model.dart';
import 'package:gbpn_messages/util/utilities.dart';
import 'package:gbpn_messages/widget/dial/dial_pad.dart';
import 'package:url_launcher/url_launcher.dart';

import '../chat/chat_screen.dart';

class CallingScreen extends StatefulWidget {
  final String? initialNumber;
  final bool? showSMSButton;

  const CallingScreen({Key? key, this.initialNumber, this.showSMSButton}) : super(key: key);

  @override
  State<CallingScreen> createState() => _CallingScreenState();
}

class _CallingScreenState extends State<CallingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                  )),
            ),
            Expanded(
                child: DialPad(
                    initialNumber: widget.initialNumber,
                    showSMSButton: widget.showSMSButton,
                    enableDtmf: true,
                    outputMask: "(000) 000-0000",
                    backspaceButtonIconColor: Colors.red,
                    sendSMS: (number) {
                      String? validate = Utilities.validateMobile(number);
                      if (validate != null) {
                        Fluttertoast.showToast(msg: validate);
                        return;
                      }
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ChatScreen(phone: "+1${number.replaceAll(' ', '').replaceAll('-', '')}"),));
                    },
                    makeCall: (number) async {
                      String? validate = Utilities.validateMobile(number);
                      if (validate != null) {
                        Fluttertoast.showToast(msg: validate);
                        return;
                      }
                      UserModel user = (AppBloc.authBloc.state as AuthLoggedInState).user;
                      await launch('tel://${user.getCurrentPhoneNumber()!.replaceAll('-', '').replaceAll(' ', '')},8,+1${number.replaceAll('-', '').replaceAll(' ', '')}');
                      //await launch('tel://+1$number');
                      Navigator.pop(context);
                    }))
          ],
        ),
      ),
    );
  }
}
