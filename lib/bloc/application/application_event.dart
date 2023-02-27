import 'package:meta/meta.dart';

@immutable
abstract class ApplicationEvent {}

class ApplicationStartEvent extends ApplicationEvent {}
