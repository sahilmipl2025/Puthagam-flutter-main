class Datum {
  String? id;
  String? bookId;
  int? sequenceNumber;
  String? name;
  String? content;
  dynamic audioUrl;
  String? audioDuration;
  String? createdDate;
  String? modifiedDate;
  String? createdBy;
  String? modifiedBy;
  bool? isActive;
  bool? isDeleted;
  dynamic bookAudio;
  String? startPodcast;
  String? endPodcast;
  bool? isPodcast;

  Datum({
    this.id,
    this.bookId,
    this.sequenceNumber,
    this.name,
    this.content,
    this.audioUrl,
    this.audioDuration,
    this.createdDate,
    this.modifiedDate,
    this.createdBy,
    this.modifiedBy,
    this.isActive,
    this.isDeleted,
    this.bookAudio,
    this.startPodcast,
    this.endPodcast,
    this.isPodcast,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json['_id'] as String?,
        bookId: json['bookId'] as String?,
        sequenceNumber: json['sequenceNumber'] as int?,
        name: json['name'] as String?,
        content: json['content'] as String?,
        audioUrl: json['audioUrl'] as dynamic,
        audioDuration: json['audioDuration'] as String?,
        createdDate: json['createdDate'] as String?,
        modifiedDate: json['modifiedDate'] as String?,
        createdBy: json['createdBy'] as String?,
        modifiedBy: json['modifiedBy'] as String?,
        isActive: json['isActive'] as bool?,
        isDeleted: json['isDeleted'] as bool?,
        bookAudio: json['bookAudio'] as dynamic,
        startPodcast: json['startPodcast'] as String?,
        endPodcast: json['endPodcast'] as String?,
        isPodcast: json['isPodcast'] as bool?,
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'bookId': bookId,
        'sequenceNumber': sequenceNumber,
        'name': name,
        'content': content,
        'audioUrl': audioUrl,
        'audioDuration': audioDuration,
        'createdDate': createdDate,
        'modifiedDate': modifiedDate,
        'createdBy': createdBy,
        'modifiedBy': modifiedBy,
        'isActive': isActive,
        'isDeleted': isDeleted,
        'bookAudio': bookAudio,
        'startPodcast': startPodcast,
        'endPodcast': endPodcast,
        'isPodcast': isPodcast,
      };
}
