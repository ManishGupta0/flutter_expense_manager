import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_expense_manager/utils/chart_utils.dart';
import 'package:flutter_expense_manager/widgets/charts/chart_legend.dart';

class MyLineChart extends StatefulWidget {
  const MyLineChart({
    Key? key,
    this.minX,
    this.maxX,
    this.minY,
    this.maxY,
    this.bottomLabels,
    required this.data,
  }) : super(key: key);

  final double? minX;
  final double? maxX;
  final double? minY;
  final double? maxY;
  final List<String>? bottomLabels;
  final ChartData data;

  @override
  State<MyLineChart> createState() => _MyLineChartState();
}

class _MyLineChartState extends State<MyLineChart> {
  @override
  Widget build(BuildContext context) {
    // var _minX = data.datas.isEmpty
    //     ? 0.0
    //     : minX ??
    //         data.datas.fold<double>(
    //           double.infinity,
    //           (previousValue, element) => min(previousValue, element.x),
    //         );
    // var _maxX = data.datas.isEmpty
    //     ? 100.0
    //     : maxX ??
    //         data.datas.fold<double>(
    //           -double.infinity,
    //           (previousValue, element) => max(previousValue, element.x),
    //         );

    // var _minY = data.datas.isEmpty
    //     ? 0.0
    //     : minY ??
    //         data.datas.fold<double>(
    //           double.infinity,
    //           (previousValue, element) => min(previousValue, element.y),
    //         );

    var minY = widget.data.datas.fold(
      double.infinity,
      (previousValue, element) {
        return min(
          previousValue as double,
          element.datas.fold(
            double.infinity,
            (previousValue, element) => min(previousValue as double, element.y),
          ),
        );
      },
    );
    var maxY = widget.data.datas.fold(
      -double.infinity,
      (previousValue, element) {
        return max(
          previousValue as double,
          element.datas.fold(
            -double.infinity,
            (previousValue, element) => max(previousValue as double, element.y),
          ),
        );
      },
    );

    var n = pow(10, log(maxY) ~/ ln10);
    maxY = ((maxY / n) + 0.5) * n;

    return Column(
      children: [
        AspectRatio(
          aspectRatio: 1.23,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: LineChart(
              LineChartData(
                // minX: _minX,
                // maxX: _maxX,
                minY: min(0.0, minY),
                maxY: maxY,
                lineTouchData: LineTouchData(
                  handleBuiltInTouches: true,
                  touchTooltipData: LineTouchTooltipData(
                    tooltipBgColor: Colors.black.withOpacity(0.5),
                    getTooltipItems: (values) {
                      return values
                          .map((e) => LineTooltipItem(
                              "${e.x}, ${e.y}", const TextStyle()))
                          .toList();
                    },
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  verticalInterval: 1,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.grey.withAlpha(100),
                    strokeWidth: 1,
                  ),
                  getDrawingVerticalLine: (value) => FlLine(
                    color: Colors.grey.withAlpha(100),
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        String text = meta.formattedValue;
                        if (widget.data.xAxis != null) {
                          text = widget.data.xAxis!.elementAt(value.toInt());
                        }
                        return Text(
                          text,
                          style: const TextStyle(fontSize: 8),
                        );
                      },
                    ),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: ((value, meta) => Text(
                            meta.formattedValue,
                            style: const TextStyle(fontSize: 10),
                          )),
                    ),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: const Border(
                    bottom: BorderSide(color: Colors.grey),
                    left: BorderSide(color: Colors.grey),
                    right: BorderSide(color: Colors.transparent),
                    top: BorderSide(color: Colors.transparent),
                  ),
                ),
                lineBarsData: [
                  ...widget.data.datas.where((element) => element.show).map(
                    (item) {
                      return LineChartBarData(
                        isCurved: true,
                        isStrokeCapRound: true,
                        dotData: FlDotData(show: false),
                        color: item.color,
                        preventCurveOverShooting: true,
                        spots: [
                          ...item.datas.map((e) => FlSpot(e.x, e.y)),
                        ],
                      );
                    },
                  ).toList(),
                ],
              ),
            ),
          ),
        ),
        ChartLegend(
          // foregroundColor: widget.foregroundColor,
          data: widget.data,
          showTotal: false,
          showPercentage: false,
          onUpdate: () {
            setState(() {});
          },
        ),
      ],
    );
  }
}
