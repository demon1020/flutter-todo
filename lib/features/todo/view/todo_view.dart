import 'package:cloud_firestore/cloud_firestore.dart';
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
    var chatProvider = Provider.of<TodoViewModel>(context, listen: false);
    chatProvider.init();
    super.initState();
  }

  String get myUserName => AuthViewModel().getUser().toString();

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final provider = Provider.of<TodoViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Todo [${authViewModel.getUser()}]'),
        automaticallyImplyLeading: false,
        actions: [
          InkWell(
              onTap: () {
                authViewModel.logout(context);
                Navigator.pushNamed(context, RoutesName.loginView);
              },
              child: const Center(child: Text('Logout'))),
          const SizedBox(
            width: 20,
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: provider.todosStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('Document does not exist'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            shrinkWrap: true,
            padding: EdgeInsets.only(top: 16),
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              DocumentSnapshot document = snapshot.data!.docs[index];
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    arguments: document.id,
                    navigatorKey.currentContext!,
                    RoutesName.editTodoView,
                  );
                },
                child: SizedBox(
                  height: 120,
                  child: Card(
                    child: Column(
                      children: [
                        ListTile(
                          leading: IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.info,
                                size: 30,
                              )),
                          title: Text('${document['title']}'),
                          subtitle: Flexible(
                            child: Text(
                              '${document['description']}',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(overflow: TextOverflow.ellipsis),
                            ),
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              provider.deleteTodo(document.id);
                            },
                            icon: Icon(Icons.delete),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          child: Text(
                            document['timestamp'],
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
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
          onPressed: () {
            Navigator.pushNamed(
              navigatorKey.currentContext!,
              RoutesName.addTodoView,
            );
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
