import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:thatismytype/Constants/Palette.dart';
import 'package:flutter_time_date_picker/flutter_time_date_picker.dart';
import 'package:thatismytype/Screens/ProfileSetup/HelloScreen.dart';

class IntroduceYourself extends StatefulWidget {
  @override
  _IntroduceYourselfState createState() => _IntroduceYourselfState();
}

class _IntroduceYourselfState extends State<IntroduceYourself> {
  String gender;
  DateTime birthday;
  List<String> errors = [];

  showDatePicker() {
    DatePicker.showDatePicker(context,
        initialDateTime: DateTime.now().subtract(Duration(days: 365 * 21)),
        locale: DATETIME_PICKER_LOCALE_DEFAULT,
        pickerMode: DateTimePickerMode.date, onChange: (date, list) {
      setState(() {
        print("Here is the date $date");
        birthday = date;
      });
    });
  }

  displayDatePicker(screenHeight, screenWidth) {
    return showAnimatedDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            elevation: 5.0,
            content: Container(
              height: screenHeight * .5,
              width: screenWidth * 6,
              child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime:
                      DateTime.now().subtract(Duration(days: 365 * 21)),
                  onDateTimeChanged: (date) {
                    setState(() {
                      birthday = date;
                    });
                  }),
            ),
          );
        },
        animationType: DialogTransitionType.scale,
        barrierDismissible: true,
        duration: Duration(milliseconds: 200),
        curve: Curves.bounceIn);
  }

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
            child: GestureDetector(
              onTap: () => showDatePicker(),
              child: Text(
                birthday == null
                    ? "MM/DD/YYYY"
                    : DateFormat.yMd("en_US").format(birthday),
                style: TextStyle(
                    color: Colors.black54,
                    fontSize: 18.0,
                    fontFamily: "Raleway"),
              ),
            ),
          ),
          Container(
            width: screenWidth * .8,
            margin: EdgeInsets.symmetric(horizontal: screenWidth * .1),
            child: TextFormField(
              textInputAction: TextInputAction.done,
              validator: (val) {
                if (val.length > 2) return null;
                return "The name must be at least two characters.";
              },
              onFieldSubmitted: (val) {
                Navigator.pushReplacement(
                    context,
                    PageTransition(
                        child: HelloScreen(), type: PageTransitionType.scale));
              },
              decoration: InputDecoration(
                  labelText: "Name",
                  labelStyle: TextStyle(fontFamily: "Raleway"),
                  hintText: "Add your first name"),
            ),
          ),
          errors.length > 0
              ? Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: screenWidth * .1),
                  child: Column(
                      children: errors
                          .map((error) => Text(
                                error,
                                style: TextStyle(color: Colors.red),
                              ))
                          .toList()))
              : SizedBox(),
          Container(
            margin: EdgeInsets.symmetric(
                horizontal: screenWidth * .1, vertical: screenHeight * .15),
            child: RaisedButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    PageTransition(
                        child: HelloScreen(),
                        type: PageTransitionType.scale,
                        duration: Duration(milliseconds: 200)));
              },
              color: kDarkerGreen,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0)),
              padding: EdgeInsets.symmetric(vertical: 14.0),
              child: Text(
                "Continue",
                style: TextStyle(color: Colors.white, fontSize: 17.0),
              ),
            ),
          )
        ],
      ),
    );
  }
}
