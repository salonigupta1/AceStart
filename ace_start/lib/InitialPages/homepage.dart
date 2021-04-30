import 'package:ace_start/backend/user.dart';
import 'package:ace_start/feedPages/feedpages.dart';
import 'package:flutter/material.dart';
import 'package:ace_start/InitialPages/login.dart';
import 'package:ace_start/InitialPages/singup.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    this.fun();
    super.initState();
  }

  void fun() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString("userId");
      userEmail = prefs.getString("userEmail");
      userName = prefs.getString("userName");
      userPropic = prefs.getString("userPropic");
      userBio = prefs.getString("userBio");
      loggedIn = prefs.getBool("loggedIn");
      if (loggedIn == null) {
        loggedIn = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    fun();
    return Scaffold(
        body: (userId == null)
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
                              width: MediaQuery.of(context).size.width - 50,
                              child: MaterialButton(
                                color: Colors.black26,
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
                              width: MediaQuery.of(context).size.width - 50,
                              child: MaterialButton(
                                color: Colors.black26,
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
