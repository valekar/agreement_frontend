import '../screens/ForgotPasswordScreen.dart';

import '../constants/constants.dart';
import '../screens/SignInScreen.dart';

import 'package:flutter/material.dart';

class AuthScreens extends StatefulWidget {
  static const routeName = "auth-screens";

  @override
  _AuthScreensState createState() => _AuthScreensState();
}

class _AuthScreensState extends State<AuthScreens> {
  bool _isLoginScreen = true;

  void changeScreen(String type) {
    if (type == Constants.FORGOT_PASSWORD_TYPE) {
      setState(() {
        _isLoginScreen = false;
      });
    }
    if (type == Constants.LOGIN_TYPE) {
      setState(() {
        _isLoginScreen = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoginScreen
        ? SignInScreen(changeScreen)
        : ForgotPasswordScreen(changeScreen);
  }
}
