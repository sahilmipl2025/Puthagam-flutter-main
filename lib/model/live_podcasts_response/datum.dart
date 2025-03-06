class Datum {
  String? authorId;
  String? authorName;
  String? authorImage;
  String? podcastId;
  String? episodeId;
  String? podcastImage;

  Datum(
      {this.authorId,
      this.authorName,
      this.authorImage,
      this.podcastId,
      this.episodeId,
      this.podcastImage});

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        authorId: json['authorId'] as String?,
        authorName: json['authorName'] as String?,
        authorImage: json['authorImage'] as String?,
        podcastId: json['podcastId'] as String?,
        episodeId: json['episodeId'] as String?,
        podcastImage: json['podcastImage'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'authorId': authorId,
        'authorName': authorName,
        'authorImage': authorImage,
        'podcastId': podcastId,
        'episodeId': episodeId,
        'podcastImage': podcastImage
      };
}
