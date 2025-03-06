// To parse this JSON data, do
//
//     final getCategoryModel = getCategoryModelFromJson(jsonString);

import 'dart:convert';

import 'package:get/get.dart';

GetCategoryModel getCategoryModelFromJson(String str) =>
    GetCategoryModel.fromJson(json.decode(str));

String getCategoryModelToJson(GetCategoryModel data) =>
    json.encode(data.toJson());

class GetCategoryModel {
  GetCategoryModel({
    this.status,
    this.data,
  });

  Status? status;
  List<Category>? data;

  factory GetCategoryModel.fromJson(Map<String, dynamic> json) =>
      GetCategoryModel(
        status: Status.fromJson(json["status"]),
        data:
            List<Category>.from(json["data"].map((x) => Category.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status!.toJson(),
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Category {
  Category({
    this.id,
    this.name,
    this.description,
    this.image,
    this.sequenceNumber,
    this.createdDate,
    this.modifiedDate,
    this.createdBy,
    this.modifiedBy,
    this.isActive,
    this.isDeleted,
    this.isSelected,
    this.profileImage,
    this.alreadySelected,
     this.isPremium,
  });

  String? id;
  String? name;
  String? description;
  String? image;
  int? sequenceNumber;
  DateTime? createdDate;
  DateTime? modifiedDate;
  String? createdBy;
  String? modifiedBy;
  bool? isActive;
  bool? isDeleted;
  bool? alreadySelected;
  RxBool? isSelected;
  dynamic profileImage;
   bool? isPremium;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["_id"],
         isPremium: json["isPremium"],
        name: json["name"],
        description: json["description"],
        image: json["image"],
        sequenceNumber: json["sequenceNumber"],
        createdDate: DateTime.parse(json["createdDate"]),
        modifiedDate: DateTime.parse(json["modifiedDate"]),
        createdBy: json["createdBy"],
        modifiedBy: json["modifiedBy"],
        isActive: json["isActive"],
        isDeleted: json["isDeleted"],
        isSelected:
            json["isSelected"].toString() == "false" ? false.obs : true.obs,
        alreadySelected: false,
        profileImage: json["profileImage"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "description": description,
        "image": image,
        "sequenceNumber": sequenceNumber,
        "createdDate": createdDate!.toIso8601String(),
        "modifiedDate": modifiedDate!.toIso8601String(),
        "createdBy": createdBy,
        "modifiedBy": modifiedBy,
        "isActive": isActive,
        "isDeleted": isDeleted,
        "isSelected": isSelected,
        "profileImage": profileImage,
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
