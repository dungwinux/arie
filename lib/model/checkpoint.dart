class Checkpoint {
  final String title;
  final String description;
  final String label;
  final String type;
  final int longitude;
  final int latitude;

  Checkpoint({
    this.title,
    this.description,
    this.label,
    this.type,
    this.latitude,
    this.longitude,
  });

  Checkpoint.fromJson(Map<String, dynamic> res)
      : title = res['title'],
        description = res['description'],
        label = res['label'],
        type = res['type'],
        latitude = res['latitude'],
        longitude = res['longitude'];

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'label': label,
        'type': type,
        'longitude': longitude,
        'latitude': latitude
      };
}
