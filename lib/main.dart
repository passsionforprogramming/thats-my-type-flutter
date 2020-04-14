import 'package:flutter/material.dart';
import 'package:thatismytype/Constants/Palette.dart';
import 'package:thatismytype/Screens/Greeting/Greeting.dart';
import 'package:thatismytype/Screens/Home/Home.dart';
import 'package:thatismytype/Screens/VerifyPhone/VerifyPhone.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final greetingScreen = "greetingScreen";
  final home = "home";
  final verifyPhone = "verifyPhone";
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(focusColor: Colors.red),
      title: 'Flutter Demo',
      initialRoute: greetingScreen,
      routes: {
        greetingScreen: (context) => Greeting(),
        home: (context) => Home(),
        verifyPhone: (context) => VerifyPhone()
      },
    );
  }
}
