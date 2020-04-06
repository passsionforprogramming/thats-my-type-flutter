import 'package:flutter/material.dart';
import 'package:thatismytype/Screens/Greeting/Greeting.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final greetingScreen = "greetingScreen";
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      initialRoute: greetingScreen,
      routes: {greetingScreen: (context) => Greeting()},
    );
  }
}
