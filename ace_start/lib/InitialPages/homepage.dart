import 'package:ace_start/feedPages/feedpages.dart';
import 'package:flutter/material.dart';
import 'package:ace_start/InitialPages/login.dart';
import 'package:ace_start/InitialPages/singup.dart';
import 'package:google_fonts/google_fonts.dart';

bool loggedIn = false;

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: (!loggedIn)
            ? Container(
                decoration: BoxDecoration(color: Colors.white),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // SizedBox(
                      //   height: 4,
                      // ),
                      Column(
                        children: [
                          Text(
                            "AceStart",
                            style: GoogleFonts.roboto(
                                color: Colors.black,
                                fontStyle: FontStyle.italic,
                                fontSize: 30),
                          ),
                          Text(
                            'Dream And Achieve',
                            style: GoogleFonts.roboto(
                                color: Colors.black,
                                fontStyle: FontStyle.italic,
                                fontSize: 20),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Image.asset(
                        'assets/images/main.gif',
                        height: MediaQuery.of(context).size.height * 0.4,
                        width: MediaQuery.of(context).size.width * 0.4,
                      ),
                      SizedBox(
                        height: 50,
                      ),

                      Column(
                        children: <Widget>[
                          Container(
                              margin: EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2),
                                gradient: LinearGradient(colors: <Color>[
                                  Colors.black,
                                  Color(0xff7399AF),
                                ]),
                              ),
                              width: MediaQuery.of(context).size.width - 50,
                              child: MaterialButton(
                                splashColor: Colors.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(5.0),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginPage()));
                                },
                                child: Text(
                                  "Login",
                                  style: TextStyle(color: Colors.white),
                                ),
                              )),
                          Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2),
                                gradient: LinearGradient(colors: <Color>[
                                  Colors.black,
                                  Color(0xff7399AF),
                                ]),
                              ),
                              width: MediaQuery.of(context).size.width - 50,
                              child: MaterialButton(
                                splashColor: Colors.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(5.0),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              RegisterPage()));
                                },
                                child: Text(
                                  "Register",
                                  style: TextStyle(color: Colors.white),
                                ),
                              )),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              )
            : FeedPage());
  }
}
