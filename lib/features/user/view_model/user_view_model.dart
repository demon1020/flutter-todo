import '/core.dart';

class UserViewModel with ChangeNotifier{

  Future<bool> saveUser(UserModel user)async{

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', user.token.toString());
    notifyListeners();
    return true ;
  }

  Future<UserModel> getUser()async{

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    return UserModel(
      token: token.toString()
    );
  }

  Future<bool> remove()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    return true;
  }

  void checkAuthentication()async{

    getUser().then((value)async{

      if (kDebugMode) {
        print(value.token.toString());
      }

      if(value.token.toString() == 'null' || value.token.toString() == ''){
        Navigator.pushNamed(navigatorKey.currentContext!, RoutesName.login);
      }else {
        Navigator.pushNamed(navigatorKey.currentContext!, RoutesName.home);
      }

    }).onError((error, stackTrace){
      Navigator.pushNamed(navigatorKey.currentContext!, RoutesName.login);
      if(kDebugMode){
        print(error.toString());
      }
    });

  }
}