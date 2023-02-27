import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:gbpn_messages/api/api.dart';
import 'package:gbpn_messages/bloc/app_bloc.dart';
import 'package:gbpn_messages/model/conversation/conversation_item_model.dart';
import 'package:gbpn_messages/model/user_model.dart';
import 'package:gbpn_messages/util/notification_manager.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

import '../bloc/bloc.dart';

class PusherManager {
  static late PusherChannelsFlutter pusherInstance;

  static Future<void> initPusher(UserModel user) async {
    try {
      pusherInstance = PusherChannelsFlutter.getInstance();
      await pusherInstance.init(
        apiKey: '3283525c429951b8738d',
        cluster: 'us3',
        useTLS: true,
        onAuthorizer:
            (String channelName, String socketId, dynamic options) async {
          return await Api.getPusherAuth(
              channel: channelName, socket: socketId);
        },
        onError: (String message, int? code, dynamic e) {
          if (kDebugMode) {
            print("[onError]: $message code: $code exception: $e");
          }
        },
        onSubscriptionSucceeded: (String channelName, dynamic data) {
          if (kDebugMode) {
            print("[onSubscriptionSucceeded]: $channelName data: $data");
          }
          final me = pusherInstance.getChannel(channelName)?.me;
          if (kDebugMode) {
            print("[Me]: $me");
          }
        },
        onEvent: (PusherEvent event) {
          if (kDebugMode) {
            print("[onEvent]: $event");
          }
          if (event.eventName == 'message-event') {
            Map<String, dynamic> eventData = jsonDecode(event.data);
            Map<String, dynamic> messageData = eventData['data'];
            String senderNumber = messageData['sender']['phone_number'];
            if (user.getCurrentPhoneNumber() != senderNumber) {
              NotificationManager.showNotification(
                  id: DateTime.now().millisecondsSinceEpoch % 10000000,
                  title: senderNumber,
                  body: messageData['message']);
              AppBloc.conversationBloc.add(ConversationAppendEvent(
                  ConversationItemModel.fromSMSJson(messageData)));
            }
          }
        },
        onSubscriptionError: (String message, dynamic e) {
          if (kDebugMode) {
            print("[onSubscriptionError]: $message Exception: $e");
          }
        },
      );
      await pusherInstance.connect();
      await pusherInstance.subscribe(
          channelName:
              'private-conversations.${user.getCurrentPhoneNumber()!.substring(1)}');
    } catch (e) {
      if (kDebugMode) {
        print("[Pusher Exception]: ${e.toString()}");
      }
    }
  }

  static Future<void> unsubscribeChannel(UserModel user) async {
    await pusherInstance.unsubscribe(
        channelName:
            'private-conversations.${user.getCurrentPhoneNumber()!.substring(1)}');
  }

  static Future<void> resetChannel(UserModel user) async {
    pusherInstance.onAuthorizer =
        (String channelName, String socketId, dynamic options) async {
      return await Api.getPusherAuth(channel: channelName, socket: socketId);
    };
    pusherInstance.onEvent = (PusherEvent event) {
      if (kDebugMode) {
        print("[onEvent]: $event");
      }
      if (event.eventName == 'message-event') {
        Map<String, dynamic> eventData = jsonDecode(event.data);
        Map<String, dynamic> messageData = eventData['data'];
        String senderNumber = messageData['sender']['phone_number'];
        if (user.getCurrentPhoneNumber() != senderNumber) {
          NotificationManager.showNotification(
              id: DateTime.now().millisecondsSinceEpoch,
              title: senderNumber,
              body: messageData['message']);
          AppBloc.conversationBloc.add(ConversationAppendEvent(
              ConversationItemModel.fromSMSJson(messageData)));
        }
      }
    };
    pusherInstance.onSubscriptionSucceeded =
        (String channelName, dynamic data) {
      if (kDebugMode) {
        print("[onSubscriptionSucceeded]: $channelName data: $data");
      }
      final me = pusherInstance.getChannel(channelName)?.me;
      if (kDebugMode) {
        print("[Me]: $me");
      }
    };
    await pusherInstance.subscribe(
        channelName:
            'private-conversations.${user.getCurrentPhoneNumber()!.substring(1)}');
  }
}
