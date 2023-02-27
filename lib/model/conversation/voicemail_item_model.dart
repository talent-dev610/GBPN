class VoicemailItemModel {
  String? url, fileUrl;
  int? duration;

  VoicemailItemModel({this.url, this.fileUrl, this.duration});

  factory VoicemailItemModel.fromJson(Map<String, dynamic> json) {
    return VoicemailItemModel(
      url: json['url'],
      duration: json['duration'],
      fileUrl: json['file_url']
    );
  }
}