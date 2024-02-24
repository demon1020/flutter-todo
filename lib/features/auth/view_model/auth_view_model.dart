import 'dart:developer';

import '/core.dart';

class AuthViewModel with ChangeNotifier {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  final _myRepo = AuthRepository();

  bool loading = false;

  setLoading(isLoading){
    loading = isLoading;
    notifyListeners();
  }

  String getUser(){
    return _myRepo.getCurrentUser();
  }

  Future<void> signInWithEmailPassword({required String email, password}) async {
    setLoading(true);

    var response = await _myRepo.signIn(email: email, password: password);

    if(response == null){
      Utils.flushBarErrorMessage("Failed to sign in\nPlease check your credentials");
      setLoading(false);
      return;
    }

    final userPreference = Provider.of<UserViewModel>(
        navigatorKey.currentContext!,
        listen: false);

    userPreference.saveUser(UserModel(token: response.uid));
    Utils.snackBar('Login Successfully');
    Navigator.pushNamed(navigatorKey.currentContext!, RoutesName.home);
    setLoading(false);
    notifyListeners();
  }

  // Future<void> loginApi(dynamic data) async {
  //   setLoading(true);
  //
  //   var response = await _myRepo.login(data);
  //
  //   response.fold((failure) => Utils.flushBarErrorMessage(failure.message),
  //       (loginResponse) async {
  //     final userPreference = Provider.of<UserViewModel>(
  //         navigatorKey.currentContext!,
  //         listen: false);
  //     userPreference.saveUser(loginResponse);
  //
  //     Utils.snackBar('Login Successfully');
  //     Navigator.pushNamed(navigatorKey.currentContext!, RoutesName.home);
  //   });
  //   setLoading(false);
  //   notifyListeners();
  // }

  void disposeData(){
    emailController.dispose();
    passwordController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
  }

  void logout(BuildContext context) async{
    await _myRepo.signOut(context);
    notifyListeners();
  }
}
