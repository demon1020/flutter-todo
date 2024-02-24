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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (widget.todoId.isNotEmpty) {
      final provider = Provider.of<TodoViewModel>(context, listen: false);
      provider.getTodo(widget.todoId);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.todoId.isNotEmpty) {

    }
  }

  getTime() {
    DateTime date = DateTime.now();
    String time = DateFormat.jm().format(date);
    return time;
  }

  @override
  void deactivate() {
    final todoViewModel = Provider.of<TodoViewModel>(context);
    todoViewModel.titleController.clear();
    todoViewModel.descriptionController.clear();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    final todoViewModel = Provider.of<TodoViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.todoId.isEmpty ? 'Create New Task' : 'Update Task'),
        actions: [
          Text(todoViewModel.loading ? 'Syncing' : 'Synced'),
          const SizedBox(
            width: 20,
          )
        ],
      ),
      body: Container(
        height: 300,
        width: double.infinity,
        margin: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormField(
              controller: todoViewModel.titleController,
              onChanged: (data) {
                todoViewModel.setLoading(true);
                todoViewModel.updateTodo(
                  todoId: widget.todoId,
                  todo: Todo(
                    title: todoViewModel.titleController.text,
                    description: todoViewModel.descriptionController.text,
                    lastEditedBy: todoViewModel.myUserName,
                    timestamp: DateTimeHelper.dateTimeStampMin(),
                  ),
                );
                todoViewModel.setLoading(false);

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
              onChanged: (data) {
                todoViewModel.setLoading(true);
                todoViewModel.setLoading(true);
                todoViewModel.updateTodo(
                  todoId: widget.todoId,
                  todo: Todo(
                    title: todoViewModel.titleController.text,
                    description: todoViewModel.descriptionController.text,
                    lastEditedBy: todoViewModel.myUserName,
                    timestamp: DateTimeHelper.dateTimeStampMin(),
                  ),
                );
                todoViewModel.setLoading(false);
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
