import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc.dart';

class AppBloc {
  static final applicationBloc = ApplicationBloc();
  static final authBloc = AuthBloc();
  static final conversationBloc = ConversationBloc();

  static final List<BlocProvider> blocProviders = [
    BlocProvider<ApplicationBloc>(create: (context) => applicationBloc),
    BlocProvider<AuthBloc>(create: (context) => authBloc),
    BlocProvider<ConversationBloc>(create: (context) => conversationBloc),
  ];

  static void dispose() {
    applicationBloc.close();
    authBloc.close();
    conversationBloc.close();
  }

  ///Singleton factory
  static final AppBloc _instance = AppBloc._internal();
  factory AppBloc() {
    return _instance;
  }
  AppBloc._internal();
}