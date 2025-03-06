import 'datum.dart';
import 'status.dart';

class LivePodcastsResponse {
  List<Datum>? data;
  Status? status;

  LivePodcastsResponse({this.data, this.status});

  factory LivePodcastsResponse.fromJson(Map<String, dynamic> json) {
    return LivePodcastsResponse(
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
