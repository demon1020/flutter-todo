import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo/features/todo/repository/todo_repository.dart';

import '../model/todo.dart';
import '/core.dart';

class TodoViewModel with ChangeNotifier {
  Stream<QuerySnapshot>? todosStream;
  String currentUser = '';

  final _myRepo = TodoRepository();

  init() async {
    getCurrentUser();
    getTodos();
  }

  void getCurrentUser()async{
    currentUser = AuthRepository().getCurrentUser().toString();
  }

  void getTodos() async {
    todosStream = await _myRepo.getTodosStream();
  }

  void deleteTodo(String todoId) async {
    await _myRepo.deleteTodo(todoId);
    notifyListeners();
  }

  void createTodo() async{
    Todo todo = Todo(
      title: "",
      description: "",
      createdBy: currentUser,
      lastEditedBy: currentUser,
      timestamp: DateTime.now().toString().substring(0,19),
      priority: ['low'],
      editors: [currentUser],
      status: false,
      isEditing: true,
    );

    Map<String, dynamic> todoMap = todo.toMap();
    DocumentReference ref = await _myRepo.createTodo(todoMap);
    notifyListeners();

    Navigator.pushNamed(
      arguments: ref.id,
      navigatorKey.currentContext!,
      RoutesName.editTodoView,
    );
  }
}
