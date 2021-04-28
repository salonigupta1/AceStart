import 'package:ace_start/backend/user.dart';
import 'package:ace_start/profileandcontactpages/chatroom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ace_start/backend/database.dart';

DatabaseMethods databaseMethods = new DatabaseMethods();
QuerySnapshot friendsSnapshot;
QuerySnapshot nameSnapshot;

List<DynamicWidget> listDynamic = [];

class Chathome extends StatefulWidget {
  @override
  ChathomeState createState() => ChathomeState();
}

class ChathomeState extends State<Chathome> {
  @override
  void initState() {
    this._getNames();
    super.initState();
  }

  final TextEditingController _filter = new TextEditingController();

  String _searchText = "";
  List<DynamicWidget> names = [];
  List<DynamicWidget> filteredNames = [];
  Icon _searchIcon = new Icon(Icons.search);
  Widget _appBarTitle = new Text('Connections');

  ChathomeState() {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          filteredNames = names;
        });
      } else {
        setState(() {
          _searchText = _filter.text;
        });
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(context),
      body: Padding(
        padding: const EdgeInsets.only(top: 15, bottom: 15),
        child: Container(
          child: _buildList(),
        ),
      ),
      resizeToAvoidBottomInset: false,
    );
  }

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      centerTitle: true,
      title: _appBarTitle,
      backgroundColor: Color(0xff2E174D),
      leading: new IconButton(
        icon: _searchIcon,
        onPressed: _searchPressed,
      ),
    );
  }

  Widget _buildList() {
    if ((_searchText.isNotEmpty)) {
      List<DynamicWidget> tempList = [];
      for (int i = 0; i < filteredNames.length; i++) {
        if (filteredNames[i]
            .n
            .toLowerCase()
            .contains(_searchText.toLowerCase())) {
          tempList
              .add(new DynamicWidget(filteredNames[i].n, filteredNames[i].id));
        }
      }
      filteredNames = tempList;
    }
    return ListView.builder(
      itemCount: names == null ? 0 : filteredNames.length,
      itemBuilder: (BuildContext context, int index) {
        return DynamicWidget(filteredNames[index].n, filteredNames[index].id);
      },
    );
  }

  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close);
        this._appBarTitle = new TextField(
          controller: _filter,
          decoration: new InputDecoration(
            prefixIcon: new Icon(Icons.search),
            hintText: 'Search...',
          ),
        );
      } else {
        this._searchIcon = new Icon(Icons.search);
        this._appBarTitle = new Text('Connections');
        filteredNames = names;
        _filter.clear();
      }
    });
  }

  void _getNames() async {
    friendsSnapshot = await databaseMethods.getConnections(userId);
    List<DynamicWidget> tempList = [];

    var x = friendsSnapshot.documents[0].data["friends"];
    for (int i = 0; i < x.length; i++) {
      nameSnapshot = await databaseMethods.getUserByUserId(x[i]);
      tempList.add(
          new DynamicWidget(nameSnapshot.documents[0].data["user_name"], x[i]));
    }

    setState(() {
      names = tempList;
      names.shuffle();
      filteredNames = names;
    });
  }
}

// ignore: must_be_immutable
class DynamicWidget extends StatelessWidget {
  String n, id;
  DynamicWidget(String name, String id) {
    this.n = name;
    this.id = id;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: new EdgeInsets.only(left: 15, right: 15, top: 4, bottom: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: Colors.grey[300],
      ),
      child: new TextButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChatHomePage(friendsuserid: id)));
        },
        child: new ListTile(
          title: Text(
            n,
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }
}
