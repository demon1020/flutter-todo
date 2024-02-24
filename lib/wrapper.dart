import 'features/auth/model/users.dart';
import '/core.dart';
import 'features/todo/view/todo_view.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Users?>(context);
    if (user != null) {
      return TodoView();
    } else {
      return AuthView();
    }
  }
}