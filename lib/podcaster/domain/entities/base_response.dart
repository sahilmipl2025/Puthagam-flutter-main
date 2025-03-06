class BaseResponse {
  String? message;

  BaseResponse({this.message});

  factory BaseResponse.fromJson(Map<String, dynamic> json) => BaseResponse(
        message: json['message'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'message': message,
      };
}
