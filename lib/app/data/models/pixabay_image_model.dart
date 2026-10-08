class PixabayImageModel {
  final int id;
  final String pageURL;
  final String type;
  final String tags;
  final String previewURL;
  final int previewWidth;
  final int previewHeight;
  final String webformatURL;
  final int webformatWidth;
  final int webformatHeight;
  final String largeImageURL;
  final int imageWidth;
  final int imageHeight;
  final int imageSize;
  final int views;
  final int downloads;
  final int likes;
  final int comments;
  final int userId;
  final String user;
  final String userImageURL;

  PixabayImageModel({
    required this.id,
    required this.pageURL,
    required this.type,
    required this.tags,
    required this.previewURL,
    required this.previewWidth,
    required this.previewHeight,
    required this.webformatURL,
    required this.webformatWidth,
    required this.webformatHeight,
    required this.largeImageURL,
    required this.imageWidth,
    required this.imageHeight,
    required this.imageSize,
    required this.views,
    required this.downloads,
    required this.likes,
    required this.comments,
    required this.userId,
    required this.user,
    required this.userImageURL,
  });

  factory PixabayImageModel.fromJson(Map<String, dynamic> json) {
    return PixabayImageModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      pageURL: json['pageURL']?.toString() ?? '',
      type: json['type']?.toString() ?? 'photo',
      tags: json['tags']?.toString() ?? '',
      previewURL: json['previewURL']?.toString() ?? '',
      previewWidth: json['previewWidth'] is int
          ? json['previewWidth']
          : int.tryParse(json['previewWidth']?.toString() ?? '150') ?? 150,
      previewHeight: json['previewHeight'] is int
          ? json['previewHeight']
          : int.tryParse(json['previewHeight']?.toString() ?? '100') ?? 100,
      webformatURL: json['webformatURL']?.toString() ?? '',
      webformatWidth: json['webformatWidth'] is int
          ? json['webformatWidth']
          : int.tryParse(json['webformatWidth']?.toString() ?? '640') ?? 640,
      webformatHeight: json['webformatHeight'] is int
          ? json['webformatHeight']
          : int.tryParse(json['webformatHeight']?.toString() ?? '426') ?? 426,
      largeImageURL: json['largeImageURL']?.toString() ?? json['webformatURL']?.toString() ?? '',
      imageWidth: json['imageWidth'] is int
          ? json['imageWidth']
          : int.tryParse(json['imageWidth']?.toString() ?? '1920') ?? 1920,
      imageHeight: json['imageHeight'] is int
          ? json['imageHeight']
          : int.tryParse(json['imageHeight']?.toString() ?? '1080') ?? 1080,
      imageSize: json['imageSize'] is int
          ? json['imageSize']
          : int.tryParse(json['imageSize']?.toString() ?? '0') ?? 0,
      views: json['views'] is int
          ? json['views']
          : int.tryParse(json['views']?.toString() ?? '0') ?? 0,
      downloads: json['downloads'] is int
          ? json['downloads']
          : int.tryParse(json['downloads']?.toString() ?? '0') ?? 0,
      likes: json['likes'] is int
          ? json['likes']
          : int.tryParse(json['likes']?.toString() ?? '0') ?? 0,
      comments: json['comments'] is int
          ? json['comments']
          : int.tryParse(json['comments']?.toString() ?? '0') ?? 0,
      userId: json['user_id'] is int
          ? json['user_id']
          : int.tryParse(json['user_id']?.toString() ?? '0') ?? 0,
      user: json['user']?.toString() ?? 'Unknown Artist',
      userImageURL: json['userImageURL']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pageURL': pageURL,
      'type': type,
      'tags': tags,
      'previewURL': previewURL,
      'previewWidth': previewWidth,
      'previewHeight': previewHeight,
      'webformatURL': webformatURL,
      'webformatWidth': webformatWidth,
      'webformatHeight': webformatHeight,
      'largeImageURL': largeImageURL,
      'imageWidth': imageWidth,
      'imageHeight': imageHeight,
      'imageSize': imageSize,
      'views': views,
      'downloads': downloads,
      'likes': likes,
      'comments': comments,
      'user_id': userId,
      'user': user,
      'userImageURL': userImageURL,
    };
  }

  double get aspectRatio {
    if (webformatHeight <= 0 || webformatWidth <= 0) return 1.0;
    final ratio = webformatWidth / webformatHeight;
    // Bound the ratio to prevent extreme vertical/horizontal cards in masonry
    return ratio.clamp(0.65, 1.6);
  }

  List<String> get tagsList {
    if (tags.isEmpty) return [];
    return tags
        .split(',')
        .map((tag) => tag.trim())
        .where((tag) => tag.isNotEmpty)
        .toList();
  }
}
