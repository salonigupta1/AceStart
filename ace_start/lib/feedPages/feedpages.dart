import 'dart:io';
import 'package:ace_start/InitialPages/homepage.dart';
import 'package:ace_start/backend/auth.dart';
import 'package:ace_start/backend/database.dart';
import 'package:ace_start/backend/user.dart';
import 'package:ace_start/feedPages/animatedappbar.dart';
import 'package:ace_start/feedPages/profilepage.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

QuerySnapshot postsnapshot, snapshots;
DatabaseMethods databaseMethods = new DatabaseMethods();

TextEditingController contentcontroller = new TextEditingController();
TextEditingController headingcontroller = new TextEditingController();

String path =
    "https://www.pngkey.com/png/detail/21-213224_unknown-person-icon-png-download.png";

List<DynamicWidget> listDynamic = [];

class FeedPage extends StatefulWidget {
  @override
  _FeedPageState createState() => _FeedPageState();
}

AuthMethods authMethods = new AuthMethods();

BuildContext cntsss;

class _FeedPageState extends State<FeedPage> with TickerProviderStateMixin {
  // ignore: non_constant_identifier_names
  AnimationController _ColorAnimationController;

  // ignore: non_constant_identifier_names
  AnimationController _TextAnimationController;
  Animation _colorTween, _homeTween, _workOutTween, _iconTween, _drawerTween;

