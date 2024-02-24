import '/core.dart';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

Duration apiTimeOut = Duration(seconds: 300);

class NetworkApiService extends BaseApiServices {

  @override
  Future<Either<AppException, Q>> callGetAPI<Q, R>(String apiURL,
      Map<String, String> headers, ComputeCallback<String, R> callback, {disableTokenValidityCheck = false}) async {
    try {
      print('apiURL : $apiURL');
      print('headers : ${jsonEncode(headers)}');
      http.Response response = await http
          .get(Uri.parse(apiURL), headers: headers)
          .timeout(apiTimeOut);
      if(response != null){
        return Parser.parseResponse(response, callback);
      }
      return Left(UnknownError());
    } on SocketException {
      return Left(NoInternetError());
    } on TimeoutException {
      return Left(TimeoutError());
    } on HandshakeException {
      return Left(HandshakeError());
    }
  }

  @override
  Future<Either<AppException, Q>> callPostAPI<Q, R>(String apiURL,
      Map<String, String> headers, ComputeCallback<String, R> callback,
      {body, disableTokenValidityCheck = false}) async {
    try {
      print('apiURL : $apiURL');
      print('headers : ${jsonEncode(headers)}');
      print('body : ${jsonEncode(body)}');
      http.Response response = await http
          .post(Uri.parse(apiURL), body: body)
          .timeout(apiTimeOut);
      if (response != null) {
        return Parser.parseResponse(response, callback);
      }
      return Left(UnknownError());
    } on SocketException {
      return Left(NoInternetError());
    } on TimeoutException {
      return Left(TimeoutError());
    } on HandshakeException {
      return Left(HandshakeError());
    }
  }
}
