// To parse this JSON data, do
//
//     final getStartedModel = getStartedModelFromJson(jsonString);

import 'dart:convert';

List<GetStartedModel> getStartedModelFromJson(String str) =>
    List<GetStartedModel>.from(
        json.decode(str).map((x) => GetStartedModel.fromJson(x)));

String getStartedModelToJson(List<GetStartedModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetStartedModel {
  GetStartedModel({
    this.id,
    this.name,
    this.image,
    this.introTitle,
    this.introSubTitle,
  });

  String? id;
  String? name;
  String? image;
  String? introTitle;
  String? introSubTitle;

  factory GetStartedModel.fromJson(Map<String, dynamic> json) =>
      GetStartedModel(
        id: json["_id"],
        name: json["name"],
        image: json["image"],
        introTitle: json["introTitle"],
        introSubTitle: json["introSubTitle"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "image": image,
        "introTitle": introTitle,
        "introSubTitle": introSubTitle,
      };
}
