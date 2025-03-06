// To parse this JSON data, do
//
//     final purchasePlanModel = purchasePlanModelFromJson(jsonString);

import 'dart:convert';

PurchasePlanModel purchasePlanModelFromJson(String str) =>
    PurchasePlanModel.fromJson(json.decode(str));

String purchasePlanModelToJson(PurchasePlanModel data) =>
    json.encode(data.toJson());

class PurchasePlanModel {
  List<PurchaseModel> data;
  Status status;

  PurchasePlanModel({
    required this.data,
    required this.status,
  });

  factory PurchasePlanModel.fromJson(Map<String, dynamic> json) =>
      PurchasePlanModel(
        data: List<PurchaseModel>.from(
            json["data"].map((x) => PurchaseModel.fromJson(x))),
        status: Status.fromJson(json["status"]),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "status": status.toJson(),
      };
}

class PurchaseModel {
  String id;
  dynamic entity;
  String planId;
  String planName;
  String status;
  int? currentStart;
  int? currentEnd;
  int? endedAt;
  int? quantity;
  Notes notes;
  int? chargeAt;
  int? startAt;
  int? endAt;
  int? authAttempts;
  int? totalCount;
  int? paidCount;
  bool customerNotify;
  int createdAt;
  dynamic expireBy;
  String? shortUrl;
  bool hasScheduledChanges;
  dynamic changeScheduledAt;
  String source;
  int? remainingCount;
  dynamic name;
  String description;
  int amount;
  String currency;
  String period;
  bool isActive;
  String userId;
  dynamic userImage;
  dynamic userName;
  bool isShared;
  bool isTrial;
  dynamic originalAmount;

  PurchaseModel({
    required this.id,
    required this.entity,
    required this.planId,
    required this.planName,
    required this.status,
    required this.currentStart,
    required this.currentEnd,
    required this.endedAt,
    required this.quantity,
    required this.notes,
    required this.chargeAt,
    required this.startAt,
    required this.endAt,
    required this.authAttempts,
    required this.totalCount,
    required this.paidCount,
    required this.customerNotify,
    required this.createdAt,
    required this.expireBy,
    required this.shortUrl,
    required this.hasScheduledChanges,
    required this.changeScheduledAt,
    required this.source,
    required this.remainingCount,
    required this.name,
    required this.description,
    required this.amount,
    required this.currency,
    required this.period,
    required this.isActive,
    required this.userId,
    required this.userImage,
    required this.userName,
    required this.isShared,
    required this.isTrial,
    required this.originalAmount,
  });

  factory PurchaseModel.fromJson(Map<String, dynamic> json) => PurchaseModel(
        id: json["id"],
        entity: json["entity"],
        planId: json["plan_id"],
        planName: json["planName"],
        status: json["status"],
        currentStart: json["current_start"],
        currentEnd: json["current_end"],
        endedAt: json["ended_at"],
        quantity: json["quantity"],
        notes: Notes.fromJson(json["notes"]),
        chargeAt: json["charge_at"],
        startAt: json["start_at"],
        endAt: json["end_at"],
        authAttempts: json["auth_attempts"],
        totalCount: json["total_count"],
        paidCount: json["paid_count"],
        customerNotify: json["customer_notify"],
        createdAt: json["created_at"],
        expireBy: json["expire_by"],
        shortUrl: json["short_url"],
        hasScheduledChanges: json["has_scheduled_changes"],
        changeScheduledAt: json["change_scheduled_at"],
        source: json["source"],
        remainingCount: json["remaining_count"],
        name: json["name"],
        description: json["description"],
        amount: json["amount"],
        currency: json["currency"],
        period: json["period"],
        isActive: json["isActive"],
        userId: json["userId"],
        userImage: json["userImage"],
        userName: json["userName"],
        isShared: json["isShared"],
        isTrial: json["isTrial"],
        originalAmount: json["originalAmount"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "entity": entity,
        "plan_id": planId,
        "planName": planName,
        "status": status,
        "current_start": currentStart,
        "current_end": currentEnd,
        "ended_at": endedAt,
        "quantity": quantity,
        "notes": notes.toJson(),
        "charge_at": chargeAt,
        "start_at": startAt,
        "end_at": endAt,
        "auth_attempts": authAttempts,
        "total_count": totalCount,
        "paid_count": paidCount,
        "customer_notify": customerNotify,
        "created_at": createdAt,
        "expire_by": expireBy,
        "short_url": shortUrl,
        "has_scheduled_changes": hasScheduledChanges,
        "change_scheduled_at": changeScheduledAt,
        "source": source,
        "remaining_count": remainingCount,
        "name": name,
        "description": description,
        "amount": amount,
        "currency": currency,
        "period": period,
        "isActive": isActive,
        "userId": userId,
        "userImage": userImage,
        "userName": userName,
        "isShared": isShared,
        "isTrial": isTrial,
        "originalAmount": originalAmount,
      };
}

class Notes {
  String? notesKey1;
  String? notesKey2;

  Notes({
    required this.notesKey1,
    required this.notesKey2,
  });

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
  String status;
  String message;
  int totalRecords;

  Status({
    required this.status,
    required this.message,
    required this.totalRecords,
  });

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
