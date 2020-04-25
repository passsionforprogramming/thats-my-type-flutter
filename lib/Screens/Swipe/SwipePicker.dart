import 'package:flutter/material.dart';
import 'ProfileCard.dart';

class SwipePicker extends StatefulWidget {
  @override
  _SwipePickerState createState() => _SwipePickerState();
}

class _SwipePickerState extends State<SwipePicker> {
  List<ProfileCard> cardList = List.generate(8, (index) {
    return ProfileCard(
        imageUrl:
            "https://haply-seed.s3.us-east-2.amazonaws.com/${index + 1}.jpg");
  });

  void removeCard(int index, DraggableDetails details) {
    print("Here are the draggable details $details");
    if (details.offset.direction > 1) {
      print("swiped left");
    } else {
      print("swiped right");
    }
    setState(() {
      cardList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          "That's My Type",
          style: TextStyle(fontSize: 28.0),
        ),
        SizedBox(height: screenHeight * .03),
        Container(
          height: screenHeight * .72,
          child: Stack(
            children: cardList
                .asMap()
                .map((index, card) => MapEntry(
                    index,
                    Draggable(
                      axis: Axis.horizontal,
                      child: cardList[index],
                      childWhenDragging: Container(),
                      feedback: Material(
                        child: cardList[index],
                        elevation: 18.0,
                      ),
                      onDragEnd: (DraggableDetails details) =>
                          removeCard(index, details),
                    )))
                .values
                .toList(),
          ),
        )
      ],
    ));
  }
}
