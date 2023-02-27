import 'dart:collection';

import 'package:gbpn_messages/model/media_model.dart';

class MessageModel {
  String id, conversationId, senderId, senderPhone, receiverId, receiverPhone;
  String? message;
  List<MediaModel>? mediaUrls;
  DateTime? readAt, notifiedAt, createdAt, updatedAt;

  MessageModel(
      {required this.id,
      required this.conversationId,
      required this.senderId,
      required this.senderPhone,
      required this.receiverId,
      required this.receiverPhone,
      this.message,
      this.mediaUrls,
      this.readAt,
      this.notifiedAt,
      this.createdAt,
      this.updatedAt});

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    List<MediaModel> mediaUrls = [];
    if (json['media_urls'] != null && json['media_urls'].isNotEmpty) {
      if (json['media_urls'] is HashMap) {
        mediaUrls.add(MediaModel.fromJson(json['media_urls']));
      } else if (json['media_urls'] is List) {
        mediaUrls = json['media_urls'].map<MediaModel>((e) => MediaModel.fromJson(e)).toList();
      }
    }
    return MessageModel(
      id: json['id'],
      conversationId: json['conversation_id'],
      senderId: json['sender']['id'],
      senderPhone: json['sender']['phone_number'],
      receiverId: json['receiver']['id'],
      receiverPhone: json['receiver']['phone_number'],
      message: json['message'],
      mediaUrls: mediaUrls,
      readAt: json['read_at'] == null ? null : DateTime.parse(json['read_at']),
      notifiedAt: json['notified_at'] == null ? null : DateTime.parse(json['notified_at']),
      createdAt: json['created_at'] == null ? null : DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] == null ? null : DateTime.parse(json['updated_at']),
    );
  }
}
