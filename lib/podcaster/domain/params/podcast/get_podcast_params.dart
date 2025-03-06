class GetPodcastParams {
  int? start;
  int? length;

  GetPodcastParams({this.start, this.length});

  factory GetPodcastParams.fromJson(Map<String, dynamic> json) {
    return GetPodcastParams(
      start: json['start'] as int?,
      length: json['length'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
        'start': start,
        'length': length,
      };
}
