import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class RadialCharts extends StatefulWidget {
  final List data;

  const RadialCharts({Key? key, required this.data}) : super(key: key);

  @override
  State<RadialCharts> createState() => _RadialChartsState();
}

class _RadialChartsState extends State<RadialCharts> {
  @override
  Widget build(BuildContext context) {
    final List<RadialChartData> chartData = widget.data
        .map(
          (d) => RadialChartData(
            x: d['label'],
            y: getChartNumber(mins: d['train_time']),
            color: getColors(mins: d['train_time']),
          ),
        )
        .toList();

    return Center(
        child: SfCircularChart(series: <CircularSeries>[
      // Renders radial bar chart
      RadialBarSeries<RadialChartData, String>(
          gap: '1',
          dataSource: chartData,
          xValueMapper: (RadialChartData data, _) => data.x,
          yValueMapper: (RadialChartData data, _) => data.y)
    ]));
  }

  double getChartNumber({required int mins}) {
    return ((mins / 60) * 360);
  }

  getColors({required mins}) {
    double angle = getChartNumber(mins: mins);
    Color color = Colors.green;
    if (angle >= 160 && angle <= 260.0) {
      color = Colors.yellow;
    } else if (angle >= 1 && angle <= 159.0) {
      color = Colors.red;
    }
    return color;
  }
}

class RadialChartData {
  final String x;
  final double y;
  final Color color;
  RadialChartData({required this.x, required this.y, required this.color});
}
