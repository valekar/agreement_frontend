import 'package:agreement_frontend/providers/UsersProvider.dart';
import 'package:agreement_frontend/screens/AuthScreen.dart';
import 'package:agreement_frontend/screens/LandingScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EntryScreen extends StatefulWidget {
  @override
  _EntryScreenState createState() => _EntryScreenState();
}

class _EntryScreenState extends State<EntryScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    () async {
      await new Future.delayed(Duration.zero, () {
        tryAutoLogin();
      });
    }();
  }

  void tryAutoLogin() async {
    final usersStore = Provider.of<UsersProvider>(context, listen: false);
    await usersStore.autoLogin();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final usersProvider = Provider.of<UsersProvider>(context);
    return _isLoading
        ? Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.blueGrey,
              ),
            ),
          )
        : usersProvider.isUserLoggedIn
            ? LandingScreen()
            : Scaffold(
                body: AuthScreens(),
              );
  }
}
