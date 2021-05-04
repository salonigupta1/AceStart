import 'dart:async';

import 'package:ace_start/backend/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

String myUserId = "";

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

List<dynamic> lists = [];

String fid;

class _ChatHomePageState extends State<ChatHomePage> {
  _ChatHomePageState(String friendsuserid) {
    fid = friendsuserid;
  }
  ScrollController _controller = ScrollController();

  @override
  void initState() {
    this.fun();
    lists = [];
    super.initState();
  }

  void fun() async {
    final prefs = await SharedPreferences.getInstance();
    myUserId = prefs.getString('userId');
    QuerySnapshot snapshot = await messagedb.getRoom(myUserId, fid);
    setState(() {
      docId = snapshot.documents[0].documentID;
    });

    print(docId);
  }

  Widget _buildList() {
    return StreamBuilder(
        stream: Firestore.instance
            .collection("chat_room")
            .document(docId)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.data != null) {
            lists = snapshot.data["messages"];

            return ListView.builder(
              controller: _controller,
              // reverse: true,
              itemCount: lists == null ? 0 : lists.length,
              itemBuilder: (BuildContext context, int index) {
                String type;
                if (lists[index]["user_id"] != myUserId) {
                  type = "receiver";
                } else {
                  type = "sender";
                }
                return (ChatMessage(lists[index]["content"], type));
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.blueAccent,
              ),
            );
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    Timer(
      Duration(seconds: 1),
      () => _controller.jumpTo(_controller.position.maxScrollExtent),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat Screen"),
        backgroundColor: Color(0xff86A7BA),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 60),
            child: _buildList(),
          ),
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
    final prefs = await SharedPreferences.getInstance();

    String userId = prefs.getString('userId');
    print(x.data);
    print(userId);

    List<dynamic> snap = x.data['messages'];
    snap.add({
      "user_id": userId,
      "content": mycontroller.text,
    });
    setState(() {
      mycontroller.clear();
    });

    await messagedb.updateMessage(snap, docId);
    Timer(Duration(milliseconds: 300),
        () => _controller.jumpTo(_controller.position.maxScrollExtent));
  }
}
