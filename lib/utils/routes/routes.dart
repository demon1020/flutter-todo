import 'package:todo/features/todo/view/todo_view.dart';

import '/core.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.wrapper:
        return MaterialPageRoute(
            builder: (BuildContext context) => const Wrapper());

      case RoutesName.login:
        return MaterialPageRoute(
            builder: (BuildContext context) => const AuthView());

      case RoutesName.home:
        return MaterialPageRoute(
            builder: (BuildContext context) => const HomeView());

      case RoutesName.todoView:
        return MaterialPageRoute(
            builder: (BuildContext context) => TodoView(todoId: settings.arguments as String,));

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
