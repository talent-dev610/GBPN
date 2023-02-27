import 'package:gbpn_messages/model/conversation/conversation_item_model.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ConversationState {}

class ConversationInitialState extends ConversationState {}

class ConversationLoadingState extends ConversationState {}

class ConversationFailedState extends ConversationState {
  final String? error;

  ConversationFailedState({this.error});
}

class ConversationLoadedState extends ConversationState {
  final List<ConversationItemModel> conversations;

  ConversationLoadedState({required this.conversations});
}