import 'package:ace_start/backend/database.dart';
import 'package:ace_start/backend/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

DatabaseMethods databaseMethods = new DatabaseMethods();
QuerySnapshot userSnapshot;
String name = "df", email = "df", profilepic = userPropic, bio = "sdfd";
bool connected = false;
bool mypro = false;

// ignore: must_be_immutable
class ProfilePage extends StatefulWidget {
  final String uid;
  ProfilePage({Key key, @required this.uid}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState(uid);
}

class _ProfilePageState extends State<ProfilePage> {
  String usid;
  _ProfilePageState(String uid) {
    usid = uid;
  }

  @override
  void initState() {
    if (usid != userId) {
      mypro = false;
      this._fetchuserInfo(usid);
      this.findconnection(userId, usid);
    } else {
      mypro = true;
    }
    super.initState();
  }

  void findconnection(String u1, String u2) async {
    QuerySnapshot snap = await databaseMethods.getRoom(u1, u2);

    setState(() {
      if (snap.documents.length == 0) {
        connected = false;
      } else {
        connected = true;
      }
    });
  }

  void _updateList() async {
    QuerySnapshot snapshotss = await databaseMethods.getUserByUserId(userId);
    String docId = snapshotss.documents[0].documentID;

    List<dynamic> snap = snapshotss.documents[0]["friends"];
    snap.add(
      usid,
    );

    await databaseMethods.updateFriends(
      docId,
      snap,
    );

    snapshotss = await databaseMethods.getUserByUserId(usid);
    docId = snapshotss.documents[0].documentID;
    print(usid);
    print(userId);

    snap = snapshotss.documents[0]["friends"];
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
      "messages": []
    };

    await databaseMethods.newRoom(userMap);
    _updateList();
    findconnection(u1, u2);
  }

  void _fetchuserInfo(String usid) {
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
          title: Text(
            "Profile",
            style: TextStyle(fontSize: 18.0),
          ),
        ),
        backgroundColor: Colors.blue[300],
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  radius: 80,
                  backgroundImage: NetworkImage(profilepic),
                ),
                Text(
                  name,
                  style: TextStyle(
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
                  child: Text(bio),
                ),
                Card(
                    color: Colors.white,
                    margin:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                    child: ListTile(
                      leading: Icon(
                        Icons.phone,
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
                      Icons.cake,
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
