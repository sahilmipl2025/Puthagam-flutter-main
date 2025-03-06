// To parse this JSON data, do
//
//     final getQueueModel = getQueueModelFromJson(jsonString);

import 'dart:convert';

import 'package:get/get.dart';
import 'package:puthagam/model/category_books/get_book_chapters_model.dart';

GetQueueModel getQueueModelFromJson(String str) =>
    GetQueueModel.fromJson(json.decode(str));

String getQueueModelToJson(GetQueueModel data) => json.encode(data.toJson());

class GetQueueModel {
  GetQueueModel({
    this.data,
    this.status,
  });

  List<QueueBook>? data;
  Status? status;

  factory GetQueueModel.fromJson(Map<String, dynamic> json) => GetQueueModel(
        data: List<QueueBook>.from(
            json["data"].map((x) => QueueBook.fromJson(x))),
        status: Status.fromJson(json["status"]),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
        "status": status!.toJson(),
      };
}

class QueueBook {
  QueueBook({
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
    this.isFinished,
    this.isContinuous,
    this.authorImageName,
    this.bookImageName,
    this.categoryImageName,
    this.listenChapterIds,
    this.bookChapterList,
    this.isPremium,
  });

  String? id;
  bool? isPremium;
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
  double? rating;
  int? listenCount;
  int? downloadCount;
  bool? isFavorite;
  RxBool? isSaved;
  int? chapterCount;
  bool? isPodcast;
  bool? isFinished;
  bool? isContinuous;
  String? authorImageName;
  String? bookImageName;
  String? categoryImageName;
  RxList<String>? listenChapterIds;
  RxList<BookChapter>? bookChapterList;

  factory QueueBook.fromJson(Map<String, dynamic> json) => QueueBook(
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
        rating: json["rating"].toDouble(),
        listenCount: json["listenCount"],
        downloadCount: json["downloadCount"],
        isFavorite: json["isFavorite"],
        isSaved: json["isSaved"].toString() == "false" ? false.obs : true.obs,
        chapterCount: json["chapterCount"],
        isPodcast: json["isPodcast"],
        isFinished: json["isFinished"],
        isContinuous: json["isContinuous"],
        authorImageName: json["authorImageName"],
        bookImageName: json["bookImageName"],
        categoryImageName: json["categoryImageName"],
        listenChapterIds:
            List<String>.from(json["listenChapterIds"].map((x) => x)).obs,
        bookChapterList: <BookChapter>[].obs,
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
        "isFinished": isFinished,
        "isContinuous": isContinuous,
        "authorImageName": authorImageName,
        "bookImageName": bookImageName,
        "categoryImageName": categoryImageName,
        "isPremium": isPremium,
        "listenChapterIds": List<dynamic>.from(listenChapterIds!.map((x) => x)),
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
