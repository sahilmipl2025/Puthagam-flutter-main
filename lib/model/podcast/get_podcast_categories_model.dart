// To parse this JSON data, do
//
//     final getPodcastCategoriesModel = getPodcastCategoriesModelFromJson(jsonString);

import 'dart:convert';

import 'package:get/get.dart';

GetPodcastCategoriesModel getPodcastCategoriesModelFromJson(String str) =>
    GetPodcastCategoriesModel.fromJson(json.decode(str));

String getPodcastCategoriesModelToJson(GetPodcastCategoriesModel data) =>
    json.encode(data.toJson());

class GetPodcastCategoriesModel {
  GetPodcastCategoriesModel({
    this.data,
    this.status,
  });

  List<PodCastCategories>? data;
  Status? status;

  factory GetPodcastCategoriesModel.fromJson(Map<String, dynamic> json) =>
      GetPodcastCategoriesModel(
        data: List<PodCastCategories>.from(
            json["data"].map((x) => PodCastCategories.fromJson(x))),
        status: Status.fromJson(json["status"]),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
        "status": status!.toJson(),
      };
}

class PodCastCategories {
  PodCastCategories({
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
    this.isFinished,
    

    this.modifiedDate,
    this.createdBy,
    this.modifiedBy,
    this.isActive,
    this.isDeleted,
    this.bookImage,
    this.saveCount,
    this.rating,
       this.listenChapterIds,
    this.listenCount,
    this.downloadCount,
    this.isFavorite,
    this.isSaved,
    this.chapterCount,
    this.isPodcast,
    this.isPremium,
    this.booktype,
  });

  String? id;
  String? authorId;
  bool? isFinished;
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
  List? listenChapterIds;
  RxBool? isSaved;
  int? chapterCount;
  bool? isPodcast;
  bool? isPremium;
  int? booktype;

  factory PodCastCategories.fromJson(Map<String, dynamic> json) =>
      PodCastCategories(
        id: json["_id"],
        authorId: json["authorId"],
          isFinished: json["isFinished"],
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
           listenChapterIds: json["listenChapterIds"],
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
        isPremium: json["isPremium"] ?? false, 
        booktype: json["booktype"],
        //isPremium: json["isPremium"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "isPremium": isPremium,
        "authorId": authorId,
        "authorName": authorName,
        "authorImage": authorImage,
        "publisherId": publisherId,
        "publisherName": publisherName,
        "categoryId": categoryId,
        "subcategoryId": subcategoryId,
        "categoryName": categoryName,
            "isFinished": isFinished,
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
        "booktype": booktype,
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
