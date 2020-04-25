import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'dart:async';

import 'package:thatismytype/Constants/Palette.dart';
import 'package:thatismytype/Screens/Home/Home.dart';

class HelloScreen extends StatefulWidget {
  final name;
  HelloScreen({this.name});
  @override
  _HelloScreenState createState() => _HelloScreenState();
}

class _HelloScreenState extends State<HelloScreen>
    with TickerProviderStateMixin {
  AnimationController fadeTextController;
  Animation fadeInAnimation;
  AnimationController secondLineController;
  Animation secondLineAnimation;
  @override
  void initState() {
    fadeTextController =
        AnimationController(vsync: this, duration: Duration(seconds: 3));
    fadeInAnimation = CurvedAnimation(
        parent: fadeTextController, curve: Curves.decelerate)
      ..addListener(() {
        setState(() {});
        fadeTextController.forward();
        secondLineController =
            AnimationController(vsync: this, duration: Duration(seconds: 3));
        secondLineAnimation = CurvedAnimation(
            parent: secondLineController, curve: Curves.decelerate);
        Timer(Duration(seconds: 2), () => secondLineController.forward());
        //Timer(Duration(seconds: 5), () => Navigator.pushReplacement(context, PageTransition(child: Home(), type: PageTransitionType.leftToRight, duration: Duration(seconds: 2))));
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
            child: Text(
          "Hi ${widget.name}",
          style: TextStyle(
              color: kDarkerGreen.withOpacity(fadeInAnimation.value),
              fontFamily: "Libre Baskerville",
              fontSize: 36.0),
        )),
        Container(
          margin: EdgeInsets.only(top: screenHeight * .02),
          child: Text(
            "Let's find your type",
            style: TextStyle(
                color: kDarkerGreen.withOpacity(fadeInAnimation.value),
                fontFamily: "Libre Baskerville",
                fontSize: 36.0),
          ),
        ),
      ],
    ));
  }
}
