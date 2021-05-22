import 'package:flutter/material.dart';
import 'package:ace_start/backend/user.dart';
import 'package:ace_start/feedPages/profilepage.dart';

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
      margin: new EdgeInsets.only(left: 5, right: 5, top: 4, bottom: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(color: Colors.black26),
        gradient: LinearGradient(colors: <Color>[
          Colors.black,
          Color(0xff7399AF),
        ]),
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
                          image: (photo == "" || photo == null)
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
                      backgroundImage: NetworkImage((photo == null ||
                              photo == "")
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
                                builder: (context) => ProfilePage(
                                      uid: uid,
                                      userId: globalUserId,
                                    )));
                      },
                      child: ListTile(
                        title: RichText(
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                              text: n == null ? "" : n,
                              style: TextStyle(color: Colors.white)),
                        ),
                        subtitle: RichText(
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                              text: bio == null ? "" : bio,
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Text(
                  c,
                  style: TextStyle(color: Colors.white),
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
              (image == "" || image == null)
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
