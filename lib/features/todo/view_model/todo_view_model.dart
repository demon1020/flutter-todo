import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo/features/todo/repository/todo_repository.dart';

import '/core.dart';

class TodoViewModel with ChangeNotifier {
  Stream<QuerySnapshot>? todosStream;
  String myUserName = '';

  final _myRepo = TodoRepository();

  init() async {
    getUserName();
    getTodos();
  }

  getUserName()async{
    myUserName = await AuthRepository().getCurrentUser().toString();
    notifyListeners();
  }

  void getTodos() async {
    todosStream = await _myRepo.getTodosStream();
    notifyListeners();
  }
  void deleteTodo(String todoId) async {
    await _myRepo.deleteTodo(todoId);
    notifyListeners();
  }
}
