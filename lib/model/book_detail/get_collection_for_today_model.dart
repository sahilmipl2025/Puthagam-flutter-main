// To parse this JSON data, do
//
//     final getCollectionForTodayModel = getCollectionForTodayModelFromJson(jsonString);

import 'dart:convert';

GetCollectionForTodayModel getCollectionForTodayModelFromJson(String str) =>
    GetCollectionForTodayModel.fromJson(json.decode(str));

String getCollectionForTodayModelToJson(GetCollectionForTodayModel data) =>
    json.encode(data.toJson());

class GetCollectionForTodayModel {
  GetCollectionForTodayModel({
    this.data,
    this.status,
  });

  List<TodayForYou>? data;
  Status? status;

  factory GetCollectionForTodayModel.fromJson(Map<String, dynamic> json) =>
      GetCollectionForTodayModel(
        data: List<TodayForYou>.from(
            json["data"].map((x) => TodayForYou.fromJson(x))),
        status: Status.fromJson(json["status"]),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
        "status": status!.toJson(),
      };
}

class TodayForYou {
  TodayForYou({
  
    this.id,
    this.authorId,
    this.bookImageName,
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
    this.listenChapterIds,
    this.isFavorite,
    this.isSaved,
    this.isFinished,
    this.chapterCount,
    this.isPodcast,
    this.isPremium,
  });

  String? id;
  String? authorId;
  String ?bookImageName;
  List? listenChapterIds;
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
  dynamic saveCount;
  dynamic rating;
  dynamic listenCount;
  dynamic downloadCount;
  bool? isFavorite;
  bool? isSaved;
  dynamic chapterCount;
  bool? isPodcast;
 bool? isFinished;
  bool? isPremium; 
  factory TodayForYou.fromJson(Map<String, dynamic> json) => TodayForYou(
        id: json["_id"],
        listenChapterIds: json["listenChapterIds"],
        bookImageName:json["bookImageName"],
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
          isFinished: json["isFinished"],
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
        isFavorite: json["isFavorite"],
        isSaved: json["isSaved"],
        chapterCount: json["chapterCount"],
        isPodcast: json["isPodcast"],
        isPremium :json["isPremium"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "isPremium":isPremium,
        "authorId": authorId,
        "bookImageName": bookImageName,
        "authorName": authorName,
        "authorImage": authorImage,
        "publisherId": publisherId,
        "publisherName": publisherName,
        "categoryId": categoryId,
        "subcategoryId": subcategoryId,
          "isFinished": isFinished,
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
         "listenChapterIds": listenChapterIds,
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
