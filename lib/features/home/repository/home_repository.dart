import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../utils/firestore_constants.dart';
import '/core.dart';

class HomeRepository {

  // final BaseApiServices _apiServices = NetworkApiService() ;
  //
  // Future<dynamic> fetchMoviesList() async {
  //   return await _apiServices.callGetAPI(
  //       AppUrl.moviesListEndPoint, {}, Parser.fetchMoviesList,disableTokenValidityCheck: true);
  // }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final AuthRepository _authService = AuthRepository();
  String get myUserName => _authService.getCurrentUser().toString();

  Future<Stream<QuerySnapshot>> getTodosStream() async {
    return FirestoreConstants().TODOS_COLLECTION
        .where('editors', arrayContains: myUserName)
        // .orderBy(FirestoreConstants.LAST_MESSAGE_TIME, descending: true)
        .snapshots();
  }
}