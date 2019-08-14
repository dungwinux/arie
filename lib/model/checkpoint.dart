import 'package:latlong/latlong.dart';

class Checkpoint {
  String title;
  String description;
  String label;
  String type;
  LatLng location;

  Checkpoint({
    this.title,
    this.description,
    this.label,
    this.type,
    this.location,
  });

  Checkpoint.fromJson(Map<String, dynamic> res)
      : title = res['title'],
        description = res['description'],
        label = res['label'],
        type = res['type'],
        location = LatLng(
          double.tryParse(res['latitude'].toString()),
          double.tryParse(res['longitude'].toString()),
        );

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'label': label,
        'type': type,
        'longitude': location.longitude,
        'latitude': location.latitude
      };
}
