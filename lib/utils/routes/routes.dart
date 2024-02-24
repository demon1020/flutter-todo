import 'package:todo/features/todo/view/add_todo_view.dart';
import '../../features/todo/view/edit_todo_view.dart';
import '../../features/todo/view/todo_view.dart';
import '../../wrapper.dart';
import '/core.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.wrapperView:
        return MaterialPageRoute(
          builder: (BuildContext context) => const Wrapper(),
        );

      case RoutesName.loginView:
        return MaterialPageRoute(
          builder: (BuildContext context) => const AuthView(),
        );

      case RoutesName.todoView:
        return MaterialPageRoute(
          builder: (BuildContext context) => const TodoView(),
        );

      case RoutesName.addTodoView:
        return MaterialPageRoute(
          builder: (BuildContext context) => AddTodoView(),
        );

      case RoutesName.editTodoView:
        return MaterialPageRoute(
          builder: (BuildContext context) => EditTodoView(
            todoId: settings.arguments as String,
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (_) {
            return const Scaffold(
              body: Center(
                child: Text('No route defined'),
              ),
            );
          },
        );
    }
  }
}
