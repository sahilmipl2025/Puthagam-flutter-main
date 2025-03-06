// To parse this JSON data, do
//
//     final getEventRolesModel = getEventRolesModelFromJson(jsonString);

import 'dart:convert';

import 'package:get/get.dart';

GetNotificationModel getNotificationModelFromJson(String str) =>
    GetNotificationModel.fromJson(json.decode(str));

String getEventRolesModelToJson(GetNotificationModel data) =>
    json.encode(data.toJson());

class GetNotificationModel {
  GetNotificationModel({
    this.data,
    this.status,
  });

  List<NotificationModel>? data;
  Status? status;

  factory GetNotificationModel.fromJson(Map<String, dynamic> json) =>
      GetNotificationModel(
        data: List<NotificationModel>.from(
            json["data"].map((x) => NotificationModel.fromJson(x))),
        status: Status.fromJson(json["status"]),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
        "status": status!.toJson(),
      };
}

class NotificationModel {
  NotificationModel({
    this.id,
    this.type,
    this.content,
    this.isRead,
    this.isSent,
    this.title,
    this.entityId,
    this.parentEntityId,
    this.createdDate,
  });

  String? id;
  String? type;
  String? content;
  RxBool? isRead;
  bool? isSent;
  String? title;
  dynamic entityId;
  dynamic parentEntityId;
  DateTime? createdDate;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        id: json["_id"],
        type: json["type"],
        content: json["content"],
        isRead: json["isRead"].toString().toLowerCase() == "false"
            ? false.obs
            : true.obs,
        isSent: json["isSent"],
        title: json["title"],
        entityId: json["entityId"],
        parentEntityId: json["parentEntityId"],
        createdDate: json["createdDate"] == null
            ? null
            : DateTime.parse(json["createdDate"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "type": type,
        "content": content,
        "isRead": isRead,
        "isSent": isSent,
        "title": title,
        "entityId": entityId,
        "parentEntityId": parentEntityId,
        "createdDate": createdDate?.toIso8601String(),
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
