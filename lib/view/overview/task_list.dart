import 'package:arie/controller/task_fetch.dart';
import 'package:arie/controller/task_local.dart';
import 'package:arie/model/database.dart';
import 'package:arie/model/task.dart';
import 'package:arie/view/task_view.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class TaskList extends StatefulWidget {
  TaskList({Key key}) : super(key: key);

  @override
  _TaskListState createState() => _TaskListState();
}

// TODO: Move FutureBuilder to Overview

class _TaskListState extends State<TaskList> {
  @override
  void initState() {
    super.initState();
    // TODO: Seperate data-fetching
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return StreamBuilder(
      stream: taskDB.watchAllTasks().asyncMap(
            (List<BasicTask> task) async =>
                Future.wait(task.map((x) => TaskFetch().fetch(x.id))),
          ),
      builder: (BuildContext context, AsyncSnapshot<List<Task>> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasError)
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.sentiment_dissatisfied,
                    size: 100,
                    color: Colors.black38,
                  ),
                  Text(
                    'Something is not working: ${snapshot.error}',
                    style: TextStyle(color: Colors.black38),
                  ),
                ],
              ),
            );

          List<Task> _formatList = snapshot.data;

          if (_formatList.isEmpty)
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.sentiment_dissatisfied,
                    size: 100,
                    color: Colors.black38,
                  ),
                  Text(
                    'No result found',
                    style: TextStyle(color: Colors.black38),
                  ),
                ],
              ),
            );
          _formatList.sort((a, b) => (b.percent.compareTo(a.percent)));
          final renderList = _formatList
              .map((Task x) => ListTile(
                    title: Text(x.name),
                    subtitle: Text(
                      x.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TaskView(x),
                        ),
                      );
                    },
                    leading: CircularPercentIndicator(
                      radius: 48,
                      percent: (x.percent),
                      center: Text('${x.doneSubtask}/${x.checkpoints.length}'),
                      animation: true,
                    ),
                  ))
              .expand((x) => [Divider(), x])
              .toList()
                ..add(FlutterLogo())
                ..insert(
                    0,
                    OverallProgress(_formatList.length,
                        _formatList.where((x) => x.percent == 1).length));
          return Column(
            children: renderList,
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.sentiment_dissatisfied,
                  size: 100,
                  color: Colors.black38,
                ),
                Text(
                  'Something is wrong',
                  style: TextStyle(color: Colors.black38),
                ),
              ],
            ),
          );
      },
    );
  }
}

class OverallProgress extends StatelessWidget {
  final int progress;
  final int total;

  OverallProgress(this.total, this.progress);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: EdgeInsets.all(20),
      child: CircularPercentIndicator(
        percent: (progress / total) ?? 0,
        radius: 150,
        lineWidth: 10,
        circularStrokeCap: CircularStrokeCap.round,
        center: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              progress.toString(),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 48),
            ),
            Text('/$total tasks')
          ],
        ),
        animation: true,
      ),
    );
  }
}
