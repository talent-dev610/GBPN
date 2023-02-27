import 'package:meta/meta.dart';

@immutable
abstract class ApplicationState {}

class ApplicationLoadingState extends ApplicationState {}

class ApplicationLoadedState extends ApplicationState {}