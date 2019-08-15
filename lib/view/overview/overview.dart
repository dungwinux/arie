import 'package:arie/view/overview/task_list.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Overview extends StatefulWidget {
  Overview({Key key}) : super(key: key);

  @override
  _OverviewState createState() => _OverviewState();
}

class _OverviewState extends State<Overview> {
  List<Widget> _widgetList = [
    Greeting(),
    OverallPerformance(),
    TaskList(),
  ];

  @override
  Widget build(BuildContext context) {
    // TODO: [Medium] Adapt SliverAppBar
    return ListView(children: _widgetList);
  }
}

class Greeting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(48),
        child: Center(
          child: Text(
            'What would you like to do today ?',
            style: TextStyle(fontSize: 28),
            textAlign: TextAlign.center,
          ),
        ));
  }
}

class OverallPerformance extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: [High] Replace mock test
    List<Color> gradientColors = [
      Color(0xff23b6e6),
      Color(0xff02d39a),
    ];
    return AspectRatio(
      aspectRatio: 2,
      child: Container(
        padding: EdgeInsets.all(12),
        width: MediaQuery.of(context).size.width,
        child: FlChart(
          chart: LineChart(
            LineChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: 10,
                minY: 0,
                maxY: 10,
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      FlSpot(0, 3),
                      FlSpot(1, 2),
                      FlSpot(2, 5),
                      FlSpot(3, 3),
                      FlSpot(4, 4),
                      FlSpot(5, 9),
                      FlSpot(6, 5),
                      FlSpot(7, 3),
                      FlSpot(8, 5),
                      FlSpot(9, 4),
                      FlSpot(10, 5),
                    ],
                    colors: gradientColors,
                    isCurved: true,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: true),
                    belowBarData: BelowBarData(show: false),
                  )
                ]),
          ),
        ),
      ),
    );
  }
}
