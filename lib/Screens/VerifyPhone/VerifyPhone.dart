import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:page_transition/page_transition.dart';
import 'package:thatismytype/Constants/Palette.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';
import 'package:thatismytype/Screens/ProfileSetup/ProfileSetup.dart';
import 'package:thatismytype/Util/Validators.dart';

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
  bool error = false;
  String phoneNumber = "";
  String phoneValid;
  String finalPhone;
  String phoneErrorText;
  String verificationId;
  int resendingToken;
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser loggedInUser;
  @override
  void initState() {
    phoneNumberController = TextEditingController()..addListener(phoneListener);
    super.initState();
  }

  void phoneListener() {
    setState(() {
      phoneNumber = phoneNumberController.text;
    });
    validatePhoneNumber();
  }

  _verifyPhone() async {
    if (phoneVerificationKey.currentState.validate()) {
      try {
        final PhoneVerificationCompleted verificationCompleted =
            (AuthCredential phoneCredential) async {
          loggedInUser.linkWithCredential(
              phoneCredential); //link with different credential
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
            timeout: null,
            verificationCompleted: verificationCompleted,
            verificationFailed: verificationFailed,
            codeSent: codeSent,
            codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
      } catch (e) {
        print(e);
      }
    }
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
            child: ListView(
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
                      horizontal: screenWidth * .1,
                      vertical: screenHeight * .03),
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
                                        width: 1.0,
                                        color: kDarkerAccentRedish)),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 2.0,
                                        color: kDarkerAccentRedish))),
                            validator: (val) {
                              return phoneValid;
                            },
                            onFieldSubmitted: (val) {
                              _verifyPhone();
                            },
                          ))
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: screenWidth * .1,
                      vertical: screenHeight * .05),
                  width: screenWidth * .8,
                  child: RaisedButton(
                    onPressed: _verifyPhone,
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
            ),
          )),
    );
  }
}
