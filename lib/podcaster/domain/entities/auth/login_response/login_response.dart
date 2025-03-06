import 'data.dart';
import 'status.dart';

class LoginResponse {
  Data? data;
  Status? status;

  LoginResponse({this.data, this.status});

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        data: json['data'] == null
            ? null
            : Data.fromJson(json['data'] as Map<String, dynamic>),
        status: json['status'] == null
            ? null
            : Status.fromJson(json['status'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'data': data?.toJson(),
        'status': status?.toJson(),
      };
}
