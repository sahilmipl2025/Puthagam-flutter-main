// To parse this JSON data, do
//
//     final historyModel = historyModelFromJson(jsonString);

import 'dart:convert';

List<QueueChapterModel> queueChapterModelFromJson(String str) =>
    List<QueueChapterModel>.from(
        json.decode(str).map((x) => QueueChapterModel.fromJson(x)));

String historyModelToJson(List<QueueChapterModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class QueueChapterModel {
  QueueChapterModel({
    this.chapter,
    this.bookId,
  });

  int? chapter;
  String? bookId;

  factory QueueChapterModel.fromJson(Map<String, dynamic> json) =>
      QueueChapterModel(
        chapter: json["chapter"],
        bookId: json["bookId"],
      );

  Map<String, dynamic> toJson() => {
        "chapter": chapter,
        "bookId": bookId,
      };
}
