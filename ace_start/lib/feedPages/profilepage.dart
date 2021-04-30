import 'package:ace_start/backend/database.dart';
import 'package:ace_start/backend/user.dart';
import 'package:ace_start/feedPages/setting.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

DatabaseMethods databaseMethods = new DatabaseMethods();
QuerySnapshot userSnapshot;
String name = userName,
    email = userEmail,
    profilepic = userPropic,
    bio = userBio;
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
    if (userId != usid) {
      print(userId);
      print(usid);
      mypro = false;
      this._fetchuserInfo(usid);
      this.findconnection(userId, usid);
    } else {
      print(userId);
      print(usid);
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
    DocumentSnapshot docSnap =
        await databaseMethods.getDocumentGlobal("user_information", docId);
    print(docId);

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
    print(docId);
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
      "messages": []
    };

    await databaseMethods.newRoom(userMap);
    _updateList();
    findconnection(u1, u2);
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
          title: Center(
            child: Text(
              mypro ? userName : name,
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
                  print("Tapped");
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SettingPage()));
                },
              ),
          ],
        ),
        backgroundColor: Colors.blue[300],
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  radius: 80,
                  backgroundImage: mypro
                      ? NetworkImage(userPropic == null
                          ? "https://www.pngkey.com/png/detail/21-213224_unknown-person-icon-png-download.png"
                          : userPropic)
                      : NetworkImage(profilepic == null
                          ? "https://www.pngkey.com/png/detail/21-213224_unknown-person-icon-png-download.png"
                          : profilepic),
                ),
                Text(
                  mypro ? userName : name,
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
                  height: 50,
                  child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Text(mypro ? userBio : bio,
                          style: TextStyle(color: Colors.black26))),
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
                        mypro ? userEmail : email,
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
                        print("tapped");
                        print(connected);
                        print(mypro);
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
