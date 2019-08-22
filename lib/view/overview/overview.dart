import 'package:arie/view/overview/task_list.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Overview extends StatefulWidget {
  Overview({Key key}) : super(key: key);

  @override
  _OverviewState createState() => _OverviewState();
}

class _OverviewState extends State<Overview> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.amber),
      child: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
            centerTitle: true,
            title: Text('Arie'),
            pinned: true,
            expandedHeight: MediaQuery.of(context).size.height * 0.4,
            flexibleSpace: FlexibleSpaceBar(background: Greeting()),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Container(
                decoration: BoxDecoration(color: Colors.transparent),
                child: TaskList(),
              ),
              SizedBox(height: 64),
            ]),
          ),
        ],
      ),
    );
  }
}

class Greeting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(48, 100, 48, 0),
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
      Colors.white60,
      Colors.white,
    ];
    return AspectRatio(
      aspectRatio: 2.5,
      child: Opacity(
        opacity: .9,
        child: Container(
          padding: EdgeInsets.fromLTRB(
            MediaQuery.of(context).size.width * 0.1,
            MediaQuery.of(context).size.width * 0.005,
            MediaQuery.of(context).size.width / 2,
            MediaQuery.of(context).size.width * 0.005,
          ),
          child: FlChart(
            chart: LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: 5,
                minY: 0,
                maxY: 10,
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      FlSpot(0, 0),
                      FlSpot(1, 3),
                      FlSpot(2, 2),
                      FlSpot(3, 4),
                      FlSpot(4, 4),
                      FlSpot(5, 6),
                    ],
                    barWidth: 5,
                    colors: gradientColors,
                    isCurved: true,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      dotColor: Theme.of(context).accentColor,
                    ),
                    belowBarData: BelowBarData(show: false),
                  )
                ],
                lineTouchData: LineTouchData(
                  enabled: true,
                  touchTooltipData: TouchTooltipData(
                      tooltipBgColor: Theme.of(context).accentColor),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
