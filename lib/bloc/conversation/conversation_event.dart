import 'package:gbpn_messages/model/conversation/conversation_item_model.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ConversationEvent {}

class ConversationLoadEvent extends ConversationEvent {
  final String? phoneNumber;

  ConversationLoadEvent({required this.phoneNumber});
}

class ConversationAddEvent extends ConversationEvent {
  final String? from, to, content, filePath;

  ConversationAddEvent({this.from, this.to, this.content, this.filePath});
}

class ConversationAppendEvent extends ConversationEvent {
  final ConversationItemModel conversation;

  ConversationAppendEvent(this.conversation);
}

class ConversationDeleteEvent extends ConversationEvent {
  final ConversationItemModel conversation;

  ConversationDeleteEvent({required this.conversation});
}

class ConversationReadEvent extends ConversationEvent {
  final ConversationItemModel conversation;

  ConversationReadEvent({required this.conversation});
}