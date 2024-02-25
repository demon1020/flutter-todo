import 'package:timeago/timeago.dart' as timeago;

import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/todo.dart';
import '../view_model/todo_view_model.dart';
import '/core.dart';

class TodoView extends StatefulWidget {
  const TodoView({Key? key}) : super(key: key);

  @override
  _TodoViewState createState() => _TodoViewState();
}

class _TodoViewState extends State<TodoView> {
  @override
  void initState() {
    var todoViewModel = Provider.of<TodoViewModel>(context, listen: false);
    todoViewModel.init();
    super.initState();
  }

  String get currentUser => AuthViewModel().getUser().toString();

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final todoViewModel = Provider.of<TodoViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Todo App'),
            Text(
              authViewModel.getUser(),
              style: TextStyle(
                overflow: TextOverflow.ellipsis,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
        actions: [
          InkWell(
            onTap: () {
              authViewModel.logout(context);
              Navigator.pushNamed(context, RoutesName.loginView);
            },
            child: const Center(
              child: Text(
                'Logout',
              ),
            ),
          ),
          const SizedBox(
            width: 20,
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: todoViewModel.todosStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('Task does not exist'));
          }
          snapshot.hasData;
          return snapshot.data!.docs.length == 0
              ? Center(
                  child: Text('No task available. Lets create new tasks'),
                )
              : ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  shrinkWrap: true,
                  padding: EdgeInsets.only(top: 10),
                  itemBuilder: (context, index) {
                    DocumentSnapshot document = snapshot.data!.docs[index];
                    Todo todo = Todo.fromSnapshot(document);
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          arguments: document.id,
                          navigatorKey.currentContext!,
                          RoutesName.editTodoView,
                        );
                      },
                      child: Card(
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: ListTile(
                          leading: IconButton(
                            onPressed: () {},
                            icon: Icon(
                              todo.createdBy == todoViewModel.currentUser
                                  ? Icons.star
                                  : Icons.people_alt_rounded,
                              size: 30,
                            ),
                          ),
                          title: Text(
                            todo.title,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ),
                          ),
                          subtitle: Flexible(
                            child: Text(
                              timeago.format(DateTime.parse(todo.timestamp),
                                  locale: 'en_short'),
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              todoViewModel.deleteTodo(document.id);
                            },
                            icon: Icon(Icons.delete),
                          ),
                        ),
                      ),
                    );
                  },
                );
        },
      ),
      floatingActionButton: SizedBox(
        height: 60,
        child: ElevatedButton(
          onPressed: () async {
            todoViewModel.createTodo();
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(
                Icons.add,
                size: 30,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                'Create New Task',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
