import "package:flutter/material.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import 'package:thatismytype/Screens/TypeTest/TestQuestions.dart';
import "package:firebase_auth/firebase_auth.dart";

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  CollectionReference testsRef = Firestore.instance.collection("tests");
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser loggedInUser;
  TypeTest test;
  bool testLoaded = false;
  bool previousTest = false;
  bool testLoadError = false;

  Future<FirebaseUser> getCurrentUser() async {
    loggedInUser = await _auth.currentUser();
    return loggedInUser;
  }

  getTest() async {
    try {
      final FirebaseUser user = await getCurrentUser();
      DocumentSnapshot testDoc = await testsRef.document(user.uid).get();
      if (testDoc.exists) {
        test = TypeTest.fromDocument(testDoc);
        previousTest = true;
      }

      setState(() {
        testLoaded = true;
      });
    } catch (e) {
      print(e);
      setState(() {
        testLoaded = true;
        testLoadError = true;
      });
    }
  }

  @override
  void initState() {
    getTest();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(horizontal: screenWidth * .1),
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(spreadRadius: 1.0, color: Colors.black54)
            ]),
            child: Column(
              children: <Widget>[
                RichText(
                    text: TextSpan(children: <TextSpan>[
                  TextSpan(
                      text: "0%",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: "Completed")
                ]))
              ],
            ),
          )
        ],
      ),
    );
  }
}
