import 'package:ace_start/backend/user.dart';
import 'package:ace_start/feedPages/feedpages.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'InitialPages/homepage.dart';

var userId;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  userId = prefs.getString('userId');
  globalUserId = userId;

  runApp(
    MaterialApp(
      home: (userId == null || userId == "") ? MyApp() : FeedPage(),
      theme: ThemeData(accentColor: Color(0xff007EF4)),
      debugShowCheckedModeBanner: false,
    ),
  );
}

class MyApp extends StatelessWidget {
  void fun() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: (userId == null || userId == "") ? MyHomePage() : FeedPage(),
    );
  }
}
