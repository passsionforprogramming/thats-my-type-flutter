import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:thatismytype/Constants/Palette.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class ProfileSetup extends StatefulWidget {
  @override
  _ProfileSetupState createState() => _ProfileSetupState();
}

class _ProfileSetupState extends State<ProfileSetup> {
  bool loading = false;
  String imageID = Uuid().v4(); //initializing UUID
  final StorageReference storageRef = FirebaseStorage.instance.ref();

  void addPhoto() {}
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
                margin: EdgeInsets.only(top: screenHeight * .1),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
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
                width: screenHeight * .3,
                height: screenHeight * .3,
                child: Icon(
                  Icons.person_pin,
                  size: screenHeight * .25,
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(vertical: screenHeight * .03),
                child: Text(
                  "Let's bulid your profile",
                  style: TextStyle(
                      fontFamily: "Raleway Bold",
                      color: kDarkerGreen,
                      fontSize: 26.0),
                ),
              ),
              Container(
                width: screenWidth * .6,
                margin: EdgeInsets.symmetric(
                    horizontal: screenWidth * .2, vertical: screenHeight * .01),
                child: Text(
                  "That's My Type is about building lasting connections between real people. Please add at least one photo of yourself with nobody else in the picture.",
                  style: TextStyle(color: kDarkerGreen, fontFamily: "Gothic"),
                ),
              ),
              SizedBox(
                height: screenHeight * .2,
              ),
              Container(
                width: screenWidth * .8,
                margin: EdgeInsets.symmetric(horizontal: screenWidth * .1),
                child: RaisedButton(
                  onPressed: addPhoto,
                  color: kDarkerGreen,
                  child: Text(
                    "Add Photo",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontFamily: "Gothic Semi-bold"),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                  padding: EdgeInsets.symmetric(vertical: 13.0),
                ),
              )
            ],
          )),
    );
  }
}
