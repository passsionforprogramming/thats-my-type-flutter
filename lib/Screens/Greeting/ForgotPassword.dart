import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:thatismytype/Constants/Palette.dart';
import 'package:thatismytype/Screens/Greeting/Greeting.dart';
import 'package:thatismytype/Util/Validators.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController emailController;
  String email = "";
  bool displayWarningBox = false;
  FirebaseAuth _auth = FirebaseAuth.instance;
  GlobalKey<FormState> resetPasswordKey = GlobalKey<FormState>();

  @override
  void initState() {
    emailController = TextEditingController()
      ..addListener(() {
        setState(() {
          email = emailController.text;
        });
      });
    super.initState();
  }

  String emailValidator(val) {
    if (validEmail(email: email)) return null;
    return "Plese enter a valid email";
  }

  Future<void> sendPasswordLink() async {
    if (resetPasswordKey.currentState.validate()) {
      try {
        await _auth.sendPasswordResetEmail(email: email);
        setState(() {
          displayWarningBox = true;
        });
      } catch (e) {
        print(e);
      }
    }
  }

  warningBox(screenWidth, screenHeight) {
    return Container(
        color: kDarkerAccentRedish,
        padding: EdgeInsets.all(screenWidth * .03),
        margin: EdgeInsets.only(bottom: screenHeight * .03),
        child: Row(
          children: <Widget>[
            Icon(
              Icons.info_outline,
              color: Colors.white,
              size: 35.0,
            ),
            SizedBox(
              width: screenWidth * .04,
            ),
            Container(
              width: screenWidth * .6,
              child: Text(
                "A password reset link has been sent to $email",
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Gothic Semi-bold",
                    fontSize: 14.0),
              ),
            ),
            SizedBox(
              width: screenWidth * .04,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    PageTransition(
                        child: Greeting(),
                        type: PageTransitionType.leftToRight));
              },
              child: Icon(
                Icons.close,
                color: Colors.white,
                size: 35.0,
              ),
            )
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: kDarkerBackgroundColor,
      body: Form(
        key: resetPasswordKey,
        child: ListView(
          children: <Widget>[
            displayWarningBox
                ? warningBox(screenWidth, screenHeight)
                : SizedBox(),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(
                  vertical: screenHeight * .05, horizontal: screenWidth * .1),
              width: screenWidth * .8,
              child: Text(
                "Reset Password",
                style: TextStyle(
                    color: kDarkerAccentRedish,
                    fontFamily: "Playfair Bold",
                    fontSize: 36.0),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: screenWidth * .1),
              color: Colors.white10,
              width: screenWidth * .8,
              child: TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (val) {
                  sendPasswordLink();
                },
                validator: emailValidator,
                decoration: InputDecoration(
                    labelText: "Email",
                    hintText: "Enter email here...",
                    labelStyle: TextStyle(color: kDarkBlue),
                    prefixIcon: Icon(
                      Icons.email,
                      color: kDarkBlue,
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: kDarkBlue,
                            width: 1.0,
                            style: BorderStyle.solid)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: kDarkBlue,
                            width: 3.0,
                            style: BorderStyle.solid))),
              ),
            ),
            Container(
              width: screenWidth * .9,
              margin: EdgeInsets.symmetric(
                  vertical: screenHeight * .05, horizontal: screenWidth * .05),
              child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0)),
                  padding: EdgeInsets.symmetric(vertical: screenHeight * .02),
                  color: kDarkerAccentRedish,
                  onPressed: sendPasswordLink,
                  child: Text(
                    "Get Reset Link",
                    style: TextStyle(
                        fontFamily: "Gothic Semi-bold",
                        color: Colors.white,
                        fontSize: 18.0),
                  )),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    PageTransition(
                        child: Greeting(),
                        type: PageTransitionType.leftToRight));
              },
              child: Container(
                margin: EdgeInsets.only(top: screenHeight * .01),
                alignment: Alignment.center,
                width: .8 * screenWidth,
                child: Text(
                  "Return to Sign In",
                  style: TextStyle(
                      color: kDarkBlue,
                      fontSize: 17.0,
                      fontFamily: "Josefin Sans Bold"),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
