import 'package:flutter/material.dart';
import 'package:ace_start/InitialPages/login.dart';
import 'package:ace_start/InitialPages/singup.dart';
import 'package:google_fonts/google_fonts.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: <Color>[
            Color(0xffC64B8A),
            Color(0xff2E174D),
          ],
              stops: [
            0.0,
            1.0
          ],
              begin: FractionalOffset.topCenter,
              end: FractionalOffset.bottomCenter,
              tileMode: TileMode.repeated)),
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
              'assets/images/mainPages.png',
              height: MediaQuery.of(context).size.height * 0.4,
              width: MediaQuery.of(context).size.width * 0.4,
            ),
            SizedBox(
              height: 50,
            ),

            Row(
              children: <Widget>[
                SizedBox(
                  width: 20,
                ),
                Expanded(
                    child: MaterialButton(
                  color: Colors.black,
                  splashColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(18.0),
                      side: BorderSide(color: Color(0xffC64B8A))),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                  child: Text(
                    "Login",
                    style: TextStyle(color: Color(0xffC64B8A)),
                  ),
                )),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                    child: MaterialButton(
                  color: Colors.black,
                  splashColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(18.0),
                      side: BorderSide(color: Color(0xffC64B8A))),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegisterPage()));
                  },
                  child: Text(
                    "Register Now",
                    style: TextStyle(color: Color(0xffC64B8A)),
                  ),
                )),
                SizedBox(
                  width: 20,
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    ));
  }
}
