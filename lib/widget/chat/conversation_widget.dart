import 'package:flutter/material.dart';
import 'package:gbpn_messages/bloc/app_bloc.dart';
import 'package:gbpn_messages/bloc/bloc.dart';
import 'package:gbpn_messages/consts/conversation_type.dart';
import 'package:gbpn_messages/model/conversation/conversation_item_model.dart';
import 'package:gbpn_messages/widget/chat/message_widget.dart';
import 'package:gbpn_messages/widget/chat/voicemail_widget.dart';

import 'call_widget.dart';

class ConversationWidget extends StatelessWidget {
  final ConversationItemModel conversation;

  const ConversationWidget({Key? key, required this.conversation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return conversation.type == ConversationType.Voicemail
        ? Dismissible(
            key: UniqueKey(),
            direction: conversation.isMine!
                ? DismissDirection.endToStart
                : DismissDirection.startToEnd,
            confirmDismiss: (_) async {
              AppBloc.conversationBloc
                  .add(ConversationDeleteEvent(conversation: conversation));
              return true;
            },
            background: Align(
              alignment: conversation.isMine!
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: Wrap(
                children: [
                  if (!conversation.isMine!) const SizedBox(width: 10),
                  FittedBox(
                      child: Icon(
                    Icons.delete_forever,
                    color: Colors.white.withOpacity(0.5),
                  )),
                  if (conversation.isMine!) const SizedBox(width: 10),
                ],
              ),
            ),
            child: Container(
              alignment: conversation.isMine!
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: conversation.isMine!
                  ? _ConversationWithoutAvatarWidget(
                      conversation: conversation,
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const CircleAvatar(
                          backgroundColor: Colors.grey,
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 5),
                        _ConversationWithoutAvatarWidget(
                            conversation: conversation)
                      ],
                    ),
            ))
        : Container(
            alignment: conversation.isMine!
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: conversation.isMine!
                ? _ConversationWithoutAvatarWidget(
                    conversation: conversation,
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const CircleAvatar(
                        backgroundColor: Colors.grey,
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Flexible(child: _ConversationWithoutAvatarWidget(
                          conversation: conversation))
                    ],
                  ),
          );
  }
}

class _ConversationWithoutAvatarWidget extends StatelessWidget {
  final ConversationItemModel conversation;

  const _ConversationWithoutAvatarWidget({Key? key, required this.conversation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return conversation.type == ConversationType.SMS
        ? MessageWidget(
            conversation: conversation,
          )
        : conversation.type == ConversationType.Voicemail
            ? VoicemailWidget(
                conversation: conversation,
              )
            : CallWidget(
                conversation: conversation,
              );
  }
}
