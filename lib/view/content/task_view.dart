import 'package:arie/controller/geolocation.dart';
import 'package:arie/controller/img_process.dart';
import 'package:arie/controller/task_fetch.dart';
import 'package:arie/controller/task_local.dart';
import 'package:arie/model/checkpoint.dart';
import 'package:arie/model/task.dart';
import 'package:arie/view/content/graph_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:slide_countdown_clock/slide_countdown_clock.dart';
import 'package:timeago/timeago.dart' as timeago;

class TaskView extends StatefulWidget {
  // Convert task into Future
  final Task task;
  final bool isAssigned;

  TaskView(this.task, {this.isAssigned = false});

  @override
  _TaskViewState createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  Task task;
  final GlobalKey<_MapViewState> _mapKey = GlobalKey();

  @override
  initState() {
    super.initState();
    task = widget.task;
  }

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
      padding: EdgeInsets.symmetric(horizontal: 10),
    );
  }

  Widget _infoCard(String title, Widget body) {
    return Container(
      constraints: BoxConstraints(maxWidth: 550),
      child: Card(
        margin: EdgeInsets.all(6),
        child: ListTile(
          title: _titleText(title),
          subtitle: Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: body,
          ),
        ),
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
          'Task ended', Center(child: Text(timeago.format(task.endTime))));
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
              'by ${task.creatorName}',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            )
          ],
        ),
        actions: <Widget>[
          Builder(
            builder: (context) => (widget.isAssigned
                ? FlatButton.icon(
                    label: Text('Delete'),
                    icon: Icon(Icons.delete),
                    onPressed: () async {
                      final bool confirmDelete = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Are you sure ?'),
                          content: Text(
                              'You are deleting task in local. This action is irreversible!'),
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
                        try {
                          await taskDB.deleteTask(task.toBasicTask());
                          Navigator.of(context).pop();
                          TaskFetch.instance.unsubscribe(task.id);
                        } catch (e) {
                          Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text('Something is not right'),
                            behavior: SnackBarBehavior.floating,
                          ));
                        }
                      } else {
                        return;
                      }
                    },
                  )
                : FlatButton.icon(
                    label: Text('Get'),
                    icon: Icon(Icons.file_download),
                    onPressed: () async {
                      if (await taskDB.isTaskExist(task.id))
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text('${task.name} was already added'),
                          behavior: SnackBarBehavior.floating,
                        ));
                      else
                        try {
                          await taskDB.insertTask(task.toBasicTask());
                          TaskFetch.instance.subscribe(task.id);
                          Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text('Added ${task.name}'),
                            behavior: SnackBarBehavior.floating,
                          ));
                          Navigator.pop(context);
                        } catch (e) {
                          Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text('Something is not right: $e'),
                            behavior: SnackBarBehavior.floating,
                          ));
                        }
                    },
                  )),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: <Widget>[
            if (widget.isAssigned)
              _infoCard(
                'Completion',
                task.getTimeline.isEmpty
                    ? Center(
                        child: Text('You have not done anything yet'),
                      )
                    : AspectRatio(
                        // TODO: Fix not working graph
                        aspectRatio: 2.5,
                        child: GraphView(
                          startTime: task.startTime,
                          endTime: task.endTime,
                          totalTask: task.checkpoints.length,
                          timeline: task.getTimeline,
                        ),
                      ),
              ),
            _renderClock(),
            MapView(
              task.checkpoints,
              task.doneSubtask,
              key: _mapKey,
            ),
            _infoCard('Description', _bodyText(task.description)),
          ],
        ),
      ),
      floatingActionButton: (widget.isAssigned
          ? Builder(
              builder: (context) {
                return FloatingActionButton(
                  child: Icon(Icons.camera),
                  onPressed: () async {
                    // TODO: [High] Switch to ModalProgressHUD
                    final pw =
                        ProgressDialog(context, ProgressDialogType.Normal);
                    try {
                      if (task.doneSubtask == task.checkpoints.length) {
                        throw 'All task were completed.';
                      }
                      final current = task.checkpoints[task.doneSubtask];

                      final now = DateTime.now();
                      if (now.isBefore(task.startTime)) {
                        throw 'Please wait before the task start.';
                      } else if (now.isAfter(task.endTime)) {
                        throw 'Task has already ended.';
                      }

                      pw.show();
                      final location = await getLocation();
                      final distance = getDistance(location, current.location);
                      if (distance > 10) {
                        throw 'You are too far away from site.';
                      }

                      // TODO: [Low] Handle edge case of ImagePicker.
                      // See https://pub.dev/packages/image_picker#handling-mainactivity-destruction-on-android
                      final img = await ImagePicker.pickImage(
                        imageQuality: 80,
                        source: ImageSource.camera,
                      );
                      if (img == null) {
                        pw.hide();
                        return;
                      }
                      Widget resultWidget;
                      try {
                        final List<String> res =
                            await imgProcess(img.path, mode: current.type);
                        if (res.isEmpty) {
                          resultWidget = ListTile(
                            leading: Icon(Icons.warning, color: Colors.yellow),
                            title: Text('Nothing is found'),
                          );
                        }
                        if (res.any((x) => x == current.label)) {
                          setState(() {
                            task.checkpoints[task.doneSubtask].doneTime =
                                DateTime.now().toUtc();
                            task.doneSubtask += 1;
                          });
                          // Update current checkpoint
                          await taskDB.updateTask(task.toBasicTask());
                          _mapKey.currentState.increase();

                          resultWidget = ListTile(
                            leading: Icon(Icons.check, color: Colors.green),
                            title: Text('Correct answer'),
                          );
                        } else {
                          resultWidget = ListTile(
                            leading: Icon(Icons.close, color: Colors.red),
                            title: Text('Wrong answer'),
                            subtitle: Text('$res'),
                          );
                        }
                      } catch (e) {
                        resultWidget = ListTile(
                          leading: Icon(Icons.sentiment_dissatisfied,
                              color: Colors.grey),
                          title: Text('Something is not right'),
                        );
                      }
                      pw.hide();
                      await showModalBottomSheet(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(16),
                            ),
                          ),
                          isScrollControlled: false,
                          context: context,
                          builder: (context) => resultWidget);
                      if (task.doneSubtask == task.checkpoints.length)
                        await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Congratulations'),
                            content:
                                Text('All tasks were completed. Well done.'),
                            actions: <Widget>[
                              FlatButton(
                                child: Text('Okay'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              )
                            ],
                          ),
                        );
                    } catch (e) {
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text(e is String ? e : 'Unknown error'),
                        behavior: SnackBarBehavior.floating,
                      ));
                    }
                  },
                );
              },
            )
          : null),
    );
  }
}

