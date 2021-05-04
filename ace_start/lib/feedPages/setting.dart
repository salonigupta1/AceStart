import 'dart:io';

import 'package:ace_start/backend/database.dart';
import 'package:ace_start/backend/user.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ace_start/backend/shared_pref.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

QuerySnapshot querySnapshot;
DocumentChange documentSnaphot;
MyLocalStorage _storage = MyLocalStorage();
TextEditingController biocontroller = new TextEditingController();

DatabaseMethods databaseMethods = new DatabaseMethods();

File _image;

String path = "", bio = "";

class SettingPage extends StatefulWidget {
  SettingPage({Key key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  void initState() {
    this.fetchInfo();
    super.initState();
  }

  void fetchInfo() async {
    QuerySnapshot snapshot =
        await databaseMethods.getUserByUserId(globalUserId);
    path = snapshot.documents[0].data["profile_picture"];
    bio = snapshot.documents[0].data["bio"];
  }

  void update(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('userId');

    querySnapshot = await databaseMethods.getUserByUserId(userId);
    String docId;

    String userBio = biocontroller.text;
    docId = querySnapshot.documents[0].documentID;

    await databaseMethods.updateBio(userBio, docId);
    if (path != "" && path != null) {
      await databaseMethods.updateProfilePicture(path, docId);
      querySnapshot = await databaseMethods.getPosts();
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
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
                      child: Column(
//                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.10,
                                width: MediaQuery.of(context).size.width - 30,
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
                                      controller: biocontroller,
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "New Bio",
                                        labelStyle: TextStyle(
                                            color: Colors.black, fontSize: 14),
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
                                borderRadius: new BorderRadius.circular(5.0),
                              ),
                              onPressed: () {
                                //signMeUp(context);
                                update(context);
                              },
                              child: Text(
                                "Update",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
    ));
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
                    takePhoto(ImageSource.camera, context);
                  },
                  label: Text("Camera")),
              // ignore: deprecated_member_use
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
    // ignore: deprecated_member_use
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
