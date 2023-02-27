import 'package:flutter/material.dart';
import 'package:gbpn_messages/util/utilities.dart';

class SeenStatus extends StatelessWidget {
  final bool isMe;
  final bool isSeen;
  final DateTime timestamp;
  const SeenStatus({Key? key, required this.isMe, required this.isSeen, required this.timestamp}) : super(key: key);

  Widget _buildStatus(BuildContext context) {
    return Wrap(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2.0),
          child: Text(
            Utilities.formatDateTimeMessage(timestamp, onlyTime: true),
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.6),
            ),
          ),
        ),
        SizedBox(
          width: 5,
        ),
        if (isMe)
          Icon(
            Icons.done_all,
            color: isSeen
                ? Colors.white
                : Colors.white.withOpacity(0.35),
            size: 19,
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: _buildStatus(context),
    );
  }
}
