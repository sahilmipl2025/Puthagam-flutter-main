// To parse this JSON data, do
//
//     final getSubsctriptionModel = getSubsctriptionModelFromJson(jsonString);

import 'dart:convert';

GetSubscriptionModel getSubscriptionModelFromJson(String str) =>
    GetSubscriptionModel.fromJson(json.decode(str));

String getSubscriptionModelToJson(GetSubscriptionModel data) =>
    json.encode(data.toJson());

class GetSubscriptionModel {
  GetSubscriptionModel({
    this.data,
    this.status,
    this.trialDays,
  });

  List<Plan>? data;
  Status? status;
  String? trialDays;

  factory GetSubscriptionModel.fromJson(Map<String, dynamic> json) =>
      GetSubscriptionModel(
          data: List<Plan>.from(json["data"].map((x) => Plan.fromJson(x))),
          status: Status.fromJson(json["status"]),
          trialDays: json['trialDays']);

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
        "status": status!.toJson(),
        "trialDays": trialDays,
      };
}

class Plan {
  Plan({
    this.image,
    this.planImage,
    this.id,
    this.entity,
    this.interval,
    this.period,
    this.item,
    this.notes,
    this.createdAt,
    this.originalAmt,
  });

  String? image;
  dynamic planImage;
  String? id;
  String? entity;
  int? interval;
  String? period;
  Item? item;
  Notes? notes;
  int? createdAt;
  dynamic originalAmt;

  factory Plan.fromJson(Map<String, dynamic> json) => Plan(
        image: json["image"],
        planImage: json["planImage"],
        id: json["id"],
        entity: json["entity"],
        interval: json["interval"],
        period: json["period"],
        item: Item.fromJson(json["item"]),
        notes: Notes.fromJson(json["notes"]),
        createdAt: json["created_at"],
        originalAmt: json["originalAmount"],
      );

  Map<String, dynamic> toJson() => {
        "image": image,
        "planImage": planImage,
        "id": id,
        "entity": entity,
        "interval": interval,
        "period": period,
        "item": item!.toJson(),
        "notes": notes!.toJson(),
        "created_at": createdAt,
        "originalAmount": originalAmt,
      };
}

class Item {
  Item({
    this.id,
    this.active,
    this.name,
    this.description,
    this.amount,
    this.unitAmount,
    this.currency,
    this.type,
    this.unit,
    this.taxInclusive,
    this.hsnCode,
    this.sacCode,
    this.taxRate,
    this.taxId,
    this.taxGroupId,
    this.createdAt,
    this.updatedAt,
  });

  String? id;
  bool? active;
  String? name;
  String? description;
  dynamic amount;
  int? unitAmount;
  String? currency;
  String? type;
  dynamic unit;
  bool? taxInclusive;
  dynamic hsnCode;
  dynamic sacCode;
  dynamic taxRate;
  dynamic taxId;
  dynamic taxGroupId;
  int? createdAt;
  int? updatedAt;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json["id"],
        active: json["active"],
        name: json["name"],
        description: json["description"],
        amount: json["amount"],
        unitAmount: json["unit_amount"],
        currency: json["currency"],
        type: json["type"],
        unit: json["unit"],
        taxInclusive: json["tax_inclusive"],
        hsnCode: json["hsn_code"],
        sacCode: json["sac_code"],
        taxRate: json["tax_rate"],
        taxId: json["tax_id"],
        taxGroupId: json["tax_group_id"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "active": active,
        "name": name,
        "description": description,
        "amount": amount,
        "unit_amount": unitAmount,
        "currency": currency,
        "type": type,
        "unit": unit,
        "tax_inclusive": taxInclusive,
        "hsn_code": hsnCode,
        "sac_code": sacCode,
        "tax_rate": taxRate,
        "tax_id": taxId,
        "tax_group_id": taxGroupId,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}

class Notes {
  Notes({
    this.notesKey1,
    this.notesKey2,
  });

  String? notesKey1;
  String? notesKey2;

  factory Notes.fromJson(Map<String, dynamic> json) => Notes(
        notesKey1: json["notes_key_1"],
        notesKey2: json["notes_key_2"],
      );

  Map<String, dynamic> toJson() => {
        "notes_key_1": notesKey1,
        "notes_key_2": notesKey2,
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
