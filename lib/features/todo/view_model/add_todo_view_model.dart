import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:todo/core.dart';

import '../../auth/repository/auth_repository.dart';
import '../model/todo.dart';
import '../repository/todo_repository.dart';

class AddTodoViewModel with ChangeNotifier {
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
    Navigator.pop(navigatorKey.currentContext!);
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

