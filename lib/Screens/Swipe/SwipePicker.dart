import 'package:flutter/material.dart';
import 'ProfileCard.dart';
import 'package:rxdart/rxdart.dart';

class SwipePicker extends StatefulWidget {
  @override
  _SwipePickerState createState() => _SwipePickerState();
}

class _SwipePickerState extends State<SwipePicker> {
  double deltaX = 1.0;
  double startPosition = 0;
  double endPosition = 0;
  final BehaviorSubject<double> subject = BehaviorSubject<double>.seeded(0.0);
  List<ProfileCard> cardList = List.generate(8, (index) {
    return ProfileCard(
        imageUrl:
            "https://haply-seed.s3.us-east-2.amazonaws.com/${index + 1}.jpg");
  });

  void setDeltaX() {
//    setState(() {
//      deltaX = endPosition - startPosition;
//      print("deltax: $deltaX");
//    });
    deltaX = endPosition - startPosition;
    subject.add(deltaX / 1000);
  }

  void removeCard(int index, DraggableDetails details) {
    print("Here is the dx: ${details.offset.dx}");
    print("Here is the dy: ${details.offset.dy}");
    print("Here is the distance: ${details.offset.distance}");
    print("here is the velocity: ${details.velocity}");
    if (details.offset.dx > 100 &&
        details.velocity.pixelsPerSecond.dx > 100.0) {
      print("swiped right");
      setState(() {
        cardList.removeAt(index);
      });
    } else if (details.offset.dx < -100 &&
        details.velocity.pixelsPerSecond.dx < -100.0) {
      print("swiped left");
      setState(() {
        cardList.removeAt(index);
      });
    } else {
      print("not enough juice go back");
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: screenHeight * .05,
        ),
        Text(
          "That's My Type",
          style: TextStyle(fontSize: 28.0, fontFamily: "Playfair"),
        ),
        SizedBox(height: screenHeight * .03),
        Container(
          height: screenHeight * .72,
          width: screenWidth,
          child: Stack(
            children: cardList
                .asMap()
                .map((index, card) => MapEntry(
                    index,
                    Listener(
                      onPointerDown: (PointerDownEvent evt) {
                        //print("PointerDownEvent ${evt.localPosition.dx}");
                        startPosition = evt.localPosition.dx;
                      },
                      onPointerMove: (PointerMoveEvent evt) {
                        //print("Pointer Move Event: ${evt.localPosition.dx}");
                        endPosition = evt.localPosition.dx;
                        print("deltax position: $deltaX");
                        setDeltaX();
                      },
                      child: Draggable(
                        axis: Axis.horizontal,
                        child: cardList[index],
                        childWhenDragging: Container(),
                        feedback: StreamBuilder(
                            initialData: 0.0,
                            stream: subject,
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              print("Here is stream ${snapshot.data}");
                              return Transform.rotate(
                                angle: snapshot.data,
                                child: Material(
                                  child: cardList[index],
                                  elevation: 18.0,
                                ),
                              );
                            }),
                        onDragEnd: (DraggableDetails details) =>
                            removeCard(index, details),
                      ),
                    )))
                .values
                .toList(),
          ),
        )
      ],
    ));
  }
}
