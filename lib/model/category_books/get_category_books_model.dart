// To parse this JSON data, do
//
//     final getCategoryBooksModel = getCategoryBooksModelFromJson(jsonString);

import 'dart:convert';

import 'package:get/get.dart';

GetCategoryBooksModel getCategoryBooksModelFromJson(String str) =>
    GetCategoryBooksModel.fromJson(json.decode(str));

String getCategoryBooksModelToJson(GetCategoryBooksModel data) =>
    json.encode(data.toJson());

class GetCategoryBooksModel {
  GetCategoryBooksModel({
    this.data,
    this.status,
  });

  List<CategoryBooks>? data;
  Status? status;

  factory GetCategoryBooksModel.fromJson(Map<String, dynamic> json) =>
      GetCategoryBooksModel(
        data: List<CategoryBooks>.from(
            json["data"].map((x) => CategoryBooks.fromJson(x))),
        status: Status.fromJson(json["status"]),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
        "status": status!.toJson(),
      };
}

class CategoryBooks {
  CategoryBooks({
    this.id,
    this.authorId,
    this.authorName,
    this.authorImage,
    this.publisherId,
    this.publisherName,
    this.categoryId,
    this.subcategoryId,
    this.categoryName,
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
    this.listenChapterIds,
    this.chapterCount,
    this.isPremium,
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
  double? rating;
  int? listenCount;
  int? downloadCount;
  RxBool? isFavorite;
  RxBool? isSaved;
  RxList<String>? listenChapterIds;
  int? chapterCount;
  bool? isPremium;

  factory CategoryBooks.fromJson(Map<String, dynamic> json) => CategoryBooks(
        id: json["_id"],
        authorId: json["authorId"],
        authorName: json["authorName"],
        authorImage: json["authorImage"],
        publisherId: json["publisherId"],
        publisherName: json["publisherName"],
        categoryId: json["categoryId"],
        subcategoryId: json["subcategoryId"],
        categoryName: json["categoryName"],
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
        rating: json["rating"].toDouble(),
        listenCount: json["listenCount"],
        downloadCount: json["downloadCount"],
        isFavorite:
            json["isFavorite"].toString() == "false" ? false.obs : true.obs,
        isSaved: json["isSaved"].toString() == "false" ? false.obs : true.obs,
        listenChapterIds:
            List<String>.from(json["listenChapterIds"].map((x) => x)).obs,
        chapterCount: json["chapterCount"] ?? 0,
         isPremium: json["isPremium"],
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
        "listenChapterIds": List<dynamic>.from(listenChapterIds!.map((x) => x)),
        "chapterCount": chapterCount,
         "isPremium": isPremium,
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
