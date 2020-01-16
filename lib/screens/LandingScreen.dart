import '../constants/Constants.dart';
import '../providers/UsersProvider.dart';
import '../screens/main_screens/home_screens/HomeScreen.dart';
import '../screens/main_screens/NewAgreementsScreen.dart';
import '../screens/main_screens/OldAgreementsScreen.dart';
import '../screens/main_screens/SettingsScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LandingScreen extends StatefulWidget {
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  int _selectedIndex = 0;
  dynamic _loadScreen = HomeScreen();
  String title = Constants.HOME_SCREEN_TITLE;
  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        _loadScreen = HomeScreen();
        title = Constants.HOME_SCREEN_TITLE;
        break;
      case 1:
        _loadScreen = NewAgreementsScreen();
        title = Constants.NEW_AGREEMENT_SCREEN_TITLE;
        break;
      case 2:
        _loadScreen = OldAgreementsScreen();
        title = Constants.OLD_AGREEMENT_SCREEN_TITLE;
        break;
      case 3:
        _loadScreen = SettingsScreen();
        title = Constants.SETTINGS_SCREEN_TITLE;
        break;
      default:
        _loadScreen = HomeScreen();
        title = Constants.HOME_SCREEN_TITLE;
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final usersProvider = Provider.of<UsersProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: _loadScreen,
      bottomNavigationBar: usersProvider.isUserLoggedIn
          ? BottomNavigationBar(
              unselectedItemColor: Colors.blueGrey[300],
              selectedItemColor: Colors.blueGrey[900],
              selectedLabelStyle: TextStyle(fontSize: 16),
              unselectedLabelStyle:
                  TextStyle(backgroundColor: Colors.blueGrey[300]),
              items: [
                BottomNavigationBarItem(
                  icon: new Icon(Icons.home),
                  title: new Text('Home'),
                ),
                BottomNavigationBarItem(
                  icon: new Icon(Icons.add_circle),
                  title: new Text(
                    'New Agreements',
                  ),
                ),
                BottomNavigationBarItem(
                  icon: new Icon(Icons.view_list),
                  title: new Text('Old Agreements'),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  title: Text('Settings'),
                ),
              ],
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
            )
          : null,
    );
  }
}
