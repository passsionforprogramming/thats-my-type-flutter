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
              child: Stack(
                children: <Widget>[
                  Container(
                    foregroundDecoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Colors.black12, Colors.black87],
                          begin: Alignment(0.0, .6),
                          end: Alignment(0.0, 1.0)),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: widget.imageUrl,
                      fit: BoxFit.fill,
                      height: screenHeight * .7,
                    ),
                  ),
                  Positioned(
                      bottom: screenHeight * .1,
                      left: 15.0,
                      child: Text(
                        "Ima Sample, 29",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "Roboto Bold",
                            fontSize: 28.0),
                      ))
                ],
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
