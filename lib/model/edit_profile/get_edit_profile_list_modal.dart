import 'dart:convert';

GetEditProfileModel getEditProfileModelFromJson(String str) =>
    GetEditProfileModel.fromJson(json.decode(str));

String getEditProfileModelToJson(GetEditProfileModel data) =>
    json.encode(data.toJson());

class GetEditProfileModel {
  GetEditProfileModel({
    this.id,
    this.userName,
    this.name,
    this.dateofBirth,
    this.email,
    this.phoneNumber,
    this.image,
    this.deviceToken,
    this.createdDate,
    this.modifiedDate,
    this.createdBy,
    this.modifiedBy,
    this.isActive,
    this.isDeleted,
    this.password,
    this.token,
  });

  String? id;
  String? userName;
  String? name;
  DateTime? dateofBirth;
  String? email;
  String? phoneNumber;
  String? image;
  dynamic deviceToken;
  DateTime? createdDate;
  DateTime? modifiedDate;
  String? createdBy;
  String? modifiedBy;
  bool? isActive;
  bool? isDeleted;
  dynamic password;
  dynamic token;

  factory GetEditProfileModel.fromJson(Map<String, dynamic> json) =>
      GetEditProfileModel(
        id: json["_id"],
        userName: json["userName"],
        name: json["name"],
        dateofBirth: DateTime.parse(json["dateofBirth"]),
        email: json["email"],
        phoneNumber: json["phoneNumber"],
        image: json["image"],
        deviceToken: json["deviceToken"],
        createdDate: DateTime.parse(json["createdDate"]),
        modifiedDate: DateTime.parse(json["modifiedDate"]),
        createdBy: json["createdBy"],
        modifiedBy: json["modifiedBy"],
        isActive: json["isActive"],
        isDeleted: json["isDeleted"],
        password: json["password"],
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "userName": userName,
        "name": name,
        "dateofBirth": dateofBirth!.toIso8601String(),
        "email": email,
        "phoneNumber": phoneNumber,
        "image": image,
        "deviceToken": deviceToken,
        "createdDate": createdDate!.toIso8601String(),
        "modifiedDate": modifiedDate!.toIso8601String(),
        "createdBy": createdBy,
        "modifiedBy": modifiedBy,
        "isActive": isActive,
        "isDeleted": isDeleted,
        "password": password,
        "token": token,
      };
}
