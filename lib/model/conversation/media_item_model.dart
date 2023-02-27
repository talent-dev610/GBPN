class MediaItemModel {
  final String? url, mimeType;

  MediaItemModel({this.url, this.mimeType});

  factory MediaItemModel.fromJson(Map<String, dynamic> json) {
    return MediaItemModel(url: json['url'], mimeType: json['mime_type']);
  }
}