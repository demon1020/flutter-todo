import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../../auth/repository/auth_repository.dart';
import '../repository/todo_repository.dart';

class TodoViewModel with ChangeNotifier {
  late TodoRepository todoRepository = TodoRepository();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  final AuthRepository _authService = AuthRepository();

  String get myUserName => _authService.getCurrentUser().toString();
  String createdBy = '';
  bool loading = false;

  setLoading(isLoading){
    loading = isLoading;
    notifyListeners();
  }

  createTodo() async {
    setLoading(true);
    notifyListeners();
    Todo todo = Todo(
      title: titleController.text,
      description: descriptionController.text,
      createdBy: myUserName,
      lastEditedBy: myUserName,
      timestamp: DateTime.now().toString(),
      priority: ['low'],
      editors: [myUserName],
      status: false,
    );
    Map<String, dynamic> todoMap = todo.toMap();

    if (todo.title.isNotEmpty) {
      await todoRepository.createTodo(todoMap);
    }
    setLoading(false);
    notifyListeners();
  }

  getTodo(String todoId) async {
    DocumentSnapshot snapshot = await todoRepository.getTodo(todoId);
    Todo todo = Todo.fromSnapshot(snapshot);
    titleController.text = todo.title;
    descriptionController.text = todo.description;
    log(todo.description);
    notifyListeners();
  }

  updateTodo({required String todoId, required Todo todo}) async {
    await todoRepository.updateTodo(todoId, todo);
    notifyListeners();
  }
}

class Todo {
  String title;
  String description;
  String? createdBy;
  String lastEditedBy;
  String timestamp;
  List<String>? priority;
  List<String>? editors;
  bool status;

  Todo(
      {required this.title,
      required this.description,
      this.createdBy,
      required this.lastEditedBy,
      required this.timestamp,
      this.editors,
      this.priority,
      this.status = false});

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
    };
  }
}
