class CallItemModel {
  String? status,
      direction,
      forwardedFrom,
      fromCity,
      fromState,
      fromZip,
      fromCountry,
      toCity,
      toState,
      toZip,
      toCountry;
  int? duration;

  CallItemModel(
      {this.status,
      this.direction,
      this.forwardedFrom,
      this.fromCity,
      this.fromState,
      this.fromZip,
      this.fromCountry,
      this.toCity,
      this.toState,
      this.toZip,
      this.toCountry,
      this.duration});

  factory CallItemModel.fromJson(Map<String, dynamic> json) {
    return CallItemModel(
      status: json['status'],
      direction: json['direction'],
      forwardedFrom: json['forwarded_from'],
      fromCity: json['from_city'],
      fromState: json['from_state'],
      fromZip: json['from_zip'],
      fromCountry: json['from_country'],
      toCity: json['to_city'],
      toState: json['to_state'],
      toZip: json['to_zip'],
      toCountry: json['to_country'],
      duration: json['duration'],
    );
  }
}
