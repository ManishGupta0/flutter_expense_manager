import 'package:flutter/material.dart';

class ChartData {
  ChartData({
    required this.datas,
  });

  List<SingleChartItem> datas;
  late List<String>? xAxis;
}

class SingleChartItem {
  SingleChartItem(
      {required this.title, required this.color, required this.datas});

  final String title;
  final Color color;
  final List<ChartPoint> datas;
  bool show = true;
}

class ChartPoint {
  const ChartPoint(this.x, this.y);

  final double x;
  final double y;
}

class ChartUtils {
  static ChartData reduceElements(ChartData data) {
    Map<String, SingleChartItem> finalDataMap = {};

    for (var d in data.datas) {
      if (finalDataMap.containsKey(d.title)) {
        finalDataMap[d.title]!.datas.addAll(d.datas);
        Map<double, double> points = {};
        for (var a in finalDataMap[d.title]!.datas) {
          if (points.containsKey(a.x)) {
            points[a.x] = points[a.x]! + a.y;
          } else {
            points[a.x] = a.y;
          }
        }
        finalDataMap[d.title]!.datas.clear();
        for (var p in points.entries) {
          finalDataMap[d.title]!.datas.add(ChartPoint(p.key, p.value));
        }
      } else {
        finalDataMap[d.title] = d;
      }
    }

    return ChartData(datas: finalDataMap.values.toList());
  }
}
