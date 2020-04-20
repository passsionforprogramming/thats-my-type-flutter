import "package:flutter/material.dart";
import "dart:io";

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:thatismytype/Constants/Palette.dart';

class CircleImageDisplay extends StatelessWidget {
  final File file;
  CircleImageDisplay(this.file);
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      //margin: EdgeInsets.only(right: screenWidth * .1),
      width: screenWidth * .1,
      height: screenWidth * .1,
      decoration: BoxDecoration(
          border: Border.all(color: kDarkerGreen, width: 3.0),
          //boxShadow: [BoxShadow(color: Colors.green, spreadRadius: 3.0)],
          shape: BoxShape.circle,
          image: file != null
              ? DecorationImage(image: FileImage(file), fit: BoxFit.cover)
              : null),
      child: file == null
          ? Icon(FontAwesomeIcons.plus, color: kDarkerGreen)
          : null,
    );
  }
}
