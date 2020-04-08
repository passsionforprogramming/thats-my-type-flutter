import 'dart:async';
import "package:flutter/material.dart";
import 'package:thatismytype/Constants/Palette.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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

  navigateToFaceBookSignIn() {}

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: kDarkerBackgroundColor,
      body: Column(
        children: <Widget>[
          Container(
              margin: EdgeInsets.only(top: screenHeight * .08),
              child: Container(
                margin: EdgeInsets.only(right: screenWidth * .35),
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
              margin: EdgeInsets.only(top: screenHeight * .015),
              child: Container(
                margin: EdgeInsets.only(right: screenWidth * .09),
                child: Text("My",
                    style: TextStyle(
                        fontSize: 36.0,
                        fontFamily: "Playfair",
                        color: kAccentBlack
                            .withOpacity(secondWordAnimation.value))),
              )),
          Container(
              margin: EdgeInsets.only(top: screenHeight * .015),
              child: Container(
                margin: EdgeInsets.only(left: screenWidth * .15),
                child: Text("Type",
                    style: TextStyle(
                        fontSize: 36.0,
                        fontFamily: "Playfair",
                        color: kAccentBlack
                            .withOpacity(thirdWordAnimation.value))),
              )),
          Container(
            margin: EdgeInsets.symmetric(vertical: screenHeight * .03),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Opacity(
                  opacity: thirdWordAnimation.value,
                  child: Container(
                    width: screenWidth * .5,
                    height: screenWidth * .5,
                    child: SvgPicture.asset(
                      "images/heart.svg",
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            width: screenWidth * .8,
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0)),
              padding: EdgeInsets.symmetric(vertical: screenHeight * .02),
              color: kAccentBlack,
              onPressed: navigateToFaceBookSignIn,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(FontAwesomeIcons.facebook, color: Colors.white),
                  SizedBox(
                    width: screenWidth * .03,
                  ),
                  Text(
                    "Continue with Facebook",
                    style: TextStyle(
                        fontFamily: "Gothic Semi-bold",
                        color: Colors.white,
                        fontSize: 18.0),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: screenHeight * .03),
            width: screenWidth * .8,
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0)),
              padding: EdgeInsets.symmetric(vertical: screenHeight * .02),
              color: kDarkerGreen,
              onPressed: navigateToFaceBookSignIn,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.phone, color: Colors.white),
                  SizedBox(
                    width: screenWidth * .03,
                  ),
                  Text(
                    "Use cell phone number",
                    style: TextStyle(
                        fontFamily: "Gothic Semi-bold",
                        color: Colors.white,
                        fontSize: 18.0),
                  ),
                ],
              ),
            ),
          ),
          Text(
            "Don't worry we never post to Facebook",
            style:
                TextStyle(color: Colors.white, fontFamily: "Josefin Sans Bold"),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: screenHeight * .03),
            width: screenWidth * .8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Terms of Service",
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Josefin Sans Bold",
                        decoration: TextDecoration.underline)),
                Text("Privacy Policy",
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Josefin Sans Bold",
                        decoration: TextDecoration.underline))
              ],
            ),
          )
        ],
      ),
    );
  }
}
