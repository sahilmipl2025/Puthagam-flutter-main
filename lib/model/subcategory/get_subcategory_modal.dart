import 'dart:convert';

List<GetSubCategoryApiModal> getSubCategoryApiModalFromJson(String str) =>
    List<GetSubCategoryApiModal>.from(
        json.decode(str).map((x) => GetSubCategoryApiModal.fromJson(x)));

String getSubCategoryApiModalToJson(List<GetSubCategoryApiModal> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetSubCategoryApiModal {
  GetSubCategoryApiModal({
    this.id,
    this.categoryId,
    this.name,
    this.description,
    this.image,
    this.sequenceNumber,
    this.createdDate,
    this.modifiedDate,
    this.createdBy,
    this.modifiedBy,
    this.isActive,
    this.isDeleted,
    this.isSelected,
    this.profileImage,
  });

  String? id;
  String? categoryId;
  String? name;
  String? description;
  String? image;
  int? sequenceNumber;
  DateTime? createdDate;
  DateTime? modifiedDate;
  String? createdBy;
  String? modifiedBy;
  bool? isActive;
  bool? isDeleted;
  bool? isSelected;
  dynamic profileImage;

  factory GetSubCategoryApiModal.fromJson(Map<String, dynamic> json) =>
      GetSubCategoryApiModal(
        id: json["_id"],
        categoryId: json["categoryId"],
        name: json["name"],
        description: json["description"],
        image: json["image"],
        sequenceNumber: json["sequenceNumber"],
        createdDate: DateTime.parse(json["createdDate"]),
        modifiedDate: DateTime.parse(json["modifiedDate"]),
        createdBy: json["createdBy"],
        modifiedBy: json["modifiedBy"],
        isActive: json["isActive"],
        isDeleted: json["isDeleted"],
        isSelected: json["isSelected"],
        profileImage: json["profileImage"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "categoryId": categoryId,
        "name": name,
        "description": description,
        "image": image,
        "sequenceNumber": sequenceNumber,
        "createdDate": createdDate!.toIso8601String(),
        "modifiedDate": modifiedDate!.toIso8601String(),
        "createdBy": createdBy,
        "modifiedBy": modifiedBy,
        "isActive": isActive,
        "isDeleted": isDeleted,
        "isSelected": isSelected,
        "profileImage": profileImage,
      };
}
