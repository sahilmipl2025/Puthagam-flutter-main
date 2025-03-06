import 'datum.dart';
import 'status.dart';

class UpcomingEpisodesResponse {
  List<Datum>? data;
  Status? status;

  UpcomingEpisodesResponse({this.data, this.status});

  factory UpcomingEpisodesResponse.fromJson(Map<String, dynamic> json) {
    return UpcomingEpisodesResponse(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Datum.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: json['status'] == null
          ? null
          : Status.fromJson(json['status'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'data': data?.map((e) => e.toJson()).toList(),
        'status': status?.toJson(),
      };
}
