import 'package:flutter/material.dart';
import 'package:thatismytype/Screens/Greeting/Greeting.dart';
import 'package:thatismytype/Screens/Home/Home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final greetingScreen = "greetingScreen";
  final home = "home";
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      initialRoute: greetingScreen,
      routes: {
        greetingScreen: (context) => Greeting(),
        home: (context) => Home()
      },
    );
  }
}
