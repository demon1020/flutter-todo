import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';

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
    editTodoViewModel.updateTodo(todoId: widget.todoId);
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
            Text(editTodoViewModel.isSyncing ? 'Syncing' : 'Synced'),
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
                return Center(child: Text('Task does not exist'));
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
                        !editTodoViewModel.isSharing
                            ? Container(
                                padding: EdgeInsets.all(10),
                                decoration: ShapeDecoration(
                                  shape: StadiumBorder(
                                    side: todo.isEditing
                                        ? BorderSide(color: Colors.blue)
                                        : BorderSide(),
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
                                editTodoViewModel.currentUser == todo.createdBy
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
                              items: editTodoViewModel.dropItems.toList(),
                              dropdownButtonProps: DropdownButtonProps(
                                icon: Icon(
                                  Icons.person_add,
                                ),
                              ),
                              popupProps: PopupPropsMultiSelection.menu(
                                showSearchBox: true,
                              ),
                              onChanged: (data) async {
                                await editTodoViewModel.share(
                                    todo, data, widget.todoId);
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
                        editTodoViewModel.updateTodo(todoId: widget.todoId);
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
                        editTodoViewModel.updateTodo(todoId: widget.todoId);
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
}
