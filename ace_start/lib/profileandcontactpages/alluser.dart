import 'package:ace_start/backend/database.dart';
import 'package:ace_start/backend/user.dart';
import 'package:ace_start/feedPages/profilepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

DatabaseMethods databaseMethods = DatabaseMethods();

class AllUser extends StatefulWidget {
  AllUser({Key key}) : super(key: key);

  @override
  _AllUserState createState() => _AllUserState();
}

class _AllUserState extends State<AllUser> {
  @override
  void initState() {
    this.getNames();
    super.initState();
  }

  final TextEditingController _filter = new TextEditingController();

  String _searchText = "";
  List<DynamicWidget> names = [];
  List<DynamicWidget> filteredNames = [];
  Icon _searchIcon = new Icon(Icons.search);
  Widget _appBarTitle = new Text('Global Users');

  _AllUserState() {
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
      backgroundColor: Color(0xff86A7BA),
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
            .name
            .toLowerCase()
            .contains(_searchText.toLowerCase())) {
          tempList.add(new DynamicWidget(filteredNames[i].name,
              filteredNames[i].id, filteredNames[i].photo));
        }
      }
      filteredNames = tempList;
    }
    return ListView.builder(
      itemCount: names == null ? 0 : filteredNames.length,
      itemBuilder: (BuildContext context, int index) {
        return DynamicWidget(filteredNames[index].name, filteredNames[index].id,
            filteredNames[index].photo);
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

  void getNames() async {
    QuerySnapshot snapshot = await databaseMethods.getAllUsers(globalUserId);
    List<DynamicWidget> tempList = [];
    var x = snapshot.documents.length;
    if (x == null) {
      return;
    }
    for (int i = 0; i < x; i++) {
      if (snapshot.documents[i].data["user_id"] != globalUserId) {
        tempList.add(DynamicWidget(
            snapshot.documents[i].data["user_name"],
            snapshot.documents[i].data["user_id"],
            snapshot.documents[i].data["profile_picture"]));
      }
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
  String id, name, photo;
  DynamicWidget(String name, String id, String photo) {
    this.id = id;
    this.name = name;
    this.photo = photo;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: new EdgeInsets.only(left: 15, right: 15, top: 4, bottom: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        // border: Border.all(color: Colors.black38),
        color: Colors.white10,
      ),
      child: new TextButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProfilePage(
                        uid: id,
                        userId: globalUserId,
                      )));
        },
        child: new ListTile(
          leading: CircleAvatar(
            backgroundImage: (photo == null || photo == "")
                ? AssetImage("assets/images/img.png")
                : NetworkImage(photo),
          ),
          title: Text(
            name,
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }
}
