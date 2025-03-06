// To parse this JSON data, do
//
//     final getBookDetailModel = getBookDetailModelFromJson(jsonString);

import 'dart:convert';

import 'package:get/get.dart';

GetBookDetailModel getBookDetailModelFromJson(String str) =>
    GetBookDetailModel.fromJson(json.decode(str));

String getBookDetailModelToJson(GetBookDetailModel data) =>
    json.encode(data.toJson());

class GetBookDetailModel {
  GetBookDetailModel({
    this.id,
    this.authorId,
    this.authorName,
    this.authorImage,
    this.authorDescription,
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
    this.isFinished,
    this.isPodcast,
    this.amazonLink,
    this.isPremium,
     this.booktype,
  });

  String? id;
  String? authorId;
  String? authorName;
  String? authorImage;
  String? authorDescription;
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
  dynamic price;
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
  dynamic rating;
  int? listenCount;
  int? downloadCount;
  RxBool? isFavorite;
  RxBool? isSaved;
  bool? isPodcast;
  bool? isFinished;
  int? chapterCount;
  String? amazonLink;
   bool? isPremium;
    int? booktype;

  factory GetBookDetailModel.fromJson(Map<String, dynamic> json) =>
      GetBookDetailModel(
        id: json["_id"],
        authorId: json["authorId"],
        authorName: json["authorName"],
        authorDescription: json["authorDescription"],
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
        rating: json["rating"],
        listenCount: json["listenCount"],
        downloadCount: json["downloadCount"],
        isFavorite:
            json["isFavorite"].toString() == "false" ? false.obs : true.obs,
        isSaved: json["isSaved"].toString() == "false" ? false.obs : true.obs,
        chapterCount: json["chapterCount"],
        isPodcast: json["isPodcast"],
        isFinished: json["isFinished"],
        isPremium: json["isPremium"],
        amazonLink: json["amazonLink"] ?? "",
        booktype: json["booktype"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "authorId": authorId,
        "isPremium":isPremium,
        "authorName": authorName,
        "authorImage": authorImage,
        "authorDescription": authorDescription,
        "publisherId": publisherId,
        "publisherName": publisherName,
        "categoryId": categoryId,
        "categoryImage": categoryImage,
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
        "chapterCount": chapterCount,
        "isFinished": isFinished,
        "isPodcast": isPodcast,
        "amazonLink": amazonLink,
          "isPremium": isPremium,
          "booktype": booktype,
          
      };
}

///
///
///
///

GetSimpleBookDetailModel getSimpleBookDetailModelFromJson(String str) =>
    GetSimpleBookDetailModel.fromJson(json.decode(str));

String getSimpleBookDetailModelToJson(GetBookDetailModel data) =>
    json.encode(data.toJson());

class GetSimpleBookDetailModel {
  GetSimpleBookDetailModel({
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
    this.isPremium,
    this.isFinished,
    this.amazonLink,
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
  dynamic price;
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
  dynamic rating;
  int? listenCount;
  int? downloadCount;
  String? isFavorite;
  String? isSaved;
  int? chapterCount;
  bool? isPodcast;
  bool? isFinished;
  String? amazonLink;
   bool? isPremium;

  factory GetSimpleBookDetailModel.fromJson(Map<String, dynamic> json) =>
      GetSimpleBookDetailModel(
        id: json["_id"],
        isPremium: json["isPremium"],
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
        rating: json["rating"],
        listenCount: json["listenCount"],
        downloadCount: json["downloadCount"],
        isFavorite: json["isFavorite"].toString(),
        isSaved: json["isSaved"].toString(),
        chapterCount: json["chapterCount"],
        isPodcast: json["isPodcast"],
        isFinished: json["isFinished"],
        amazonLink: json["amazonLink"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "authorId": authorId,
        "isPremium":isPremium,
        "authorName": authorName,
        "authorImage": authorImage,
        "publisherId": publisherId,
        "publisherName": publisherName,
        "categoryId": categoryId,
        "categoryImage": categoryImage,
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
        "chapterCount": chapterCount,
        "isFinished": isFinished,
        "isPodcast": isPodcast,
        "amazonLink": amazonLink,
      };
}
