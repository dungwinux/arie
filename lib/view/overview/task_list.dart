import 'package:arie/controller/task_local.dart';
import 'package:arie/model/database.dart';
import 'package:arie/model/task.dart';
import 'package:arie/view/content/task_view.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class TaskList extends StatefulWidget {
  TaskList({Key key}) : super(key: key);

  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  Stream<List<Task>> _data;

  @override
  void initState() {
    super.initState();
    _data = _fetchData();
  }

  void _reload() {
    setState(() {
      _data = _fetchData();
    });
  }

  // Consider switch from Stream to Future
  Stream<List<Task>> _fetchData() {
    return taskDB.watchAllTasks().map((List<BasicTask> taskList) =>
        taskList.map((BasicTask task) => Task.fromBasicTask(task)).toList());
  }

  ListTile createListTile(Task x) => ListTile(
        key: Key(x.id),
        contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
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
              builder: (context) => TaskView(x, isAssigned: true),
            ),
          );
        },
        leading: CircularPercentIndicator(
          radius: 48,
          percent: (x.percent),
          center: Text('${x.doneSubtask}/${x.checkpoints.length}'),
          animation: true,
          progressColor: Theme.of(context).accentColor,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _data,
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
                  RaisedButton(
                    color: Theme.of(context).accentColor,
                    child: Text('Retry'),
                    onPressed: _reload,
                  ),
                ],
              ),
            );

          List<Task> _formatList = snapshot.data;

          if (!snapshot.hasData || _formatList.isEmpty)
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.explore,
                    size: 100,
                    color: Colors.black38,
                  ),
                  Text(
                    'No assigned task',
                    style: TextStyle(color: Colors.black38),
                  ),
                ],
              ),
            );
          List<Task> _completedList =
              _formatList.where((x) => x.percent == 1).toList();
          List<Task> _pendingList =
              _formatList.where((x) => x.percent != 1).toList();

          _pendingList.sort((a, b) => (b.percent.compareTo(a.percent)));

          List<Widget> renderList = <Widget>[
            Container(
              constraints: BoxConstraints(maxWidth: 550),
              child: Card(
                child: Column(
                  children: _pendingList.map(createListTile).toList(),
                ),
              ),
            ),
          ];
          if (_completedList.length > 0)
            renderList.addAll([
              Padding(
                child: Text('Completed',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                padding: EdgeInsets.symmetric(vertical: 20),
              ),
              Container(
                constraints: BoxConstraints(maxWidth: 550),
                child: Card(
                  child: Column(
                    children: _completedList.map(createListTile).toList(),
                  ),
                ),
              ),
            ]);

          return Column(children: renderList);
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
