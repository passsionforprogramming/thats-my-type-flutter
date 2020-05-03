import 'package:flutter/material.dart';
import "./TestQuestions.dart";
import "package:cloud_firestore/cloud_firestore.dart";

class TypeScreen extends StatefulWidget {
  final TypeTest test;
  TypeScreen({this.test});
  @override
  _TypeScreenState createState() => _TypeScreenState();
}

class _TypeScreenState extends State<TypeScreen> {
  double progress;
  CollectionReference testsRef = Firestore.instance.collection("tests");
  List<Map<String, dynamic>> currentQuestions = [];
  Map<String, dynamic> _currentQuestionValue;
  @override
  void initState() {
    progress = widget.test.questionsAnswered.length / 36;
    currentQuestions = widget.test.displayQuestions();
    super.initState();
  }

  handleSubmit() {
    if (widget.test.questionsAnswered.isEmpty) {
      testsRef.document("userId").setData({
        "answerGroup": _currentQuestionValue["id"],
        "type": _currentQuestionValue["type"],
        _currentQuestionValue["type"]: 1,
        "questionsAnswered":
            FieldValue.arrayUnion([_currentQuestionValue["id"]])
      });
      widget.test.scoreQuestion(
          uniqueId: _currentQuestionValue["uniqueId"],
          type: _currentQuestionValue["type"]);
      widget.test.addQuestionToAnswered(_currentQuestionValue["id"]);
      setState(() {
        currentQuestions = widget.test.displayQuestions();
      });
    }
  }

  questionBuilder() {
    return ListView.builder(
        itemCount: currentQuestions.length,
        itemBuilder: (BuildContext context, int index) {
          return RadioListTile(
              value: currentQuestions[index]["type"],
              groupValue: _currentQuestionValue,
              onChanged: (val) {
                setState(() {
                  _currentQuestionValue = val;
                });
              });
        });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double containerSize = screenWidth * .8;

    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            decoration:
                BoxDecoration(borderRadius: BorderRadius.circular(10.0)),
            height: 2.0,
            width: containerSize,
            margin: EdgeInsets.symmetric(horizontal: screenWidth * .1),
            child: Container(
                height: 2.0,
                width: progress * containerSize,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.blue)),
          ),
          SizedBox(height: screenHeight * .1),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(horizontal: .1),
            child: Text(
                "Be Honest...Be Spontaneous...And choose the one that best describes you!"),
          ),
          SizedBox(
            height: screenHeight * .1,
          ),
          questionBuilder(),
          SizedBox(
            height: screenHeight * .1,
          ),
          RaisedButton(
            child: Text("Next"),
            onPressed: handleSubmit,
          )
        ],
      ),
    );
  }
}
