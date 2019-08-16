import 'package:latlong/latlong.dart';
import 'package:location/location.dart';

Future<LatLng> getLocation() async {
  final location = Location();
  final getPermission = await location.requestPermission();
  if (getPermission) {
    final rawLocation = await location.getLocation();
    return LatLng(
      rawLocation.latitude,
      rawLocation.longitude,
    );
  } else
    return null;
}

double getDistance(LatLng p1, LatLng p2) {
  final Distance distance = const Distance();
  return distance(p1, p2);
}
