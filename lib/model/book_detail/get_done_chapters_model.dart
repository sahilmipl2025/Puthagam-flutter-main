// To parse this JSON data, do
//
//     final getDoneChaptersModel = getDoneChaptersModelFromJson(jsonString);

import 'dart:convert';

GetDoneChaptersModel getDoneChaptersModelFromJson(String str) =>
    GetDoneChaptersModel.fromJson(json.decode(str));

String getDoneChaptersModelToJson(GetDoneChaptersModel data) =>
    json.encode(data.toJson());

class GetDoneChaptersModel {
  GetDoneChaptersModel({
    this.data,
    this.status,
  });

  List<Chapter>? data;
  Status? status;

  factory GetDoneChaptersModel.fromJson(Map<String, dynamic> json) =>
      GetDoneChaptersModel(
        data: List<Chapter>.from(json["data"].map((x) => Chapter.fromJson(x))),
        status: Status.fromJson(json["status"]),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
        "status": status!.toJson(),
      };
}

class Chapter {
  Chapter({
    this.userId,
    this.bookId,
    this.chapterId,
  });

  String? userId;
  String? bookId;
  String? chapterId;

  factory Chapter.fromJson(Map<String, dynamic> json) => Chapter(
        userId: json["userId"],
        bookId: json["bookId"],
        chapterId: json["chapterId"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "bookId": bookId,
        "chapterId": chapterId,
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
