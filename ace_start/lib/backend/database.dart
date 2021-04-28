import 'package:ace_start/backend/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  getUserByUserId(String userId) async {
    return await Firestore.instance
        .collection("user_information")
        .where("user_id", isEqualTo: userId)
        .getDocuments();
  }

  updateUserInfo(userMap) {
    Firestore.instance.collection("user_information").add(userMap);
  }

  getConnections(String userId) async {
    return await Firestore.instance
        .collection("user_information")
        .where("user_id", isEqualTo: userId)
        .getDocuments();
  }

  updateConnections(userMap) {
    Firestore.instance.collection("user_information").add(userMap);
  }

  getRoom(String userIdone, String userIdtwo) async {
    return await Firestore.instance
        .collection("chat_room")
        .where(
          'part.' + userIdone,
          isEqualTo: true,
        )
        .where('part.' + userIdtwo, isEqualTo: true)
        .getDocuments();
  }

  newRoom(userMap) async {
    return await Firestore.instance.collection("chat_room").add(userMap);
  }

  getDocument(String docId) {
    return Firestore.instance.collection("chat_room").document(docId).get();
  }

  updateMessage(usermap, documentIds) async {
    return Firestore.instance
        .collection("chat_room")
        .document(documentIds)
        .updateData({
      "messages": usermap,
    });
  }

  updatePosts(postmap) async {
    return Firestore.instance.collection("post").add(postmap);
  }

  updateFriends(String docId, maps) async {
    return Firestore.instance
        .collection("user_information")
        .document(docId)
        .updateData({"friends": maps});
  }

  getPosts() async {
    return Firestore.instance.collection("post").getDocuments();
  }

  createRoom(usersMap) async {
    return await Firestore.instance.collection("chat_room").add(usersMap);
  }
}
