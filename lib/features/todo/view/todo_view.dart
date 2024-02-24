import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:todo/utils/datetime_helper.dart';

import '../../../core.dart';
import '../view_model/todo_view_model.dart';

class TodoView extends StatefulWidget {
  final String todoId;

  const TodoView({super.key, required this.todoId});

  @override
  State<TodoView> createState() => _TodoViewState();
}

class _TodoViewState extends State<TodoView> with WidgetsBindingObserver {
  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addObserver(this);
  //   if (widget.todoId.isNotEmpty) {
  //     final provider = Provider.of<TodoViewModel>(context, listen: false);
  //     provider.getTodo(widget.todoId);
  //   }
  // }
  //
  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   if (widget.todoId.isNotEmpty) {
  //
  //   }
  // }
  //
  // @override
  // void deactivate() {
  //   final todoViewModel = Provider.of<TodoViewModel>(context);
  //   todoViewModel.titleController.clear();
  //   todoViewModel.descriptionController.clear();
  //   super.deactivate();
  // }

  @override
  Widget build(BuildContext context) {
    final todoViewModel = Provider.of<TodoViewModel>(context);
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    return widget.todoId.isEmpty ? buildScaffold(todoViewModel) :StreamBuilder<DocumentSnapshot>(
      stream: firestore.collection('todos').doc(widget.todoId).snapshots(),
      builder: (context, snapshot) {
        todoViewModel.titleController.text = snapshot.data?['title'];
        todoViewModel.descriptionController.text = snapshot.data?['description'];
        return buildScaffold(todoViewModel, snapshot);
      }
    );
  }

  Scaffold buildScaffold(TodoViewModel todoViewModel, [AsyncSnapshot<DocumentSnapshot<Object?>>? snapshot]) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.todoId.isEmpty ? 'Create New Task' : 'Update Task'),
          actions: [
            Text(todoViewModel.loading ? 'Syncing' : 'Synced'),
            const SizedBox(
              width: 20,
            ),
          ],
        ),
        body: Container(
          height: 300,
          width: double.infinity,
          margin: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              widget.todoId.isEmpty ? SizedBox.shrink() : FittedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: ShapeDecoration(
                          shape:
                          StadiumBorder(side: BorderSide())),
                      child: Text(
                        'Created by : ${snapshot?.data!['createdBy']}',
                      ),
                    ),
                    SizedBox(width: 10,),
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: ShapeDecoration(
                          shape:
                          StadiumBorder(side: BorderSide(),),),
                      child: snapshot?.data!['isEditing'] ? Text(
                        'Editing : ${snapshot?.data!['lastEditedBy']}',
                      ):Text(
                        'Last edit by : ${snapshot?.data!['lastEditedBy']}',
                      ),
                    ),
                  ],
                ),
              ),

              TextFormField(
                controller: todoViewModel.titleController,
                onChanged: (data) {
                  if(widget.todoId.isNotEmpty){
                    todoViewModel.setLoading(true);
                    todoViewModel.updateTodo(
                      todoId: widget.todoId,
                      todo: Todo(
                        title: todoViewModel.titleController.text,
                        description: todoViewModel.descriptionController.text,
                        lastEditedBy: todoViewModel.myUserName,
                        timestamp: DateTimeHelper.dateTimeStampMin(),
                        isEditing: true,
                      ),
                    );
                    todoViewModel.setLoading(false);
                    todoViewModel.updateTodo(
                      todoId: widget.todoId,
                      todo: Todo(
                        title: todoViewModel.titleController.text,
                        description: todoViewModel.descriptionController.text,
                        lastEditedBy: todoViewModel.myUserName,
                        timestamp: DateTimeHelper.dateTimeStampMin(),
                        isEditing: false,
                      ),
                    );
                  }

                },
                onEditingComplete: () {
                  todoViewModel.setLoading(false);
                },
                decoration: InputDecoration(
                  hintText: 'Title',
                  border: InputBorder.none,
                ),
              ),
              Divider(),
              TextFormField(
                controller: todoViewModel.descriptionController,
                minLines: 1,
                maxLines: 10,
                onChanged: (data) {
                  if(widget.todoId.isNotEmpty){
                    todoViewModel.setLoading(true);
                    todoViewModel.updateTodo(
                      todoId: widget.todoId,
                      todo: Todo(
                        title: todoViewModel.titleController.text,
                        description: todoViewModel.descriptionController.text,
                        lastEditedBy: todoViewModel.myUserName,
                        timestamp: DateTimeHelper.dateTimeStampMin(),
                        isEditing: true,
                      ),
                    );
                    todoViewModel.setLoading(false);
                    todoViewModel.updateTodo(
                      todoId: widget.todoId,
                      todo: Todo(
                        title: todoViewModel.titleController.text,
                        description: todoViewModel.descriptionController.text,
                        lastEditedBy: todoViewModel.myUserName,
                        timestamp: DateTimeHelper.dateTimeStampMin(),
                        isEditing: false,
                      ),
                    );
                  }
                },
                onEditingComplete: () {
                  todoViewModel.setLoading(false);
                },
                decoration: InputDecoration(
                  hintText: 'Description',
                  border: InputBorder.none,
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: widget.todoId.isEmpty
            ? SizedBox(
                height: 60,
                child: ElevatedButton(
                  onPressed: widget.todoId.isEmpty ? todoViewModel.createTodo : () {},
                  child: Text('Create Task'),
                ),
              )
            : SizedBox.shrink(),
      );
  }
}
