// To parse this JSON data, do
//
//     final getMeetCreatorModel = getMeetCreatorModelFromJson(jsonString);

import 'dart:convert';

GetMeetCreatorModel getMeetCreatorModelFromJson(String str) =>
    GetMeetCreatorModel.fromJson(json.decode(str));

String getMeetCreatorModelToJson(GetMeetCreatorModel data) =>
    json.encode(data.toJson());

class GetMeetCreatorModel {
  GetMeetCreatorModel({
    this.data,
    this.status,
  });

  List<MeetCreator>? data;
  Status? status;

  factory GetMeetCreatorModel.fromJson(Map<String, dynamic> json) =>
      GetMeetCreatorModel(
        data: List<MeetCreator>.from(
            json["data"].map((x) => MeetCreator.fromJson(x))),
        status: Status.fromJson(json["status"]),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
        "status": status!.toJson(),
      };
}

class MeetCreator {
  MeetCreator({
    this.id,
    this.image,
    this.name,
    this.bookCount,
    this.description,
  });

  String? id;
  String? image;
  String? name;
  String? description;
  int? bookCount;

  factory MeetCreator.fromJson(Map<String, dynamic> json) => MeetCreator(
        id: json["_id"],
        image: json["image"],
        name: json["name"],
        bookCount: json["bookCount"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "image": image,
        "name": name,
        "bookCount": bookCount,
        "description": description,
      };
}

class Status {
  Status({
    this.status,
    this.message,
    this.totalRecords,
  });

  dynamic status;
  dynamic message;
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
