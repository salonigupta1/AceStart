import 'package:ace_start/InitialPages/singup.dart';
import 'package:ace_start/feedPages/feedpages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ace_start/backend/auth.dart';
import 'package:ace_start/backend/database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:ace_start/backend/user.dart';

User user = User();
String userId;

QuerySnapshot userSnapshot;
bool loggedIn = false;

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  @override
  void initState() {
    this.fun();
    super.initState();
  }

  void fun() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId') ?? "";
    setState(() {
      isLoading = false;
    });
  }

  DatabaseMethods databaseMethods = new DatabaseMethods();
  bool isLoading = false;
  AuthMethods authMethods = new AuthMethods();
  final formKey = GlobalKey<FormState>();
  TextEditingController emailTextEditingController =
      new TextEditingController();
  TextEditingController passwordTextEditingController =
      new TextEditingController();

  void resetPass(String email) async {
    if (!formKey.currentState.validate()) {
      Toast.show("Enter your mail id and last password you remember", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    await authMethods.resetPass(email);
    Toast.show("Reset link has been sent to the provided mail address", context,
        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
  }

  signMeIN() async {
    if (formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });

      await authMethods
          .signInWithEmailAndPassword(emailTextEditingController.text,
              passwordTextEditingController.text)
          .then((value) async {
        var user = value;

        if (user == null || user.userId == null || user.userId == "") {
          Toast.show("Wrong email or password", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          setState(() {
            isLoading = false;
          });

          return;
        }

        userId = user.userId;

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('userId', userId);
        userSnapshot = await databaseMethods.getUserByUserId(userId);
        setState(() {
          globalUserId = userId;
          isLoading = false;
        });

        if (userId != null && userId != "") {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => FeedPage()),
              (Route<dynamic> route) => false);
          isLoading = false;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: (userId == null || userId == "")
            ? isLoading
                ? SingleChildScrollView(
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.white,
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  )
                : SingleChildScrollView(
                    child: Container(
                        height: MediaQuery.of(context).size.height,
                        color: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Stack(
                              alignment: Alignment.bottomCenter,
                              children: <Widget>[
                                ClipPath(
                                  clipper: TopWaveClipper(),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          colors: <Color>[
                                            Color(0xff094C72),
                                            Colors.white,
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.center),
                                    ),
                                    height: MediaQuery.of(context).size.height /
                                        2.5,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                height:
                                    MediaQuery.of(context).size.height * 0.5,
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: <Widget>[
                                    ClipPath(
                                      clipper: FooterWaveClipper(),
                                      child: Container(
                                        decoration:
                                            BoxDecoration(color: Colors.white),
                                        height:
                                            MediaQuery.of(context).size.height /
                                                3,
                                      ),
                                    ),
                                    Form(
                                      key: formKey,
                                      child: Column(
//                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          SizedBox(
                                            height: 15,
                                          ),
                                          SizedBox(
                                            height: 30,
                                          ),
                                          Padding(
                                              padding:
                                                  EdgeInsets.only(bottom: 10),
                                              child: Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.09,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    30,
                                                child: Material(
                                                  elevation: 10,
                                                  color: Color(0xff7399AF),
                                                  shape:
                                                      RoundedRectangleBorder(),
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 20,
                                                        right: 20,
                                                        top: 10,
                                                        bottom: 10),
                                                    child: TextFormField(
                                                      controller:
                                                          emailTextEditingController,
                                                      keyboardType:
                                                          TextInputType
                                                              .emailAddress,
                                                      validator: (val) {
                                                        return RegExp(
                                                                    r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                                                                .hasMatch(val)
                                                            ? null
                                                            : null;
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                        hintText: "Email",
                                                        labelStyle: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 14),
                                                        // hintText: "Email",
                                                        // hintStyle: TextStyle(color: Color(0xFFE1E1E1), fontSize: 14)
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )),
                                          Padding(
                                              padding:
                                                  EdgeInsets.only(bottom: 5),
                                              child: Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.08,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    30,
                                                child: Material(
                                                  elevation: 10,
                                                  color: Color(0xff7399AF),
                                                  shape:
                                                      RoundedRectangleBorder(),
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 20,
                                                        right: 20,
                                                        top: 10,
                                                        bottom: 10),
                                                    child: TextFormField(
                                                      controller:
                                                          passwordTextEditingController,
                                                      obscureText: true,
                                                      keyboardType:
                                                          TextInputType
                                                              .emailAddress,
                                                      validator: (val) {
                                                        return val.length > 6
                                                            ? null
                                                            : null;
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            InputBorder.none,
                                                        hintText: "Password",
                                                        labelStyle: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 14),
                                                        // hintText: "Email",
                                                        // hintStyle: TextStyle(color: Color(0xFFE1E1E1), fontSize: 14)
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )),
                                          SizedBox(
                                            height: 40,
                                          ),
                                          Align(
                                              alignment: Alignment.center,
                                              child: GestureDetector(
                                                onTap: () {
                                                  resetPass(
                                                      emailTextEditingController
                                                          .text);
                                                },
                                                child: Text(
                                                  'Forget your password?',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              )),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            width: 150,
                                            child: MaterialButton(
                                              color: Color(0xff7399AF),
                                              splashColor: Colors.blue,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        5.0),
                                              ),
                                              onPressed: () {
                                                signMeIN();
                                              },
                                              child: Text(
                                                "Login",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )),
                            SizedBox(
                              height: 15,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => RegisterPage()));
                              },
                              child: RichText(
                                text: TextSpan(
                                    text: 'Do not have account? ',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                    children: <TextSpan>[
                                      new TextSpan(
                                          text: 'Register Now',
                                          style: new TextStyle(
                                              fontWeight: FontWeight.bold,
                                              decoration:
                                                  TextDecoration.underline,
                                              color: Colors.black)),
                                    ]),
                              ),
                            )
                          ],
                        )),
                  )
            : FeedPage());
  }
}

class TopWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // This is where we decide what part of our image is going to be visible.
    var path = Path();
    path.lineTo(0.0, size.height);

    var firstControlPoint = new Offset(size.width / 7, size.height - 30);
    var firstEndPoint = new Offset(size.width / 6, size.height / 1.5);

    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondControlPoint = Offset(size.width / 5, size.height / 4);
    var secondEndPoint = Offset(size.width / 1.5, size.height / 5);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    var thirdControlPoint =
        Offset(size.width - (size.width / 9), size.height / 6);
    var thirdEndPoint = Offset(size.width, 0.0);
    path.quadraticBezierTo(thirdControlPoint.dx, thirdControlPoint.dy,
        thirdEndPoint.dx, thirdEndPoint.dy);

    ///move from bottom right to top
    path.lineTo(size.width, 0.0);

    ///finally close the path by reaching start point from top right corner
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class FooterWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(size.width, 0.0);
    path.lineTo(size.width, size.height);
    path.lineTo(0.0, size.height);
    path.lineTo(0.0, size.height - 60);
    var secondControlPoint = Offset(size.width - (size.width / 6), size.height);
    var secondEndPoint = Offset(size.width, 0.0);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
