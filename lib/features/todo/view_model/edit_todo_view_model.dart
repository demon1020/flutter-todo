import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../../auth/model/users.dart';
import '../../auth/repository/auth_repository.dart';
import '../model/todo.dart';
import '../repository/todo_repository.dart';

class EditTodoViewModel with ChangeNotifier {
  late final TodoRepository _myRepo = TodoRepository();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  final AuthRepository _authService = AuthRepository();

  String get myUserName => _authService.getCurrentUser().toString();
  Stream<DocumentSnapshot>? todoDocumentStream;

  String createdBy = '';
  bool loading = false;
  bool isSharing = false;
  List<Users> dropItems = [];

  setSharing(isLoading){
    isSharing = isLoading;
    notifyListeners();
  }
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
      isEditing: true,
    );
    Map<String, dynamic> todoMap = todo.toMap();

    if (todo.title.isNotEmpty) {
      DocumentReference ref = await _myRepo.createTodo(todoMap);
      log(ref.id);
    }
    setLoading(false);
    notifyListeners();
  }

  // getTodo(String todoId) async {
  //   DocumentSnapshot snapshot = await todoRepository.getTodo(todoId);
  //   Todo todo = Todo.fromSnapshot(snapshot);
  //   titleController.text = todo.title;
  //   descriptionController.text = todo.description;
  //   log(todo.description);
  //   notifyListeners();
  // }

  updateTodo({required String todoId, required Todo todo}) async {
    await _myRepo.updateTodo(todoId, todo);
    notifyListeners();
  }

  void getTodoDocumentStream(String todoId) async {
    todoDocumentStream = await _myRepo.getTodoDocumentStream(todoId);
    notifyListeners();
  }

  init(todoId) async{
    getTodoDocumentStream(todoId);
    QuerySnapshot snapshot = await _authService.getAllUsers();
    dropItems = Users.parseUsersList(snapshot.docs);
  }

  shareToPeople({required String todoId, required List<String>users}){
    _myRepo.shareTodoToUsers(todoId, users);
    notifyListeners();
  }
}

