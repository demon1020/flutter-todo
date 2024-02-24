import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo/core.dart';
import 'package:uuid/uuid.dart';

import '../../../utils/firestore_constants.dart';
import '../view_model/todo_view_model.dart';

class TodoRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final AuthRepository _authService = AuthRepository();

  String get myUserName => _authService.getCurrentUser().toString();

  //Update users status
  setStatus(String status) async {
    return FirestoreConstants()
        .USERS_COLLECTION
        .doc(_auth.currentUser!.uid)
        .update({
      FirestoreConstants.STATUS: status,
    });
  }

  //Update users message read status
  setMessageReadStatus(String chatRoomId) async {
    return FirestoreConstants().CHATROOM_COLLECTION.doc(chatRoomId).update({
      FirestoreConstants.IS_READ: true,
    });
  }

  //Change it to Firestore.username later
  Future<Stream<QuerySnapshot>?> getUserByUsername(String username) async {
    if (myUserName != username) {
      return FirestoreConstants()
          .USERS_COLLECTION
          .where(FirestoreConstants.NAME, isEqualTo: username)
          .snapshots();
    } else {
      return null;
    }
  }

  //to get users detail and status based on data
  Future<Stream<DocumentSnapshot>> getChatUserInfo(
      Map<String, dynamic>? userInfoMap) async {
    return FirestoreConstants()
        .USERS_COLLECTION
        .doc(userInfoMap![FirestoreConstants.UID])
        .snapshots();
  }

  createChatRoom(
      String chatRoomId, Map<String, dynamic> chatRoomInfoMap) async {
    final snapShot =
        await FirestoreConstants().CHATROOM_COLLECTION.doc(chatRoomId).get();

    if (snapShot.exists) {
      // chatroom already exists
      return true;
    } else {
      // chatroom does not exists
      return FirestoreConstants()
          .CHATROOM_COLLECTION
          .doc(chatRoomId)
          .set(chatRoomInfoMap);
    }
  }

  Future addMessage(String chatRoomId, Map<String, dynamic> messages) async {
    return await FirestoreConstants()
        .CHATROOM_COLLECTION
        .doc(chatRoomId)
        .collection(FirestoreConstants.TODOS)
        .add(messages);
  }

  Future UpdateLastMessage(
      String chatRoomId, Map<String, dynamic> lastMessage) async {
    final snapShot =
        await FirestoreConstants().CHATROOM_COLLECTION.doc(chatRoomId).get();
    if (snapShot.exists) {
      return FirestoreConstants()
          .CHATROOM_COLLECTION
          .doc(chatRoomId)
          .update(lastMessage);
    }
  }

  Future<Stream<QuerySnapshot>> getChatUserMessages(String chatRoomId) async {
    return FirestoreConstants()
        .CHATROOM_COLLECTION
        .doc(chatRoomId)
        .collection(FirestoreConstants.TODOS)
        .orderBy(FirestoreConstants.TIME, descending: true)
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> getChatRoomList() async {
    return FirestoreConstants()
        .CHATROOM_COLLECTION
        .where(FirestoreConstants.CHAT_USERS, arrayContains: myUserName)
        .orderBy(FirestoreConstants.LAST_MESSAGE_TIME, descending: true)
        .snapshots();
  }

//Change it to Firestore.username later
  Future<QuerySnapshot> getUserInfo(String username) async {
    return await FirestoreConstants()
        .USERS_COLLECTION
        .where(FirestoreConstants.NAME, isEqualTo: username)
        .get();
  }

  //-----------

  Future<Stream<QuerySnapshot>> getTodosStream() async {
    return FirestoreConstants()
        .TODOS_COLLECTION
        .where(FirestoreConstants.CHAT_USERS, arrayContains: myUserName)
        .orderBy(FirestoreConstants.LAST_MESSAGE_TIME, descending: true)
        .snapshots();
  }

  Future createTodo(Map<String, dynamic> todo) async {
    return await FirestoreConstants().TODOS_COLLECTION.add(todo);
  }

  Future getTodo(String todoId) async {
    return await FirestoreConstants().TODOS_COLLECTION.doc(todoId).get();
  }

  updateTodo(String todoId, Todo todo) async {
    return FirestoreConstants().TODOS_COLLECTION.doc(todoId).update({
      'title': todo.title,
      'description': todo.description,
      'lastEditedBy': todo.lastEditedBy,
      'timestamp': todo.timestamp,
      'isEditing': todo.isEditing,
    });
  }

  // Future<Stream<DocumentSnapshot>> getTodoDocumentStream() async {
  //   return FirestoreConstants().TODOS_COLLECTION
  //       .where('editors', arrayContains: myUserName)
  //   // .orderBy(FirestoreConstants.LAST_MESSAGE_TIME, descending: true)
  //       .snapshots();
  // }
}
