import 'package:arie/model/checkpoint.dart';
import 'package:arie/model/task.dart';
import 'package:flutter/material.dart';
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

  Widget _checkpointsList(List<Checkpoint> checkpoints) {
    return Column(
      children: checkpoints
          .map((Checkpoint x) => ListTile(
                title: Text(x.title),
              ))
          .toList(),
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
          _infoCard('Map', _checkpointsList(task.checkpoints)),
          _infoCard('Description', _bodyText(task.description)),
        ],
      ),
    );
  }
}
