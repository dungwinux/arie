import 'package:arie/controller/geolocation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong/latlong.dart';

class LocationForm extends StatefulWidget {
  final LatLng location;
  LocationForm({this.location});
  @override
  _LocationFormState createState() => _LocationFormState();
}

class _LocationFormState extends State<LocationForm> {
  final _controller = MapController();

  LatLng get location {
    return widget.location ?? LatLng(0, 0);
  }

  void setToCurrentLocation({context}) async {
    final location = await getLocation();
    if (location != null) {
      _controller.move(location, _controller.zoom);
    } else {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Cannot get current location'),
        behavior: SnackBarBehavior.floating,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose location'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              Navigator.of(context).pop(_controller.center);
            },
          ),
        ],
      ),
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          FlutterMap(
            options: MapOptions(center: location, zoom: 10),
            mapController: _controller,
            layers: [
              TileLayerOptions(
                urlTemplate:
                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: ['a', 'b', 'c'],
              )
            ],
          ),
          Container(
              child: Icon(
            Icons.flag,
            color: Colors.blue,
            size: 36,
          )),
        ],
      ),
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton(
          child: Icon(Icons.gps_fixed),
          onPressed: () {
            setToCurrentLocation(context: context);
          },
        ),
      ),
    );
  }
}
