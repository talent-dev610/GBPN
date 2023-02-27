import 'package:flutter/material.dart';
import 'package:gbpn_messages/consts/conversation_type.dart';
import 'package:gbpn_messages/model/conversation/conversation_item_model.dart';
import 'package:gbpn_messages/util/utilities.dart';
import 'package:gbpn_messages/widget/chat/video_player.dart';

import 'image_view.dart';

class LatestConversationWidget extends StatelessWidget {
  final ConversationItemModel conversation;

  const LatestConversationWidget({Key? key, required this.conversation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (conversation.type == ConversationType.Call) return buildCallWidget();
    if (conversation.type == ConversationType.Voicemail) return buildVoicemailWidget();
    return buildSMSWidget();
  }

  Widget buildCallWidget() {
    bool isInbound = conversation.callDetail!.direction! == "inbound";
    bool isCompleted = conversation.callDetail!.status == "completed";
    IconData icon = Icons.call_received;
    if (isInbound) {
      if (isCompleted) {
        icon = Icons.call_received;
      } else {
        icon = Icons.call_missed;
      }
    } else {
      if (isCompleted) {
        icon = Icons.call_made;
      } else {
        icon = Icons.call_missed_outgoing;
      }
    }
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: isInbound ? Colors.blue : Colors.green,
        ),
        const SizedBox(width: 6),
        Text(
          isCompleted ? Utilities.formatDuration(conversation.callDetail!.duration!)
              : conversation.isMine! ? "Cancelled" : "Missed",
            style: const TextStyle(fontSize: 12, color: Colors.white)
        )
      ],
    );
  }

  Widget buildSMSWidget() {
    return Row(
      children: [
        if (conversation.smsDetail!.media!.isNotEmpty)
          SizedBox(
            width: 16,
            height: 16,
            child: conversation.smsDetail!.media![0].mimeType!
                    .toLowerCase()
                    .contains('image')
                ? ImageViewWidget(url: conversation.smsDetail!.media![0].url!)
                : ChatVideoPlayer(
                    url: conversation.smsDetail!.media![0].url,
                    isLocal: !conversation.smsDetail!.media![0].url!
                        .contains("http")),
          ),
        if (conversation.smsDetail!.media!.isNotEmpty)
          const SizedBox(width: 6),
        Text(
            conversation.smsDetail!.message != null &&
                    conversation.smsDetail!.message!.isNotEmpty
                ? conversation.smsDetail!.message!.length > 30 ? conversation.smsDetail!.message!.substring(0, 30) + '...' : conversation.smsDetail!.message!
                : conversation.smsDetail!.media![0].mimeType!
                        .toLowerCase()
                        .contains('image')
                    ? "Photo"
                    : "Video",
            style: const TextStyle(fontSize: 12, color: Colors.white))
      ],
    );
  }

  Widget buildVoicemailWidget() {
    return const Text('Voicemail',
        style: TextStyle(fontSize: 12, color: Colors.white));
  }
}
