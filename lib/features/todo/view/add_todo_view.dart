import '../../../core.dart';
import '../view_model/add_todo_view_model.dart';

class AddTodoView extends StatefulWidget {
  const AddTodoView({super.key});

  @override
  State<AddTodoView> createState() => _AddTodoViewState();
}

class _AddTodoViewState extends State<AddTodoView> with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    final addTodoViewModel = Provider.of<AddTodoViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Create New Task'),
      ),
      body: Container(
        height: 300,
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormField(
              controller: addTodoViewModel.titleController,
              decoration: InputDecoration(
                hintText: 'Title',
                border: InputBorder.none,
              ),
            ),
            Divider(),
            TextFormField(
              controller: addTodoViewModel.descriptionController,
              minLines: 1,
              maxLines: 10,
              decoration: InputDecoration(
                hintText: 'Description',
                border: InputBorder.none,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 60,
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: ElevatedButton(
          onPressed: ()=> addTodoViewModel.createTodo(),
          child: Text(
            'Create Task',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}
