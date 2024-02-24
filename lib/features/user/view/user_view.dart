import '../../auth/model/users.dart';
import '/core.dart';

// class UserView extends StatefulWidget {
//   const UserView({Key? key}) : super(key: key);
//
//   @override
//   State<UserView> createState() => _UserViewState();
// }
//
// class _UserViewState extends State<UserView> {
//   @override
//   void initState() {
//     super.initState();
//     var userViewModel = Provider.of<UserViewModel>(context, listen: false);
//     userViewModel.checkAuthentication();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       body: CircularProgressIndicator(),
//     );
//   }
// }

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Users?>(context);
    if (user != null) {
      return HomeView();
    } else {
      return AuthView();
    }
  }
}