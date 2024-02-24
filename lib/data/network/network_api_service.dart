import 'dart:developer';

import '/core.dart';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

Duration apiTimeOut = Duration(seconds: 300);

class NetworkApiService extends BaseApiServices {

  @override
  Future<Either<AppException, Q>> callGetAPI<Q, R>(String apiURL,
      Map<String, String> headers, ComputeCallback<String, R> callback) async {
    try {
      log('apiURL : $apiURL');
      log('headers : ${jsonEncode(headers)}');
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
      log('apiURL : $apiURL');
      log('headers : ${jsonEncode(headers)}');
      log('body : ${jsonEncode(body)}');
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
