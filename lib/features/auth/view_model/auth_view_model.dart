import '/core.dart';

class AuthViewModel with ChangeNotifier {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  bool loading = false;
  bool isSignIn = true;
  final _myRepo = AuthRepository();

  toggleSignIn(){
    isSignIn = !isSignIn;
    notifyListeners();
  }

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
      Utils.flushBarErrorMessage("User does not exists\nPlease check your credentials");
      setLoading(false);
      return;
    }

    Utils.snackBar('Login Successfully');
    Navigator.pushNamed(navigatorKey.currentContext!, RoutesName.todoView);
    setLoading(false);
    notifyListeners();
  }

  Future<void> signUpWithEmailPassword({required String email, password}) async {
    setLoading(true);
    var result = await _myRepo.signIn(email: email, password: password);
    if(result == null){
      var response = await _myRepo.signUp(email: email, password: password);

      if(response == null){
        Utils.flushBarErrorMessage("Failed to sign Up\nPlease check your credentials");
        setLoading(false);
        return;
      }

      Utils.snackBar('Account created and Login Successfully');
      Navigator.pushNamed(navigatorKey.currentContext!, RoutesName.todoView);
      setLoading(false);
      notifyListeners();
    }else{
      Utils.snackBar('User Exists and Login Successfully');
      Navigator.pushNamed(navigatorKey.currentContext!, RoutesName.todoView);
      setLoading(false);
      notifyListeners();
    }

  }

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
