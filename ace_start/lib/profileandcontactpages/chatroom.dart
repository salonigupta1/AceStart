import 'package:ace_start/backend/database.dart';
import 'package:ace_start/backend/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

TextEditingController mycontroller = new TextEditingController();

class ChatHomePage extends StatefulWidget {
  final String friendsuserid;
  ChatHomePage({Key key, @required this.friendsuserid}) : super(key: key);

  @override
  _ChatHomePageState createState() => _ChatHomePageState(friendsuserid);
}

String docId;

DatabaseMethods messagedb = new DatabaseMethods();
QuerySnapshot snapshot, partsnap;

// ignore: must_be_immutable
class ChatMessage extends StatelessWidget {
  String messageContent;
  String messageType;
  ChatMessage(String messageContent, String messageType) {
    this.messageContent = messageContent;
    this.messageType = messageType;
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
      child: Align(
        alignment: (messageType == "receiver"
            ? Alignment.topLeft
            : Alignment.topRight),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: (messageType == "receiver"
                ? Colors.grey.shade200
                : Color(0xff86A7BA)),
          ),
          padding: EdgeInsets.all(16),
          child: Text(
            messageContent,
            style: TextStyle(fontSize: 15),
          ),
        ),
      ),
    );
  }
}

List<ChatMessage> messages = [];

String fid;

class _ChatHomePageState extends State<ChatHomePage> {
  _ChatHomePageState(String friendsuserid) {
    fid = friendsuserid;
  }

  @override
  void initState() {
    this._getNames();
    super.initState();
  }

  Widget _buildList() {
    return StreamBuilder(
        stream: Firestore.instance
            .collection("chat_room")
            .document(docId)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          List<dynamic> lists;
          if (snapshot.data != null) {
            lists = snapshot.data["messages"];
            return ListView.builder(
              itemCount: lists == null ? 0 : lists.length,
              itemBuilder: (BuildContext context, int index) {
                String type;
                if (lists[index]["user_id"] != userId) {
                  type = "receiver";
                } else {
                  type = "sender";
                }
                return (ChatMessage(lists[index]["content"], type));
              },
            );
          } else {
            return Container();
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat Screen"),
        backgroundColor: Color(0xff86A7BA),
      ),
      body: Stack(
        children: <Widget>[
          _buildList(),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
              height: 60,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: TextField(
                      controller: mycontroller,
                      decoration: InputDecoration(
                          hintText: "Write message...",
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      _updateList();
                    },
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 18,
                    ),
                    backgroundColor: Color(0xff86A7BA),
                    elevation: 0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _updateList() async {
    DocumentSnapshot x = await messagedb.getDocument(docId);

    List<dynamic> snap = x.data['messages'];
    snap.add({
      "user_id": userId,
      "content": mycontroller.text,
    });

    await messagedb.updateMessage(snap, docId);
    setState(() {
      mycontroller.clear();
    });
  }

  void _getNames() async {
    snapshot = await messagedb.getRoom(userId, fid);

    List<ChatMessage> tempList = [];

    var x = snapshot.documents[0].data["messages"];
    docId = snapshot.documents[0].documentID;

    for (int i = 0; i < x.length; i++) {
      String type;
      if (x[i]['user_id'] == userId) {
        type = "sender";
      } else {
        type = "receiver";
      }
      tempList.add(new ChatMessage(x[i]['content'], type));
    }

    setState(() {
      messages = tempList;
    });
  }
}
