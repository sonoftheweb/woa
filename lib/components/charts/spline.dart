import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AnimatedSplineChart extends StatefulWidget {
  final List<ChartData> chartData;
  final String? secondsOrMinutes;
  const AnimatedSplineChart({
    Key? key,
    required this.chartData,
    this.secondsOrMinutes = 's',
  }) : super(key: key);

  @override
  State<AnimatedSplineChart> createState() => _AnimatedSplineChartState();
}

class _AnimatedSplineChartState extends State<AnimatedSplineChart> {
  @override
  Widget build(BuildContext context) {
    return _buildDefaultSplineChart();
  }

  double minMaxFromChartData({String? type}) {
    List numbers = widget.chartData.map((e) => e.y).toList();
    numbers.sort();

    if (type == null || type == 'minimum') {
      return numbers.first + .0;
    } else {
      return numbers.last + .0;
    }
  }

  SfCartesianChart _buildDefaultSplineChart() {
    return SfCartesianChart(
      // Palette colors
      palette: const <Color>[Colors.white60],
      plotAreaBorderWidth: 0,
      primaryXAxis: CategoryAxis(
        majorGridLines: const MajorGridLines(width: 0),
        labelPlacement: LabelPlacement.onTicks,
        axisLine: const AxisLine(width: 0),
      ),
      primaryYAxis: NumericAxis(
        majorGridLines: MajorGridLines(
          width: 1,
          color: Colors.green.shade200,
        ),
        minimum: minMaxFromChartData(type: 'minimum'),
        maximum: minMaxFromChartData(type: 'max'),
        axisLine: const AxisLine(width: 0),
        borderColor: Colors.white,
        edgeLabelPlacement: EdgeLabelPlacement.shift,
        labelFormat: '{value} ${widget.secondsOrMinutes}',
        majorTickLines: const MajorTickLines(size: 1),
      ),
      series: _getDefaultSplineSeries(),
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }

  List<SplineAreaSeries<ChartData, String>> _getDefaultSplineSeries() {
    return <SplineAreaSeries<ChartData, String>>[
      SplineAreaSeries<ChartData, String>(
        dataSource: widget.chartData,
        splineType: SplineType.cardinal,
        cardinalSplineTension: 0.9,
        xValueMapper: (ChartData data, _) => data.x,
        yValueMapper: (ChartData data, _) => data.y,
        markerSettings: const MarkerSettings(isVisible: true),
        name: '',
      ),
    ];
  }

  @override
  void dispose() {
    widget.chartData.clear();
    super.dispose();
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final int y;
}
