class GetSignupModel {
  Data? data;
  Status? status;

  GetSignupModel({this.data, this.status});

  GetSignupModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    status = json['status'] != null ? Status.fromJson(json['status']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    if (status != null) {
      data['status'] = status!.toJson();
    }
    return data;
  }
}

class Data {
  String? sId;
  String? name;
  String? dateofBirth;
  String? email;
  String? phoneNumber;
  String? createdDate;
  String? modifiedDate;
  String? createdBy;
  String? modifiedBy;
  bool? isActive;
  bool? isDeleted;
  String? token;

  Data(
      {this.sId,
      this.name,
      this.dateofBirth,
      this.email,
      this.phoneNumber,
      this.createdDate,
      this.modifiedDate,
      this.createdBy,
      this.modifiedBy,
      this.isActive,
      this.isDeleted,
      this.token});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    dateofBirth = json['dateofBirth'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
    createdDate = json['createdDate'];
    modifiedDate = json['modifiedDate'];
    createdBy = json['createdBy'];
    modifiedBy = json['modifiedBy'];
    isActive = json['isActive'];
    isDeleted = json['isDeleted'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['dateofBirth'] = dateofBirth;
    data['email'] = email;
    data['phoneNumber'] = phoneNumber;
    data['createdDate'] = createdDate;
    data['modifiedDate'] = modifiedDate;
    data['createdBy'] = createdBy;
    data['modifiedBy'] = modifiedBy;
    data['isActive'] = isActive;
    data['isDeleted'] = isDeleted;
    data['token'] = token;
    return data;
  }
}

class Status {
  String? status;
  String? message;
  int? totalRecords;

  Status({this.status, this.message, this.totalRecords});

  Status.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    totalRecords = json['totalRecords'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['totalRecords'] = totalRecords;
    return data;
  }
}
