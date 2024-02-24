import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo/utils/helper/datetime_helper.dart';

import '../../../core.dart';
import '../model/todo.dart';
import '../view_model/edit_todo_view_model.dart';

class EditTodoView extends StatefulWidget {
  final String todoId;

  const EditTodoView({super.key, required this.todoId});

  @override
  State<EditTodoView> createState() => _TodoViewState();
}

class _TodoViewState extends State<EditTodoView> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    final editTodoViewModel =
        Provider.of<EditTodoViewModel>(context, listen: false);
    editTodoViewModel.getTodoDocumentStream(widget.todoId);
  }

  @override
  Widget build(BuildContext context) {
    final editTodoViewModel = Provider.of<EditTodoViewModel>(context);

    return StreamBuilder<DocumentSnapshot>(
        stream: editTodoViewModel.todoDocumentStream,
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

          editTodoViewModel.titleController.text = snapshot.data?['title'];
          editTodoViewModel.descriptionController.text =
              snapshot.data?['description'];
          return Scaffold(
            appBar: AppBar(
              title: Text('Edit Task'),
              actions: [
                Text(editTodoViewModel.loading ? 'Syncing' : 'Synced'),
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
                  widget.todoId.isEmpty
                      ? SizedBox.shrink()
                      : FittedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: EdgeInsets.all(5),
                                decoration: ShapeDecoration(
                                    shape: StadiumBorder(side: BorderSide())),
                                child: Text(
                                  'Created by : ${snapshot.data!['createdBy']}',
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                padding: EdgeInsets.all(5),
                                decoration: ShapeDecoration(
                                  shape: StadiumBorder(
                                    side: BorderSide(),
                                  ),
                                ),
                                child: snapshot.data!['isEditing']
                                    ? Text(
                                        'Editing : ${snapshot.data!['lastEditedBy']}',
                                      )
                                    : Text(
                                        'Last edit by : ${snapshot.data!['lastEditedBy']}',
                                      ),
                              ),
                            ],
                          ),
                        ),
                  TextFormField(
                    controller: editTodoViewModel.titleController,
                    onChanged: (data) {
                      if (widget.todoId.isNotEmpty) {
                        editTodoViewModel.setLoading(true);
                        editTodoViewModel.updateTodo(
                          todoId: widget.todoId,
                          todo: Todo(
                            title: editTodoViewModel.titleController.text,
                            description:
                                editTodoViewModel.descriptionController.text,
                            lastEditedBy: editTodoViewModel.myUserName,
                            timestamp: DateTimeHelper.dateTimeStamp(),
                            isEditing: true,
                          ),
                        );
                        editTodoViewModel.setLoading(false);
                        editTodoViewModel.updateTodo(
                          todoId: widget.todoId,
                          todo: Todo(
                            title: editTodoViewModel.titleController.text,
                            description:
                                editTodoViewModel.descriptionController.text,
                            lastEditedBy: editTodoViewModel.myUserName,
                            timestamp: DateTimeHelper.dateTimeStamp(),
                            isEditing: false,
                          ),
                        );
                      }
                    },
                    onEditingComplete: () {
                      editTodoViewModel.setLoading(false);
                    },
                    decoration: InputDecoration(
                      hintText: 'Title',
                      border: InputBorder.none,
                    ),
                  ),
                  Divider(),
                  TextFormField(
                    controller: editTodoViewModel.descriptionController,
                    minLines: 1,
                    maxLines: 10,
                    onChanged: (data) {
                      if (widget.todoId.isNotEmpty) {
                        editTodoViewModel.setLoading(true);
                        editTodoViewModel.updateTodo(
                          todoId: widget.todoId,
                          todo: Todo(
                            title: editTodoViewModel.titleController.text,
                            description:
                                editTodoViewModel.descriptionController.text,
                            lastEditedBy: editTodoViewModel.myUserName,
                            timestamp: DateTimeHelper.dateTimeStamp(),
                            isEditing: true,
                          ),
                        );
                        editTodoViewModel.setLoading(false);
                        editTodoViewModel.updateTodo(
                          todoId: widget.todoId,
                          todo: Todo(
                            title: editTodoViewModel.titleController.text,
                            description:
                                editTodoViewModel.descriptionController.text,
                            lastEditedBy: editTodoViewModel.myUserName,
                            timestamp: DateTimeHelper.dateTimeStamp(),
                            isEditing: false,
                          ),
                        );
                      }
                    },
                    onEditingComplete: () {
                      editTodoViewModel.setLoading(false);
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
                      onPressed: widget.todoId.isEmpty
                          ? editTodoViewModel.createTodo
                          : () {},
                      child: Text('Create Task'),
                    ),
                  )
                : SizedBox.shrink(),
          );
        });
  }
}
