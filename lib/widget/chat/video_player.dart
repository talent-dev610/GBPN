import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ChatVideoPlayer extends StatefulWidget {
  final File? video;
  final String? url;
  final bool isLocal;

  ChatVideoPlayer({
    this.video,
    this.url,
    this.isLocal = false,
  });

  @override
  _ChatVideoPlayerState createState() => _ChatVideoPlayerState();
}

class _ChatVideoPlayerState extends State<ChatVideoPlayer>
    with AutomaticKeepAliveClientMixin {
  late VideoPlayerController _controller;
  late Future<void> _initializedPlayerFuture;
  @override
  void initState() {
    super.initState();
    if (widget.isLocal)
      _controller = VideoPlayerController.file(widget.video!);
    else
      _controller = VideoPlayerController.network(widget.url!);
    // _controller.setLooping(true);
    _controller.addListener(() {
      setState(() {});
    });

    _initializedPlayerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void togglePlay() {
    setState(() {
      if (_controller.value.isPlaying)
        _controller.pause();
      else
        _controller.play();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      children: [
        FutureBuilder(
          future: _initializedPlayerFuture,
          builder: (ctx, snaps) {
            if (snaps.connectionState == ConnectionState.done) {
              return Container(
                width: MediaQuery.of(context).size.width,
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
              );
            }
            return Center(child: CupertinoActivityIndicator());
          },
        ),
        Align(
          alignment: Alignment.center,
          child: CupertinoButton(
            onPressed: togglePlay,
            padding: const EdgeInsets.all(0),
            child: Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: Theme.of(context).accentColor.withOpacity(0.8), width: 2),
              ),
              child: Center(
                child: Icon(
                  _controller.value.isPlaying
                      ? Icons.pause_circle_filled_outlined
                      : Icons.play_arrow_outlined,
                  color: Theme.of(context).accentColor.withOpacity(0.8),
                  size: 70,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
