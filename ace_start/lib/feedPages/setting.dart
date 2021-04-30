import 'dart:io';

import 'package:ace_start/backend/database.dart';
import 'package:ace_start/backend/user.dart';
import 'package:ace_start/feedPages/profilepage.dart';
import 'package:ace_start/widgets/fieldwidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

QuerySnapshot querySnapshot;
DocumentChange documentSnaphot;
TextEditingController biocontroller = new TextEditingController();

DatabaseMethods databaseMethods = new DatabaseMethods();

File _image;

String path =
    "https://www.pngkey.com/png/detail/21-213224_unknown-person-icon-png-download.png";

class SettingPage extends StatefulWidget {
  SettingPage({Key key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  void update(BuildContext context) async {
    if (path == null) {
      setState(() {
        path = userPropic;
      });
    }

    querySnapshot = await databaseMethods.getUserByUserId(userId);
    String docId;

    userBio = biocontroller.text;
    docId = querySnapshot.documents[0].documentID;
    print(userBio);
    print(docId);

    await databaseMethods.updateBio(userBio, docId);
    setState(() {
      userPropic = path;
    });

    await databaseMethods.updateProfilePicture(userPropic, docId);

    querySnapshot = await databaseMethods.getPosts();

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
