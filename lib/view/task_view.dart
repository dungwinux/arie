import 'package:arie/model/checkpoint.dart';
import 'package:arie/model/task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:slide_countdown_clock/slide_countdown_clock.dart';
import 'package:timeago/timeago.dart' as timeago;

class TaskView extends StatelessWidget {
  final Task task;

  TaskView(this.task);

  Widget _titleText(String text) {
    return Container(
      child: Text(
        text,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.left,
      ),
      padding: EdgeInsets.fromLTRB(5, 20, 5, 10),
    );
  }

  Widget _bodyText(String text) {
    return Container(
      child: Text(
        text,
        textAlign: TextAlign.justify,
      ),
      padding: EdgeInsets.fromLTRB(10, 5, 10, 25),
    );
  }

  Widget _infoCard(String title, Widget body) {
    return Card(
      margin: EdgeInsets.all(6),
      child: ListTile(
        title: _titleText(title),
        subtitle: body,
      ),
    );
  }

  Widget _renderClock() {
    var now = DateTime.now();
    if (now.isBefore(task.startTime)) {
      return _infoCard(
        'Coming soon',
        Center(
          child: SlideCountdownClock(
            duration: task.startTime.difference(DateTime.now()),
            separator: ':',
          ),
        ),
      );
    } else if (now.isAfter(task.endTime)) {
      return _infoCard(
          'Task ended', Center(child: Text(timeago.format(task.endTime))));
    } else if (now.isAfter(task.startTime) && now.isBefore(task.endTime)) {
      return _infoCard(
        'Time left',
        Center(
          child: SlideCountdownClock(
            duration: task.endTime.difference(DateTime.now()),
            separator: ':',
          ),
        ),
      );
    }
    return null;
  }

  // TODO: Add progress graph
  // TODO: Add Map for checkpoint list

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(task.name),
      ),
      body: ListView(
        children: <Widget>[
          _infoCard('Created by', _bodyText(task.creator)),
          _renderClock(),
          MapView(task.checkpoints, task.doneSubtask),
          // _infoCard('Checkpoint map', _checkpointsList(task.checkpoints)),
          _infoCard('Description', _bodyText(task.description)),
        ],
      ),
    );
  }
}

class MapView extends StatefulWidget {
  final List<Checkpoint> checkpoints;
  final int index;

  MapView(this.checkpoints, this.index)
      : assert(checkpoints.length > 0 &&
            index >= 0 &&
            index <= checkpoints.length);

  @override
  State<StatefulWidget> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  final _controller = MapController();

  @override
  Widget build(BuildContext context) {
    final idx = widget.checkpoints.length == widget.index
        ? widget.checkpoints.length - 1
        : widget.index;
    // TODO: implement build
    final centerLoc = widget.checkpoints[idx].location;
    final markerList = widget.checkpoints
        .map(
          (Checkpoint x) => Marker(
              width: 45,
              height: 45,
              point: x.location,
              builder: (context) => Container(
                    child: IconButton(
                      icon: Icon(Icons.location_on),
                      color: Colors.red,
                      iconSize: 45,
                      onPressed: () {
                        // Move to position
                        _controller.move(x.location, _controller.zoom);
                      },
                    ),
                  )),
        )
        .toList();

    return Stack(
      children: <Widget>[
        Container(
          height: 300,
          child: FlutterMap(
            options: MapOptions(center: centerLoc, zoom: 10),
            mapController: _controller,
            layers: [
              // TODO: Change map provider
              TileLayerOptions(
                urlTemplate:
                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: ['a', 'b', 'c'],
              ),
              MarkerLayerOptions(markers: markerList)
            ],
          ),
        ),
        Container(
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.checkpoints.length,
            itemBuilder: (context, index) {
              // TODO: Constraint card
              final item = widget.checkpoints[index];
              return Container(
                padding: EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width * 0.7,
                child: Card(
                  child: ListTile(
                    title: Text(item.title),
                    subtitle: Text(item.description),
                    onTap: () {
                      // Move to position
                      _controller.move(item.location, _controller.zoom);
                    },
                  ),
                ),
              );
            },
            physics: BouncingScrollPhysics(),
          ),
          alignment: Alignment.bottomCenter,
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          height: 150,
        ),
      ],
    );
  }
}
