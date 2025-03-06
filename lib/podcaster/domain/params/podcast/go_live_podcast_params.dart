class GoLivePodcastParams {
  String? episodeId;
  String? podcastId;
  String? podcastName;
  String? episodeName;
  String? podcastImage;

  GoLivePodcastParams({
    this.episodeId,
    this.podcastId,
    this.podcastName,
    this.episodeName,
    this.podcastImage,
  });

  factory GoLivePodcastParams.fromJson(Map<String, dynamic> json) {
    return GoLivePodcastParams(
      episodeId: json['episodeId'] as String?,
      podcastId: json['podcastId'] as String?,
      podcastName: json['podcast-name'] as String?,
      episodeName: json['episode-name'] as String?,
      podcastImage: json['podcast-image'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'episodeId': episodeId,
        'podcastId': podcastId,
        'podcast-name': podcastName,
        'episode-name': episodeName,
        'podcast-image': podcastImage,
      };
}
