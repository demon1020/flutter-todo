import '/core.dart';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

class ApiResponse<T> {
  Status? status;

  T? data;

  String? message;

  ApiResponse(this.status, this.data, this.message);

  ApiResponse.loading() : status = Status.loading;

  ApiResponse.completed(this.data) : status = Status.completed;

  ApiResponse.error(this.message) : status = Status.error;

  @override
  String toString() {
    return "Status : $status \n Message : $message \n Data: $data";
  }
}

class Parser {
  static Future<UserModel> parseLogInResponse(String responseBody) async {
    return UserModel.fromJson(json.decode(responseBody));
  }

  static Future<MovieListModel> fetchMoviesList(String responseBody) async {
    return MovieListModel.fromJson(json.decode(responseBody));
  }

  static Future<Either<AppException, Q>> parseResponse<Q, R>(
      http.Response response, ComputeCallback<String, R> callback) async {
    if (response == null) {
      print('response is null ');
      return Left(UnknownError());
    } else {
      // log('callback : ${callback.toString()}response.statusCode : ${response.statusCode} | response.body ${response.body}');
      try {
        switch (response.statusCode) {
          case 200:
            {
              final Map<String, dynamic> body = json.decode(response.body);
              // if (body.containsKey("code")) {
              // BaseResponse baseResponse = BaseResponse.fromJson(body);
              // if (baseResponse.code != 0) {
              //   if (baseResponse.refreshTokenExpired) {
              //     return Left(SessionExpiry(message: baseResponse.message));
              //   } else if (baseResponse.userResigned) {
              //     return Left(UserResigned(message: baseResponse.message));
              //   }
              //   return Left(ServerValidation(message: baseResponse.message));
              // } else {
              //   var result = await compute(callback, response.body);
              //   return Right(result as Q);
              // }
              // } else {
              //   return Left(InvalidResponse());
              // }
              var result = await compute(callback, response.body);
              return Right(result as Q);
            }
          // break;
          case 401:
            return Left(ForbiddenError());
            break;
          case 403:
            return Left(UnAuthorizedError());
            break;
          case 404:
            return Left(ServerError(
                statusCode: response.statusCode, message: "File not found"));
            break;
          case 500:
            return Left(ServerError(
                statusCode: response.statusCode, message: "Server Failure"));
            break;
          default:
            return Left(UnknownError(
                statusCode: response.statusCode, message: response.body));
        }
      } catch (e) {
        return Left(UnknownError());
      }
    }
  }
}
