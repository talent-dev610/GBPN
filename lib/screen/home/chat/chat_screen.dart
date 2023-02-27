import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gbpn_messages/bloc/app_bloc.dart';
import 'package:gbpn_messages/bloc/bloc.dart';
import 'package:gbpn_messages/consts/colors.dart';
import 'package:gbpn_messages/consts/conversation_type.dart';
import 'package:gbpn_messages/consts/media_type.dart';
import 'package:gbpn_messages/model/conversation/conversation_item_model.dart';
import 'package:gbpn_messages/model/user_model.dart';
import 'package:gbpn_messages/util/media_picker_utils.dart';
import 'package:gbpn_messages/util/utilities.dart';
import 'package:gbpn_messages/widget/appbar/chat_appbar.dart';
import 'package:gbpn_messages/widget/chat/conversation_widget.dart';
import 'package:gbpn_messages/widget/chat/selected_media_preview.dart';
import 'package:sticky_headers/sticky_headers.dart';

class ChatScreen extends StatefulWidget {
  final String phone;
  final ConversationType? type;

  const ChatScreen({Key? key, required this.phone, this.type = ConversationType.SMS})
      : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<ConversationItemModel> _conversations = [];

  final FocusNode _bodyFocusNode = FocusNode();
  late ScrollController _scrollController;
  final TextEditingController _textEditingController = TextEditingController();

  // handle media selection
  File? _selectedMedia;
  MediaType? _pickedMediaType;
  bool _mediaSelected = false;

  @override
  void initState() {
    super.initState();
    ConversationState conversationState = AppBloc.conversationBloc.state;
    if (conversationState is ConversationLoadedState) {
      List<ConversationItemModel> items = Utilities.filterByPhone(
          conversationState.conversations, widget.phone);
      _conversations = widget.type == null
          ? items
          : Utilities.filterByType(items, widget.type!);
    }
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _bodyFocusNode.dispose();
    _scrollController.dispose();
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ConversationBloc, ConversationState>(
      listener: (context, state) {
        if (state is ConversationLoadedState) {
          List<ConversationItemModel> items =
              Utilities.filterByPhone(state.conversations, widget.phone);
          setState(() {
            _conversations = widget.type == null
                ? items
                : Utilities.filterByType(items, widget.type!);
          });
        }
      },
      child: Scaffold(
        backgroundColor: kPrimary,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: ChatAppbar(phoneNumber: widget.phone),
        ),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(_bodyFocusNode),
          child: Stack(
            children: [
              buildChatBoard(),
              if (_mediaSelected)
                SelectedMediaPreview(
                    file: _selectedMedia!,
                    textEditingController: _textEditingController,
                    onSend: (content, mediaType) {
                      sendMessage(media: true);
                    },
                    onClosed: () => setState(() {
                          _mediaSelected = false;
                        }),
                    pickedMediaType: _pickedMediaType!)
            ],
          ),
        ),
      ),
    );
  }

  Widget buildChatBoard() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [Expanded(child: renderMessages()),
            if (widget.type == ConversationType.SMS)
              buildTextInputField()
          ],
        );
      },
    );
  }

  Widget renderMessages() {
    Map<DateTime, List<ConversationItemModel>> convMap =
        Utilities.sortConversationsByDate(_conversations);
    return ListView(
        addAutomaticKeepAlives: true,
        physics: const AlwaysScrollableScrollPhysics(),
        primary: false,
        shrinkWrap: true,
        reverse: true,
        children: convMap.keys.toList().map<Widget>((e) {
          List<ConversationItemModel> conversations = convMap[e]!;
          return StickyHeader(
              header: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(1),
                        borderRadius: BorderRadius.circular(8)),
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                    child: Text(
                      Utilities.formatStickyDateLabel(e),
                      style: const TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              content: ListView(
                addAutomaticKeepAlives: true,
                physics: const NeverScrollableScrollPhysics(),
                primary: false,
                shrinkWrap: true,
                children: conversations
                    .map<Widget>((conversation) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: ConversationWidget(conversation: conversation)))
                    .toList(),
              ));
        }).toList());
  }

  Widget buildTextInputField() {
    if (widget.type != null && widget.type == ConversationType.Voicemail) {
      return Container();
    }
    return Container(
      decoration: BoxDecoration(color: kPrimaryDark, boxShadow: [
        BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 3,
            offset: const Offset(0, -4))
      ]),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CupertinoButton(
                  padding: const EdgeInsets.all(0),
                  child: Icon(
                    Icons.image_outlined,
                    size: 25,
                    color: Theme.of(context).accentColor,
                  ),
                  onPressed: pickImage,
                ),
                CupertinoButton(
                  padding: const EdgeInsets.all(0),
                  child: Icon(
                    Icons.videocam,
                    size: 25,
                    color: Theme.of(context).accentColor,
                  ),
                  onPressed: pickVideo,
                ),
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.only(left: 8, right: 5),
                    decoration: BoxDecoration(
                        color: const Color(0xFF151515),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey)),
                    child: TextField(
                      maxLines: null,
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                      focusNode: FocusNode(),
                      controller: _textEditingController,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.go,
                      cursorColor: Theme.of(context).accentColor,
                      keyboardAppearance: Brightness.dark,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 4),
                        border: InputBorder.none,
                        hintText: 'Type a message',
                        hintStyle: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      onSubmitted: (_) {},
                    ),
                  ),
                ),
                CupertinoButton(
                  padding: const EdgeInsets.all(0),
                  child: Icon(Icons.send,
                      size: 30, color: Theme.of(context).accentColor),
                  onPressed: () {
                    sendMessage();
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future pickImage() async {
    var pickedFile = await MediaPickerUtils.pickImage(context);
    if (pickedFile != null) {
      setState(() {
        _pickedMediaType = MediaType.Photo;
        _selectedMedia = File(pickedFile.path);
        _mediaSelected = true;
      });
    }
  }

  Future pickVideo() async {
    var pickedFile = await MediaPickerUtils.pickVideo(context);
    if (pickedFile != null) {
      setState(() {
        _pickedMediaType = MediaType.Video;
        _selectedMedia = File(pickedFile.path);
        _mediaSelected = true;
      });
    }
  }

  void sendMessage({bool media = false}) async {
    if (_textEditingController.text.toString().isEmpty &&
        _selectedMedia == null) {
      return;
    }
    UserModel user = (AppBloc.authBloc.state as AuthLoggedInState).user;
    String phone = user.getCurrentPhoneNumber()!;
    String yourPhone = widget.phone;
    AppBloc.conversationBloc.add(ConversationAddEvent(
        from: phone,
        to: yourPhone,
        content: _textEditingController.text.toString(),
        filePath: _selectedMedia == null ? null : _selectedMedia!.path));
    _textEditingController.text = '';
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      _mediaSelected = false;
      _selectedMedia = null;
    });
  }
}
