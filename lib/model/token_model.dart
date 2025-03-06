
// To parse this JSON data, do
//
//     final getBookChaptersModel = getBookChaptersModelFromJson(jsonString);

import 'dart:convert';

Autogenerated AutogeneratedModelFromJson(String str) =>
    Autogenerated.fromJson(json.decode(str));

String AutogeneratedModelToJson(Autogenerated data) =>
    json.encode(data.toJson());

// class Autogenerated {
//   Autogenerated({
//     this.data,
//     this.status,
//   });

 class Autogenerated {
  String? userId;
  String? deviceToken;

  Autogenerated({this.userId, this.deviceToken});

  Autogenerated.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    deviceToken = json['deviceToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['deviceToken'] = this.deviceToken;
    return data;
  }
}