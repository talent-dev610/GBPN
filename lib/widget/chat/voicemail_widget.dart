import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:gbpn_messages/model/conversation/conversation_item_model.dart';
import 'package:gbpn_messages/util/utilities.dart';

class VoicemailWidget extends StatefulWidget {
  final ConversationItemModel conversation;

  const VoicemailWidget({Key? key, required this.conversation}) : super(key: key);

  @override
  State<VoicemailWidget> createState() => _VoicemailWidgetState();
}

class _VoicemailWidgetState extends State<VoicemailWidget> {
  AudioPlayer? _player;
  int _currentPos = 0;
  int _maxDuration = 100;
  bool _isPlaying = false, _audioPlayed = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Align(
      alignment: widget.conversation.isMine! ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        width: size.width * 0.6,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: widget.conversation.isMine! ? null : Border.all(color: Colors.grey),
          color: widget.conversation.isMine! ? Colors.blue : Colors.black,
        ),
        child: Padding(
          key: widget.key,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () async {
                    initPlayer();
                    if (!_isPlaying && !_audioPlayed) {
                      int result = await _player!.play(widget.conversation.voicemailDetail!.fileUrl!);
                      if(result == 1){ //play success
                        setState(() {
                          _isPlaying = true;
                          _audioPlayed = true;
                        });
                      }else{
                        print("Error while playing audio.");
                      }
                    } else if (_audioPlayed && !_isPlaying) {
                      int result = await _player!.resume();
                      if(result == 1){ //resume success
                        setState(() {
                          _isPlaying = true;
                          _audioPlayed = true;
                        });
                      }else{
                        print("Error on resume audio.");
                      }
                    } else {
                      int result = await _player!.pause();
                      if(result == 1){ //pause success
                        setState(() {
                          _isPlaying = false;
                        });
                      }else{
                        print("Error on pause audio.");
                      }
                    }
                  },
                  child: Icon(
                    _isPlaying ? Icons.pause : Icons.play_arrow,
                    color: widget.conversation.isMine! ? Colors.white : Colors.blue,
                    size: 28,
                  ),
                ),
              ),
              Expanded(
                  child: Slider(
                    value: _currentPos.toDouble(),
                    min: 0,
                    max: _maxDuration.toDouble(),
                    divisions: _maxDuration,
                    activeColor: widget.conversation.isMine! ? Colors.white : Colors.blue,
                    inactiveColor: widget.conversation.isMine! ? Colors.white.withOpacity(0.7) : Colors.blue.withOpacity(0.7),
                    thumbColor: widget.conversation.isMine! ? Colors.white : Colors.blue,
                    onChanged: (double value) async {
                      initPlayer();
                      int seekval = value.round();
                      int result = await _player!.seek(Duration(milliseconds: seekval));
                      if(result == 1){ //seek successful
                        _currentPos = seekval;
                      }else{
                        print("Seek unsuccessful.");
                      }
                    },
                  )
              ),
              Text(Utilities.formatDateTimeMessage(widget.conversation.createdAt!),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.6),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  void initPlayer() {
    if (_player == null) {
      _player = AudioPlayer();
      _player!.onDurationChanged.listen((Duration duration) {
        setState(() {
          _maxDuration = duration.inMilliseconds;
        });
      });
      _player!.onAudioPositionChanged.listen((Duration duration) {
        setState(() {
          _currentPos = duration.inMilliseconds;
        });
      });
      _player!.onPlayerStateChanged.listen((event) {
        if (event.index == 3) {
          _player!.pause();
          _player!.seek(const Duration(milliseconds: 0));
          _isPlaying = false;
          setState(() {});
        }
      });
    }

  }
}
