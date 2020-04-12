import 'dart:async';
import "package:flutter/material.dart";
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:thatismytype/Constants/Palette.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:cloud_firestore/cloud_firestore.dart";
import 'package:page_transition/page_transition.dart';
import 'package:thatismytype/Screens/Home/Home.dart';
import 'package:thatismytype/Screens/VerifyPhone/VerifyPhone.dart';
import 'package:thatismytype/Util/Validators.dart';

class Greeting extends StatefulWidget {
  @override
  _GreetingState createState() => _GreetingState();
}

class _GreetingState extends State<Greeting> with TickerProviderStateMixin {
  AnimationController firstAnimationController;
  AnimationController secondAnimationController;
  AnimationController thirdAnimationController;
  TextEditingController emailController;
  TextEditingController passwordController;
  FocusNode emailFocusNode;
  FocusNode passwordFocusNode;
  Animation firstWordAnimation;
  Animation secondWordAnimation;
  Animation thirdWordAnimation;
  final FacebookLogin facebookLogin = FacebookLogin();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference usersRef = Firestore.instance.collection("users");
  FirebaseUser loggedInUser;
  bool signUpProcess = true;
  bool loading = false;
  bool signInMode = false;
  bool emailError = false;
  bool passwordError = false;
  String email;
  String password;
  String emailErrorText;
  String passwordErrorText;

  GlobalKey<FormState> signUpKey = GlobalKey<FormState>();

  @override
  void initState() {
    firstAnimationController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    secondAnimationController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    thirdAnimationController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    firstWordAnimation = CurvedAnimation(
        parent: firstAnimationController, curve: Curves.decelerate)
      ..addListener(() {
        setState(() {
          print(firstWordAnimation.value);
        });
      });
    secondWordAnimation = CurvedAnimation(
        parent: secondAnimationController, curve: Curves.decelerate)
      ..addListener(() {
        setState(() {});
      });
    thirdWordAnimation = CurvedAnimation(
        parent: thirdAnimationController, curve: Curves.decelerate)
      ..addListener(() {
        setState(() {});
      });
    staggerFade();
    emailController = TextEditingController()
      ..addListener(() {
        setState(() {
          email = emailController.text;
        });
      });
    passwordController = TextEditingController()
      ..addListener(() {
        setState(() {
          password = passwordController.text;
        });
      });
    emailFocusNode = FocusNode();
    passwordFocusNode = FocusNode();
    super.initState();
  }

  void trackState() {
    setState(() {});
  }

  staggerFade() {
    Timer(Duration(seconds: 1), () => firstAnimationController.forward());
    Timer(Duration(seconds: 2), () => secondAnimationController.forward());
    Timer(Duration(seconds: 4), () => thirdAnimationController.forward());
  }

  navigateToFaceBookSignIn() async {
    final FacebookLoginResult facebookLoginResult =
        await facebookLogin.logIn(["email"]);
    if (facebookLoginResult.status == FacebookLoginStatus.loggedIn) {
      final AuthCredential credential = FacebookAuthProvider.getCredential(
          accessToken: facebookLoginResult.accessToken.token);
      loggedInUser = (await _auth.signInWithCredential(credential)).user;
      print("signed in ${loggedInUser.displayName}");
      loggedInUser.linkWithCredential(credential);
      await usersRef.document(loggedInUser.uid).setData({
        "name": loggedInUser.displayName,
        "mediaUrl": loggedInUser.photoUrl
      });
      Navigator.pushReplacement(
        context,
        PageTransition(
          type: PageTransitionType.leftToRight,
          duration: Duration(milliseconds: 200),
          child: Home(),
        ),
      );
    }
  }

