import 'package:ace_start/backend/database.dart';
import 'package:ace_start/feedPages/setting.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

DatabaseMethods databaseMethods = new DatabaseMethods();
QuerySnapshot userSnapshot;
String name = "", email = "", profilepic = "", bio = "";
bool connected = false;
bool mypro = false;

// ignore: must_be_immutable
class ProfilePage extends StatefulWidget {
  final String uid, userId;
  ProfilePage({Key key, @required this.uid, @required this.userId})
      : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState(uid, userId);
}

class _ProfilePageState extends State<ProfilePage> {
  String usid, userId;
  _ProfilePageState(String uid, String userId) {
    usid = uid;
    this.userId = userId;
  }

  @override
  void initState() {
    if (userId != usid) {
      mypro = false;
      this._fetchuserInfo(usid);
      this.findconnection(userId, usid);
    } else {
      mypro = true;
      this._fetchuserInfo(userId);
    }

    super.initState();
  }

  void findconnection(String u1, String u2) async {
    QuerySnapshot snap = await databaseMethods.getRoom(u1, u2);
    print(snap);

    setState(() {
      if (snap == null || snap.documents.length == 0) {
        connected = false;
      } else {
        connected = true;
      }
    });
  }

  void _updateList() async {
    QuerySnapshot snapshotss = await databaseMethods.getUserByUserId(userId);
    String docId = snapshotss.documents[0].documentID;
    DocumentSnapshot docSnap =
        await databaseMethods.getDocumentGlobal("user_information", docId);

    List<dynamic> snap = docSnap.data['friends'];
    snap.add(
      usid,
    );

    await databaseMethods.updateFriends(
      docId,
      snap,
    );

    snapshotss = await databaseMethods.getUserByUserId(usid);
    docId = snapshotss.documents[0].documentID;

    docSnap =
        await databaseMethods.getDocumentGlobal("user_information", docId);

    snap = docSnap.data["friends"];
    snap.add(
      userId,
    );

    await databaseMethods.updateFriends(
      docId,
      snap,
    );
  }

  void makenewroom(String u1, String u2) async {
    Map<String, dynamic> userMap = {
      "part": {
        u1: true,
        u2: true,
      },
      "messages": [],
    };

    await databaseMethods.newRoom(userMap);
    _updateList();
    setState(() {
      connected = true;
    });
  }

  void _fetchuserInfo(String usid) async {
    databaseMethods.getUserByUserId(usid).then((val) {
      setState(() {
        userSnapshot = val;
      });

      setState(() {
        bio = userSnapshot.documents[0].data["bio"];
        name = userSnapshot.documents[0].data["user_name"];
        email = userSnapshot.documents[0].data["email"];
        profilepic = userSnapshot.documents[0].data["profile_picture"];
      });
    });
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: <Color>[Colors.black, Color(0xff7399AF)]),
            ),
          ),
          title: Center(
            child: Text(
              name,
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          actions: <Widget>[
            if (mypro)
              IconButton(
                icon: Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
                onPressed: () {
                  // do something

                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SettingPage()));
                },
              ),
          ],
        ),
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  radius: 80,
                  backgroundImage: profilepic == ""
                      ? AssetImage("assets/images/img.png")
                      : NetworkImage(profilepic),
                ),
                Text(
                  name,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'SourceSansPro',
                    fontSize: 25,
                  ),
                ),
                SizedBox(
                  height: 20.0,
                  width: 200,
                  child: Divider(
                    color: Colors.teal[100],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 50,
                  height: 30,
                  child: Center(
                    child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child:
                            Text(bio, style: TextStyle(color: Colors.white24))),
                  ),
                ),
                Card(
                    color: Colors.white,
                    margin:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                    child: ListTile(
                      leading: Icon(
                        Icons.mail,
                        color: Colors.teal[900],
                      ),
                      title: Text(
                        email,
                        style:
                            TextStyle(fontFamily: 'BalooBhai', fontSize: 20.0),
                      ),
                    )),
                Card(
                  color: Colors.white,
                  margin:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                  child: ListTile(
                    leading: Icon(
                      Icons.person,
                      color: Colors.teal[900],
                    ),
                    title: GestureDetector(
                      onTap: () {
                        if (!connected && !mypro) {
                          makenewroom(usid, userId);
                        }
                      },
                      child: usid == userId
                          ? Text("Your Profile")
                          : Text(
                              connected == true
                                  ? 'Connected'
                                  : 'Add to your Connections',
                              style: TextStyle(
                                  fontSize: 20.0, fontFamily: 'Neucha'),
                            ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
