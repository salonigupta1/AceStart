import 'dart:io';
import 'package:ace_start/backend/auth.dart';
import 'package:ace_start/backend/database.dart';
import 'package:ace_start/backend/user.dart';
import 'package:ace_start/feedPages/animatedappbar.dart';
import 'package:ace_start/feedPages/profilepage.dart';
import 'package:ace_start/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ace_start/backend/imagespicker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

QuerySnapshot postsnapshot, snapshots;
DatabaseMethods databaseMethods = new DatabaseMethods();
File _image;
TextEditingController contentcontroller = new TextEditingController();
TextEditingController headingcontroller = new TextEditingController();

String path;

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

  @override
  Widget build(BuildContext context) {
    cntsss = context;

    return Scaffold(
      key: scaffoldKey,
      drawer: Drawer(
        child: Container(
          color: Colors.black,
          child: ListView(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: <Color>[
                    Color(0xffC64B8A),
                    Color(0xff2E174D),
                  ]),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(7),
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(userPropic),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      userName,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          letterSpacing: 1),
                    ),
                    Text(
                      userEmail,
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
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  "Settings",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(
                height: 345,
              ),
              GestureDetector(
                onTap: () {
                  authMethods.signout();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MyApp()));
                },
                child: Container(
                  width: 100,
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                  child: Text(
                    "Logout",
                    textAlign: TextAlign.center,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: <Color>[
                      Color(0xffC64B8A),
                      Color(0xff2E174D),
                    ]),
                    color: Colors.yellow[900],
                    borderRadius: BorderRadius.circular(5),
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
                            backgroundImage: NetworkImage(userPropic),
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
                                        child: ListView(
                                          children: <Widget>[
                                            SizedBox(height: 20),
                                            Center(
                                              child: Text(
                                                "Write Post",
                                                style: TextStyle(
                                                    fontSize: 24,
                                                    color: Color(0xff2E174D),
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            SizedBox(height: 20),
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
                                                      gradient: LinearGradient(
                                                          begin: Alignment
                                                              .topRight,
                                                          end: Alignment
                                                              .bottomLeft,
                                                          colors: [
                                                            Colors.orange[600],
                                                            Colors.yellow
                                                          ]),
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
                                                          "Write about your needs briefly and upload the images of your reports for verification purpose",
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
                                                  decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                          begin: Alignment
                                                              .topRight,
                                                          end: Alignment
                                                              .bottomLeft,
                                                          colors: [
                                                            Colors.orange[600],
                                                            Colors.yellow
                                                          ]),
                                                      border: Border.all(
                                                          color: Colors.black,
                                                          width: 0.5),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  height: 40,
                                                  width: 150,
                                                  child: FlatButton(
                                                    onPressed: () {
                                                      showModalBottomSheet(
                                                          context: context,
                                                          builder: (builder) =>
                                                              bottomSheet(
                                                                  context));
                                                    },
                                                    child:
                                                        Text("Upload Reports"),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Container(
                                                  height: 30,
                                                  width: 100,
                                                  decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                          begin: Alignment
                                                              .topRight,
                                                          end: Alignment
                                                              .bottomLeft,
                                                          colors: [
                                                            Colors.orange[600],
                                                            Colors.yellow
                                                          ]),
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

  addPost(String image, String content, String heading) async {
    Map<String, String> userMap = {
      "user_id": userId,
      "name": heading,
      "image": image,
      "content": content,
    };

    await databaseMethods.updatePosts(userMap);
  }

  takePhoto(ImageSource source, BuildContext context) async {
    var im = await ImagePicker.pickImage(source: source);
    setState(() {
      _image = im;
      upload(context);
    });
  }

  void _getNames() async {
    postsnapshot = await databaseMethods.getPosts();

    List<DynamicWidget> tempList = [];

    var x = postsnapshot.documents;
    for (int i = 0; i < x.length; i++) {
      snapshots = await databaseMethods.getUserByUserId(x[i].data["user_id"]);

      tempList.add(new DynamicWidget(
          x[i].data["image"],
          snapshots.documents[0].data["user_name"],
          x[i].data["content"],
          x[i].data["user_id"]));
    }

    setState(() {
      listDynamic = tempList;
    });
  }
}

Widget askList() {
  return StreamBuilder(
    stream: Firestore.instance.collection("post").snapshots(),
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.data != null) {
        var y = snapshot.data.documents;

        return ListView.builder(
          itemCount: y == null ? 0 : y.length,
          itemBuilder: (BuildContext context, int index) {
            return DynamicWidget(y[index]["image"], y[index]["name"],
                y[index]["content"], y[index]["user_id"]);
          },
        );
      } else {
        return null;
      }
    },
  );
}

// ignore: must_be_immutable
class DynamicWidget extends StatelessWidget {
  String i, n, c, uid;
  DynamicWidget(String image, String name, String content, String uid) {
    this.i = image;
    this.n = name;
    this.c = content;
    this.uid = uid;
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: new EdgeInsets.only(left: 15, right: 15, top: 4, bottom: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: Colors.pink,
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
                      _buildName(imageAsset: i, name: n, score: c),
                    ],
                  ),
                ),
              );
            },
          );
        },
        child: new ListTile(
          leading: Image.network(i),
          title: GestureDetector(
            onTap: () {
              if (uid != null) {
                print(uid);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProfilePage(
                              uid: uid,
                            )));
              }
            },
            child: Text(
              n,
              style: TextStyle(color: Colors.white),
            ),
          ),
          subtitle: Text(
            c,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

Widget _buildName({String imageAsset, String name, String score}) {
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
              imageAsset,
              height: 80,
              width: 330,
            ),
            SizedBox(
              height: 30,
            ),
            Text(name),
            SizedBox(
              height: 10,
            ),
            Text(score.toString()),
            SizedBox(
              height: 10,
            ),
            Container(
              width: 100,
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
              child: Text(
                "Pay",
                textAlign: TextAlign.center,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: <Color>[
                  Color(0xffC64B8A),
                  Color(0xff2E174D),
                ]),
                color: Colors.yellow[900],
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
