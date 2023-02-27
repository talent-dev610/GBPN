import 'package:flutter/material.dart';
import 'package:gbpn_messages/model/conversation/media_item_model.dart';
import 'package:gbpn_messages/widget/chat/image_view.dart';
import 'package:gbpn_messages/widget/chat/video_player.dart';

class MediaView extends StatelessWidget {
  final MediaItemModel media;

  const MediaView({Key? key, required this.media}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Hero(
            tag: media.url!,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: InteractiveViewer(
                minScale: 1,
                maxScale: 4,
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: mq.size.height,
                  ),
                  height: double.infinity,
                  width: double.infinity,
                  child: media.mimeType!.toLowerCase().contains("image")
                      ? ImageViewWidget(url: media.url!)
                      : ChatVideoPlayer(url: media.url!, isLocal: !media.url!.contains("http")),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
