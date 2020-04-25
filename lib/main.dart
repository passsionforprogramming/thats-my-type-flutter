import 'package:flutter/material.dart';
import 'package:thatismytype/Constants/Palette.dart';
import 'package:thatismytype/Screens/Greeting/Greeting.dart';
import 'package:thatismytype/Screens/Home/Home.dart';
import 'package:thatismytype/Screens/ProfileSetup/ProfileSetup.dart';
import 'package:thatismytype/Screens/Swipe/SwipePicker.dart';
import 'package:thatismytype/Screens/VerifyPhone/VerifyPhone.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final greetingScreen = "greetingScreen";
  final home = "home";
  final verifyPhone = "verifyPhone";
  final profileSetup = "profileSetup";
  final swipePicker = "swipePicker";
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(focusColor: Colors.red),
      title: 'Flutter Demo',
      initialRoute: swipePicker,
      routes: {
        greetingScreen: (context) => Greeting(),
        home: (context) => Home(),
        verifyPhone: (context) => VerifyPhone(),
        profileSetup: (context) => ProfileSetup(),
        swipePicker: (context) => SwipePicker()
      },
    );
  }
}
