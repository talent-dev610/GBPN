import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:gbpn_messages/app.dart';
import 'package:gbpn_messages/util/bloc_inspector.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  BlocOverrides.runZoned(
        () => runApp(const GBPNMessageApp()),
    blocObserver: BlocInspector(),
  );
}
