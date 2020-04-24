import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
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
  String name;
  DateTime birthday;
  List<String> errors = [];
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = false;
  bool networkError = false;
  GlobalKey<FormState> introduceFormKey = GlobalKey<FormState>();
  FirebaseUser loggedInUser;
  CollectionReference userRef = Firestore.instance.collection("users");

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

  getCurrentUser() async {
    try {
      final FirebaseUser user = await _auth.currentUser();
      if (user != null) loggedInUser = user;
    } catch (e) {
      setState(() {
        networkError = true;
      });
    }
  }

  validateForm() {
    if (gender == null) errors.add("Please select your gender");
    if (birthday == null) errors.add("Please enter your date of birth");
    if (birthday != null &&
        birthday.add(Duration(days: 365 * 13)).isBefore(DateTime.now()))
      errors.add("Sorry, You must be at least 13 years old to use this app.");
  }

  void handleSubmit() async {
    try {
      errors = [];
      if (introduceFormKey.currentState.validate()) {
        validateForm();
        if (errors.isNotEmpty) return;
      }
      setState(() {
        isLoading = true;
      });

      await userRef
          .document(loggedInUser.uid)
          .updateData({"gender": gender, "birthdate": birthday, "name": name});

      Navigator.pushReplacement(
          context,
          PageTransition(
              child: HelloScreen(),
              type: PageTransitionType.scale,
              duration: Duration(milliseconds: 200)));
    } catch (e) {
      print(e);
      // warning box should go there with refresh.
    }
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
  void initState() {
    getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: Form(
          child: ListView(
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
                  style:
                      TextStyle(fontFamily: "Raleway", color: Colors.black87),
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
                  style:
                      TextStyle(color: Colors.black87, fontFamily: "Raleway"),
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
                    handleSubmit();
                  },
                  onChanged: (val) {
                    setState(() {
                      name = val;
                    });
                  },
                  decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: kDarkerGreen, width: 2.0)),
                      labelText: "Name",
                      labelStyle:
                          TextStyle(fontFamily: "Raleway", color: kDarkerGreen),
                      hintText: "Add your first name"),
                ),
              ),
              errors.length > 0
                  ? Container(
                      alignment: Alignment.center,
                      margin:
                          EdgeInsets.symmetric(horizontal: screenWidth * .1),
                      child: Column(
                          children: errors
                              .map((error) => Text(
                                    error,
                                    style: TextStyle(color: Colors.red),
                                  ))
                              .toList()))
                  : SizedBox(),
              Container(
                margin: EdgeInsets.only(
                    left: .1 * screenWidth,
                    right: screenWidth * .1,
                    top: screenHeight * .12),
                child: RaisedButton(
                  onPressed: () {
                    handleSubmit();
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
        ),
      ),
    );
  }
}
