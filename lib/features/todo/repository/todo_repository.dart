import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo/core.dart';

import '../../../resources/constants/firestore_constants.dart';
import '../model/todo.dart';

class TodoRepository {
  final AuthRepository _authService = AuthRepository();
  String get currentUser => _authService.getCurrentUser().toString();

  Future<Stream<QuerySnapshot>> getTodosStream() async {
    return FirestoreConstants.todosCollection
        .where(FirestoreConstants.editors, arrayContains: currentUser)
        // .orderBy(FirestoreConstants.LAST_MESSAGE_TIME, descending: true)
        .snapshots();
  }

  Future<Stream<DocumentSnapshot<Object?>>> getTodoDocumentStream(String todoId) async {
    return FirestoreConstants.todosCollection.doc(todoId).snapshots();
  }

  Future<DocumentReference<Object?>> createTodo(Map<String, dynamic> todo) async {
    return await FirestoreConstants.todosCollection.add(todo);
  }

  Future getTodo(String todoId) async {
    return await FirestoreConstants.todosCollection.doc(todoId).get();
  }

  updateTodo(String todoId, Todo todo) async {
    return FirestoreConstants.todosCollection.doc(todoId).update({
      'title': todo.title,
      'description': todo.description,
      'lastEditedBy': todo.lastEditedBy,
      'timestamp': todo.timestamp,
      'isEditing': todo.isEditing,
    });
  }

  shareTodoToUsers (String todoId,List<String> users) async {
    return FirestoreConstants.todosCollection.doc(todoId).update({
      'editors': users,
    });
  }

  Future deleteTodo(String todoId) async {
    return await FirestoreConstants.todosCollection.doc(todoId).delete();
  }
}
