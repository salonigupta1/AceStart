import 'package:ace_start/InitialPages/login.dart';
import 'package:ace_start/feedPages/feedpages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'user.dart';

import 'package:ace_start/backend/shared_pref.dart';

MyLocalStorage _storage = MyLocalStorage();

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(userId: user.uid) : null;
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      FirebaseUser firebaseUser = result.user;
      String userId = _userFromFirebaseUser(firebaseUser).userId;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('userId', userId);
      globalUserId = userId;

      return _userFromFirebaseUser(firebaseUser);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future signUpWithEmailAndPassword(
      String email, String password, String name) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser firebaseUser = result.user;
      String userId = _userFromFirebaseUser(firebaseUser).userId;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      globalUserId = userId;
      prefs.setString('userId', userId);

      return _userFromFirebaseUser(firebaseUser);
    } catch (e) {
      print(e.toString());
    }
  }

  Future resetPass(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
    }
  }

  Future signout() async {
    try {
      await _storage.clearPrefs();
      userBio = "";
      userName = "";
      userPropic = "";
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }
}
