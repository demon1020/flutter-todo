import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:email_sender/email_sender.dart';

import '../../../core.dart';
import '../../auth/model/users.dart';
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
    editTodoViewModel.init(widget.todoId);
  }

  @override
  void deactivate() {
    final editTodoViewModel =
        Provider.of<EditTodoViewModel>(context, listen: false);
    editTodoViewModel.setLoading(false);
    editTodoViewModel.updateTodo(
      todoId: widget.todoId,
      todo: Todo(
        title: editTodoViewModel.titleController.text,
        description: editTodoViewModel.descriptionController.text,
        lastEditedBy: editTodoViewModel.myUserName,
        timestamp: DateTime.now().toString().substring(0,19),
        isEditing: false,
      ),
    );
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    final editTodoViewModel = Provider.of<EditTodoViewModel>(context);
    return WillPopScope(
      onWillPop: () async {
        editTodoViewModel.setSharing(false);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Edit Task'),
          actions: [
            const SizedBox(
              width: 20,
            ),
            Text(editTodoViewModel.loading ? 'Syncing' : 'Synced'),
            const SizedBox(
              width: 20,
            ),
          ],
        ),
        body: StreamBuilder<DocumentSnapshot>(
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

              final DocumentSnapshot document = snapshot.data!;
              final Todo todo = Todo.fromSnapshot(document);

              editTodoViewModel.titleController.text = todo.title;
              editTodoViewModel.descriptionController.text = todo.description;

              return Container(
                height: 300,
                width: double.infinity,
                margin: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Container(
                        //   padding: EdgeInsets.all(5),
                        //   decoration: ShapeDecoration(
                        //       shape: StadiumBorder(side: BorderSide())),
                        //   child: Text(
                        //     'Created by : ${todo.createdBy}',
                        //   ),
                        // ),
                        // SizedBox(
                        //   width: 10,
                        // ),
                        !editTodoViewModel.isSharing
                            ? Container(
                                padding: EdgeInsets.all(10),
                                decoration: ShapeDecoration(
                                  shape: StadiumBorder(
                                    side: BorderSide(),
                                  ),
                                ),
                                child: todo.isEditing
                                    ? Text(
                                        'Editing : ${todo.lastEditedBy}',
                                      )
                                    : Text(
                                        'Last edit by : ${todo.lastEditedBy}',
                                      ),
                              )
                            : SizedBox.shrink(),

                        Visibility(
                          visible: editTodoViewModel.isSharing,
                          replacement: OutlinedButton(
                            onPressed:
                                editTodoViewModel.myUserName == todo.createdBy
                                    ? () => editTodoViewModel.setSharing(true)
                                    : () {
                                        Utils.toastMessage(
                                            "You do not have permission to share this todo.");
                                      },
                            child: Icon(
                              Icons.person_add,
                            ),
                          ),
                          child: Expanded(
                            child: DropdownSearch<Users>.multiSelection(
                              items: editTodoViewModel.dropItems,
                              dropdownButtonProps: DropdownButtonProps(
                                icon: Icon(
                                  Icons.person_add,
                                ),
                              ),
                              popupProps: PopupPropsMultiSelection.menu(
                                showSearchBox: true,
                              ),
                              onChanged: (data) async {
                                if (editTodoViewModel.myUserName ==
                                    todo.createdBy) {
                                  log(data.toString());
                                  editTodoViewModel.setSharing(false);
                                  List<String> users = [];
                                  List<String> tempUsers = [];
                                  for (int i = 0; i < data.length; i++) {
                                    users.add(data[i].email.toString());
                                    if (!todo.editors!
                                        .contains(data[i].email)) {
                                      tempUsers.add(data[i].email.toString());
                                    }
                                  }
                                  editTodoViewModel.shareToPeople(
                                    todoId: widget.todoId,
                                    users: users,
                                  );

                                  EmailSender emailSender = EmailSender();
                                  for (var email in tempUsers) {
                                    var response =
                                        await emailSender.sendMessage(
                                      email,
                                      "Todo App",
                                      "Task : ${editTodoViewModel.titleController.text}",
                                      "This task is shared by ${editTodoViewModel.myUserName}",
                                    );
                                    log(response);
                                  }
                                  Utils.toastMessage(
                                      "Task Shared To : $tempUsers");
                                } else {
                                  Utils.toastMessage(
                                      "You do not have permission to share this todo.");
                                }
                              },
                              itemAsString: (Users u) => u.email.toString(),
                              selectedItems: editTodoViewModel.dropItems
                                  .where((element) =>
                                      todo.editors!.contains(element.email))
                                  .toList(),
                            ),
                          ),
                        )
                      ],
                    ),
                    TextFormField(
                      controller: editTodoViewModel.titleController,
                      minLines: 1,
                      maxLines: 2,
                      onChanged: (data) {
                        editTodoViewModel.setSharing(false);
                        editTodoViewModel.setLoading(todo.isEditing);
                        editTodoViewModel.updateTodo(
                          todoId: widget.todoId,
                          todo: Todo(
                            title: data,
                            description:
                                editTodoViewModel.descriptionController.text,
                            lastEditedBy: editTodoViewModel.myUserName,
                            timestamp: DateTime.now().toString().substring(0,19),
                            isEditing: true,
                          ),
                        );
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
                        editTodoViewModel.setSharing(false);
                        editTodoViewModel.setLoading(todo.isEditing);
                        editTodoViewModel.updateTodo(
                          todoId: widget.todoId,
                          todo: Todo(
                            title: editTodoViewModel.titleController.text,
                            description: data,
                            lastEditedBy: editTodoViewModel.myUserName,
                            timestamp: DateTime.now().toString().substring(0,19),
                            isEditing: true,
                          ),
                        );
                      },
                      decoration: InputDecoration(
                        hintText: 'Description',
                        border: InputBorder.none,
                      ),
                    ),
                  ],
                ),
              );
            }),
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
      ),
    );
  }

  getData(String filter) {}
}
