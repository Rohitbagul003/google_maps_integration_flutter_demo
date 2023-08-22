class ProfileModel {
  final String? id;
  final String? title;
  final dynamic lat;
  final dynamic lang;

  ProfileModel({
    this.id,
    this.title,
    this.lat,
    this.lang,
  });

  ProfileModel.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String?,
        title = json['title'] as String?,
        lat = json['lat'] as dynamic,
        lang = json['lang'] as dynamic;

  Map<String, dynamic> toJson() => {'id': id, 'title': title, 'lat': lat, 'lang': lang};
}
