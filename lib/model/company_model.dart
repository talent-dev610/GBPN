import 'package:flutter/foundation.dart';

class CompanyModel {
  String? uuid, name, timezone;
  List<String>? phoneNumbers;

  CompanyModel({this.uuid, this.name, this.timezone, this.phoneNumbers});

  CompanyModel loadFromJson(Map<String, dynamic> data) {
    uuid = data['uuid'];
    name = data['name'];
    timezone = data['timezone'];
    if (kDebugMode) {
      print("[Company Name]: " + name!);
      print("[Company UUID]: " + uuid!);
      print("[Company Timezone]: " + timezone!);
    }
    if (data['phone_numbers'] != null && data['phone_numbers'].isNotEmpty) {
      phoneNumbers = data['phone_numbers'].map<String>((e) {
        if (kDebugMode) {
          print("[Company Phone Number]: " + e.toString());
        }
        return e.toString();
      }).toList();
    } else {
      phoneNumbers = [];
    }
    return this;
  }
}
