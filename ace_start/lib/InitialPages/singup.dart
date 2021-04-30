import 'dart:io';
import 'package:ace_start/InitialPages/login.dart';
import 'package:ace_start/backend/auth.dart';
import 'package:ace_start/backend/database.dart';
import 'package:ace_start/backend/user.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:ace_start/feedPages/feedpages.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

File _image;

String path =
    "https://www.pngkey.com/png/detail/21-213224_unknown-person-icon-png-download.png";

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RegisterPage();
}

class _RegisterPage extends State<RegisterPage> {
  double withG;
  TextEditingController nameTextEditingController = new TextEditingController();
  TextEditingController emailTextEditingController =
      new TextEditingController();
  TextEditingController passwordTextEditingController =
      new TextEditingController();
  TextEditingController bioTextEditingController = new TextEditingController();
  bool isLoading = false;
  AuthMethods authMethods = new AuthMethods();
  final formKey = GlobalKey<FormState>();

  DatabaseMethods databaseMethods = new DatabaseMethods();
  signMeUp(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    if (path == null) {
      setState(() {
        path =
            "https://www.pngkey.com/png/detail/21-213224_unknown-person-icon-png-download.png";
      });
    }
    if (formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });

      authMethods
          .signUpWithEmailAndPassword(
              emailTextEditingController.text,
              passwordTextEditingController.text,
              nameTextEditingController.text)
          .then((val) async {
        if (val != null) {
          Map<String, dynamic> userMap = {
            "user_id": userId,
            "user_name": nameTextEditingController.text,
            "email": userEmail,
            "profile_picture": path,
            "bio": bioTextEditingController.text,
            "friends": [],
          };
          setState(() {
            userPropic = path;
            userBio = bioTextEditingController.text;
            userName = nameTextEditingController.text;
            prefs.setString("userId", userId);
            prefs.setString("userEmail", userEmail);
            prefs.setString("userPropic", path);
            prefs.setString("userName", userName);
            prefs.setString("userBio", userBio);
            prefs.setBool("loggedIn", true);
            loggedIn = true;
          });
          await databaseMethods.updateUserInfo(userMap);

          Navigator.push(
              context, MaterialPageRoute(builder: (context) => FeedPage()));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    withG = MediaQuery.of(context).size.width;

    return Scaffold(
      body: !loggedIn
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
                        // crossAxisAlignment: CrossAxisAlignment.start,
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
                                  height:
                                      MediaQuery.of(context).size.height / 4.5,
                                ),
                              ),
                            ],
                          ),
                          imageProfile(context),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              height: MediaQuery.of(context).size.height / 2.2,
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: Stack(
                                alignment: Alignment.bottomCenter,
                                children: <Widget>[
                                  Form(
                                    key: formKey,
                                    child: Column(
//                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        Padding(
                                            padding:
                                                EdgeInsets.only(bottom: 10),
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
                                                color: Color(0xff6B93AA),
                                                shape: RoundedRectangleBorder(),
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 20,
                                                      right: 20,
                                                      top: 10,
                                                      bottom: 10),
                                                  child: TextField(
                                                    controller:
                                                        nameTextEditingController,
                                                    keyboardType: TextInputType
                                                        .emailAddress,
                                                    decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      hintText: "Name",
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
                                                EdgeInsets.only(bottom: 10),
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
                                                color: Color(0xff6B93AA),
                                                shape: RoundedRectangleBorder(),
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 20,
                                                      right: 20,
                                                      top: 10,
                                                      bottom: 10),
                                                  child: TextFormField(
                                                    controller:
                                                        emailTextEditingController,
                                                    validator: (val) {
                                                      return RegExp(
                                                                  r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                                                              .hasMatch(val)
                                                          ? null
                                                          : "PLEASE PROVIDE A VALID EMAIL ID";
                                                    },
                                                    keyboardType: TextInputType
                                                        .emailAddress,
                                                    decoration: InputDecoration(
                                                      border: InputBorder.none,
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
                                                color: Color(0xff6B93AA),
                                                shape: RoundedRectangleBorder(),
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 20,
                                                      right: 20,
                                                      top: 10,
                                                      bottom: 10),
                                                  child: TextFormField(
                                                    controller:
                                                        bioTextEditingController,
                                                    validator: (val) {
                                                      return val.length > 6
                                                          ? null
                                                          : "PLEASE TYPE LONGER PASSWORD";
                                                    },
                                                    keyboardType: TextInputType
                                                        .emailAddress,
                                                    decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      hintText: "Bio",
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
                                            padding: EdgeInsets.only(bottom: 5),
                                            child: Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.07,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  30,
                                              child: Material(
                                                elevation: 10,
                                                color: Color(0xff6B93AA),
                                                shape: RoundedRectangleBorder(),
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 20,
                                                      right: 20,
                                                      top: 10,
                                                      bottom: 5),
                                                  child: TextFormField(
                                                    validator: (val) {
                                                      return val.length > 6
                                                          ? null
                                                          : "PLEASE TYPE LONGER PASSWORD";
                                                    },
                                                    controller:
                                                        passwordTextEditingController,
                                                    obscureText: true,
                                                    keyboardType: TextInputType
                                                        .emailAddress,
                                                    decoration: InputDecoration(
                                                      border: InputBorder.none,
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
                                        Container(
                                          width: 150,
                                          child: MaterialButton(
                                            color: Color(0xff6B93AA),
                                            splashColor: Colors.blue,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  new BorderRadius.circular(
                                                      5.0),
                                            ),
                                            onPressed: () {
                                              signMeUp(context);
                                            },
                                            child: Text(
                                              "Register",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage()));
                            },
                            child: RichText(
                              text: TextSpan(
                                  text: 'Already have an account? ',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                  children: <TextSpan>[
                                    new TextSpan(
                                        text: 'Login Now',
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
          : FeedPage(),
    );
  }

  @override
  void dispose() {
    emailTextEditingController.dispose();
    passwordTextEditingController.dispose();
    bioTextEditingController.dispose();
    nameTextEditingController.dispose();
    super.dispose();
  }

  Widget bottomSheet(BuildContext context) {
    return Container(
      height: 100.0,
      width: withG,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: [
          Text(
            "Choose Profile Picture",
            style: TextStyle(fontSize: 20.0),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FlatButton.icon(
                  icon: Icon(Icons.camera),
                  onPressed: () {
                    takePhoto(ImageSource.camera, context);
                  },
                  label: Text("Camera")),
              FlatButton.icon(
                  icon: Icon(Icons.image),
                  onPressed: () {
                    takePhoto(ImageSource.gallery, context);
                  },
                  label: Text("Gallery")),
            ],
          )
        ],
      ),
    );
  }

  upload(BuildContext context) async {
    String filename = basename(_image.path);
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(filename);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);

    StorageTaskSnapshot taskSnapshots = await uploadTask.onComplete;
    var p = await taskSnapshots.ref.getDownloadURL();
    setState(() {
      path = p;
    });
  }

  takePhoto(ImageSource source, BuildContext context) async {
    var im = await ImagePicker.pickImage(source: source);
    setState(() {
      _image = im;
      upload(context);
    });
  }

  Widget imageProfile(BuildContext context) {
    return Stack(
      children: <Widget>[
        CircleAvatar(
          radius: 80,
          backgroundImage: NetworkImage(path == null
              ? "https://www.pngkey.com/png/detail/21-213224_unknown-person-icon-png-download.png"
              : path),
        ),
        Positioned(
          bottom: 20.0,
          right: 20.0,
          child: InkWell(
            onTap: () {
              showModalBottomSheet(
                  context: context, builder: (builder) => bottomSheet(context));
            },
            child: Icon(
              Icons.camera_alt,
              color: Colors.teal,
              size: 28.0,
            ),
          ),
        )
      ],
    );
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
