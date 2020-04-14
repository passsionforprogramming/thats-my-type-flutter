import "package:flutter/material.dart";
import 'package:international_phone_input/international_phone_input.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:thatismytype/Constants/Palette.dart';

class VerifyPhone extends StatefulWidget {
  final userId;
  VerifyPhone({this.userId});
  @override
  _VerifyPhoneState createState() => _VerifyPhoneState();
}

class _VerifyPhoneState extends State<VerifyPhone> {
  bool loading = false;
  GlobalKey<FormState> phoneVerificationKey = GlobalKey<FormState>();
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
                    top: screenHeight * .1,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "Whats's your number",
                    style: TextStyle(fontFamily: "Playfair", fontSize: 22.0),
                  ),
                ),
                Container(
                  width: screenWidth * .7,
                  alignment: Alignment.center,
                  child: Text(
                    "We care about the security of your account and our community, so let's get a number",
                    style: TextStyle(fontFamily: "Gothic", fontSize: 18.0),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: screenWidth * .15),
                  child: Text("Cell phone number"),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: screenWidth * .15),
                  child: InternationalPhoneInput(
                    hintText: "1234567890",
                    labelText: "Cell phone number",
                  ),
                )
              ],
            ),
          )),
    );
  }
}
