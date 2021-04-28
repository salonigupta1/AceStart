import 'dart:io';

import 'package:ace_start/InitialPages/singup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(userId: user.uid) : null;
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser firebaseUser = result.user;
      userId = _userFromFirebaseUser(firebaseUser).userId;
      userEmail = email;
      prefs.setString('userId', _userFromFirebaseUser(firebaseUser).userId);
      prefs.setString('email', email);
      return _userFromFirebaseUser(firebaseUser);
    } catch (e) {
      print(e);
    }
  }

  Future signUpWithEmailAndPassword(
      String email, String password, String name) async {
    final prefs = await SharedPreferences.getInstance();
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser firebaseUser = result.user;
      userId = _userFromFirebaseUser(firebaseUser).userId;
      userEmail = email;
      userName = name;
      prefs.setString('userId', _userFromFirebaseUser(firebaseUser).userId);
      prefs.setString('email', email);
      prefs.setString('name', userName);
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
    final prefs = await SharedPreferences.getInstance();
    try {
      prefs.clear();
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }
}
