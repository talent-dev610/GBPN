import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart' as DIO;
import 'package:gbpn_messages/api/api.dart';
import 'package:gbpn_messages/consts/conversation_type.dart';
import 'package:gbpn_messages/model/conversation/conversation_item_model.dart';
import 'package:gbpn_messages/model/conversation/media_item_model.dart';
import 'package:gbpn_messages/model/conversation/message_item_model.dart';
import 'package:gbpn_messages/util/utilities.dart';

import 'bloc.dart';

class ConversationBloc extends Bloc<ConversationEvent, ConversationState> {
  ConversationBloc() : super(ConversationInitialState()) {
    on((ConversationLoadEvent event, emit) =>
        _mapConversationLoadEventToState(event, emit));
    on((ConversationAddEvent event, emit) =>
        _mapConversationAddEventToState(event, emit));
    on((ConversationDeleteEvent event, emit) =>
        _mapConversationDeleteEventToState(event, emit));
    on((ConversationReadEvent event, emit) =>
        _mapConversationReadEventToState(event, emit));
    on((ConversationAppendEvent event, emit) =>
        _mapConversationAppendEventToState(event, emit));
  }

  void _mapConversationLoadEventToState(
      ConversationLoadEvent event, emit) async {
    emit(ConversationInitialState());
    if (event.phoneNumber == null || event.phoneNumber!.isEmpty) {
      //emit(ConversationFailedState(error: 'phone_required'));
      emit(ConversationLoadedState(conversations: []));
    } else {
      List<ConversationItemModel> conversations = [];
      
      // get calls
      final responseCall = await Api.getCalls();
      if (responseCall['status'] != null && responseCall['status'] == 1) {
        List<dynamic> callDataList = responseCall['data'];
        if (callDataList.isNotEmpty) {
          List<ConversationItemModel> calls = callDataList.map((e) => ConversationItemModel.fromCallJson(e)).toList();
          conversations.addAll(calls);
        }
      } else {
        emit(ConversationFailedState(error: 'error_occurred'));
        return;
      }

      // get sms messages
      final responseSMS = await Api.getMessages(event.phoneNumber);
      if (responseSMS['status'] != null && responseSMS['status'] == 1) {
        List<dynamic> smsConversationList = responseSMS['data'];
        if (smsConversationList.isNotEmpty) {
          for (var element in smsConversationList) {
            List<dynamic> smsMessageList = element['messages'];
            List<ConversationItemModel> messages = smsMessageList
                .map((e) => ConversationItemModel.fromSMSJson(e))
                .toList();
            conversations.addAll(messages);
          }
        }
      } else {
        emit(ConversationFailedState(error: 'error_occurred'));
        return;
      }

      // get voicemails
      final responseVoice = await Api.getVoicemails();
      if (responseVoice['status'] != null && responseVoice['status'] == 1) {
        List<dynamic> voiceList = responseVoice['data'];
        if (voiceList.isNotEmpty) {
          List<ConversationItemModel> voices = voiceList
              .map((e) => ConversationItemModel.fromVoicemailJson(e))
              .toList();
          conversations.addAll(voices);
        }
      } else {
        emit(ConversationFailedState(error: 'error_occurred'));
        return;
      }
      emit(ConversationLoadedState(conversations: conversations));
    }
  }

  void _mapConversationAddEventToState(ConversationAddEvent event, emit) async {
    List<ConversationItemModel> conversations =
        (state as ConversationLoadedState).conversations;
    emit(ConversationLoadingState());
    DateTime now = DateTime.now();
    ConversationItemModel conversation = ConversationItemModel(
        id: "conversation_" + now.millisecondsSinceEpoch.toString(),
        from: event.from,
        to: event.to,
        createdAt: Utilities.convertToServerTime(now),
        isMine: true,
        type: ConversationType.SMS,
        smsDetail: MessageItemModel(
            message: event.content,
            media: event.filePath == null
                ? []
                : [
                    MediaItemModel(url: event.filePath, mimeType: 'image/jpeg')
                  ]));
    conversations.add(conversation);
    emit(ConversationLoadedState(conversations: conversations));
    DIO.FormData formData = DIO.FormData();
    formData.fields.add(MapEntry('from', event.from!));
    formData.fields.add(MapEntry('to', event.to!));
    formData.fields.add(MapEntry('content', event.content ?? ""));
    if (event.filePath != null) {
      formData.files.add(MapEntry(
          'files[0]', await DIO.MultipartFile.fromFile(event.filePath!)));
    }
    final response = await Api.sendMessage(formData);
  }

  void _mapConversationDeleteEventToState(ConversationDeleteEvent event, emit) async {
    List<ConversationItemModel> conversations =
        (state as ConversationLoadedState).conversations;
    emit(ConversationLoadingState());
    if (event.conversation.type == ConversationType.Voicemail) {
      conversations.remove(event.conversation);
    } else if (event.conversation.type == ConversationType.SMS) {
      conversations.removeWhere((element) => element.conversationId == event.conversation.conversationId);
    }

    emit(ConversationLoadedState(conversations: conversations));
    if (event.conversation.type == ConversationType.SMS) {
      await Api.deleteSMS(event.conversation.conversationId!);
    } else if (event.conversation.type == ConversationType.Voicemail) {
      await Api.deleteVoicemail(event.conversation.id!);
    }
  }

  void _mapConversationReadEventToState(ConversationReadEvent event, emit) async {
    List<ConversationItemModel> conversations =
        (state as ConversationLoadedState).conversations;
    emit(ConversationLoadingState());
    final readAt = Utilities.convertToServerTime(DateTime.now());
    ConversationItemModel conversation = event.conversation;
    conversations.remove(conversation);
    conversation.smsDetail!.readAt = readAt;
    conversations.add(conversation);
    emit(ConversationLoadedState(conversations: conversations));
    final response = await Api.readMessage(event.conversation.id!, readAt);
  }
  
  void _mapConversationAppendEventToState(ConversationAppendEvent event, emit) async {
    List<ConversationItemModel> conversations =
        (state as ConversationLoadedState).conversations;
    emit(ConversationLoadingState());
    conversations.add(event.conversation);
    emit(ConversationLoadedState(conversations: conversations));
  }
}
