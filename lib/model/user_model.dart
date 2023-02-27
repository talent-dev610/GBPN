import 'package:flutter/foundation.dart';
import 'package:gbpn_messages/consts/preference_params.dart';
import 'package:gbpn_messages/model/company_model.dart';
import 'package:gbpn_messages/util/preference_helper.dart';

class UserModel {
  String? name, email, password, bearerToken, appAuthToken, uuid, selectedCompany;
  List<CompanyModel>? companies;

  UserModel({
    this.name = "",
    this.email = "",
    this.password = "",
    this.bearerToken = "",
    this.appAuthToken = ""});

  Future<void> store() async {
    await PreferenceHelper.setString(PreferenceParams.name, name);
    await PreferenceHelper.setString(PreferenceParams.email, email);
    await PreferenceHelper.setString(PreferenceParams.password, email);
    await PreferenceHelper.setString(PreferenceParams.bearerToken, bearerToken);
    if (kDebugMode) {
      print("[Bearer Token]: " + bearerToken!);
    }
    await PreferenceHelper.setString(PreferenceParams.appAuthToken, appAuthToken);
  }

  void load() {
    name = PreferenceHelper.getString(PreferenceParams.name);
    email = PreferenceHelper.getString(PreferenceParams.email);
    password = PreferenceHelper.getString(PreferenceParams.password);
    bearerToken = PreferenceHelper.getString(PreferenceParams.bearerToken);
    if (kDebugMode) {
      print("[Bearer Token]: " + bearerToken!);
    }
    appAuthToken = PreferenceHelper.getString(PreferenceParams.appAuthToken);
  }

  CompanyModel? getSelectedCompany() {
    if (companies == null || companies!.isEmpty) return null;
    return companies!.firstWhere((element) => selectedCompany != null && element.uuid == selectedCompany);
  }

  String? getCurrentPhoneNumber() {
    CompanyModel? selectedCompany = getSelectedCompany();
    if (selectedCompany == null) return null;
    if (selectedCompany.phoneNumbers == null || selectedCompany.phoneNumbers!.isEmpty) return null;
    return selectedCompany.phoneNumbers!.first;
  }

  int getSelectedCompanyIndex() {
    return companies!.indexOf(getSelectedCompany()!);
  }
}