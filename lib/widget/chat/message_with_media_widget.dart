import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gbpn_messages/model/conversation/conversation_item_model.dart';
import 'package:gbpn_messages/widget/chat/image_view.dart';
import 'package:gbpn_messages/widget/chat/video_player.dart';

import 'bubble_text.dart';
import 'media_view.dart';
import 'seen_status.dart';

class MessageWithMediaWidget extends StatefulWidget {
  final ConversationItemModel conversation;

  const MessageWithMediaWidget({Key? key, required this.conversation}) : super(key: key);

  @override
  State<MessageWithMediaWidget> createState() => _MessageWithMediaWidgetState();
}

class _MessageWithMediaWidgetState extends State<MessageWithMediaWidget> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Hero(
      tag: widget.conversation.smsDetail!.media![0].url!,
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => MediaView(
              media: widget.conversation.smsDetail!.media![0],
            ),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              var begin = 0.0;
              var end = 1.0;
              var tween = Tween(begin: begin, end: end);
              var fadeAnimation = animation.drive(tween);

              return FadeTransition(
                opacity: fadeAnimation,
                child: child,
              );
            },
          ));
        },
        child: Align(
          alignment: widget.conversation.isMine! ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.white.withOpacity(0.2)), color: widget.conversation.isMine! ? const Color(0xFF1c1c1e) : Colors.black),
            padding: const EdgeInsets.all(5),
            constraints: BoxConstraints(
              minWidth: size.width * 0.7,
              maxWidth: size.width * 0.7,
              minHeight: size.height * 0.35,
              // maxHeight: mq.size.height * 0.35,
            ),
            child: widget.conversation.smsDetail!.message == null || widget.conversation.smsDetail!.message!.isEmpty ? _WithoutText(conversation: widget.conversation) : _WithText(conversation: widget.conversation),
          ),
        ),
      ),
    );
  }
}

class _WithText extends StatelessWidget {
  final ConversationItemModel conversation;

  const _WithText({Key? key, required this.conversation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.end,
      alignment: WrapAlignment.end,
      runAlignment: WrapAlignment.spaceBetween,
      children: [
        Wrap(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                constraints: BoxConstraints(
                  minWidth: size.width * 0.7,
                  maxWidth: size.width * 0.7,
                  minHeight: size.height * 0.35,
                  maxHeight: size.height * 0.35,
                ),
                child: conversation.smsDetail!.media![0].mimeType!.toLowerCase().contains('image')
                    ? ImageViewWidget(url: conversation.smsDetail!.media![0].url!)
                    : ChatVideoPlayer(url: conversation.smsDetail!.media![0].url, isLocal: !conversation.smsDetail!.media![0].url!.contains("http")),
              ),
            ),
            Padding(padding: const EdgeInsets.only(top: 10.0), child: BubbleText(text: conversation.smsDetail!.message!)),
          ],
        ),
        SeenStatus(
          isMe: conversation.isMine!,
          isSeen: conversation.smsDetail!.readAt != null,
          timestamp: conversation.createdAt!,
        ),
      ],
    );
  }
}

class _WithoutText extends StatelessWidget {
  final ConversationItemModel conversation;

  const _WithoutText({Key? key, required this.conversation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final mediaItem = conversation.smsDetail!.media![0];
    return Stack(
      children: [
        Container(
          constraints: BoxConstraints(
            minWidth: size.width * 0.7,
            maxWidth: size.width * 0.7,
            minHeight: size.height * 0.35,
            maxHeight: size.height * 0.35,
          ),
          width: double.infinity,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: mediaItem.mimeType!.toLowerCase().contains('image')
                ? ImageViewWidget(url: mediaItem.url!)
                : ChatVideoPlayer(url: mediaItem.url, isLocal: !mediaItem.url!.contains("http")),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Material(
            color: Colors.transparent,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
              child: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.all(5),
                height: 30,
                constraints: BoxConstraints(
                  maxWidth: size.width * 0.8,
                ),
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.6),
                      Colors.black.withOpacity(0.01),
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
                child: SeenStatus(
                  isMe: conversation.isMine!,
                  isSeen: conversation.smsDetail!.readAt != null,
                  timestamp: conversation.createdAt!,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
