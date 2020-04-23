import 'package:flutter/material.dart';
import 'package:thatismytype/Constants/Palette.dart';

class IntroduceYourself extends StatefulWidget {
  @override
  _IntroduceYourselfState createState() => _IntroduceYourselfState();
}

class _IntroduceYourselfState extends State<IntroduceYourself> {
  String gender;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: screenHeight * .03),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Colors.grey[300],
                  radius: 5.0,
                ),
                SizedBox(
                  width: 3.0,
                ),
                CircleAvatar(
                  backgroundColor: kDarkerGreen,
                  radius: 5.0,
                ),
                SizedBox(
                  width: 3.0,
                ),
                CircleAvatar(
                  backgroundColor: Colors.grey[300],
                  radius: 5.0,
                ),
                SizedBox(
                  width: 3.0,
                ),
                CircleAvatar(
                  backgroundColor: Colors.grey[300],
                  radius: 5.0,
                )
              ],
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: screenHeight * .05),
            child: Text(
              "Introduce Yourself",
              style: TextStyle(
                  color: kDarkerGreen,
                  fontFamily: "Raleway Bold",
                  fontSize: 28.0),
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(
                horizontal: screenWidth * .1, vertical: screenHeight * .02),
            width: screenWidth * .8,
            child: Text(
              "Fill out the rest of your details so people know a little more about you.",
              style: TextStyle(fontFamily: "Gothic"),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(
                horizontal: screenWidth * .1, vertical: screenHeight * .03),
            child: Text(
              "I am a...",
              style: TextStyle(fontFamily: "Raleway", color: Colors.black87),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: screenWidth * .1,
            ),
            child: Row(
              children: <Widget>[
                Radio(
                    activeColor: kDarkerGreen,
                    value: "male",
                    groupValue: gender,
                    onChanged: (val) {
                      setState(() {
                        gender = val;
                      });
                    }),
                Text(
                  "Male",
                  style: TextStyle(fontFamily: "Gothic"),
                ),
                SizedBox(width: screenWidth * .1),
                Radio(
                  activeColor: kDarkerGreen,
                  value: "female",
                  groupValue: gender,
                  onChanged: (val) {
                    setState(() {
                      gender = val;
                    });
                  },
                ),
                Text(
                  "Female",
                  style: TextStyle(fontFamily: "Gothic"),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(
                horizontal: screenWidth * .1, vertical: screenHeight * .04),
            child: Text(
              "Birthday",
              style: TextStyle(color: Colors.black87, fontFamily: "Raleway"),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: screenWidth * .1,
              vertical: screenHeight * .02,
            ),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(width: 1.0, color: Colors.black26))),
            child: Text(
              "MM/DD/YYYY",
              style: TextStyle(
                  color: Colors.black54, fontSize: 18.0, fontFamily: "Raleway"),
            ),
          )
        ],
      ),
    );
  }
}
