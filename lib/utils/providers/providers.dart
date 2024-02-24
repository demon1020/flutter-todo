import '../../features/auth/model/users.dart';
import '../../features/todo/view_model/todo_view_model.dart';
import '/core.dart';

class Providers {
  static List<SingleChildWidget> getAllProviders() {
    List<SingleChildWidget> _providers = [
      StreamProvider<Users?>.value(
        value: AuthRepository().user,
        initialData: null,
      ),
      ChangeNotifierProvider(create: (context) => AuthViewModel()),
      ChangeNotifierProvider(create: (context) => UserViewModel()),
      ChangeNotifierProvider(create: (context) => HomeViewViewModel()),
      ChangeNotifierProvider(create: (context) => TodoViewModel()),
    ];
    return _providers;
  }
}
