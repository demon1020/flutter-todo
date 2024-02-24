import 'package:cloud_firestore/cloud_firestore.dart';

import '/core.dart';

class HomeViewViewModel with ChangeNotifier {
  Stream<QuerySnapshot>? todosStream;
  String myUserName = '';

  final _myRepo = HomeRepository();
  //
  // ApiResponse<MovieListModel> moviesList = ApiResponse.loading();
  //
  // setMoviesList(ApiResponse<MovieListModel> response) {
  //   moviesList = response;
  // }

  // Future<void> fetchMoviesListApi() async {
  //   setMoviesList(ApiResponse.loading());
  //
  //   var response = await _myRepo.fetchMoviesList();
  //
  //   response
  //       .fold((failure) => setMoviesList(ApiResponse.error(failure.message)),
  //           (data) async {
  //     setMoviesList(ApiResponse.completed(data));
  //   });
  //   notifyListeners();
  // }

  init() async {
    getUserName();
    getTodos();
  }

  getUserName()async{
    myUserName = await AuthRepository().getCurrentUser().toString();
    notifyListeners();
  }

  void getTodos() async {
    todosStream = await _myRepo.getTodosStream();
    notifyListeners();
  }
}
