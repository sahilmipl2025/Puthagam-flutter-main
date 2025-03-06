class LoginParams {
  String? email;
  String? password;

  LoginParams({this.email, this.password});

  factory LoginParams.fromJson(Map<String, dynamic> json) => LoginParams(
        email: json['email'] as String?,
        password: json['password'] as String?,
      );

  Map<String, dynamic> toJson() => {
        "emailOrPhone": "manoj@yopmail.com",
        "authKey": "ac786f8f-f4cd-4c3e-8962-694910c65700",
      };
}
