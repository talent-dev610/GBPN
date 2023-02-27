import 'dart:collection';

import 'package:gbpn_messages/model/conversation/media_item_model.dart';

class MessageItemModel {
  String? message;
  DateTime? updatedAt, notifiedAt, readAt;
  List<MediaItemModel>? media;

  MessageItemModel({this.message, this.updatedAt, this.notifiedAt, this.readAt, this.media});

  factory MessageItemModel.fromJson(Map<String, dynamic> json) {
    List<MediaItemModel> mediaUrls = [];
    if (json['media_urls'] != null && json['media_urls'].isNotEmpty) {
      if (json['media_urls'] is HashMap) {
        mediaUrls.add(MediaItemModel.fromJson(json['media_urls']));
      } else if (json['media_urls'] is List) {
        mediaUrls = json['media_urls'].map<MediaItemModel>((e) => MediaItemModel.fromJson(e)).toList();
      }
    }
    return MessageItemModel(
      message: json['message'],
      media: mediaUrls,
      readAt: json['read_at'] == null ? null : DateTime.parse(json['read_at']),
      notifiedAt: json['notified_at'] == null ? null : DateTime.parse(json['notified_at']),
      updatedAt: json['updated_at'] == null ? null : DateTime.parse(json['updated_at']),
    );
  }
}