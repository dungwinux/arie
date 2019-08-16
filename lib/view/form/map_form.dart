import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong/latlong.dart';

class LocationForm extends StatefulWidget {
  LatLng location;
  LocationForm({this.location});
  @override
  _LocationFormState createState() => _LocationFormState();
}

class _LocationFormState extends State<LocationForm> {
  final _controller = MapController();

  LatLng get locateUser {
    // final rawLatLng = Gps.currentGps();
    return widget.location ?? LatLng(0, 0);
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
            options: MapOptions(center: locateUser, zoom: 10),
            mapController: _controller,
            layers: [
              TileLayerOptions(
                urlTemplate:
                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: ['a', 'b', 'c'],
              )
            ],
          ),
          Container(child: Icon(Icons.flag, color: Colors.blue, size: 36,)),
        ],
      ),
    );
  }
}
