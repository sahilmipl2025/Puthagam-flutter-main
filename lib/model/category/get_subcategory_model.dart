// To parse this JSON data, do
//
//     final getSubCategoryModel = getSubCategoryModelFromJson(jsonString);

import 'dart:convert';

GetSubCategoryModel getSubCategoryModelFromJson(String str) =>
    GetSubCategoryModel.fromJson(json.decode(str));

String getSubCategoryModelToJson(GetSubCategoryModel data) =>
    json.encode(data.toJson());

class GetSubCategoryModel {
  GetSubCategoryModel({
    this.data,
    this.status,
  });

  List<SubCategory>? data;
  Status? status;

  factory GetSubCategoryModel.fromJson(Map<String, dynamic> json) =>
      GetSubCategoryModel(
        data: List<SubCategory>.from(
            json["data"].map((x) => SubCategory.fromJson(x))),
        status: Status.fromJson(json["status"]),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
        "status": status!.toJson(),
      };
}

class SubCategory {
  SubCategory({
    this.id,
    this.categoryId,
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
  });

  String? id;
  String? categoryId;
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
  bool? isSelected;
  dynamic profileImage;

  factory SubCategory.fromJson(Map<String, dynamic> json) => SubCategory(
        id: json["_id"],
        categoryId: json["categoryId"],
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
        isSelected: json["isSelected"],
        profileImage: json["profileImage"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "categoryId": categoryId,
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
