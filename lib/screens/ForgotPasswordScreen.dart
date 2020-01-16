import 'package:agreement_frontend/business/Validator.dart';
import 'package:agreement_frontend/constants/Constants.dart';
import 'package:agreement_frontend/widgets/CustomAlertDialog.dart';
import 'package:agreement_frontend/widgets/CustomFlatButton.dart';
import 'package:agreement_frontend/widgets/CustomTextField.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  final Function changeScreen;
  ForgotPasswordScreen(this.changeScreen);
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _email = new TextEditingController();
  CustomTextField _emailField;
  bool _blackVisible = false;

  @override
  void initState() {
    super.initState();

    _emailField = new CustomTextField(
      baseColor: Colors.grey,
      borderColor: Colors.grey[400],
      errorColor: Colors.blueGrey,
      controller: _email,
      hint: Constants.HINT_EMAIL_ADDRESS,
      inputType: TextInputType.emailAddress,
      validator: Validator.validateEmail,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Stack(
          alignment: Alignment.topLeft,
          children: <Widget>[
            ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                      top: 70.0, bottom: 10.0, left: 10.0, right: 10.0),
                  child: Text(
                    Constants.FORGOTTEN_PASSWORD,
                    softWrap: true,
                    textAlign: TextAlign.left,
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
                  padding: EdgeInsets.only(top: 10.0, left: 15.0, right: 15.0),
                  child: _emailField,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 25.0, horizontal: 40.0),
                  child: CustomFlatButton(
                    title: Constants.RESET_PASSWORD,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    textColor: Colors.white,
                    onPressed: () {
                      _signUp(email: _email.text);
                    },
                    splashColor: Colors.black12,
                    borderColor: Color.fromRGBO(59, 89, 152, 1.0),
                    borderWidth: 0,
                    color: Colors.blueGrey,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 25.0, horizontal: 40.0),
                  child: CustomFlatButton(
                    title: Constants.BACK_TO_LOGIN,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    textColor: Colors.white,
                    onPressed: () {
                      widget.changeScreen(Constants.LOGIN_TYPE);
                    },
                    splashColor: Colors.black12,
                    borderColor: Color.fromRGBO(59, 89, 152, 1.0),
                    borderWidth: 0,
                    color: Colors.blueGrey,
                  ),
                ),
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

  void _signUp({String email}) async {
    if (!Validator.validateEmail(email)) {
      _changeBlackVisible();
      _showErrorAlert(
          title: Constants.EMAIL_FAIL,
          content: Constants.EMAIL_FAIL_MESSAGE,
          onPressed: _changeBlackVisible);
    } else {
      //send email api for resetting password
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
