import 'package:event_bus/event_bus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gbpn_messages/bloc/app_bloc.dart';
import 'package:gbpn_messages/util/globals.dart';
import 'package:gbpn_messages/util/notification_manager.dart';
import 'package:gbpn_messages/util/preference_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../bloc.dart';

class ApplicationBloc extends Bloc<ApplicationEvent, ApplicationState> {
  ApplicationBloc() : super(ApplicationLoadingState()){
    on((ApplicationStartEvent event, emit) => _mapApplicationStartEventToState(event, emit));
  }

  void _mapApplicationStartEventToState(ApplicationStartEvent event, emit) async {
    /// Init preferences
    Globals.eventBus = EventBus();
    PreferenceHelper.preferences = await SharedPreferences.getInstance();
    NotificationManager.configureNotification(onSelectNotification: (p0) {
      if (kDebugMode) {
        print('[onSelectNotification]: $p0');
        NotificationManager.notificationInstance.cancelAll();
      }
    });

    AppBloc.authBloc.add(AuthCheckEvent());
    emit(ApplicationLoadedState());
  }
}