import 'package:flutter/material.dart';
import 'package:gbpn_messages/model/conversation/conversation_item_model.dart';

import 'bubble_text.dart';
import 'seen_status.dart';

class MessageWithoutMediaWidget extends StatefulWidget {
  final ConversationItemModel conversation;
  const MessageWithoutMediaWidget({Key? key, required this.conversation}) : super(key: key);

  @override
  State<MessageWithoutMediaWidget> createState() => _MessageWithoutMediaWidgetState();
}

class _MessageWithoutMediaWidgetState extends State<MessageWithoutMediaWidget> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) {
          return Wrap(
            children: [
              Align(
                alignment: widget.conversation.isMine! ? Alignment.bottomRight : Alignment.bottomLeft,
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: constraints.maxWidth * 0.8,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: widget.conversation.isMine! ? null : Border.all(color: Colors.grey),
                    color: widget.conversation.isMine! ? Colors.blue : Colors.black,
                  ),
                  child: Padding(
                    key: widget.key,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.end,
                      runAlignment: WrapAlignment.end,
                      alignment: WrapAlignment.end,
                      spacing: 20,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0, bottom: 12),
                          child: BubbleText(text: widget.conversation.smsDetail!.message!),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5.0),
                          child: SeenStatus(
                            isMe: widget.conversation.isMine!,
                            isSeen: widget.conversation.smsDetail!.readAt != null,
                            timestamp: widget.conversation.createdAt!,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          );
        },
    );
  }
}
