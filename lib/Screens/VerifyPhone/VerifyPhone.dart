import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:page_transition/page_transition.dart';
import 'package:thatismytype/Constants/Palette.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';
import 'package:thatismytype/Screens/ProfileSetup/ProfileSetup.dart';
import 'package:thatismytype/Util/Validators.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerifyPhone extends StatefulWidget {
  final userId;
  VerifyPhone({this.userId});
  @override
  _VerifyPhoneState createState() => _VerifyPhoneState();
}

class _VerifyPhoneState extends State<VerifyPhone> {
  bool loading = false;
  Country _selected = Country.US;
  GlobalKey<FormState> phoneVerificationKey = GlobalKey<FormState>();
  TextEditingController phoneNumberController;
  StreamController<ErrorAnimationType> errorController;
  bool error = false;
  bool inputtingPhoneNumber = true;
  String phoneNumber = "";
  String phoneValid;
  String finalPhone;
  String phoneErrorText;
  String verificationId;
  AuthCredential credential;
  TextEditingController pinController;
  String smsCode;
  List<String> code = [];
  int resendingToken;
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser loggedInUser;
  @override
  void initState() {
    phoneNumberController = TextEditingController()..addListener(phoneListener);
    pinController = TextEditingController();
    errorController = StreamController<ErrorAnimationType>();
    getCurrentUser();
    super.initState();
  }

  void phoneListener() {
    setState(() {
      phoneNumber = phoneNumberController.text;
    });
    validatePhoneNumber();
  }

