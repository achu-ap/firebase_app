import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app/utils/models/todomodel.dart';
import 'package:firebase_app/utils/models/usermodel.dart';

class FirestoreServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Stream<QuerySnapshot> read(String uid) {
    return _firestore
        .collection("todos")
        .where("userId", isEqualTo: uid)
        .snapshots();
  }

  Future write(TodoModel todo) async {
    try {
      final res = await _firestore.collection("todos").doc().set(todo.toJSON());
      return res;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future writeuser(Usermodel user) async {
    try {
      final res = await _firestore.collection("users").doc().set(user.toJSON());
      return res;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future updateuserinfo(String id, Usermodel user) async {
    try {
      final res = await _firestore.collection("users").doc().set(user.toJSON());
      return res;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future delete(String id) async {
    try {
      final res = await _firestore.collection("todos").doc(id).delete();
      return res;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future update(String id, TodoModel todo) async {
    try {
      final res =
          await _firestore.collection("todos").doc(id).update(todo.toJSON());
      return res;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<QueryDocumentSnapshot?> getUser(String id) async {
    try {
      final user = await _firestore.collection("users").where("userid", isEqualTo: id).get();
      return user.docs.single;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
