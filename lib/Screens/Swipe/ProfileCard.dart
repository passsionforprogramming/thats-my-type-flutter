import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

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
      width: screenWidth * .9,
      margin: EdgeInsets.symmetric(horizontal: .05 * screenWidth),
      height: screenHeight * .7,
      child: ListView(
        children: <Widget>[
          CachedNetworkImage(
            imageUrl: widget.imageUrl,
            fit: BoxFit.fitHeight,
          ),
          Text("more text here"),
        ],
      ),
    );
  }
}
