// To parse this JSON data, do
//
//     final getPodcaster = getPodcasterFromMap(jsonString);

import 'dart:convert';

GetPodcaster getPodcasterFromMap(String str) =>
    GetPodcaster.fromMap(json.decode(str));

String getPodcasterToMap(GetPodcaster data) => json.encode(data.toMap());

class GetPodcaster {
  List<Podcaster> data;
  Status status;

  GetPodcaster({
    required this.data,
    required this.status,
  });

  factory GetPodcaster.fromMap(Map<String, dynamic> json) => GetPodcaster(
        data:
            List<Podcaster>.from(json["data"].map((x) => Podcaster.fromMap(x))),
        status: Status.fromMap(json["status"]),
      );

  Map<String, dynamic> toMap() => {
        "data": List<dynamic>.from(data.map((x) => x.toMap())),
        "status": status.toMap(),
      };
}

class Podcaster {
  String id;
  String image;
  String name;
  dynamic description;
  int bookCount;
  bool isActive;
  bool isDeleted;

  Podcaster({
    required this.id,
    required this.image,
    required this.name,
    this.description,
    required this.bookCount,
    required this.isActive,
    required this.isDeleted,
  });

  factory Podcaster.fromMap(Map<String, dynamic> json) => Podcaster(
        id: json["_id"],
        image: json["image"],
        name: json["name"],
        description: json["description"],
        bookCount: json["bookCount"],
        isActive: json["isActive"],
        isDeleted: json["isDeleted"],
      );

  Map<String, dynamic> toMap() => {
        "_id": id,
        "image": image,
        "name": name,
        "description": description,
        "bookCount": bookCount,
        "isActive": isActive,
        "isDeleted": isDeleted,
      };
}

class Status {
  dynamic status;
  dynamic message;
  int totalRecords;

  Status({
    this.status,
    this.message,
    required this.totalRecords,
  });

  factory Status.fromMap(Map<String, dynamic> json) => Status(
        status: json["status"],
        message: json["message"],
        totalRecords: json["totalRecords"],
      );

  Map<String, dynamic> toMap() => {
        "status": status,
        "message": message,
        "totalRecords": totalRecords,
      };
}
