import 'package:ace_start/feedPages/feedpages.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'InitialPages/homepage.dart';
import 'backend/user.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  userId = prefs.getString("userId");
  userEmail = prefs.getString("userEmail");
  userName = prefs.getString("userName");
  userPropic = prefs.getString("userPropic");
  userBio = prefs.getString("userBio");
  loggedIn = prefs.getBool("loggedIn");
  if (loggedIn == null) {
    loggedIn = false;
  }

  runApp(
    MaterialApp(
      home: !loggedIn ? MyApp() : FeedPage(),
      theme: ThemeData(accentColor: Color(0xff007EF4)),
      debugShowCheckedModeBanner: false,
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: !loggedIn ? MyHomePage() : FeedPage(),
    );
  }
}
