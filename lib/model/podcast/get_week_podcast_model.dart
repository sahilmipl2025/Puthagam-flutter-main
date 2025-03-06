// To parse this JSON data, do
//
//     final getWeekPodcastModel = getWeekPodcastModelFromJson(jsonString);

import 'dart:convert';

import 'package:get/get.dart';

GetWeekPodcastModel getWeekPodcastModelFromJson(String str) =>
    GetWeekPodcastModel.fromJson(json.decode(str));

String getWeekPodcastModelToJson(GetWeekPodcastModel data) =>
    json.encode(data.toJson());

class GetWeekPodcastModel {
  GetWeekPodcastModel({
    this.data,
    this.status,
  });

  List<WeekPodcast>? data;
  Status? status;

  factory GetWeekPodcastModel.fromJson(Map<String, dynamic> json) =>
      GetWeekPodcastModel(
        data: List<WeekPodcast>.from(
            json["data"].map((x) => WeekPodcast.fromJson(x))),
        status: Status.fromJson(json["status"]),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
        "status": status!.toJson(),
      };
}

class WeekPodcast {
  WeekPodcast({
    this.id,
    this.authorId,
    this.authorName,
    this.authorImage,
    this.publisherId,
    this.publisherName,
    this.categoryId,
    this.subcategoryId,
    this.categoryName,
    this.categoryImage,
    this.subcategoryName,
    this.title,
    this.caption,
    this.image,
    this.info,
    this.price,
    this.publishDate,
    this.isPublished,
    this.isPaid,
    this.totalAudioDuration,
    this.createdDate,
    this.modifiedDate,
    this.createdBy,
    this.modifiedBy,
    this.isActive,
    this.isDeleted,
    this.bookImage,
    this.saveCount,
    this.rating,
    this.listenCount,
    this.downloadCount,
    this.isFavorite,
    this.isSaved,
    this.chapterCount,
    this.isPodcast,
  });

  String? id;
  String? authorId;
  String? authorName;
  String? authorImage;
  String? publisherId;
  dynamic publisherName;
  String? categoryId;
  String? subcategoryId;
  String? categoryName;
  String? categoryImage;
  dynamic subcategoryName;
  String? title;
  String? caption;
  String? image;
  String? info;
  int? price;
  DateTime? publishDate;
  bool? isPublished;
  bool? isPaid;
  String? totalAudioDuration;
  DateTime? createdDate;
  DateTime? modifiedDate;
  String? createdBy;
  String? modifiedBy;
  bool? isActive;
  bool? isDeleted;
  dynamic bookImage;
  int? saveCount;
  int? rating;
  int? listenCount;
  int? downloadCount;
  RxBool? isFavorite;
  RxBool? isSaved;
  int? chapterCount;
  bool? isPodcast;

  factory WeekPodcast.fromJson(Map<String, dynamic> json) => WeekPodcast(
        id: json["_id"],
        authorId: json["authorId"],
        authorName: json["authorName"],
        authorImage: json["authorImage"],
        publisherId: json["publisherId"],
        publisherName: json["publisherName"],
        categoryId: json["categoryId"],
        subcategoryId: json["subcategoryId"],
        categoryName: json["categoryName"],
        categoryImage: json["categoryImage"],
        subcategoryName: json["subcategoryName"],
        title: json["title"],
        caption: json["caption"],
        image: json["image"],
        info: json["info"],
        price: json["price"],
        publishDate: DateTime.parse(json["publishDate"]),
        isPublished: json["isPublished"],
        isPaid: json["isPaid"],
        totalAudioDuration: json["totalAudioDuration"],
        createdDate: DateTime.parse(json["createdDate"]),
        modifiedDate: DateTime.parse(json["modifiedDate"]),
        createdBy: json["createdBy"],
        modifiedBy: json["modifiedBy"],
        isActive: json["isActive"],
        isDeleted: json["isDeleted"],
        bookImage: json["bookImage"],
        saveCount: json["saveCount"],
        rating: json["rating"] == null || json["rating"] == 0
            ? 0
            : int.parse(json["rating"].round().toString()),
        listenCount: json["listenCount"],
        downloadCount: json["downloadCount"],
        isFavorite:
            json["isFavorite"].toString() == "false" ? false.obs : true.obs,
        isSaved: json["isSaved"].toString() == "false" ? false.obs : true.obs,
        chapterCount: json["chapterCount"],
        isPodcast: json["isPodcast"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "authorId": authorId,
        "authorName": authorName,
        "authorImage": authorImage,
        "publisherId": publisherId,
        "publisherName": publisherName,
        "categoryId": categoryId,
        "subcategoryId": subcategoryId,
        "categoryName": categoryName,
        "categoryImage": categoryImage,
        "subcategoryName": subcategoryName,
        "title": title,
        "caption": caption,
        "image": image,
        "info": info,
        "price": price,
        "publishDate": publishDate!.toIso8601String(),
        "isPublished": isPublished,
        "isPaid": isPaid,
        "totalAudioDuration": totalAudioDuration,
        "createdDate": createdDate!.toIso8601String(),
        "modifiedDate": modifiedDate!.toIso8601String(),
        "createdBy": createdBy,
        "modifiedBy": modifiedBy,
        "isActive": isActive,
        "isDeleted": isDeleted,
        "bookImage": bookImage,
        "saveCount": saveCount,
        "rating": rating,
        "listenCount": listenCount,
        "downloadCount": downloadCount,
        "isFavorite": isFavorite,
        "isSaved": isSaved,
        "chapterCount": chapterCount,
        "isPodcast": isPodcast,
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
