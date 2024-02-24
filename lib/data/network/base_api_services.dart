import '/core.dart';
import 'package:dartz/dartz.dart';

abstract class BaseApiServices {

  Future<Either<AppException, Q>> callPostAPI<Q, R>(String apiURL,
      Map<String, String> headers, ComputeCallback<String, R> callback,
      {body, disableTokenValidityCheck = false});

  Future<Either<AppException, Q>> callGetAPI<Q, R>(String apiURL,
      Map<String, String> headers, ComputeCallback<String, R> callback);
}