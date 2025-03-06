class Data {
  String? id;
  dynamic userName;
  String? name;
  String? dateofBirth;
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
  String? description;
  dynamic profileImage;
  String? token;

  Data({
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
    this.description,
    this.profileImage,
    this.token,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json['_id'] as String?,
        userName: json['userName'] as dynamic,
        name: json['name'] as String?,
        dateofBirth: json['dateofBirth'] as String?,
        email: json['email'] as String?,
        phoneNumber: json['phoneNumber'] as String?,
        image: json['image'] as String?,
        deviceToken: json['deviceToken'] as dynamic,
        createdDate: json['createdDate'] == null
            ? null
            : DateTime.parse(json['createdDate'] as String),
        modifiedDate: json['modifiedDate'] == null
            ? null
            : DateTime.parse(json['modifiedDate'] as String),
        createdBy: json['createdBy'] as String?,
        modifiedBy: json['modifiedBy'] as String?,
        isActive: json['isActive'] as bool?,
        isDeleted: json['isDeleted'] as bool?,
        description: json['description'] as String?,
        profileImage: json['profileImage'] as dynamic,
        token: json['token'] as String?,
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'userName': userName,
        'name': name,
        'dateofBirth': dateofBirth,
        'email': email,
        'phoneNumber': phoneNumber,
        'image': image,
        'deviceToken': deviceToken,
        'createdDate': createdDate?.toIso8601String(),
        'modifiedDate': modifiedDate?.toIso8601String(),
        'createdBy': createdBy,
        'modifiedBy': modifiedBy,
        'isActive': isActive,
        'isDeleted': isDeleted,
        'description': description,
        'profileImage': profileImage,
        'token': token,
      };
}
