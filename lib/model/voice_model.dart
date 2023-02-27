class VoiceModel {
  String? id, caller, url, fileUrl;
  DateTime? date;
  int? duration;

  VoiceModel({this.id, this.caller, this.url, this.fileUrl, this.date, this.duration});

  factory VoiceModel.fromJson(Map<String, dynamic> json) {
    return VoiceModel(
      id: json['id'],
      date: DateTime.parse(json['date']),
      caller: json['caller'],
      url: json['url'],
      duration: json['duration'],
      fileUrl: json['file_url']
    );
  }
}