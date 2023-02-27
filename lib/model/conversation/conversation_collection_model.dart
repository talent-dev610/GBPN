import 'package:gbpn_messages/consts/conversation_type.dart';
import 'package:gbpn_messages/model/conversation/conversation_item_model.dart';

class ConversationCollectionModel {
  String phone;
  List<ConversationItemModel> conversations;

  ConversationCollectionModel({required this.phone, required this.conversations});

  DateTime getLastDate() {
    final createdAt = conversations.last.createdAt!;
    return DateTime(createdAt.year, createdAt.month, createdAt.day);
  }

  int getUnreadMessageCount() {
    try {
      return conversations.where((element) => element.isMine != true && element.type == ConversationType.SMS && element.smsDetail!.readAt == null).toList().length;
    } catch (e) {
      return 0;
    }
  }
}
