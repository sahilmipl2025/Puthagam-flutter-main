class Datum {
  String? podcastId;
  String? episodeId;
  String? speakerId;
  String? podcastName;
  String? episodeName;
  String? speakerName;
  String? speakerImage;
  String? podcastImage;
  String? startPodcast;
  String? endPodcast;

  Datum(
      {this.podcastId,
      this.episodeId,
      this.speakerId,
      this.podcastName,
      this.episodeName,
      this.speakerName,
      this.speakerImage,
      this.podcastImage,
      this.startPodcast,
      this.endPodcast});

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        podcastId: json['podcastId'] as String?,
        episodeId: json['episodeId'] as String?,
        speakerId: json['speakerId'] as String?,
        podcastName: json['podcastName'] as String?,
        episodeName: json['episodeName'] as String?,
        speakerName: json['speakerName'] as String?,
        speakerImage: json['speakerImage'] as String?,
        podcastImage: json['podcastImage'] as String?,
        startPodcast: json['startPodcast'] as String?,
        endPodcast: json['endPodcast'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'podcastId': podcastId,
        'episodeId': episodeId,
        'speakerId': speakerId,
        'podcastName': podcastName,
        'episodeName': episodeName,
        'speakerName': speakerName,
        'speakerImage': speakerImage,
        'podcastImage': podcastImage,
        'startPodcast': startPodcast,
        'endPodcast': endPodcast
      };
}
