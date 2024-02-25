import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreConstants{

  static final CollectionReference todosCollection = FirebaseFirestore.instance.collection(todos);
  static final CollectionReference usersCollection = FirebaseFirestore.instance.collection(users);

  static const String todos = "todos";
  static const String users = "users";
  static const String editors = "editors";
  static const String lastMessageBy = "timestamp";


}