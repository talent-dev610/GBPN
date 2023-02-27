import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gbpn_messages/consts/colors.dart';
import 'package:gbpn_messages/consts/conversation_type.dart';
import 'package:gbpn_messages/model/conversation/conversation_collection_model.dart';
import 'package:gbpn_messages/model/conversation/conversation_item_model.dart';
import 'package:gbpn_messages/model/user_model.dart';
import 'package:gbpn_messages/util/utilities.dart';
import 'package:gbpn_messages/widget/chat/ptr_header.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../bloc/app_bloc.dart';
import '../../bloc/bloc.dart';
import 'chat/chat_screen.dart';

class VoiceMailListScreen extends StatefulWidget {
  const VoiceMailListScreen({Key? key}) : super(key: key);

  @override
  State<VoiceMailListScreen> createState() => _VoiceMailListScreenState();
}

class _VoiceMailListScreenState extends State<VoiceMailListScreen> {
  List<ConversationItemModel> _conversations = [];
  final RefreshController _refreshController = RefreshController();

  @override
  void initState() {
    super.initState();
    ConversationState conversationState = AppBloc.conversationBloc.state;
    if (conversationState is ConversationLoadedState) {
      _conversations = Utilities.filterByType(
          conversationState.conversations, ConversationType.Voicemail);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<ConversationCollectionModel> collections =
        Utilities.sortConversationsByPhone(_conversations);
    return BlocListener<ConversationBloc, ConversationState>(
      listener: (context, state) {
        if (state is ConversationLoadedState) {
          _refreshController.loadComplete();
          _refreshController.refreshCompleted();
          setState(() {
            _conversations = Utilities.filterByType(
                state.conversations, ConversationType.Voicemail);
          });
        }
      },
      child: Scaffold(
        backgroundColor: kPrimary,
        body: SmartRefresher(
            controller: _refreshController,
            header: const PTRHeader(
              text: Text(
                "Refreshing...",
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
            child: collections.isEmpty ? buildEmpty() : ListView.separated(
                primary: false,
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                itemBuilder: (ctx, idx) {
                  ConversationCollectionModel collection = collections[idx];
                  ConversationItemModel lastConversation =
                      collection.conversations.last;
                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(
                              phone: collection.phone,
                              type: ConversationType.Voicemail,
                            ),
                          )),
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 12),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 36,
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          collection.phone
                                              .replaceAll('+', '')
                                              .replaceAllMapped(
                                              RegExp(r'1(\d{3})(\d{3})(\d+)'),
                                                  (Match m) =>
                                              "(${m[1]}) ${m[2]}-${m[3]}") +
                                              " (${collection.conversations.length})",
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white)),
                                    ],
                                  )),
                              const SizedBox(
                                width: 20,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  if (collection.getUnreadMessageCount() > 0)
                                    Padding(
                                      padding: const EdgeInsets.all(4),
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius:
                                            BorderRadius.circular(16)),
                                        child: Center(
                                          child: Text(
                                            collection
                                                .getUnreadMessageCount()
                                                .toString(),
                                            style: const TextStyle(
                                                color: Colors.white, fontSize: 10),
                                          ),
                                        ),
                                      ),
                                    ),
                                  Text(
                                      Utilities.formatDateTimeMessage(
                                          Utilities.convertToLocalTime(collection
                                              .conversations.last.createdAt!),
                                          onlyTime: false,
                                          onlyDate: true,
                                          inline: false),
                                      textAlign: TextAlign.right,
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.white))
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemCount: collections.length),
            onRefresh: () async {
              UserModel user = (AppBloc.authBloc.state as AuthLoggedInState).user;
              String? selectedPhone = user.getCurrentPhoneNumber();
              AppBloc.conversationBloc.add(ConversationLoadEvent(phoneNumber: selectedPhone));
            }
        ),
      ),
    );
  }

  Widget buildEmpty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.dashboard_outlined, color: kGray.withOpacity(0.5), size: 64,),
          const SizedBox(height: 8,),
          Text("No voicemails", style: TextStyle(color: kGray.withOpacity(0.5), fontSize: 18),)
        ],
      ),
    );
  }
}
