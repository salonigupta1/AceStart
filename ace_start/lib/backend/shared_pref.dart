import 'package:shared_preferences/shared_preferences.dart';

class MyLocalStorage {
  setUserId(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userId', userId);
  }

  Future<String> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.getString('userId');
  }

  // clear local storage
  clearPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("userId");
  }
}
