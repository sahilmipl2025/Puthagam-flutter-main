// To parse this JSON data, do
//
//     final getCollectionModel = getCollectionModelFromJson(jsonString);

import 'dart:convert';

import 'package:get/get.dart';

GetCollectionModel getCollectionModelFromJson(String str) =>
    GetCollectionModel.fromJson(json.decode(str));

String getCollectionModelToJson(GetCollectionModel data) =>
    json.encode(data.toJson());

class GetCollectionModel {
  GetCollectionModel({
    this.data,
    this.status,
  });

  List<CollectionModel>? data;
  Status? status;

  factory GetCollectionModel.fromJson(Map<String, dynamic> json) =>
      GetCollectionModel(
        data: List<CollectionModel>.from(
            json["data"].map((x) => CollectionModel.fromJson(x))),
        status: Status.fromJson(json["status"]),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
        "status": status!.toJson(),
      };
}

class CollectionModel {
  CollectionModel({
    this.id,
    this.userId,
    this.name,
    this.image,
    this.bookCount,
    this.bookIds,
  });

  String? id;
  String? userId;
  String? name;
  String? image;
  RxInt? bookCount;
  List<String>? bookIds;

  factory CollectionModel.fromJson(Map<String, dynamic> json) =>
      CollectionModel(
        id: json["_id"],
        userId: json["userId"],
        name: json["name"],
        image: json["image"],
        bookCount: int.parse(json["bookCount"].toString()).obs,
        bookIds: List<String>.from(json["bookIds"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "userId": userId,
        "name": name,
        "image": image,
        "bookCount": bookCount.obs,
        "bookIds": List<dynamic>.from(bookIds!.map((x) => x)),
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
