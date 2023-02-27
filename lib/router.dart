import 'package:flutter/material.dart';
import 'package:gbpn_messages/consts/routes.dart';
import 'package:gbpn_messages/screen/auth/forgot_password_screen.dart';
import 'package:gbpn_messages/screen/auth/login_screen.dart';

Route<MaterialPageRoute> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case Routes.loginScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      );
    case Routes.forgotPasswordScreenRoute:
      return MaterialPageRoute(
        builder: (context) => const ForgotPasswordScreen(),
      );
    default:
      return MaterialPageRoute(
        builder: (context) => Scaffold(
          body: Center(
            child: Text(
              'No path for ${routeSettings.name}',
            ),
          ),
        ),
      );
  }
}
