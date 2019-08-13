import 'package:arie/controller/img_process.dart';
import 'package:arie/controller/task_local.dart';
import 'package:arie/model/checkpoint.dart';
import 'package:arie/model/database.dart';
import 'package:arie/model/task.dart';
import 'package:arie/view/camera/camera.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:slide_countdown_clock/slide_countdown_clock.dart';
import 'package:timeago/timeago.dart' as timeago;

class TaskView extends StatelessWidget {
  // Convert task into Future
  final Task task;
  final bool isAssigned;

  TaskView(this.task, {this.isAssigned = false});

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
            shouldShowDays: true,
          ),
        ),
      );
    } else if (now.isAfter(task.endTime)) {
      return _infoCard(
          'Task ended',
          Padding(
            child: Center(child: Text(timeago.format(task.endTime))),
            padding: EdgeInsets.all(10),
          ));
    } else if (now.isAfter(task.startTime) && now.isBefore(task.endTime)) {
      return _infoCard(
        'Time left',
        Center(
          child: SlideCountdownClock(
            duration: task.endTime.difference(DateTime.now()),
            separator: ':',
            shouldShowDays: true,
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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(task.name),
            Text(
              'by ${task.creator}',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            )
          ],
        ),
        actions: <Widget>[
          if (isAssigned)
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                final bool confirmDelete = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Are you sure you want to delete ?'),
                    content: Text('The following action is irreversible!'),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                      ),
                      FlatButton(
                        child: Text('Delete'),
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                      ),
                    ],
                  ),
                );
                if (confirmDelete) {
                  taskDB.deleteTask(BasicTask(id: task.id));
                  Navigator.of(context).pop();
                } else {
                  return;
                }
              },
            ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          _renderClock(),
          MapView(task.checkpoints, task.doneSubtask),
          // _infoCard('Checkpoint map', _checkpointsList(task.checkpoints)),
          _infoCard('Description', _bodyText(task.description)),
        ],
      ),
      floatingActionButton: (isAssigned &&
              task.doneSubtask < task.checkpoints.length
          ? FloatingActionButton(
              child: Icon(Icons.camera),
              onPressed: () async {
                final imgPath = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CameraPage()),
                );
                if (imgPath == null) return;
                final Future<Widget> _futureResult =
                    mlBarcodeScan(imgPath).then((data) async {
                  final List<String> res =
                      data.map((Barcode x) => x.rawValue).toList();
                  if (res.isEmpty) {
                    return ListTile(
                      title: Text('Nothing is found'),
                    );
                  }
                  if (res.any(
                      (x) => x == task.checkpoints[task.doneSubtask].label)) {
                    await taskDB.updateTask(
                        BasicTask(id: task.id, progress: task.doneSubtask + 1));
                    return ListTile(
                      title: Text('Correct answer'),
                    );
                  } else {
                    return ListTile(
                      title: Text('Wrong answer'),
                      subtitle: Text('$res'),
                    );
                  }
                }).catchError(
                  (e) => ListTile(
                    title: Text('Something is not right'),
                  ),
                );
                showModalBottomSheet(
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(16))),
                    isScrollControlled: false,
                    context: context,
                    builder: (context) => FutureBuilder(
                          // TODO: Process different type of checkpoint
                          future: _futureResult,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              return snapshot.data;
                            } else
                              return LinearProgressIndicator();
                          },
                        ));
              },
            )
          : null),
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
  final _pageController = PageController(viewportFraction: 0.7);

  @override
  Widget build(BuildContext context) {
    // TODO: Set default page
    final idx = widget.checkpoints.length == widget.index
        ? widget.checkpoints.length - 1
        : widget.index;
    // TODO: Convert Description to StreamBuilder
    // TODO: Add last section so that PageView does not overflow

    final centerLoc = widget.checkpoints[idx].location;

    List<Marker> markerList = <Marker>[];
    for (int i = 0; i < widget.checkpoints.length; i++) {
      final x = widget.checkpoints[i];
      markerList.add(
        Marker(
          width: 45,
          height: 45,
          point: x.location,
          builder: (context) => Container(
            child: IconButton(
              icon: Icon(Icons.location_on),
              color: Colors.red,
              iconSize: 45,
              onPressed: () {
                _pageController.jumpToPage(i);
              },
            ),
          ),
        ),
      );
    }

    return Stack(
      children: <Widget>[
        Container(
          height: 300,
          child: FlutterMap(
            options: MapOptions(center: centerLoc, zoom: 12.5),
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
          height: 300,
          padding: EdgeInsets.symmetric(vertical: 20.0),
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.checkpoints.length,
            physics: BouncingScrollPhysics(),
            onPageChanged: (int index) {
              _controller.move(
                  widget.checkpoints[index].location, _controller.zoom);
            },
            itemBuilder: (context, index) {
              final item = widget.checkpoints[index];
              return Container(
                padding: EdgeInsets.all(8),
                alignment: Alignment.bottomCenter,
                child: Card(
                  child: ListTile(
                    title: Text(
                      item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      item.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () {
                      _controller.move(item.location, _controller.zoom);
                    },
                    onLongPress: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => ListTile(
                          title: Text(item.title),
                          subtitle: Text(item.description),
                        ),
                      );
                    },
                    trailing: (widget.index > index
                        ? Icon(Icons.check, color: Colors.green)
                        : null),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
