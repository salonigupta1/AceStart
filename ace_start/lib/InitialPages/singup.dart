import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RegisterPage();
}

class _RegisterPage extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
          height: MediaQuery.of(context).size.height,
          color: Colors.black,
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Stack(
                alignment: Alignment.bottomCenter,
                children: <Widget>[
                  ClipPath(
                    clipper: TopWaveClipper(),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: <Color>[
                          Color(0xff2E174D),
                          Color(0xffC64B8A),
                        ], begin: Alignment.topLeft, end: Alignment.center),
                      ),
                      height: MediaQuery.of(context).size.height / 2.5,
                    ),
                  ),
                  // Image.asset(
                  //   'assets/burger.png',
                  //   height: MediaQuery.of(context).size.height * 0.2,
                  // ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                  decoration: BoxDecoration(
                      color: Color(0xff2E174D),
                      borderRadius: BorderRadius.circular(10)),
                  height: MediaQuery.of(context).size.height * 0.5,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: <Widget>[
                      ClipPath(
                        clipper: FooterWaveClipper(),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: <Color>[
                                  Color(0xff2E174D),
                                  Color(0xffC64B8A)
                                ],
                                begin: Alignment.center,
                                end: Alignment.bottomRight),
                          ),
                          height: MediaQuery.of(context).size.height / 3,
                        ),
                      ),
                      Column(
//                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          SizedBox(
                            height: 15,
                          ),
                          // Text('Hello',
                          //     style: GoogleFonts.roboto(
                          //       fontSize: 20,
                          //       color: Color(0xffC64B8A),
                          //       fontWeight: FontWeight.bold,
                          //     )),
                          // Text('Sign into your Account',
                          //     style: GoogleFonts.roboto(
                          //         fontSize: 20,
                          //         color: Color(0xffC64B8A),
                          //         fontWeight: FontWeight.bold)),
                          SizedBox(
                            height: 30,
                          ),
                          Padding(
                              padding: EdgeInsets.only(right: 40, bottom: 10),
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.08,
                                width: MediaQuery.of(context).size.width - 40,
                                child: Material(
                                  elevation: 10,
                                  color: Color(0xff943A76),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      // bottomRight: Radius.circular00),
                                      topRight: Radius.circular(35),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 20,
                                        right: 20,
                                        top: 10,
                                        bottom: 10),
                                    child: TextField(
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        labelText: "Email",
                                        labelStyle: TextStyle(
                                            color: Colors.black, fontSize: 14),
                                        // hintText: "Email",
                                        // hintStyle: TextStyle(color: Color(0xFFE1E1E1), fontSize: 14)
                                      ),
                                    ),
                                  ),
                                ),
                              )),
                          Padding(
                              padding: EdgeInsets.only(right: 40, bottom: 10),
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.08,
                                width: MediaQuery.of(context).size.width - 40,
                                child: Material(
                                  elevation: 10,
                                  color: Color(0xff943A76),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      // bottomRight: Radius.circular00),
                                      topRight: Radius.circular(35),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 20,
                                        right: 20,
                                        top: 10,
                                        bottom: 10),
                                    child: TextField(
                                      obscureText: true,
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        labelText: "Phone Number",
                                        labelStyle: TextStyle(
                                            color: Colors.black, fontSize: 14),
                                        // hintText: "Email",
                                        // hintStyle: TextStyle(color: Color(0xFFE1E1E1), fontSize: 14)
                                      ),
                                    ),
                                  ),
                                ),
                              )),
                          Padding(
                              padding: EdgeInsets.only(right: 40, bottom: 5),
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.08,
                                width: MediaQuery.of(context).size.width - 40,
                                child: Material(
                                  elevation: 10,
                                  color: Color(0xff943A76),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      // bottomRight: Radius.circular00),
                                      topRight: Radius.circular(35),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 20,
                                        right: 20,
                                        top: 10,
                                        bottom: 10),
                                    child: TextField(
                                      obscureText: true,
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        labelText: "Password",
                                        labelStyle: TextStyle(
                                            color: Colors.black, fontSize: 14),
                                        // hintText: "Email",
                                        // hintStyle: TextStyle(color: Color(0xFFE1E1E1), fontSize: 14)
                                      ),
                                    ),
                                  ),
                                ),
                              )),
                          SizedBox(
                            height: 30,
                          ),

                          Container(
                            width: 150,
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
                                "Register",
                                style: TextStyle(color: Color(0xffC64B8A)),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    ],
                  )),
              SizedBox(
                height: 15,
              ),
              RichText(
                text: TextSpan(
                    text: 'Already have an account? ',
                    style: TextStyle(
                        color: Color(0xff2E174D), fontWeight: FontWeight.bold),
                    children: <TextSpan>[
                      new TextSpan(
                          text: 'Login Now',
                          style: new TextStyle(
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                              color: Color(0xffA23F7C))),
                    ]),
              )
            ],
          )),
    ));
  }
}

class TopWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // This is where we decide what part of our image is going to be visible.
    var path = Path();
    path.lineTo(0.0, size.height);

    var firstControlPoint = new Offset(size.width / 7, size.height - 30);
    var firstEndPoint = new Offset(size.width / 6, size.height / 1.5);

    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondControlPoint = Offset(size.width / 5, size.height / 4);
    var secondEndPoint = Offset(size.width / 1.5, size.height / 5);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    var thirdControlPoint =
        Offset(size.width - (size.width / 9), size.height / 6);
    var thirdEndPoint = Offset(size.width, 0.0);
    path.quadraticBezierTo(thirdControlPoint.dx, thirdControlPoint.dy,
        thirdEndPoint.dx, thirdEndPoint.dy);

    ///move from bottom right to top
    path.lineTo(size.width, 0.0);

    ///finally close the path by reaching start point from top right corner
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class FooterWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(size.width, 0.0);
    path.lineTo(size.width, size.height);
    path.lineTo(0.0, size.height);
    path.lineTo(0.0, size.height - 60);
    var secondControlPoint = Offset(size.width - (size.width / 6), size.height);
    var secondEndPoint = Offset(size.width, 0.0);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
