import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gbpn_messages/api/api.dart';
import 'package:gbpn_messages/bloc/app_bloc.dart';
import 'package:gbpn_messages/bloc/conversation/conversation_event.dart';
import 'package:gbpn_messages/consts/preference_params.dart';
import 'package:gbpn_messages/model/company_model.dart';
import 'package:gbpn_messages/model/user_model.dart';
import 'package:gbpn_messages/util/preference_helper.dart';
import 'package:gbpn_messages/util/pusher_manager.dart';

import 'bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitialState()) {
    on((AuthCheckEvent event, emit) => _mapAuthCheckEventToState(event, emit));
    on((AuthLoginEvent event, emit) => _mapAuthLoginEventToState(event, emit));
    on((AuthLogoutEvent event, emit) => _mapAuthLogoutEventToState(event, emit));
    on((AuthSelectCompanyEvent event, emit) => _mapAuthSelectCompanyEventToState(event, emit));
  }

  void _mapAuthCheckEventToState(AuthCheckEvent event, emit) async {
    String? token = PreferenceHelper.getString(PreferenceParams.bearerToken);
    if (token == null) {
      emit(AuthLoggedOutState());
    } else {
      UserModel? user = UserModel();
      user.load();
      user = await _getProfile(user);
      if (user == null) {
        emit(AuthFailedState(errMsg: 'unauthenticated'));
      } else {
        await _loadData(user);
        emit(AuthLoggedInState(user: user));
      }
    }
  }

  void _mapAuthLoginEventToState(AuthLoginEvent event, emit) async {
    emit(AuthLoadingState());
    String email = event.email;
    String password = event.password;
    final response = await Api.login(email: email, password: password);
    if (response['success'] == true) {
      final name = response['user']['name'];
      final token = response['bearer_token'];
      final appAuthToken = response['app_auth_token'];
      UserModel? user = UserModel(name: name, email: email, password: password, bearerToken: token, appAuthToken: appAuthToken);
      await user.store();
      user = await _getProfile(user);
      if (user == null) {
        emit(AuthFailedState(errMsg: 'unauthenticated'));
      } else {
        await _loadData(user);
        emit(AuthLoggedInState(user: user));
      }
    } else {
      emit(AuthFailedState(errMsg: response['code']));
    }
  }

  Future<UserModel?> _getProfile(UserModel user) async {
    final profileResponse = await Api.whoAmI();
    if (profileResponse['success'] != null && profileResponse['success'] == false) {
      return null;
    }
    final data = profileResponse['data'];
    final uuid = data['uuid'];
    final selectedCompany = data['selected_company'];
    List<dynamic> companiesList = data['companies'];
    List<CompanyModel> companies = companiesList.map<CompanyModel>((e) => CompanyModel().loadFromJson(e)).toList();
    user.uuid = uuid;
    user.selectedCompany = selectedCompany;
    user.companies = companies;
    return user;
  }

  Future<void> _loadData(UserModel user) async {
    await PusherManager.initPusher(user);
    String? selectedPhone = user.getCurrentPhoneNumber();
    AppBloc.conversationBloc.add(ConversationLoadEvent(phoneNumber: selectedPhone));
  }

  Future<void> _resetData(UserModel user) async {
    await PusherManager.resetChannel(user);
    String? selectedPhone = user.getCurrentPhoneNumber();
    AppBloc.conversationBloc.add(ConversationLoadEvent(phoneNumber: selectedPhone));
  }

  void _mapAuthLogoutEventToState(AuthLogoutEvent event, emit) async {
    emit(AuthLoadingState());
    await PreferenceHelper.clear();
    emit(AuthLoggedOutState());
  }

  void _mapAuthSelectCompanyEventToState(AuthSelectCompanyEvent event, emit) async {
    UserModel user = (state as AuthLoggedInState).user;
    await PusherManager.unsubscribeChannel(user);
    final response = await Api.selectCompany(uuid: event.uuid);
    if (response['status'] == 1) {
      user.selectedCompany = event.uuid;
      await _resetData(user);
      emit(AuthLoadingState());
      emit(AuthLoggedInState(user: user));
    }
  }
}
