class PodcastStatusParams {
  String? autorId;
  String? podcastId;
  String? episodeId;

  PodcastStatusParams({this.autorId, this.podcastId, this.episodeId});

  factory PodcastStatusParams.fromJson(Map<String, dynamic> json) {
    return PodcastStatusParams(
      autorId: json['authorId'] as String?,
      podcastId: json['podcastId'] as String?,
      episodeId: json['episodeId'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'authorId': autorId,
        'podcastId': podcastId,
        'episodeId': episodeId,
      };
}
