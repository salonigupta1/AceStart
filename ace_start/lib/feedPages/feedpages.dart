import 'package:ace_start/backend/auth.dart';
import 'package:ace_start/backend/database.dart';
import 'package:ace_start/backend/user.dart';
import 'package:ace_start/feedPages/profilepage.dart';
import 'package:ace_start/profileandcontactpages/messagehome.dart' as message;
import 'package:ace_start/widgets/dynamicwidgets.dart';
import 'package:ace_start/widgets/postwidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ace_start/backend/shared_pref.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ace_start/profileandcontactpages/alluser.dart' as globalusers;

import '../main.dart';

QuerySnapshot postsnapshot, snapshots;
DatabaseMethods databaseMethods = new DatabaseMethods();

TextEditingController contentcontroller = new TextEditingController();
TextEditingController headingcontroller = new TextEditingController();

MyLocalStorage _storage = MyLocalStorage();
bool loggedOut = true;

List<DynamicWidget> listDynamic = [];

class FeedPage extends StatefulWidget {
  @override
  _FeedPageState createState() => _FeedPageState();
}

String userName = "", userEmail = "", userPropic = "", userBio = "";

AuthMethods authMethods = new AuthMethods();

class _FeedPageState extends State<FeedPage> with TickerProviderStateMixin {
  @override
  void initState() {
    setState(() {
      this.fetchInfo();
      loggedOut = false;
    });
    super.initState();
  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  void alluser(context) async {
    Navigator.push(context,
        MaterialPageRoute(builder: (builder) => globalusers.AllUser()));
  }

  void logout(context) async {
    var x = await authMethods.signout();
    print(x);
    await Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (builder) => MyApp()), (route) => false);
    // Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));
  }

  @override
  Widget build(BuildContext context) {
    _getNames();
    return loggedOut
        ? SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Center(child: CircularProgressIndicator()),
            ),
          )
        : Scaffold(
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
                              backgroundImage: userPropic == ""
                                  ? AssetImage("assets/images/img.png")
                                  : NetworkImage(userPropic),
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
                                color: Colors.black,
                                fontSize: 14,
                                letterSpacing: 0),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (builder) => ProfilePage(
                                      uid: globalUserId,
                                      userId: globalUserId,
                                    )));
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
                        alluser(context);
                      },
                      child: ListTile(
                        title: Text(
                          "All users",
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
            appBar: AppBar(
              foregroundColor: Color(0xff86A7BA),
              leading: IconButton(
                icon: Icon(
                  Icons.dehaze,
                  color: Colors.white,
                ),
                onPressed: () {
                  scaffoldKey.currentState.openDrawer();
                },
              ),
              backgroundColor: Color(0xff86A7BA),
              elevation: 0,
              titleSpacing: 0.0,
              title: Row(
                children: <Widget>[
                  Text(
                    "Hello  ",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        letterSpacing: 1),
                  ),
                  Text(
                    userName,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        letterSpacing: 1),
                  ),
                ],
              ),
              actions: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => (message.Chathome())),
                    );
                  },
                  child: Icon(
                    Icons.message,
                    color: Colors.black38,
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
              ],
            ),
            backgroundColor: Color(0xFFEEEEEE),
            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
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
                      child: writePost(userPropic, context),
                    ),
                    SingleChildScrollView(
                      child: Container(
                          height: 500,
                          width: MediaQuery.of(context).size.width - 30,
                          child: askList()),
                    ),
                    //ADD_MORE_WIDGETS
                  ],
                ),
              ),
            ),
          );
  }

  void fetchInfo() async {
    print(globalUserId);

    QuerySnapshot snap = await databaseMethods.getUserByUserId(globalUserId);
    setState(() {
      userName = snap.documents[0].data["user_name"];
      userEmail = snap.documents[0].data["email"];
      userPropic = snap.documents[0].data["profile_picture"];
      userBio = snap.documents[0].data["bio"];
    });
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

addPost(String content, String heading) async {
  Map<String, String> userMap = {
    "user_id": globalUserId,
    "name": userName,
    "profile_picture": userPropic,
    "bio": bio,
    "content": heading + "\n" + content,
  };

  contentcontroller.clear();
  headingcontroller.clear();

  await databaseMethods.updatePosts(userMap);
}

// ignore: must_be_immutable
