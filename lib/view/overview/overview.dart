import 'package:arie/view/overview/task_list.dart';
import 'package:flutter/material.dart';

class Overview extends StatefulWidget {
  Overview({Key key}) : super(key: key);

  @override
  _OverviewState createState() => _OverviewState();
}

class _OverviewState extends State<Overview> {
  List<Widget> _widgetList = [
    Greeting(),
    TaskList(),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(children: _widgetList);
  }
}

class Greeting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            'Welcome, User',
            style: TextStyle(fontSize: 20),
          ),
          CircleAvatar(child: Icon(Icons.cloud), radius: 36),
        ],
      ),
    );
  }
}
