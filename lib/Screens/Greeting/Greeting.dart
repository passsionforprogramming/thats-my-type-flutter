import 'dart:async';
import "package:flutter/material.dart";
import 'package:thatismytype/Constants/Palette.dart';

class Greeting extends StatefulWidget {
  @override
  _GreetingState createState() => _GreetingState();
}

class _GreetingState extends State<Greeting> with TickerProviderStateMixin {
  AnimationController firstAnimationController;
  AnimationController secondAnimationController;
  AnimationController thirdAnimationController;
  Animation firstWordAnimation;
  Animation secondWordAnimation;
  Animation thirdWordAnimation;
  @override
  void initState() {
    firstAnimationController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    secondAnimationController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    thirdAnimationController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    firstWordAnimation = CurvedAnimation(
        parent: firstAnimationController, curve: Curves.decelerate)
      ..addListener(() {
        setState(() {
          print(firstWordAnimation.value);
        });
      });
    secondWordAnimation = CurvedAnimation(
        parent: secondAnimationController, curve: Curves.decelerate)
      ..addListener(() {
        setState(() {});
      });
    thirdWordAnimation = CurvedAnimation(
        parent: thirdAnimationController, curve: Curves.decelerate)
      ..addListener(() {
        setState(() {});
      });
    staggerFade();
    super.initState();
  }

  void trackState() {
    setState(() {});
  }

  staggerFade() {
    Timer(Duration(seconds: 1), () => firstAnimationController.forward());
    Timer(Duration(seconds: 2), () => secondAnimationController.forward());
    Timer(Duration(seconds: 4), () => thirdAnimationController.forward());
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: kDarkerBackgroundColor,
      body: Column(
        children: <Widget>[
          Container(
              margin: EdgeInsets.only(top: screenHeight * .1),
              child: Container(
                margin: EdgeInsets.only(left: screenWidth * .01),
                child: Text(
                  "That's",
                  style: TextStyle(
                      fontSize: 36.0,
                      fontFamily: "Playfair",
                      color:
                          kAccentBlack.withOpacity(firstWordAnimation.value)),
                ),
              )),
          Container(
              margin: EdgeInsets.only(top: screenHeight * .02),
              child: Container(
                margin: EdgeInsets.only(left: screenWidth * .30),
                child: Text("My",
                    style: TextStyle(
                        fontSize: 36.0,
                        fontFamily: "Playfair",
                        color: kAccentBlack
                            .withOpacity(secondWordAnimation.value))),
              )),
          Container(
              margin: EdgeInsets.only(top: screenHeight * .02),
              child: Container(
                margin: EdgeInsets.only(left: screenWidth * .5),
                child: Text("Type",
                    style: TextStyle(
                        fontSize: 36.0,
                        fontFamily: "Playfair",
                        color: kAccentBlack
                            .withOpacity(thirdWordAnimation.value))),
              ))
        ],
      ),
    );
  }
}
