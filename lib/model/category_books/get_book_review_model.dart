// To parse this JSON data, do
//
//     final getBookReviewModelFromJson = getBookReviewModelFromJsonFromJson(jsonString);

import 'dart:convert';

GetBookReviewModel getBookReviewModelFromJson(String str) =>
    GetBookReviewModel.fromJson(json.decode(str));

String getBookReviewModelToJson(GetBookReviewModel data) =>
    json.encode(data.toJson());

class GetBookReviewModel {
  GetBookReviewModel({
    this.data,
    this.status,
  });

  List<BookReview>? data;
  Status? status;

  factory GetBookReviewModel.fromJson(Map<String, dynamic> json) =>
      GetBookReviewModel(
        data: List<BookReview>.from(
            json["data"].map((x) => BookReview.fromJson(x))),
        status: Status.fromJson(json["status"]),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
        "status": status!.toJson(),
      };
}

class BookReview {
  BookReview({
    this.id,
    this.userId,
    this.userName,
    this.userImage,
    this.bookId,
    this.title,
    this.bookImage,
    this.comment,
    this.rating,
    this.createdDate,
    this.modifiedDate,
    this.createdBy,
    this.createdByName,
    this.modifiedBy,
    this.isActive,
    this.isDeleted,
  });

  String? id;
  String? userId;
  String? userName;
  String? userImage;
  String? bookId;
  String? title;
  String? bookImage;
  String? comment;
  int? rating;
  DateTime? createdDate;
  DateTime? modifiedDate;
  String? createdBy;
  String? createdByName;
  String? modifiedBy;
  bool? isActive;
  bool? isDeleted;

  factory BookReview.fromJson(Map<String, dynamic> json) => BookReview(
        id: json["_id"],
        userId: json["userId"],
        userName: json["userName"],
        userImage: json["userImage"],
        bookId: json["bookId"],
        title: json["title"],
        bookImage: json["bookImage"],
        comment: json["comment"],
        rating: json["rating"],
        createdDate: DateTime.parse(json["createdDate"]),
        modifiedDate: DateTime.parse(json["modifiedDate"]),
        createdBy: json["createdBy"],
        createdByName: json["createdByName"],
        modifiedBy: json["modifiedBy"],
        isActive: json["isActive"],
        isDeleted: json["isDeleted"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "userId": userId,
        "userName": userName,
        "userImage": userImage,
        "bookId": bookId,
        "title": title,
        "bookImage": bookImage,
        "comment": comment,
        "rating": rating,
        "createdDate": createdDate!.toIso8601String(),
        "modifiedDate": modifiedDate!.toIso8601String(),
        "createdBy": createdBy,
        "createdByName": createdByName,
        "modifiedBy": modifiedBy,
        "isActive": isActive,
        "isDeleted": isDeleted,
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
