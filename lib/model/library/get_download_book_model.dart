// To parse this JSON data, do
//
//     final getDownloadBookModel = getDownloadBookModelFromJson(jsonString);

import 'dart:convert';

GetDownloadBookModel getDownloadBookModelFromJson(String str) =>
    GetDownloadBookModel.fromJson(json.decode(str));

String getDownloadBookModelToJson(GetDownloadBookModel data) =>
    json.encode(data.toJson());

class GetDownloadBookModel {
  GetDownloadBookModel({
    this.data,
    this.status,
  });

  List<DownloadBook>? data;
  Status? status;

  factory GetDownloadBookModel.fromJson(Map<String, dynamic> json) =>
      GetDownloadBookModel(
        data: List<DownloadBook>.from(
            json["data"].map((x) => DownloadBook.fromJson(x))),
        status: Status.fromJson(json["status"]),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
        "status": status!.toJson(),
      };
}

class DownloadBook {
  DownloadBook({
    this.id,
    this.authorId,
    this.authorName,
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
  });

  String? id;
  String? authorId;
  String? authorName;
  String? publisherId;
  dynamic publisherName;
  String? categoryId;
  String? subcategoryId;
  dynamic categoryName;
  dynamic subcategoryName;
  String? title;
  String? caption;
  String? image;
  String? info;
  num? price;
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
  num? saveCount;
  num? rating;
  num? listenCount;
  num? downloadCount;
  bool? isFavorite;
  bool? isSaved;

  factory DownloadBook.fromJson(Map<String, dynamic> json) => DownloadBook(
        id: json["_id"],
        authorId: json["authorId"],
        authorName: json["authorName"],
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
        rating: json["rating"],
        listenCount: json["listenCount"],
        downloadCount: json["downloadCount"],
        isFavorite: json["isFavorite"],
        isSaved: json["isSaved"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "authorId": authorId,
        "authorName": authorName,
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
  num? totalRecords;

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
