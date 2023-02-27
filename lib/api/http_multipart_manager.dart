import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:gbpn_messages/consts/app_consts.dart';
import 'package:gbpn_messages/consts/preference_params.dart';
import 'package:gbpn_messages/util/preference_helper.dart';

Map<String, dynamic> dioErrorHandle(DioError error) {
  if (kDebugMode) {
    print('DIO ERROR: $error');
  }
  switch (error.type) {
    case DioErrorType.response:
      return {"success": false, "code": "unauthenticated"};
    case DioErrorType.sendTimeout:
    case DioErrorType.receiveTimeout:
      return {"success": false, "code": "request_time_out"};
    default:
      return {"success": false, "code": "connect_to_server_fail"};
  }
}

class HTTPMultipartManager {
  BaseOptions baseOptions = BaseOptions(
    baseUrl: AppConsts.baseUrl,
  );

  ///Post method
  Future<dynamic> post({
    required String url,
    required FormData data,
    bool authToken = true,
  }) async {
    if (kDebugMode) {
      print('POST REQUEST: $url');
      print('PARAMS: $data');
    }
    Dio dio = Dio(baseOptions);
    try {
      final response = await dio.post(url, data: data, options: generateOptions(authToken));
      if (kDebugMode) {
        print('----------- API response -----------');
        print(response);
      }
      return response.data;
    } on DioError catch (error) {
      return dioErrorHandle(error);
    }
  }

  ///Get method
  Future<dynamic> get({
    required String url,
    Map<String, dynamic>? params,
    bool authToken = true,
  }) async {
    if (kDebugMode) {
      print('GET REQUEST: $url');
      print('PARAMS: $params');
    }
    Dio dio = Dio(baseOptions);
    try {
      final response = await dio.get(url, queryParameters: params, options: generateOptions(authToken));
      if (kDebugMode) {
        print('----------- API response -----------');
        print(response);
      }
      return response.data;
    } on DioError catch (error) {
      return dioErrorHandle(error);
    }
  }

  Options generateOptions(bool authToken) {
    Options options = Options();
    if (authToken) {
      String? token = PreferenceHelper.getString(PreferenceParams.bearerToken);
      if (token != null) {
        Map<String, String> headers = {
          'Authorization': 'Bearer $token',
          'Content-Type': 'multipart/form-data'
        };
        options.headers = headers;
      }
    }
    return options;
  }

  factory HTTPMultipartManager() {
    return HTTPMultipartManager._internal();
  }

  HTTPMultipartManager._internal();
}

HTTPMultipartManager httpMultipartManager = HTTPMultipartManager();
