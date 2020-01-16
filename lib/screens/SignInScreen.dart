//import 'package:basic/screens/landing.screen.dart';

import '../constants/constants.dart';
import '../providers/UsersProvider.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import '../widgets/CustomTextField.dart';
import '../business/Validator.dart';
import 'package:flutter/services.dart';
import '../widgets/CustomFlatButton.dart';
import '../widgets/CustomAlertDialog.dart';

class SignInScreen extends StatefulWidget {
  static const routeName = "/signIn";
  final Function changeScreen;

  SignInScreen(this.changeScreen);

  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _email = new TextEditingController();
  final TextEditingController _password = new TextEditingController();
  CustomTextField _emailField;
  CustomTextField _passwordField;
  bool _blackVisible = false;
  VoidCallback onBackPress;

  @override
  void initState() {
    super.initState();

    onBackPress = () {
      Navigator.of(context).pop();
    };

    _emailField = new CustomTextField(
      baseColor: Colors.grey,
      borderColor: Colors.grey[400],
      errorColor: Colors.blueGrey,
      controller: _email,
      hint: "E-mail Adress",
      inputType: TextInputType.emailAddress,
      validator: Validator.validateEmail,
    );
    _passwordField = CustomTextField(
      baseColor: Colors.grey,
      borderColor: Colors.grey[400],
      errorColor: Colors.blueGrey,
      controller: _password,
      obscureText: true,
      hint: "Password",
      validator: Validator.validatePassword,
    );
  }

  @override
  Widget build(BuildContext context) {
    final usersProvider = Provider.of<UsersProvider>(context);
    final screenSize = MediaQuery.of(context).size;
    return Stack(
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              child: Text(
                "Agreement",
                softWrap: true,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.blueGrey,
                  decoration: TextDecoration.none,
                  fontSize: 48.0,
                  fontWeight: FontWeight.w700,
                  fontFamily: "OpenSans",
                ),
              ),
              padding: const EdgeInsets.all(70),
            ),
          ],
        ),
        Stack(
          alignment: Alignment.topLeft,
          children: <Widget>[
            ListView(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 5,
                      bottom: 10.0,
                      left: 15.0,
                      right: 10.0),
                  child: Text(
                    Constants.SIGN_IN,
                    softWrap: true,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.blueGrey,
                      decoration: TextDecoration.none,
                      fontSize: 24.0,
                      fontWeight: FontWeight.w700,
                      fontFamily: "OpenSans",
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: 20.0, bottom: 10.0, left: 15.0, right: 15.0),
                  child: _emailField,
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: 10.0, bottom: 20.0, left: 15.0, right: 15.0),
                  child: _passwordField,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 14.0, horizontal: 40.0),
                  child: CustomFlatButton(
                    title: Constants.SIGN_IN,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    textColor: Colors.white,
                    onPressed: () {
                      _emailLogin(
                          email: _email.text,
                          password: _password.text,
                          usersProvider: usersProvider);
                    },
                    splashColor: Colors.black12,
                    borderColor: Color.fromRGBO(212, 20, 15, 1.0),
                    borderWidth: 0,
                    color: Colors.blueGrey,
                  ),
                ),
                Divider(
                  height: screenSize.height / 12,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 14.0, horizontal: 40.0),
                  child: CustomFlatButton(
                    title: Constants.REGISTER_AUTOMATICALLY,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    textColor: Colors.white,
                    onPressed: () {
                      usersProvider.autoCreateUser();
                    },
                    splashColor: Colors.black12,
                    borderColor: Color.fromRGBO(59, 89, 152, 1.0),
                    borderWidth: 0,
                    color: Colors.blueGrey,
                  ),
                ),
                Divider(
                  height: screenSize.height / 20,
                ),
                GestureDetector(
                    child: Text(Constants.FORGOTTEN_PASSWORD,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontSize: 24,
                            color: Colors.blue)),
                    onTap: () {
                      widget.changeScreen(Constants.FORGOT_PASSWORD_TYPE);
                    }),
              ],
            ),
          ],
        ),
        Offstage(
          offstage: !_blackVisible,
          child: GestureDetector(
            onTap: () {},
            child: AnimatedOpacity(
              opacity: _blackVisible ? 1.0 : 0.0,
              duration: Duration(milliseconds: 400),
              curve: Curves.ease,
              child: Container(
                height: MediaQuery.of(context).size.height,
                color: Colors.black54,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _changeBlackVisible() {
    setState(() {
      _blackVisible = !_blackVisible;
    });
  }

  void _emailLogin({String email, String password, final usersProvider}) async {
    if (!Validator.validateEmail(email)) {
      _changeBlackVisible();
      _showErrorAlert(
          title: Constants.EMAIL_FAIL,
          content: Constants.EMAIL_FAIL_MESSAGE,
          onPressed: _changeBlackVisible);
    } else if (!Validator.validatePassword(password)) {
      _changeBlackVisible();
      _showErrorAlert(
          title: Constants.PASSWORD_FAIL,
          content: Constants.PASSWORD_FAIL_MESAGE,
          onPressed: _changeBlackVisible);
    } else {
      try {
        _changeBlackVisible();
        await usersProvider.userSignIn(email, password);
        if (usersProvider.isUserLoggedIn) {
          //Navigator.of(context).pushReplacementNamed(LandingScreen.routeName);
        }
      } catch (error) {
        _showErrorAlert(
            title: Constants.ERROR_OCCURED,
            content: error.toString(),
            onPressed: _changeBlackVisible);
      }
    }
  }

  void _showErrorAlert({String title, String content, VoidCallback onPressed}) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return CustomAlertDialog(
          content: content,
          title: title,
          onPressed: onPressed,
        );
      },
    );
  }
}
