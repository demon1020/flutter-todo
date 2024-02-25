import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../resources/constants/firestore_constants.dart';
import '../model/users.dart';
import '/core.dart';

class AuthRepository{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  Users? _userFromFirebaseUser(User? user) {
    return user != null ? Users(user.uid) : null;
  }

  Stream<Users?> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }


  getCurrentUser(){
    return _auth.currentUser?.email;
  }

  // sign in with email and password
  Future<User?> signIn({required String email, required String password}) async {

    try {
      User? user = (await _auth.signInWithEmailAndPassword(
          email: email, password: password))
          .user;

      if (user != null) {
        print("Login Successful");
        return user;
      } else {
        print("Login Failed");
        return user;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  // signUp with email and password
  Future<User?> signUp({String name ="", required String email, required String password}) async {
    try {
      User? user = (await _auth.createUserWithEmailAndPassword(
          email: email, password: password))
          .user;

      if (user != null) {
        await _firestore.collection('users').doc(_auth.currentUser!.uid).set({
          "name": name,
          "email": email,
          "password": password,
          "uid": _auth.currentUser!.uid,
        });
        return user;
      } else {
        print("Account creation failed");
        return user;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  // sign out
  Future signOut(BuildContext context) async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }


  Future<QuerySnapshot<Object?>> getAllUsers() async {
    return await FirestoreConstants.usersCollection.get();
  }
}

