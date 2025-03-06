class Datum {
  String? id;
  String? authorId;
  String? authorName;
  String? authorImage;
  String? publisherId;
  dynamic publisherName;
  String? categoryId;
  String? subcategoryId;
  String? categoryName;
  String? categoryImage;
  dynamic subcategoryName;
  String? title;
  String? caption;
  String? image;
  String? info;
  int? price;
  String? publishDate;
  bool? isPublished;
  bool? isPaid;
  String? totalAudioDuration;
  DateTime? createdDate;
  DateTime? modifiedDate;
  String? createdBy;
  String? modifiedBy;
  bool? isActive;
  bool? isDeleted;
  dynamic bookImage;
  int? saveCount;
  int? rating;
  int? listenCount;
  int? downloadCount;
  bool? isFavorite;
  bool? isSaved;
  int? chapterCount;
  bool? isPodcast;

  Datum({
    this.id,
    this.authorId,
    this.authorName,
    this.authorImage,
    this.publisherId,
    this.publisherName,
    this.categoryId,
    this.subcategoryId,
    this.categoryName,
    this.categoryImage,
    this.subcategoryName,
    this.title,
    this.caption,
    this.image,
    this.info,
    this.price,
    this.publishDate,
    this.isPublished,
    this.isPaid,
    this.totalAudioDuration,
    this.createdDate,
    this.modifiedDate,
    this.createdBy,
    this.modifiedBy,
    this.isActive,
    this.isDeleted,
    this.bookImage,
    this.saveCount,
    this.rating,
    this.listenCount,
    this.downloadCount,
    this.isFavorite,
    this.isSaved,
    this.chapterCount,
    this.isPodcast,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json['_id'] as String?,
        authorId: json['authorId'] as String?,
        authorName: json['authorName'] as String?,
        authorImage: json['authorImage'] as String?,
        publisherId: json['publisherId'] as String?,
        publisherName: json['publisherName'] as dynamic,
        categoryId: json['categoryId'] as String?,
        subcategoryId: json['subcategoryId'] as String?,
        categoryName: json['categoryName'] as String?,
        categoryImage: json['categoryImage'] as String?,
        subcategoryName: json['subcategoryName'] as dynamic,
        title: json['title'] as String?,
        caption: json['caption'] as String?,
        image: json['image'] as String?,
        info: json['info'] as String?,
        price: json['price'] as int?,
        publishDate: json['publishDate'] as String?,
        isPublished: json['isPublished'] as bool?,
        isPaid: json['isPaid'] as bool?,
        totalAudioDuration: json['totalAudioDuration'] as String?,
        createdDate: json['createdDate'] == null
            ? null
            : DateTime.parse(json['createdDate'] as String),
        modifiedDate: json['modifiedDate'] == null
            ? null
            : DateTime.parse(json['modifiedDate'] as String),
        createdBy: json['createdBy'] as String?,
        modifiedBy: json['modifiedBy'] as String?,
        isActive: json['isActive'] as bool?,
        isDeleted: json['isDeleted'] as bool?,
        bookImage: json['bookImage'] as dynamic,
        saveCount: json['saveCount'] as int?,
        rating: json["rating"] == null || json["rating"] == 0
            ? 0
            : int.parse(json["rating"].round().toString()),
        listenCount: json['listenCount'] as int?,
        downloadCount: json['downloadCount'] as int?,
        isFavorite: json['isFavorite'] as bool?,
        isSaved: json['isSaved'] as bool?,
        chapterCount: json['chapterCount'] as int?,
        isPodcast: json['isPodcast'] as bool?,
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'authorId': authorId,
        'authorName': authorName,
        'authorImage': authorImage,
        'publisherId': publisherId,
        'publisherName': publisherName,
        'categoryId': categoryId,
        'subcategoryId': subcategoryId,
        'categoryName': categoryName,
        'categoryImage': categoryImage,
        'subcategoryName': subcategoryName,
        'title': title,
        'caption': caption,
        'image': image,
        'info': info,
        'price': price,
        'publishDate': publishDate,
        'isPublished': isPublished,
        'isPaid': isPaid,
        'totalAudioDuration': totalAudioDuration,
        'createdDate': createdDate?.toIso8601String(),
        'modifiedDate': modifiedDate?.toIso8601String(),
        'createdBy': createdBy,
        'modifiedBy': modifiedBy,
        'isActive': isActive,
        'isDeleted': isDeleted,
        'bookImage': bookImage,
        'saveCount': saveCount,
        'rating': rating,
        'listenCount': listenCount,
        'downloadCount': downloadCount,
        'isFavorite': isFavorite,
        'isSaved': isSaved,
        'chapterCount': chapterCount,
        'isPodcast': isPodcast,
      };
}
