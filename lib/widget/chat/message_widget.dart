import 'package:flutter/material.dart';
import 'package:gbpn_messages/bloc/app_bloc.dart';
import 'package:gbpn_messages/bloc/bloc.dart';
import 'package:gbpn_messages/model/conversation/conversation_item_model.dart';
import 'package:gbpn_messages/widget/chat/message_without_media_widget.dart';

import 'message_with_media_widget.dart';

class MessageWidget extends StatefulWidget {
  final ConversationItemModel conversation;
  const MessageWidget({Key? key, required this.conversation}) : super(key: key);

  @override
  State<MessageWidget> createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {

  @override
  void initState() {
    super.initState();
    if (!widget.conversation.isMine! && widget.conversation.smsDetail!.readAt == null) {
      AppBloc.conversationBloc.add(ConversationReadEvent(conversation: widget.conversation));
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.conversation.smsDetail!.media!.isEmpty
        ? MessageWithoutMediaWidget(conversation: widget.conversation)
        : MessageWithMediaWidget(conversation: widget.conversation);
  }
}
