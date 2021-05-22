import 'package:ace_start/backend/user.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ace_start/feedPages/feedpages.dart';

TextEditingController headingcontroller = TextEditingController();
TextEditingController contentcontroller = TextEditingController();
final formKey = GlobalKey<FormState>();

Widget writePost(userPropic, context) {
  return SingleChildScrollView(
    scrollDirection: Axis.vertical,
    child: Row(children: [
      Container(
        width: 35,
        child: CircleAvatar(
          radius: 25,
          backgroundImage: globalPropic == ""
              ? AssetImage(
                  "assets/images/img.png",
                )
              : NetworkImage(
                  userPropic,
                ),
        ),
      ),
      SizedBox(
        width: 15,
      ),
      Container(
        height: 20,
        width: 100,
        child: GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (contexts) {
                return Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40)),
                  elevation: 16,
                  child: Container(
                    height: 500,
                    child: ListView(
                      children: <Widget>[
                        Column(
                          children: [
                            SizedBox(
                              height: 50,
                            ),
                            Container(
                              margin: EdgeInsets.all(15),
                              padding: EdgeInsets.all(15),
                              height: 350,
                              width: MediaQuery.of(context).size.width - 30,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border:
                                      Border.all(color: Colors.black, width: 1),
                                  borderRadius: BorderRadius.circular(20)),
                              child: Form(
                                key: formKey,
                                child: Column(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.all(10),
                                      child: Text(
                                        "Tell us about your idea in brief",
                                        style: GoogleFonts.roboto(
                                            color: Colors.black, fontSize: 15),
                                      ),
                                    ),
                                    TextFormField(
                                      validator: (val) {
                                        return val.length > 6
                                            ? null
                                            : "Write a heading";
                                      },
                                      controller: headingcontroller,
                                      decoration:
                                          InputDecoration(hintText: "Heading"),
                                    ),
                                    Container(
                                      child: TextFormField(
                                        validator: (val) {
                                          return val.length > 6
                                              ? null
                                              : "Please tell us more about the idea";
                                        },
                                        controller: contentcontroller,
                                        keyboardType: TextInputType.multiline,
                                        minLines: 1,
                                        maxLines: 10,
                                        decoration: InputDecoration(
                                          hintText: "Content",
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: 30,
                              width: 100,
                              decoration: BoxDecoration(
                                  color: Color(0xff6B93AA),
                                  border: Border.all(
                                      color: Colors.black, width: 0.5),
                                  borderRadius: BorderRadius.circular(5)),
                              // ignore: deprecated_member_use
                              child: FlatButton(
                                onPressed: () {
                                  if (formKey.currentState.validate()) {
                                    addPost(contentcontroller.text,
                                        headingcontroller.text);
                                    Navigator.of(contexts).pop();

                                    contentcontroller.clear();
                                    headingcontroller.clear();
                                  }
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

          child: Text("Write a Post", style: TextStyle(color: Colors.white)),
          // decoration:
          //     InputDecoration(border: InputBorder.none, hintText: 'Write a post'),
        ),
      ),
    ]),
  );
}
