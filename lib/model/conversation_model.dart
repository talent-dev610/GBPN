import 'package:gbpn_messages/model/message_model.dart';

class ConversationModel {
  String id, title;
  DateTime? createdAt, updatedAt, deletedAt;
  List<MessageModel>? messages;

  ConversationModel({
    required this.id,
    required this.title,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.messages});

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    List<dynamic>? messageList = json['messages'];
    return ConversationModel(
        id: json['id'],
        title: json['title'],
        createdAt: json['created_at'] == null ? null : DateTime.parse(json['created_at']),
        updatedAt: json['updated_at'] == null ? null : DateTime.parse(json['updated_at']),
        deletedAt: json['deleted_at'] == null ? null : DateTime.parse(json['deleted_at']),
      messages: messageList == null ? [] : messageList.map<MessageModel>((e) => MessageModel.fromJson(e)).toList()
    );
  }
}