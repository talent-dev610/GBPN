import 'package:flutter/material.dart';

class ComposePhoneDialog extends StatelessWidget {
  ComposePhoneDialog({Key? key}) : super(key: key);

  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      title: Text('Enter phone number'),
      content: TextField(
        style: const TextStyle(fontSize: 16, color: Colors.black),
        focusNode: FocusNode(),
        controller: _controller,
        keyboardType: TextInputType.phone,
        textInputAction: TextInputAction.go,
        cursorColor: Colors.black,
        keyboardAppearance: Brightness.dark,
        decoration: const InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
          border: OutlineInputBorder(),
          hintText: '',
          hintStyle: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'Cancel',
            style: TextStyle(
              color: Colors.white
            ),
          ),
        ),
        SizedBox(width: 20,),
        TextButton(
          onPressed: () {
            if (_controller.text.isEmpty) {
              return;
            }
            Navigator.of(context).pop(_controller.text.toString());
          },
          child: Text(
            'Compose',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
