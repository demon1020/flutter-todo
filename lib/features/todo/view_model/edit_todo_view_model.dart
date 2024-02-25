import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_sender/email_sender.dart';
import 'package:flutter/cupertino.dart';

import '../../../utils/utils.dart';
import '../../auth/model/users.dart';
import '../../auth/repository/auth_repository.dart';
import '../model/todo.dart';
import '../repository/todo_repository.dart';

class EditTodoViewModel with ChangeNotifier {
  late final TodoRepository _myRepo = TodoRepository();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  final AuthRepository _authService = AuthRepository();

  String get currentUser => _authService.getCurrentUser().toString();
  Stream<DocumentSnapshot>? todoDocumentStream;

  String createdBy = '';
  bool isSyncing = false;
  bool isSharing = false;
  Set<Users> dropItems = {};

  setSharing(isLoading) {
    isSharing = isLoading;
    notifyListeners();
  }

  setSyncing(isLoading) {
    isSyncing = isLoading;
    notifyListeners();
  }

  createTodo() async {
    setSyncing(true);
    notifyListeners();
    Todo todo = Todo(
      title: titleController.text,
      description: descriptionController.text,
      createdBy: currentUser,
      lastEditedBy: currentUser,
      timestamp: DateTime.now().toString(),
      priority: ['low'],
      editors: [currentUser],
      status: false,
      isEditing: true,
    );
    Map<String, dynamic> todoMap = todo.toMap();

    if (todo.title.isNotEmpty) {
      DocumentReference ref = await _myRepo.createTodo(todoMap);
      log(ref.id);
    }
    setSyncing(false);
    notifyListeners();
  }

  void updateTodo({required String todoId}) async {
    setSharing(false);
    setSyncing(true);
    Todo todo = Todo(
      title: titleController.text,
      description: descriptionController.text,
      lastEditedBy: currentUser,
      timestamp: DateTime.now().toString().substring(0, 19),
      isEditing: true,
    );

    await _myRepo.updateTodo(todoId, todo);
    notifyListeners();
  }

  void getTodoDocumentStream(String todoId) async {
    todoDocumentStream = await _myRepo.getTodoDocumentStream(todoId);
    notifyListeners();
  }

  init(todoId) async {
    getTodoDocumentStream(todoId);
    QuerySnapshot snapshot = await _authService.getAllUsers();
    dropItems = Users.parseUsersList(snapshot.docs).toSet();
  }

  updateTodoEditors({required String todoId, required List<String> users}) {
    _myRepo.shareTodoToUsers(todoId, users);
    notifyListeners();
  }

  Future<void> share(Todo todo, List<Users> data, String todoId) async {
    if (currentUser == todo.createdBy) {
      log(data.toString());
      setSharing(false);
      List<String> users = [];
      List<String> tempUsers = [];
      for (int i = 0; i < data.length; i++) {
        users.add(data[i].email.toString());
        if (!todo.editors!.contains(data[i].email)) {
          tempUsers.add(data[i].email.toString());
        }
      }
      updateTodoEditors(
        todoId: todoId,
        users: users,
      );

      await sendEmail(tempUsers);
    } else {
      Utils.toastMessage("You do not have permission to share this todo.");
    }
  }

  Future<void> sendEmail(List<String> tempUsers) async {
    EmailSender emailSender = EmailSender();
    for (var email in tempUsers) {
      var response = await emailSender.sendMessage(
        email,
        "Todo App",
        "Task : ${titleController.text}",
        "This task is shared by $currentUser",
      );
    }
    if (tempUsers.isNotEmpty) {
      Utils.toastMessage("Task Shared To : $tempUsers");
    }
  }
}
