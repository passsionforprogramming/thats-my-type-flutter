import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:thatismytype/Constants/Palette.dart';

class ProfileSetup extends StatefulWidget {
  @override
  _ProfileSetupState createState() => _ProfileSetupState();
}

class _ProfileSetupState extends State<ProfileSetup> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: ModalProgressHUD(
          inAsyncCall: loading,
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                child: Row(
                  children: <Widget>[
                    CircleAvatar(
                      backgroundColor: kDarkBlue,
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.grey[300],
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.grey[300],
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.grey[300],
                    )
                  ],
                ),
              ),
              Container(
                alignment: Alignment.center,
                width: screenHeight * .3,
                height: screenHeight * .3,
                child: CircleAvatar(
                  child: Icon(
                    Icons.person_pin,
                    size: screenHeight * .25,
                  ),
                ),
              )
            ],
          )),
    );
  }
}
