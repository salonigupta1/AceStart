import 'dart:io';
import 'package:ace_start/InitialPages/login.dart';
import 'package:ace_start/backend/auth.dart';
import 'package:ace_start/backend/database.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:ace_start/feedPages/feedpages.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:ace_start/backend/user.dart';

import 'package:shared_preferences/shared_preferences.dart';

User user = User();

String userId = "";

File _image;

String path = "";

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RegisterPage();
}

class _RegisterPage extends State<RegisterPage> {
  @override
  void initState() {
    this.fun();
    super.initState();
  }

  void fun() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId');
  }

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
          var x = val;
          Map<String, dynamic> userMap = {
            "user_id": x.userId,
            "user_name": nameTextEditingController.text,
            "email": emailTextEditingController.text,
            "profile_picture": path ?? "",
            "bio": bioTextEditingController.text,
            "friends": [],
          };

          await databaseMethods.updateUserInfo(userMap);
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('userId', x.userId);
          setState(() {
            globalUserId = userId;
          });

          print("WORKING");
          print(globalUserId);
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => FeedPage()),
              (Route<dynamic> route) => false);
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
      width: MediaQuery.of(context).size.width,
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
              // ignore: deprecated_member_use
              FlatButton.icon(
                  icon: Icon(Icons.camera),
                  onPressed: () {
                    Navigator.pop(context);
                    takePhoto(ImageSource.camera, context);
                  },
                  label: Text("Camera")),
              // ignore: deprecated_member_use
              FlatButton.icon(
                  icon: Icon(Icons.image),
                  onPressed: () {
                    Navigator.pop(context);
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
    isLoading = true;
    String filename = basename(_image.path);
    StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(filename);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);

    StorageTaskSnapshot taskSnapshots = await uploadTask.onComplete;
    var p = await taskSnapshots.ref.getDownloadURL();

    setState(() {
      path = p;
    });
    isLoading = false;
  }

  takePhoto(ImageSource source, BuildContext context) async {
    // ignore: deprecated_member_use
    var im = await ImagePicker.pickImage(source: source);
    if (im == null) {
      return;
    }
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
          backgroundColor: Colors.white,
          backgroundImage: (path == null || path == "")
              ? AssetImage("assets/images/img.png")
              : NetworkImage(path),
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