  Column signUp({screenWidth, screenHeight}) {
    return Column(
      children: <Widget>[
        Container(
          width: screenWidth * .8,
          child: RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0)),
            padding: EdgeInsets.symmetric(vertical: screenHeight * .02),
            color: kAccentBlack,
            onPressed: navigateToFaceBookSignIn,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(FontAwesomeIcons.facebook, color: Colors.white),
                SizedBox(
                  width: screenWidth * .03,
                ),
                Text(
                  "Continue with Facebook",
                  style: TextStyle(
                      fontFamily: "Gothic Semi-bold",
                      color: Colors.white,
                      fontSize: 18.0),
                ),
              ],
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: screenHeight * .03),
          width: screenWidth * .8,
          child: RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0)),
            padding: EdgeInsets.symmetric(vertical: screenHeight * .02),
            color: kDarkerGreen,
            onPressed: () {
              setState(() {
                signUpProcess = false;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.email, color: Colors.white),
                SizedBox(
                  width: screenWidth * .03,
                ),
                Text(
                  "Use email",
                  style: TextStyle(
                      fontFamily: "Gothic Semi-bold",
                      color: Colors.white,
                      fontSize: 18.0),
                ),
              ],
            ),
          ),
        ),
        Text(
          "Don't worry we never post to Facebook",
          style:
              TextStyle(color: Colors.white, fontFamily: "Josefin Sans Bold"),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: kDarkerBackgroundColor,
      body: ModalProgressHUD(
        inAsyncCall: loading,
        child: Form(
          key: signUpKey,
          child: ListView(
            children: <Widget>[
              Container(
                  margin: EdgeInsets.only(top: screenHeight * .02),
                  child: Container(
                    margin: EdgeInsets.only(left: screenWidth * .22),
                    child: Text(
                      "That's",
                      style: TextStyle(
                          fontSize: 36.0,
                          fontFamily: "Playfair",
                          color: kAccentBlack
                              .withOpacity(firstWordAnimation.value)),
                    ),
                  )),
              Container(
                  margin: EdgeInsets.only(top: screenHeight * .007),
                  child: Container(
                    margin: EdgeInsets.only(left: screenWidth * .4),
                    child: Text("My",
                        style: TextStyle(
                            fontSize: 36.0,
                            fontFamily: "Playfair",
                            color: kAccentBlack
                                .withOpacity(secondWordAnimation.value))),
                  )),
              Container(
                  margin: EdgeInsets.only(top: screenHeight * .007),
                  child: Container(
                    margin: EdgeInsets.only(left: screenWidth * .47),
                    child: Text("Type",
                        style: TextStyle(
                            fontSize: 36.0,
                            fontFamily: "Playfair",
                            color: kAccentBlack
                                .withOpacity(thirdWordAnimation.value))),
                  )),
              Container(
                margin: EdgeInsets.symmetric(vertical: screenHeight * .03),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Opacity(
                      opacity: thirdWordAnimation.value,
                      child: Container(
                        width: signUpProcess
                            ? screenHeight * .3
                            : screenHeight * .1,
                        height: signUpProcess
                            ? screenHeight * .3
                            : screenHeight * .1,
                        child: SvgPicture.asset(
                          "images/heart.svg",
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              signUpProcess
                  ? signUp(screenWidth: screenWidth, screenHeight: screenHeight)
                  : SignIn(
                      screenWidth: screenWidth, screenHeight: screenHeight),
              Container(
                margin: EdgeInsets.symmetric(
                    vertical: screenHeight * .03, horizontal: screenWidth * .1),
                width: screenWidth * .8,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Terms of Service",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "Josefin Sans Bold",
                            decoration: TextDecoration.underline)),
                    Text("Privacy Policy",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "Josefin Sans Bold",
                            decoration: TextDecoration.underline))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Column SignIn({double screenWidth, double screenHeight}) {
    return Column(
      children: <Widget>[
        Container(
          color: Colors.white10,
          width: screenWidth * .8,
          child: TextFormField(
            controller: emailController,
            focusNode: emailFocusNode,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (val) {
              FocusScope.of(context).requestFocus(passwordFocusNode);
            },
            validator: emailValidator,
            decoration: InputDecoration(
                labelText: "Email",
                labelStyle: TextStyle(color: kDarkBlue),
                prefixIcon: Icon(
                  Icons.email,
                  color: kDarkBlue,
                ),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: kDarkBlue,
                        width: 1.0,
                        style: BorderStyle.solid)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: kDarkBlue,
                        width: 3.0,
                        style: BorderStyle.solid))),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: screenHeight * .03),
          color: Colors.white10,
          width: screenWidth * .8,
          child: TextFormField(
            obscureText: true,
            controller: passwordController,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (val) {
              handleSubmit();
            },
            validator: validatePassword,
            decoration: InputDecoration(
                labelText: "Password",
                labelStyle: TextStyle(color: kDarkBlue),
                prefixIcon: Icon(
                  Icons.lock,
                  color: kDarkBlue,
                ),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: kDarkBlue,
                        width: 1.0,
                        style: BorderStyle.solid)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: kDarkBlue,
                        width: 3.0,
                        style: BorderStyle.solid))),
          ),
        ),
        Center(
            child: emailError && passwordError || emailError
                ? Text(
                    '$emailErrorText!',
                    style: TextStyle(color: Colors.red, fontSize: 16.0),
                  )
                : SizedBox()),
        Center(
            child: passwordError
                ? Text(
                    '$emailErrorText!',
                    style: TextStyle(color: Colors.red, fontSize: 16.0),
                  )
                : SizedBox()),
        emailError || passwordError
            ? SizedBox(
                height: 20.0,
              )
            : SizedBox(),
        Container(
          margin: EdgeInsets.only(top: screenHeight * .03),
          width: .8 * screenWidth,
          child: RaisedButton(
            color: kDarkBlue,
            padding: EdgeInsets.symmetric(vertical: 15.0),
            child: signInMode
                ? Text(
                    "Sign In",
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Gothic Semi-bold",
                        fontSize: 16.0),
                  )
                : Text(
                    "Sign Up",
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Gothic Semi-bold",
                        fontSize: 16.0),
                  ),
            onPressed: () {},
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: screenHeight * .03),
          width: .8 * screenWidth,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                  child: Divider(
                height: 5.0,
                color: Colors.black,
              )),
              SizedBox(
                width: 5.0,
              ),
              Text(
                "OR",
                style: TextStyle(
                    color: Colors.white, fontFamily: "Josefin Sans Bold"),
              ),
              SizedBox(
                width: 5.0,
              ),
              Expanded(
                child: Divider(
                  height: 5.0,
                  color: Colors.black,
                ),
              )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: screenHeight * .03),
          width: .8 * screenWidth,
          child: RaisedButton(
            color: kDarkerGreen,
            padding: EdgeInsets.symmetric(vertical: 15.0),
            child: signInMode
                ? Text(
                    "Sign Up",
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Gothic Semi-bold",
                        fontSize: 16.0),
                  )
                : Text(
                    "Sign In",
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Gothic Semi-bold",
                        fontSize: 16.0),
                  ),
            onPressed: () {
              setState(() {
                signInMode = !signInMode;
              });
            },
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: screenHeight * .03),
          width: .8 * screenWidth,
          child: RaisedButton(
            color: kDarkerAccentRedish,
            padding: EdgeInsets.symmetric(vertical: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  FontAwesomeIcons.facebook,
                  color: Colors.white,
                ),
                SizedBox(
                  width: screenWidth * .03,
                ),
                Text(
                  "Continue with Facebook",
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Gothic Semi-bold",
                      fontSize: 16.0),
                ),
              ],
            ),
            onPressed: () {},
          ),
        )
      ],
    );
  }

  String emailValidator(String email) {
    if (validEmail()) return null;
    return "Plese enter a valid email";
  }

  void handleSubmit() {
    if (signUpKey.currentState.validate()) {
      signInMode ? handleSignIn() : handleSignUp();
    }
  }

  Future<void> handleSignIn() async {
    try {
      setState(() {
        loading = true;
      });
      FirebaseUser user = (await _auth.signInWithEmailAndPassword(
              email: email, password: password))
          .user;
      if (user != null) {
        Navigator.push(
            context,
            PageTransition(
                child: Home(),
                type: PageTransitionType.rightToLeft,
                duration: Duration(milliseconds: 200)));
      }
    } catch (e) {
      setState(() {
        loading = false;
      });
      if (e.toString().contains('ERROR_WRONG_PASSWORD')) {
        setState(() {
          emailErrorText = "Password Incorrect";
          emailError = true;
        });
      }
      if (e.toString().contains('ERROR_EMAIL_ALREADY_IN_USE')) {
        emailErrorText = "Email address is already registered. Please login";
        emailError = true;
      }
      if (e.toString().contains('ERROR_USER_NOT_FOUND')) {
        emailErrorText = "Account does not exist";
        emailError = true;
      }
      if (e.toString().contains('ERROR_INVALID_EMAIL')) {
        setState(() {
          emailErrorText = "Enter a valid email";
          emailError = true;
        });
      }
    }
  }

  Future<void> handleSignUp() async {
    try {
      setState(() {
        loading = true;
      });
      FirebaseUser user = (await _auth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user;
      if (user != null) {
        usersRef.document(user.uid).setData({"email": email, "id": user.uid});
        setState(() {
          loading = false;
        });
        Navigator.push(
            context,
            PageTransition(
                child: VerifyPhone(userId: user.uid),
                type: PageTransitionType.scale,
                duration: Duration(milliseconds: 200)));
      }
    } catch (e) {
      setState(() {
        loading = false;
      });
      setState(() {
        if (e.toString().contains('ERROR_INVALID_EMAIL')) {
          setState(() {
            emailErrorText = "Enter a valid email";
            emailError = true;
          });
        }
        if (e.toString().contains('ERROR_EMAIL_ALREADY_IN_USE')) {
          emailErrorText = "Email address is already registered. Please login";
          emailError = true;
        }
        if (e.toString().contains('ERROR_WEAK_PASSWORD')) {
          emailErrorText = "Password must be at least 6 characters";
          emailError = true;
        }
      });
      print(e);
    }
  }

  String validatePassword(String password) {
    if (password.length > 5) return null;
    return "Your password must be at least six characters";
  }
}