  @override
  void initState() {
    this._getNames();
    loggedIn = true;
    _ColorAnimationController =
        AnimationController(vsync: this, duration: Duration(seconds: 0));
    _colorTween = ColorTween(begin: Colors.transparent, end: Colors.white)
        .animate(_ColorAnimationController);
    _iconTween =
        ColorTween(begin: Colors.white, end: Color(0xffC64B8A).withOpacity(0.5))
            .animate(_ColorAnimationController);
    _drawerTween = ColorTween(begin: Colors.white, end: Colors.black)
        .animate(_ColorAnimationController);
    _homeTween = ColorTween(begin: Colors.white, end: Color(0xffC64B8A))
        .animate(_ColorAnimationController);
    _workOutTween = ColorTween(begin: Colors.white, end: Colors.black)
        .animate(_ColorAnimationController);
    _TextAnimationController =
        AnimationController(vsync: this, duration: Duration(seconds: 0));

    super.initState();
  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  bool scrollListener(ScrollNotification scrollInfo) {
    bool scroll = false;
    if (scrollInfo.metrics.axis == Axis.vertical) {
      _ColorAnimationController.animateTo(scrollInfo.metrics.pixels / 80);

      _TextAnimationController.animateTo(scrollInfo.metrics.pixels);
      return scroll = true;
    }
    return scroll;
  }

  void logout(context) async {
    setState(() {
      loggedIn = false;
    });
    await authMethods.signout();
    if (path == null) {
      path =
          "https://www.pngkey.com/png/detail/21-213224_unknown-person-icon-png-download.png";
    }

    if (userPropic == null) {
      userPropic =
          "https://www.pngkey.com/png/detail/21-213224_unknown-person-icon-png-download.png";
    }

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => MyHomePage()),
        (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    _getNames();
    cntsss = context;
    return Scaffold(
      key: scaffoldKey,
      drawer: Drawer(
        child: Container(
          color: Colors.white,
          child: ListView(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: <Color>[
                    Color(0xff86A7BA),
                    Colors.white,
                  ]),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(7),
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(userPropic == null
                            ? "https://www.pngkey.com/png/detail/21-213224_unknown-person-icon-png-download.png"
                            : userPropic),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      userName == null ? "" : userName,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          letterSpacing: 1),
                    ),
                    Text(
                      userEmail == null ? "" : userEmail,
                      style: TextStyle(
                          color: Colors.black, fontSize: 14, letterSpacing: 0),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (builder) => ProfilePage(uid: userId)));
                },
                child: ListTile(
                  title: Text(
                    "Profile",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  logout(context);
                },
                child: ListTile(
                  title: Text(
                    "Logout",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Color(0xFFEEEEEE),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(5),
                      child: AnimatedAppBar(
                        drawerTween: _drawerTween,
                        onPressed: () {
                          scaffoldKey.currentState.openDrawer();
                        },
                        colorAnimationController: _ColorAnimationController,
                        colorTween: _colorTween,
                        homeTween: _homeTween,
                        iconTween: _iconTween,
                        workOutTween: _workOutTween,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(5),
                      padding: EdgeInsets.only(
                          left: 15, right: 15, top: 15, bottom: 15),
                      height: 80,
                      width: MediaQuery.of(context).size.width - 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.black,
                          )),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(userPropic == null
                                ? "https://www.pngkey.com/png/detail/21-213224_unknown-person-icon-png-download.png"
                                : userPropic),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Container(
                            height: 20,
                            width: 100,
                            child: TextField(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (contexts) {
                                    return Dialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(40)),
                                      elevation: 16,
                                      child: Container(
                                        height: 500,
                                        child: ListView(
                                          children: <Widget>[
                                            Column(
                                              children: [
                                                SizedBox(
                                                  height: 50,
                                                ),
                                                Container(
                                                  margin: EdgeInsets.all(15),
                                                  padding: EdgeInsets.all(15),
                                                  height: 350,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      30,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      border: Border.all(
                                                          color: Colors.black,
                                                          width: 1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20)),
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        margin:
                                                            EdgeInsets.all(10),
                                                        child: Text(
                                                          "Tell us about your idea in brief",
                                                          style: GoogleFonts
                                                              .roboto(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 15),
                                                        ),
                                                      ),
                                                      TextField(
                                                        controller:
                                                            headingcontroller,
                                                        decoration:
                                                            InputDecoration(
                                                                hintText:
                                                                    "Heading"),
                                                      ),
                                                      Container(
                                                        child: TextField(
                                                          controller:
                                                              contentcontroller,
                                                          keyboardType:
                                                              TextInputType
                                                                  .multiline,
                                                          minLines: 1,
                                                          maxLines: 10,
                                                          decoration:
                                                              InputDecoration(
                                                            hintText: "Content",
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Container(
                                                  height: 30,
                                                  width: 100,
                                                  decoration: BoxDecoration(
                                                      color: Color(0xff6B93AA),
                                                      border: Border.all(
                                                          color: Colors.black,
                                                          width: 0.5),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  child: FlatButton(
                                                    onPressed: () {
                                                      addPost(
                                                          path,
                                                          contentcontroller
                                                              .text,
                                                          headingcontroller
                                                              .text);
                                                      Navigator.of(contexts)
                                                          .pop();
                                                      setState(() {
                                                        headingcontroller
                                                            .clear();
                                                        contentcontroller
                                                            .clear();
                                                      });
                                                    },
                                                    child: Text("Submit"),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Write a post'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      child: Container(
                          height: 500,
                          width: MediaQuery.of(context).size.width - 30,
                          child: askList()),
                    ),
                  ],
                ),
              ),
              //ADD_MORE_WIDGETS
            ],
          ),
        ),
      ),
    );
  }

  void _getNames() async {
    postsnapshot = await databaseMethods.getPosts();

    listDynamic = [];

    var x = postsnapshot.documents;
    for (int i = 0; i < x.length; i++) {
      snapshots = await databaseMethods.getUserByUserId(x[i].data["user_id"]);
      if (x[i].data["bio"] != snapshots.documents[0].data["bio"]) {
        await databaseMethods.updateBioFromPost(
            snapshots.documents[0].data["bio"], x[i].documentID);
        await databaseMethods.updateProfilePictureFromPost(
            snapshots.documents[0].data["profile_picture"], x[i].documentID);
      }

      listDynamic.add(new DynamicWidget(
          x[i].data["image"],
          snapshots.documents[0].data["user_name"],
          x[i].data["content"],
          x[i].data["user_id"],
          snapshots.documents[0].data["bio"],
          snapshots.documents[0].data["profile_picture"]));
    }
  }

  Widget askList() {
    return StreamBuilder(
      stream: Firestore.instance.collection("post").snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        var y;
        if (snapshot.data != null) {
          y = snapshot.data.documents;
        } else {
          y = null;
        }
        return ListView.builder(
          itemCount: y == null ? 0 : y.length,
          itemBuilder: (BuildContext context, int index) {
            return DynamicWidget(
                y[index]["image"],
                y[index]["name"],
                y[index]["content"],
                y[index]["user_id"],
                y[index]["bio"],
                y[index]["profile_picture"]);
          },
        );
      },
    );
  }
}

addPost(String image, String content, String heading) async {
  Map<String, String> userMap = {
    "user_id": userId,
    "name": userName,
    "profile_picture": userPropic,
    "bio": bio,
    "content": heading + "\n" + content,
  };

  await databaseMethods.updatePosts(userMap);
}

// ignore: must_be_immutable
class DynamicWidget extends StatelessWidget {
  String i, n, c, uid, bio, photo;
  DynamicWidget(String image, String name, String content, String uid,
      String bio, String photo) {
    this.i = image;
    this.n = name;
    this.c = content;
    this.uid = uid;
    this.bio = bio;
    this.photo = photo;
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: new EdgeInsets.only(left: 15, right: 15, top: 4, bottom: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(color: Colors.black26),
        color: Colors.white,
      ),
      child: new TextButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40)),
                elevation: 16,
                child: Container(
                  height: 400.0,
                  width: 360.0,
                  child: ListView(
                    children: <Widget>[
                      SizedBox(height: 20),
                      Center(
                        child: Text(
                          "Preview",
                          style: TextStyle(
                              fontSize: 24,
                              color: Color(0xff2E174D),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 20),
                      _buildName(
                          image: photo == null
                              ? "https://www.pngkey.com/png/detail/21-213224_unknown-person-icon-png-download.png"
                              : photo,
                          name: n,
                          score: c),
                    ],
                  ),
                ),
              );
            },
          );
        },
        child: new Container(
          height: 150,
          width: MediaQuery.of(context).size.width - 30,
          padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 30,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(photo == null
                          ? "https://www.pngkey.com/png/detail/21-213224_unknown-person-icon-png-download.png"
                          : photo),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfilePage(uid: uid)));
                      },
                      child: ListTile(
                        title: RichText(
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                              text: n == null ? "" : n,
                              style: TextStyle(color: Colors.black)),
                        ),
                        subtitle: RichText(
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                              text: bio == null ? "" : bio,
                              style: TextStyle(color: Colors.black26)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Text(
                  c,
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildName({String image, String name, String score}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20.0),
    child: Column(
      children: <Widget>[
        SizedBox(height: 12),
        Container(
          height: 2,
          color: Color(0xff2E174D),
        ),
        SizedBox(height: 12),
        Column(
          children: <Widget>[
            Image.network(
              image == null
                  ? "https://www.pngkey.com/png/detail/21-213224_unknown-person-icon-png-download.png"
                  : image,
              height: 80,
              width: 330,
            ),
            SizedBox(
              height: 30,
            ),
            Text(name == null ? "" : name),
            SizedBox(
              height: 10,
            ),
            Text(score == null ? "" : score),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ],
    ),
  );
}
