import 'package:latlong/latlong.dart';

class Checkpoint {
  String title;
  String description;
  String label;
  String type;
  LatLng location;
  DateTime doneTime;

  Checkpoint({
    this.title,
    this.description,
    this.label,
    this.type,
    this.location,
    this.doneTime,
  });

  Checkpoint.fromJson(Map<String, dynamic> res)
      : title = res['title'],
        description = res['description'],
        label = res['label'],
        type = res['type'],
        location = LatLng(
          double.tryParse(res['latitude'].toString()),
          double.tryParse(res['longitude'].toString()),
        ),
        doneTime = DateTime.tryParse(res['doneTime'] ?? '');

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'label': label,
        'type': type,
        'longitude': location.longitude,
        'latitude': location.latitude,
        'doneTime': doneTime?.toUtc()?.toIso8601String(),
      };
}
