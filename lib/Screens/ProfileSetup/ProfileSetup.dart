import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:page_transition/page_transition.dart';
import 'package:thatismytype/Constants/Palette.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:thatismytype/Screens/ProfileSetup/CircleImageDisplay.dart';
import 'package:uuid/uuid.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as Im;
import "package:thatismytype/Screens/Home/Home.dart";

class ProfileSetup extends StatefulWidget {
  final String userId;
  ProfileSetup({this.userId});
  @override
  _ProfileSetupState createState() => _ProfileSetupState();
}

class _ProfileSetupState extends State<ProfileSetup> {
  bool loading = false;
  int imageIdx;
  File file;
  bool networkError = false;
  FirebaseUser loggedInUser;
  CollectionReference userRef = Firestore.instance.collection("users");
  FirebaseAuth _auth = FirebaseAuth.instance;
  final StorageReference storageRef = FirebaseStorage.instance.ref();
  List<File> _images = List.generate(6, (index) => null, growable: true);

  void getUser() async {
    try {
      loggedInUser = await _auth.currentUser();
    } catch (e) {
      setState(() {
        networkError = true;
      });
    }
  }

  chooseImage({index = 0}) {
    imageIdx = index;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text('Profile photo'),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: handleCamera,
                child: ListTile(
                  leading: SvgPicture.asset(
                    'images/camera.svg',
                    semanticsLabel: 'Camera',
                    height: 50.0,
                  ),
                  title: Text(
                    'Camera',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SimpleDialogOption(
                onPressed: handleGallery,
                child: ListTile(
                  leading: SvgPicture.asset(
                    'images/gallery.svg',
                    semanticsLabel: 'Gallery',
                    height: 50.0,
                  ),
                  title: Text(
                    'Gallery',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          );
        });
  }

  void insertImage({File file}) {
//    for (int i = 0; i < 6; i++) {
//      if (_images[i] == null) {
//        setState(() {
//          _images[i] = file;
//        });
//        print("Here is i: $i");
//        break;
//      }
//    }
    setState(() {
      _images[imageIdx] = file;
    });
  }

  void removeImage(int idx) {
    Navigator.of(context, rootNavigator: true).pop();
    _images.removeAt(idx);
    print(_images);
    setState(() {
      _images.add(null);
    });
  }

  void handleGallery() async {
    Navigator.of(context, rootNavigator: true).pop();
    File file = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      this.file = file;
      loading = true;
    });
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: file.path,
        aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0));
    setState(() {
      loading = false;
      if (croppedFile != null) {
        insertImage(file: croppedFile);
        this.file = null;
      }
    });
  }

  Future<String> uploadImage(imageFile) async {
    String imageID = Uuid().v4();
    StorageUploadTask uploadTask =
        storageRef.child("pro_$imageID.jpg").putFile(imageFile);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  multiImageBuilder(screenWidth, screenHeight) {
    return Column(
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
          margin: EdgeInsets.symmetric(vertical: screenHeight * .03),
          child: Text(
            "Why not add more photos?",
            style: TextStyle(
                fontFamily: "Raleway Bold",
                color: kDarkerGreen,
                fontSize: 24.0),
          ),
        ),
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.symmetric(vertical: screenHeight * .001),
          width: screenWidth * .9,
          child: Text(
            "It only takes a second and it boosts your chances of finding someone!",
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: "Raleway", fontSize: 20.0),
          ),
        ),
        Container(
          height: screenHeight * .55,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
                itemCount: _images.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: screenWidth * .07,
                    mainAxisSpacing: screenWidth * .07),
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                      onTap: () {},
                      child: GestureDetector(
                          onTap: () => chooseImage(index: index),
                          onLongPress: () => _images[index] == null
                              ? chooseImage(index: index)
                              : deleteImageDialog(index: index),
                          child: CircleImageDisplay(_images[index])));
                }),
          ),
        ),
        Container(
          width: screenWidth * .9,
          child: RaisedButton(
            onPressed: handleImageUpload,
            color: kDarkerGreen,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Continue",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontFamily: "Gothic Semi-bold"),
                )
              ],
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0)),
            padding: EdgeInsets.symmetric(vertical: 13.0),
          ),
        )
      ],
    );
  }

  deleteImageDialog({index}) {
    print("What is the index here: $index");
    imageIdx = index;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () => removeImage(imageIdx),
                child: ListTile(
                  leading: Icon(
                    FontAwesomeIcons.trash,
                    color: kDarkerGreen,
                    size: 30.0,
                  ),
                  title: Text(
                    'Remove Image',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          );
        });
  }

  void handleCamera() async {
    Navigator.of(context, rootNavigator: true).pop();
    File file = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      this.file = file;
    });
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: file.path,
        aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0));
    setState(() {
      loading = false;
      if (croppedFile != null) {
        insertImage(file: croppedFile);
        this.file = null;
      }
    });
  }

  Future<File> compressImage({File file}) async {
    String imageID = Uuid().v4();
    final tempDir =
        await getTemporaryDirectory(); //creating temporary directory
    final path = tempDir.path; //creating temporary path from directory
    Im.Image imageFile =
        Im.decodeImage(file.readAsBytesSync()); //reading file stored in state
    final compressedImageFile = File('$path/img_$imageID.jpg')
      ..writeAsBytesSync(
          Im.encodeJpg(imageFile, quality: 85)); //writing JPG to temporary path
    return compressedImageFile;
  }

  handleImageUpload() async {
    try {
      setState(() {
        loading = true;
      });
      List<String> urls = [];
      for (File imageFile in _images) {
        print("running...");
        if (imageFile != null) {
          final compressedFile = await compressImage(file: imageFile);
          String downloadUrl = await uploadImage(compressedFile);
          urls.add(downloadUrl);
        }
      }
      if (urls.isNotEmpty) {
        await userRef.document(loggedInUser.uid).updateData({
          "phoneNumber": loggedInUser.phoneNumber,
          "photoUrls": FieldValue.arrayUnion(urls)
        });
      }
      setState(() {
        loading = false;
      });
      Navigator.pushReplacement(
          context,
          PageTransition(
              child: Home(),
              type: PageTransitionType.leftToRight,
              duration: Duration(milliseconds: 200)));
    } catch (e) {
      print("Here is the error in uploading $e");
      setState(() {
        loading = false;
        networkError = true;
      });
    }
  }

  Column initialImage(screenWidth, screenHeight) {
    print(loggedInUser.phoneNumber);
    return Column(
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
        GestureDetector(
          onTap: chooseImage,
          child: Container(
            alignment: Alignment.center,
            width: screenHeight * .3,
            height: screenHeight * .3,
            child: _images[0] == null
                ? Icon(
                    Icons.person_pin,
                    size: screenHeight * .25,
                  )
                : null,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: _images[0] != null
                    ? DecorationImage(image: FileImage(_images[0]))
                    : null),
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
            onPressed: chooseImage,
            color: kDarkerGreen,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  FontAwesomeIcons.camera,
                  color: Colors.white,
                ),
                SizedBox(
                  width: screenWidth * .04,
                ),
                Text(
                  "Add Photo",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontFamily: "Gothic Semi-bold"),
                )
              ],
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            padding: EdgeInsets.symmetric(vertical: 13.0),
          ),
        )
      ],
    );
  }

  @override
  void initState() {
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: ModalProgressHUD(
          inAsyncCall: loading,
          child: _images[0] == null
              ? initialImage(screenWidth, screenHeight)
              : multiImageBuilder(screenWidth, screenHeight)),
    );
  }
}
