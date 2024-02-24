import 'package:cloud_firestore/cloud_firestore.dart';

class Todo {
  String title;
  String description;
  String? createdBy;
  String lastEditedBy;
  String timestamp;
  List<String>? priority;
  List<String>? editors;
  bool status;
  bool isEditing;

  Todo(
      {required this.title,
        required this.description,
        this.createdBy,
        required this.lastEditedBy,
        required this.timestamp,
        this.editors,
        this.priority,
        this.status = false,
        this.isEditing = false,
      });

  factory Todo.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return Todo(
      title: data['title'],
      description: data['description'],
      createdBy: data['createdBy'],
      lastEditedBy: data['lastEditedBy'],
      timestamp: data['timestamp'],
      priority: List<String>.from(data['priority'] ?? []),
      editors: List<String>.from(data['editors'] ?? []),
      status: data['status'],
      isEditing: data['isEditing'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'createdBy': createdBy,
      'lastEditedBy': lastEditedBy,
      'timestamp': timestamp,
      'priority': priority,
      'editors': editors,
      'status': status,
      'isEditing': isEditing,
    };
  }
}
