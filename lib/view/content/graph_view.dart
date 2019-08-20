import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class GraphView extends StatelessWidget {
  final List<DateTime> timeline;
  final DateTime startTime;
  final DateTime endTime;
  final int totalTask;
  GraphView({this.timeline, this.startTime, this.endTime, this.totalTask});

  DateTime get lastTime =>
      (DateTime.now().isAfter(endTime) ? endTime : DateTime.now());

  Duration get length => endTime.difference(startTime);
  List<FlSpot> dataPointGenerator() {
    // Generate
    final _timeline = timeline.where((x) => x != null).toList();
    _timeline.sort((DateTime x, DateTime y) => x.compareTo(y));
    var pointList = List.generate(_timeline.length, (index) {
      final percent = _timeline[index].difference(startTime).inMilliseconds /
          length.inMilliseconds;
      return [
        FlSpot(percent, index.toDouble()),
        FlSpot(percent, index.toDouble() + 1),
      ];
    }).expand((x) => x).toList();
    pointList.add(FlSpot(
      lastTime.difference(startTime).inMilliseconds / length.inMilliseconds,
      totalTask.toDouble(),
    ));
    return pointList;
  }

  @override
  Widget build(BuildContext context) {
    List<Color> gradientColors = [
      Color(0xff23b6e6),
      Color(0xff02d39a),
    ];
    return FlChart(
      chart: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawHorizontalGrid: false,
            getDrawingVerticalGridLine: (value) {
              return FlLine(
                color: Colors.grey.withOpacity(0.25),
                strokeWidth: 1,
              );
            },
          ),
          lineTouchData: LineTouchData(
            enabled: true,
            touchTooltipData: TouchTooltipData(
              tooltipBgColor: Colors.amberAccent.withOpacity(0.6),
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: SideTitles(showTitles: false, margin: 8),
            leftTitles: SideTitles(
              showTitles: true,
              textStyle: TextStyle(
                color: const Color(0xff67727d),
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
              getTitles: (value) {
                return value.toInt().toString();
              },
              reservedSize: 28,
              margin: 12,
            ),
          ),
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: 1,
          minY: 0,
          maxY: timeline.length.toDouble(),
          lineBarsData: [
            LineChartBarData(
              spots: dataPointGenerator(),
              colors: gradientColors,
              barWidth: 5,
              isStrokeCapRound: true,
              dotData: FlDotData(show: false),
              belowBarData: BelowBarData(
                show: true,
                colors: gradientColors
                    .map((color) => color.withOpacity(0.3))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