  _verifyPhoneMethod() async {
    print("There are lots of people");
    if (phoneVerificationKey.currentState.validate()) {
      print("passed the validations");
      try {
        final PhoneVerificationCompleted verificationCompleted =
            (AuthCredential phoneCredential) async {
          loggedInUser.linkWithCredential(phoneCredential);
          print("verification completed");
          Navigator.pushReplacement(
              context,
              PageTransition(
                  type: PageTransitionType.leftToRightWithFade,
                  duration: Duration(seconds: 1),
                  child: ProfileSetup()));
        };
        final PhoneVerificationFailed verificationFailed =
            (AuthException authException) {
          setState(() {
            error = true;
            phoneErrorText = "Phone number is invalid";
            //errorDialog(stateScreenWidth);
            print(
                'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}');
          });
        };

        final PhoneCodeSent codeSent =
            (String verificationId, [int forceResendingToken]) async {
          this.verificationId = verificationId;
          this.resendingToken = forceResendingToken;
          print("success");
          setState(() {
            inputtingPhoneNumber = false;
          });
          print("code sent");
          //normalDialog(stateScreenWidth);
          //print("code sent to " + _phoneController.text.trim());
        };

        final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
            (String verificationId) {
          this.verificationId = verificationId;
          print("time out");
        };
        await _auth.verifyPhoneNumber(
            phoneNumber: finalPhone,
            timeout: const Duration(seconds: 5),
            verificationCompleted: verificationCompleted,
            verificationFailed: verificationFailed,
            codeSent: codeSent,
            codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
      } catch (e) {
        print(e);
      }
    }
  }

  getCurrentUser() async {
    loggedInUser = await _auth.currentUser();
  }

  linkPhoneCredential() async {
    print("I think it can be stronger");
    try {
      AuthCredential credential = PhoneAuthProvider.getCredential(
          verificationId: verificationId, smsCode: smsCode);
      this.credential = credential;
      loggedInUser.linkWithCredential(credential).then((AuthResult result) {
        print(result);
        Navigator.pushReplacement(
            context,
            PageTransition(
                type: PageTransitionType.leftToRightWithFade,
                duration: Duration(seconds: 1),
                child: ProfileSetup()));
      }).catchError((onError) {
        String invalidCodeError = "ERROR_INVALID_VERIFICATION_CODE";
        if (onError.toString().contains(invalidCodeError)) {
          setState(() {
            phoneErrorText = "Code invalid. Please try again";
          });
        }
      });
      print("credential $credential");
      print("link credential triggered");
    } catch (e) {
      print("There is an error $e");
      String invalidCodeError = "ERROR_INVALID_VERIFICATION_CODE";
      if (e.toString().contains(invalidCodeError)) {
        setState(() {
          phoneErrorText = "Code invalid. Please try again";
        });
      }
    }
  }

  _resendCodeToPhoneNumber() async {
    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      this.verificationId = verificationId;
      print("time out");
    };
    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      this.verificationId = verificationId;
      this.resendingToken = forceResendingToken;
    };

    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential phoneCredential) async {
      loggedInUser
          .linkWithCredential(phoneCredential); //link with different credential
      print("verification completed");
      Navigator.pushReplacement(
          context,
          PageTransition(
              type: PageTransitionType.leftToRightWithFade,
              duration: Duration(seconds: 1),
              child: ProfileSetup()));
    };
    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
      setState(() {
        error = true;
        print(
            'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}');
      });
    };
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: finalPhone,
      timeout: const Duration(seconds: 5),
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      forceResendingToken: this.resendingToken,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

  Future<void> validatePhoneNumber() async {
    final formattedPhone = "+${_selected.dialingCode}$phoneNumber";
    final bool verified = await validatePhone(
        number: formattedPhone, country: _selected.toString());
    if (!verified) {
      setState(() {
        phoneValid = "Please enter a valid phone number";
      });
    } else {
      setState(() {
        phoneValid = null;
        finalPhone = formattedPhone;
      });
    }
  }

  Widget inputPhoneNumber({screenHeight, screenWidth}) {
    return ListView(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(
            top: screenHeight * .04,
          ),
          alignment: Alignment.center,
          child: Text(
            "What's your number",
            style: TextStyle(
                fontFamily: "Karla-Bold",
                fontSize: 22.0,
                color: kDarkerAccentRedish),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(
              horizontal: screenWidth * .1, vertical: screenHeight * .03),
          width: screenWidth * .7,
          alignment: Alignment.center,
          child: Text(
            "We care about the security of your account and our community, so let's get a number",
            style: TextStyle(fontFamily: "Gothic", fontSize: 18.0),
          ),
        ),
        Container(
          width: screenWidth * .8,
          margin: EdgeInsets.symmetric(horizontal: screenWidth * .1),
          child: Row(
            children: <Widget>[
              CountryPicker(
                showFlag: true,
                showDialingCode: true,
                showName: false,
                onChanged: (Country country) {
                  setState(() {
                    _selected = country;
                  });
                },
                selectedCountry: _selected,
              ),
              Container(
                  width: screenWidth * .5,
                  child: TextFormField(
                    controller: phoneNumberController,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.done,
                    autovalidate: phoneNumber.length > 0,
                    decoration: InputDecoration(
                        hintText: "1234567890",
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                width: 1.0, color: kDarkerAccentRedish)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                width: 2.0, color: kDarkerAccentRedish))),
                    validator: (val) {
                      return phoneValid;
                    },
                    onFieldSubmitted: (val) {
                      _verifyPhoneMethod();
                    },
                  ))
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(
              horizontal: screenWidth * .1, vertical: screenHeight * .05),
          width: screenWidth * .8,
          child: RaisedButton(
            onPressed: _verifyPhoneMethod,
            color: kDarkerAccentRedish,
            padding: EdgeInsets.symmetric(vertical: 13.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.phone,
                  color: Colors.white,
                ),
                SizedBox(
                  width: screenWidth * .01,
                ),
                Text(
                  "Continue",
                  style: TextStyle(
                      fontFamily: "Gothic Semi-bold",
                      fontSize: 18.0,
                      color: Colors.white),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget inputCode({screenHeight, screenWidth}) {
    return ListView(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(
            top: screenHeight * .04,
          ),
          alignment: Alignment.center,
          child: Text(
            "Verify your number",
            style: TextStyle(
                fontFamily: "Karla-Bold",
                fontSize: 22.0,
                color: kDarkerAccentRedish),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(
              horizontal: screenWidth * .1, vertical: screenHeight * .01),
          width: screenWidth * .7,
          alignment: Alignment.center,
          child: Text(
            "Code sent to $finalPhone",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: "Karla-bold",
                fontSize: 16.0),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(
              horizontal: screenWidth * .1, vertical: screenHeight * .03),
          width: screenWidth * .7,
          alignment: Alignment.center,
          child: Text(
            "If it doesn't happen automatically, enter the 4 digit code we just sent you to verify your account.",
            style: TextStyle(fontFamily: "Gothic", fontSize: 18.0),
          ),
        ),
        phoneErrorText != null
            ? Container(
                margin: EdgeInsets.symmetric(
                    horizontal: screenWidth * .1, vertical: screenHeight * .03),
                width: screenWidth * .7,
                alignment: Alignment.center,
                child: Text(
                  phoneErrorText,
                  style: TextStyle(color: Colors.red, fontSize: 18.0),
                ),
              )
            : SizedBox(),
        Container(
          width: screenWidth * .6,
          margin: EdgeInsets.symmetric(horizontal: screenWidth * .15),
          child: PinCodeTextField(
            length: 6,
            onChanged: (val) {
              smsCode = val;
            },
            obsecureText: false,
            animationType: AnimationType.slide,
            shape: PinCodeFieldShape.underline,
            animationDuration: const Duration(milliseconds: 200),
            fieldHeight: 50.0,
            fieldWidth: 30.0,
            controller: pinController,
            errorAnimationController: errorController,
            backgroundColor: Colors.white.withOpacity(0.0),
            activeColor: kDarkerAccentRedish,
            inactiveColor: kDarkerAccentRedish,
            selectedColor: kDarkerGreen,
            onCompleted: (val) {
              linkPhoneCredential();
            },
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(
              horizontal: screenWidth * .1, vertical: screenHeight * .05),
          //width: screenWidth,
          //alignment: Alignment.center,
          child: RaisedButton(
            onPressed: linkPhoneCredential,
            color: kDarkerAccentRedish,
            padding: EdgeInsets.symmetric(vertical: 13.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            child: Text(
              "Continue",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontFamily: "Gothic Semi-bold"),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(
              horizontal: screenWidth * .1, vertical: screenHeight * .05),
          width: screenWidth * .7,
          alignment: Alignment.center,
          child: Column(
            children: <Widget>[
              GestureDetector(
                onTap: _resendCodeToPhoneNumber,
                child: Text(
                  "Didn't get your code? Tap here and we will resend it",
                  style: TextStyle(
                      color: kDarkerAccentRedish,
                      fontFamily: "Karla-Bold",
                      fontSize: 18.0),
                ),
              ),
              SizedBox(
                height: screenHeight * .03,
              ),
              GestureDetector(
                onTap: restart,
                child: Text(
                  "Did you put the wrong number? Tap here to start over.",
                  style: TextStyle(
                      color: kDarkerAccentRedish,
                      fontFamily: "Karla-Bold",
                      fontSize: 18.0),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  void restart() {
    setState(() {
      inputtingPhoneNumber = true;
      finalPhone = "";
    });
  }

  @override
  void dispose() {
    errorController.close();
    pinController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: kDarkerBackgroundColor,
      body: ModalProgressHUD(
          inAsyncCall: loading,
          child: Form(
              key: phoneVerificationKey,
              child: inputtingPhoneNumber
                  ? inputPhoneNumber(
                      screenHeight: screenHeight, screenWidth: screenWidth)
                  : inputCode(
                      screenHeight: screenHeight, screenWidth: screenWidth))),
    );
  }
}
