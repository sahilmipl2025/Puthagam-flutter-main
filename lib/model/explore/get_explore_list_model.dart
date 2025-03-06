// To parse this JSON data, do
//
//     final getExploreListModel = getExploreListModelFromJson(jsonString);

import 'dart:convert';

import 'package:puthagam/model/category_books/get_category_books_model.dart';

GetExploreListModel getExploreListModelFromJson(String str) =>
    GetExploreListModel.fromJson(json.decode(str));

String getExploreListModelToJson(GetExploreListModel data) =>
    json.encode(data.toJson());

class GetExploreListModel {
  GetExploreListModel({
    this.data,
    this.status,
  });

  List<CategoryBooks>? data;
  Status? status;

  factory GetExploreListModel.fromJson(Map<String, dynamic> json) =>
      GetExploreListModel(
        data: List<CategoryBooks>.from(
            json["data"].map((x) => CategoryBooks.fromJson(x))),
        status: Status.fromJson(json["status"]),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
        "status": status!.toJson(),
      };
}

class Status {
  Status({
    this.status,
    this.message,
    this.totalRecords,
  });

  String? status;
  String? message;
  int? totalRecords;

  factory Status.fromJson(Map<String, dynamic> json) => Status(
        status: json["status"],
        message: json["message"],
        totalRecords: json["totalRecords"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "totalRecords": totalRecords,
      };
}
