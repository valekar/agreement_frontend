import 'package:agreement_frontend/constants/Constants.dart';
import 'package:agreement_frontend/models/model.dart';
import 'package:agreement_frontend/providers/UsersProvider.dart';
import 'package:agreement_frontend/screens/EntryScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final isExisting = await AgreementModel().initializeDB();
  if (isExisting) {
    //BasicModel().initializeDB();

  }

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: UsersProvider(),
        )
      ],
      child: MaterialApp(
        title: Constants.TITLE,
        theme: ThemeData(primarySwatch: Colors.blueGrey),
        home: EntryScreen(),
        routes: {},
      ),
    );
  }
}
