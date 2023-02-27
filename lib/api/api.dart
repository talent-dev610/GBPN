import 'package:dio/dio.dart';
import 'package:gbpn_messages/api/http_multipart_manager.dart';
import 'package:intl/intl.dart';

import 'http_manager.dart';

class Api {
  static Future<dynamic> login({required String email, required String password}) async {
    return await httpManager.post(url: '/auth', data: {'email': email, 'password': password}, authToken: false);
  }

  static Future<dynamic> whoAmI() async {
    return await httpManager.get(url: '/who-am-i');
  }

  static Future<dynamic> getVoicemails() async {
    return await httpManager.get(url: '/voicemail');
  }

  static Future<dynamic> deleteVoicemail(String id) async {
    return await httpManager.delete(url: '/voicemail/$id');
  }

  static Future<dynamic> deleteSMS(String id) async {
    return await httpManager.delete(url: '/sms/conversations/$id');
  }
  
  static Future<dynamic> getMessages(String? phone) async {
    return await httpManager.get(url: '/sms/conversations?phone_numbers[]=' + (phone ?? ''));
  }

  static Future<dynamic> sendMessage(FormData data) async {
    return await httpMultipartManager.post(url: '/sms/messages', data: data);
  }

  static Future<dynamic> readMessage(String id, DateTime readAt) async {
    return await httpManager.put(url: '/sms/messages/$id', data: {'read_at': readAt.toString()});
  }

  static Future<dynamic> getPusherAuth({required String channel, required String socket}) async {
    return await httpManager.post(url: '/broadcasting/auth', data: {
      'socket_id': socket, 'channel_name': channel
    });
  }

  static Future<dynamic> selectCompany({required String uuid}) async {
    return await httpManager.post(url: '/select-company/$uuid');
  }

  static Future<dynamic> getCalls({DateTime? startDate}) async {
    return await httpManager.get(url: '/calls', params: {"start_date": DateFormat('yyyy-MM-DD').format(startDate ?? DateTime(2020, 1, 1))});
  }
}