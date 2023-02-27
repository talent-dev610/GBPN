import 'package:flutter/material.dart';
import 'package:flutter_dtmf/dtmf.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'dial_button.dart';

class DialPad extends StatefulWidget {
  final String? initialNumber;
  final ValueSetter<String>? makeCall;
  final ValueSetter<String>? sendSMS;
  final ValueSetter<String>? keyPressed;
  final bool? hideDialButton;
  final bool? showSMSButton;
  // buttonColor is the color of the button on the dial pad. defaults to Colors.gray
  final Color? buttonColor;
  final Color? buttonTextColor;
  final Color? dialButtonColor;
  final Color? dialButtonIconColor;
  final IconData? dialButtonIcon;
  final Color? backspaceButtonIconColor;
  final Color? dialOutputTextColor;
  // outputMask is the mask applied to the output text. Defaults to (000) 000-0000
  final String? outputMask;
  final bool? enableDtmf;

  // ignore: use_key_in_widget_constructors
  const DialPad(
      {
        this.initialNumber,
        this.makeCall,
        this.sendSMS,
        this.keyPressed,
        this.hideDialButton,
        this.showSMSButton,
        this.outputMask,
        this.buttonColor,
        this.buttonTextColor,
        this.dialButtonColor,
        this.dialButtonIconColor,
        this.dialButtonIcon,
        this.dialOutputTextColor,
        this.backspaceButtonIconColor,
        this.enableDtmf});

  @override
  _DialPadState createState() => _DialPadState();
}

class _DialPadState extends State<DialPad> {
  MaskedTextController? textEditingController;
  var _value = "";
  var mainTitle = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "*", "0", "＃"];
  var subTitle = [
    "",
    "ABC",
    "DEF",
    "GHI",
    "JKL",
    "MNO",
    "PQRS",
    "TUV",
    "WXYZ",
    null,
    "+",
    null
  ];

  @override
  void initState() {
    textEditingController = MaskedTextController(
        mask: widget.outputMask ?? '(000) 000-0000');
    if (widget.initialNumber != null) {
      _value = widget.initialNumber!.substring(2);
      textEditingController!.text = _value;
    }
    super.initState();
  }

  _setText(String? value) async {
    if (_value.length > 9) return;
    if ((widget.enableDtmf == null || widget.enableDtmf!) && value != null) {
      Dtmf.playTone(digits: value.trim(), samplingRate: 8000, durationMs: 160);
    }

    if (widget.keyPressed != null) widget.keyPressed!(value!);

    setState(() {
      _value += value!;
      textEditingController!.text = _value;
    });
  }

  List<Widget> _getDialerButtons() {
    var rows = <Widget>[];
    var items = <Widget>[];

    for (var i = 0; i < mainTitle.length; i++) {
      if (i % 3 == 0 && i > 0) {
        rows.add(Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: items));
        rows.add(const SizedBox(
          height: 12,
        ));
        items = <Widget>[];
      }

      items.add(DialButton(
        title: mainTitle[i],
        subtitle: subTitle[i],
        color: widget.buttonColor,
        textColor: widget.buttonTextColor,
        onTap: _setText,
      ));
    }
    //To Do: Fix this workaround for last row
    rows.add(
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: items));
    rows.add(const SizedBox(
      height: 12,
    ));

    return rows;
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var sizeFactor = screenSize.height * 0.09852217;

    return Center(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextFormField(
              readOnly: true,
              style: TextStyle(
                  color: widget.dialOutputTextColor ?? Colors.white,
                  fontSize: sizeFactor / 2),
              textAlign: TextAlign.center,
              decoration: const InputDecoration(border: InputBorder.none),
              controller: textEditingController,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(),
              ),
              Expanded(
                child: Padding(
                  padding:
                  EdgeInsets.only(right: screenSize.height * 0.03685504),
                  child: IconButton(
                    icon: Icon(
                      Icons.backspace,
                      size: sizeFactor / 2,
                      color: _value.isNotEmpty
                          ? (widget.backspaceButtonIconColor ?? Colors.white24)
                          : Colors.white24,
                    ),
                    onPressed: _value.isEmpty
                        ? null
                        : () {
                      if (_value.isNotEmpty) {
                        setState(() {
                          _value = _value.substring(0, _value.length - 1);
                          textEditingController!.text = _value;
                        });
                      }
                    },
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 15,),
          ..._getDialerButtons(),
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (widget.showSMSButton != null && widget.showSMSButton!)
                DialButton(
                  icon: widget.dialButtonIcon ?? Icons.message_outlined,
                  color: widget.dialButtonColor != null ? widget.dialButtonColor! : Colors.green,
                  onTap: (value) {
                    if (_value.length < 10) {
                      Fluttertoast.showToast(msg: 'Please enter a valid number');
                      return;
                    }
                    String val = _value.substring(0, 3) + " " + _value.substring(3, 6) + "-" + _value.substring(6);
                    widget.sendSMS!(val);
                  },
                ),
              if (widget.showSMSButton != null && widget.showSMSButton!)
                const SizedBox(width: 40,),
              if (widget.hideDialButton == null || !widget.hideDialButton!)
                DialButton(
                  icon: widget.dialButtonIcon ?? Icons.phone,
                  color: widget.dialButtonColor != null ? widget.dialButtonColor! : Colors.green,
                  onTap: (value) {
                    if (_value.length < 10) {
                      Fluttertoast.showToast(msg: 'Please enter a valid number');
                      return;
                    }
                    String val = _value.substring(0, 3) + " " + _value.substring(3, 6) + "-" + _value.substring(6);
                    widget.makeCall!(val);
                  },
                )
            ],
          )
        ],
      ),
    );
  }
}