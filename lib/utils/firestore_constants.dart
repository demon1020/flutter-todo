import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreConstants{
  final CollectionReference USERS_COLLECTION = FirebaseFirestore.instance.collection(USERS);
  final CollectionReference CHATROOM_COLLECTION = FirebaseFirestore.instance.collection(CHATROOM);
  final CollectionReference TODOS_COLLECTION = FirebaseFirestore.instance.collection(TODOS);

  static const String TODOS = "todos";
  static const String USERS = "users";
  static const String CHATROOM = "chatroom";

  static const String UID = "uid";
  static const String CHAT_USERS = "editors";
  static const String USERNAME = "username";
  static const String NAME = "name";
  static const String STATUS = "status";
  static const String TIME = "time";
  static const String IMAGE_URL= "imageUrl";
  static const String EMAIL = "email";
  static const String PHONE = "phone";
  static const String STATUS_ONLINE = "Online";
  static const String STATUS_OFFLINE = "Offline";
  static const String IS_READ = "isRead";

  static const String LAST_MESSAGE_TIME = "timestamp";


}