class MapView extends StatefulWidget {
  final List<Checkpoint> checkpoints;
  final int doneSubtask;
  final MapController _mapController;
  final PageController _pageController;

  MapView(this.checkpoints, this.doneSubtask,
      {MapController mapController, PageController pageController, Key key})
      : assert(checkpoints.length > 0),
        _mapController = mapController ?? MapController(),
        _pageController =
            pageController ?? PageController(viewportFraction: 0.8),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  // In place of doneSubtask
  int done;

  @override
  void initState() {
    super.initState();
    done = widget.doneSubtask;
  }

  void increase() {
    if (done < widget.checkpoints.length) {
      final newIdx = done + 1;
      if (newIdx < widget.checkpoints.length)
        widget._pageController.jumpToPage(newIdx);
      setState(() {
        done = newIdx;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final centerLoc = widget
        .checkpoints[done < widget.checkpoints.length ? done : done - 1]
        .location;

    List<Marker> markerList = <Marker>[];
    for (int i = 0; i < widget.checkpoints.length; i++) {
      final x = widget.checkpoints[i];
      markerList.add(
        Marker(
          width: 40,
          height: 40,
          point: x.location,
          builder: (context) => Container(
            alignment: Alignment.topCenter,
            child: IconButton(
              icon: Icon(Icons.location_on),
              color: Colors.red,
              iconSize: 40,
              onPressed: () {
                widget._pageController.jumpToPage(i);
              },
            ),
          ),
        ),
      );
    }

    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height / 2,
          child: FlutterMap(
            options: MapOptions(center: centerLoc, zoom: 12),
            mapController: widget._mapController,
            layers: [
              // TODO: [Low] Change map provider
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
          height: 100,
          padding: EdgeInsets.symmetric(vertical: 4),
          child: PageView.builder(
            controller: widget._pageController,
            itemCount: widget.checkpoints.length,
            physics: BouncingScrollPhysics(),
            onPageChanged: (int index) {
              widget._mapController.move(
                widget.checkpoints[index].location,
                widget._mapController.zoom,
              );
            },
            itemBuilder: (context, index) {
              final item = widget.checkpoints[index];
              return Container(
                padding: EdgeInsets.all(4),
                alignment: Alignment.bottomCenter,
                child: Card(
                  child: ListTile(
                    leading: SizedBox.fromSize(
                      size: Size.square(36),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          (index + 1).toString(),
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                    ),
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
                      widget._mapController
                          .move(item.location, widget._mapController.zoom);
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
                    trailing: (done > index
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
