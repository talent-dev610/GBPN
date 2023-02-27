import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlocInspector extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    if (kDebugMode) {
      print("---------- Bloc Inspector -> onEvent ----------");
      print(event.toString());
      print("-----------------------------------------------");
    }
    super.onEvent(bloc, event);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    if (kDebugMode) {
      print("---------- Bloc Inspector -> onError ----------");
      print(error);
      print("-----------------------------------------------");
    }
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    if (kDebugMode) {
      print("---------- Bloc Inspector -> onTransition ----------");
      print("Event: ${transition.event.toString()}");
      print("Current State: ${transition.currentState.toString()}");
      print("Next State: ${transition.nextState.toString()}");
      print("----------------------------------------------------");
    }
    super.onTransition(bloc, transition);
  }
}