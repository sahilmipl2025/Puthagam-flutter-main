// To parse this JSON data, do
//
//     final getBookChaptersModel = getBookChaptersModelFromJson(jsonString);

import 'dart:convert';

GetBookChaptersModel getBookChaptersModelFromJson(String str) =>
    GetBookChaptersModel.fromJson(json.decode(str));

String getBookChaptersModelToJson(GetBookChaptersModel data) =>
    json.encode(data.toJson());

class GetBookChaptersModel {
  GetBookChaptersModel({
    this.data,
    this.status,
  });

  List<BookChapter>? data;
  Status? status;

  factory GetBookChaptersModel.fromJson(Map<String, dynamic> json) =>
      GetBookChaptersModel(
        data: List<BookChapter>.from(
            json["data"].map((x) => BookChapter.fromJson(x))),
        status: Status.fromJson(json["status"]),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
        "status": status!.toJson(),
      };
}

class BookChapter {
  BookChapter({
    this.id,
    this.bookId,
    this.sequenceNumber,
    this.name,
    this.content,
    this.audioUrl,
    this.audioDuration,
    this.createdDate,
    this.modifiedDate,
    this.createdBy,
    this.modifiedBy,
    this.isActive,
    this.isDeleted,
    this.bookAudio,
  });

  String? id;
  String? bookId;
  int? sequenceNumber;
  String? name;
  String? content;
  String? audioUrl;
  String? audioDuration;
  DateTime? createdDate;
  DateTime? modifiedDate;
  String? createdBy;
  String? modifiedBy;
  bool? isActive;
  bool? isDeleted;
  dynamic bookAudio;

  factory BookChapter.fromJson(Map<String, dynamic> json) => BookChapter(
        id: json["_id"],
        bookId: json["bookId"],
        sequenceNumber: json["sequenceNumber"],
        name: json["name"],
        content: json["content"],
        audioUrl: json["audioUrl"],
        audioDuration: json["audioDuration"],
        createdDate: DateTime.parse(json["createdDate"]),
        modifiedDate: DateTime.parse(json["modifiedDate"]),
        createdBy: json["createdBy"],
        modifiedBy: json["modifiedBy"],
        isActive: json["isActive"],
        isDeleted: json["isDeleted"],
        bookAudio: json["bookAudio"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "bookId": bookId,
        "sequenceNumber": sequenceNumber,
        "name": name,
        "content": content,
        "audioUrl": audioUrl,
        "audioDuration": audioDuration,
        "createdDate": createdDate!.toIso8601String(),
        "modifiedDate": modifiedDate!.toIso8601String(),
        "createdBy": createdBy,
        "modifiedBy": modifiedBy,
        "isActive": isActive,
        "isDeleted": isDeleted,
        "bookAudio": bookAudio,
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
