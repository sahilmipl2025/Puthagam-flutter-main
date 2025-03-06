class Status {
  String? status;
  String? message;
  int? totalRecords;

  Status({this.status, this.message, this.totalRecords});

  factory Status.fromJson(Map<String, dynamic> json) => Status(
        status: json['status'] as String?,
        message: json['message'] as String?,
        totalRecords: json['totalRecords'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'totalRecords': totalRecords,
      };
}
