import 'package:flutter/material.dart';
import 'package:gbpn_messages/model/conversation/conversation_item_model.dart';
import 'package:gbpn_messages/util/utilities.dart';

class CallWidget extends StatefulWidget {
  final ConversationItemModel conversation;
  const CallWidget({Key? key, required this.conversation}) : super(key: key);

  @override
  State<CallWidget> createState() => _CallWidgetState();
}

class _CallWidgetState extends State<CallWidget> {

  @override
  Widget build(BuildContext context) {
    bool isInbound = widget.conversation.callDetail!.direction! == "inbound";
    bool isCompleted = widget.conversation.callDetail!.status == "completed";
    IconData icon = Icons.call_received;
    Color color = Colors.white;
    if (isInbound) {
      color = Colors.blue;
      if (isCompleted) {
        icon = Icons.call_received;
      } else {
        icon = Icons.call_missed;
      }
    } else {
      color = Colors.green;
      if (isCompleted) {
        icon = Icons.call_made;
      } else {
        icon = Icons.call_missed_outgoing;
      }
    }

    return LayoutBuilder(
        builder: (context, constraints) => Align(
          alignment: widget.conversation.isMine! ? Alignment.bottomRight : Alignment.bottomLeft,
          child: Container(
            constraints: BoxConstraints(
              maxWidth: constraints.maxWidth * 0.6,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: widget.conversation.isMine! ? null : Border.all(color: Colors.grey),
              color: widget.conversation.isMine! ? Colors.blue : Colors.black,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.end,
                runAlignment: WrapAlignment.end,
                alignment: WrapAlignment.end,
                spacing: 20,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          icon,
                          size: 18,
                          color: widget.conversation.isMine! ? Colors.white : color,
                        ),
                        const SizedBox(width: 6),
                        Text(
                            isCompleted ? "Call ended  ${Utilities.formatDuration(widget.conversation.callDetail!.duration!)}"
                                : widget.conversation.isMine! ? "Cancelled call" : "Missed call",
                            style: const TextStyle(fontSize: 12, color: Colors.white)
                        )
                      ],
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: Text(
                        Utilities.formatDateTimeMessage(widget.conversation.createdAt!, onlyTime: true),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.6),
                        ),
                      )
                  ),
                ],
              ),
            ),
          ),
        ),
    );
  }
}
