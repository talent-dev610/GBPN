class MediaModel {
  final String url, mimeType;

  MediaModel({required this.url, required this.mimeType});

  factory MediaModel.fromJson(Map<String, dynamic> json) {
    return MediaModel(url: json['url'], mimeType: json['mime_type']);
  }
}