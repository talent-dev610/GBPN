import 'package:gbpn_messages/bloc/app_bloc.dart';
import 'package:gbpn_messages/bloc/bloc.dart';
import 'package:gbpn_messages/consts/conversation_type.dart';
import 'package:gbpn_messages/model/conversation/call_item_model.dart';
import 'package:gbpn_messages/model/conversation/message_item_model.dart';
import 'package:gbpn_messages/model/conversation/voicemail_item_model.dart';
import 'package:gbpn_messages/model/user_model.dart';

class ConversationItemModel {
  String? id, from, to, conversationId;
  bool? isMine;
  DateTime? createdAt;
  ConversationType? type;
  MessageItemModel? smsDetail;
  VoicemailItemModel? voicemailDetail;
  CallItemModel? callDetail;

  ConversationItemModel({this.id, this.conversationId, this.from, this.to, this.isMine, this.createdAt, this.type, this.smsDetail, this.voicemailDetail, this.callDetail});

  factory ConversationItemModel.fromCallJson(Map<String, dynamic> json) {
    UserModel user = (AppBloc.authBloc.state as AuthLoggedInState).user;
    String? selectedPhoneNumber = user.getCurrentPhoneNumber();
    return ConversationItemModel(
        id: json['from'] + json['created_at'],
        from: json['from'],
        to: json['to'],
        isMine: json['from'] == selectedPhoneNumber,
        createdAt: json['created_at'] == null ? null : DateTime.parse(json['created_at']),
        type: ConversationType.Call,
        callDetail: CallItemModel.fromJson(json)
    );
  }

  factory ConversationItemModel.fromSMSJson(Map<String, dynamic> json) {
    UserModel user = (AppBloc.authBloc.state as AuthLoggedInState).user;
    String? selectedPhoneNumber = user.getCurrentPhoneNumber();
    return ConversationItemModel(
      id: json['id'],
      conversationId: json['conversation_id'],
      from: json['sender']['phone_number'],
      to: json['receiver']['phone_number'],
      isMine: json['sender']['phone_number'] == selectedPhoneNumber,
      createdAt: json['created_at'] == null ? null : DateTime.parse(json['created_at']),
      type: ConversationType.SMS,
      smsDetail: MessageItemModel.fromJson(json)
    );
  }

  factory ConversationItemModel.fromVoicemailJson(Map<String, dynamic> json) {
    UserModel user = (AppBloc.authBloc.state as AuthLoggedInState).user;
    String? selectedPhoneNumber = user.getCurrentPhoneNumber();
    return ConversationItemModel(
      id: json['id'],
      from: json['caller'],
      to: selectedPhoneNumber,
      isMine: false,
      createdAt: json['date'] == null ? null : DateTime.parse(json['date']),
      type: ConversationType.Voicemail,
      voicemailDetail: VoicemailItemModel.fromJson(json)
    );
  }

  DateTime getCreatedDate() {
    return DateTime(createdAt!.year, createdAt!.month, createdAt!.day);
  }
}