import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thatismytype/Constants/Palette.dart';

class ProfileCard extends StatefulWidget {
  final String imageUrl;
  ProfileCard({this.imageUrl});
  @override
  _ProfileCardState createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
      width: screenWidth * .9,
      margin: EdgeInsets.symmetric(horizontal: .05 * screenWidth),
      height: screenHeight * .7,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: ListView(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: CachedNetworkImage(
                imageUrl: widget.imageUrl,
                fit: BoxFit.fill,
                height: screenHeight * .7,
              ),
            ),
            Container(
              decoration: BoxDecoration(color: kLighterGreen),
              child: Text("A great title"),
            ),
          ],
        ),
      ),
    );
  }
}
