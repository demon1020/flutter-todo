import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  final String uid;
  final String? email;
  final String? name;

  Users(this.uid, {this.email, this.name});

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
    };
  }

  static Users fromJson(Map<String, dynamic> json) {
    return Users(
      json['uid'] ?? "",
      email: json['email'] ?? "",
      name: json['name'] ?? "",
    );
  }

  static List<Users> parseUsersList(List<QueryDocumentSnapshot<Object?>> documents) {
    return documents.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return Users.fromJson(data);
    }).toList();
  }
}