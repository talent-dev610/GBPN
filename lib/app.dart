import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:gbpn_messages/bloc/app_bloc.dart';
import 'package:gbpn_messages/consts/themes.dart';
import 'package:gbpn_messages/main.dart';
import 'package:gbpn_messages/screen/auth/login_screen.dart';
import 'package:gbpn_messages/screen/home/main_screen.dart';

import 'bloc/bloc.dart';
import 'router.dart' as router;

class GBPNMessageApp extends StatefulWidget {
  const GBPNMessageApp({Key? key}) : super(key: key);

  @override
  State<GBPNMessageApp> createState() => _GBPNMessageAppState();
}

class _GBPNMessageAppState extends State<GBPNMessageApp> {

  @override
  void initState() {
    super.initState();
    AppBloc.applicationBloc.add(ApplicationStartEvent());
  }

  @override
  void dispose() {
    AppBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: AppBloc.blocProviders,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'GBPN',
          theme: AppTheme.initialTheme(),
          onGenerateRoute: router.generateRoute,
          home: BlocBuilder<ApplicationBloc, ApplicationState>(
            builder: (context, appState) {
              if (appState is ApplicationLoadingState) {
                return Container();
              } else {
                return BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, authState) {
                      if (authState is AuthLoggedInState) {
                        FlutterNativeSplash.remove();
                        return const MainScreen();
                      } else if (authState is AuthInitialState) {
                        return Container();
                      } else {
                        FlutterNativeSplash.remove();
                        return const LoginScreen();
                      }
                    },
                );
              }
            },
          ),
        )
    );
  }
}
