class BaseResponse {
  String message;
  int code;
  String token;

  BaseResponse({required this.message, required this.code, required this.token});

  factory BaseResponse.fromJson(Map<String, dynamic> parsedJson) {
    return BaseResponse(
        message: parsedJson.containsKey("message") ? parsedJson['message'] : "",
        code: parsedJson.containsKey("code") ? parsedJson['code'] : 0,
        token: parsedJson.containsKey("token") ? parsedJson['token'] : "",
    );
  }

  bool get accessTokenExpired => code == 498 ? true : false;
  bool get refreshTokenExpired => code == 698 ? true : false;
  bool get userResigned => code == 401 ? true : false;
}
