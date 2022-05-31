import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_expense_manager/utils/chart_utils.dart';
import 'package:flutter_expense_manager/widgets/charts/chart_legend.dart';

class MyPieChart extends StatefulWidget {
  const MyPieChart({
    Key? key,
    required this.showPercentage,
    required this.data,
  }) : super(key: key);
  final bool showPercentage;
  final ChartData data;

  @override
  State<MyPieChart> createState() => _MyPieChartState();
}

class _MyPieChartState extends State<MyPieChart> {
  int touchedIndex = -1;
  List<double?> percentages = [];

  @override
  Widget build(BuildContext context) {
    double total = widget.data.datas.fold(
      0.0,
      (previousValue, element) {
        if (element.show) {
          return previousValue + element.datas.first.y;
        }
        return previousValue;
      },
    );

    percentages.clear();
    for (var item in widget.data.datas) {
      if (item.show) {
        percentages.add(item.datas.first.y / total * 100);
      }
    }

    return Column(
      children: [
        AspectRatio(
          aspectRatio: 1.23,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: PieChart(
              PieChartData(
                pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  setState(() {
                    if (!event.isInterestedForInteractions ||
                        pieTouchResponse == null ||
                        pieTouchResponse.touchedSection == null) {
                      touchedIndex = -1;
                      return;
                    }
                    touchedIndex =
                        pieTouchResponse.touchedSection!.touchedSectionIndex;
                  });
                }),
                borderData: FlBorderData(
                  show: false,
                ),
                sectionsSpace: 2,
                centerSpaceRadius: 80,
                sections: showingSections(),
              ),
            ),
          ),
        ),
        ChartLegend(
          // foregroundColor: widget.foregroundColor,
          data: widget.data,
          showTotal: true,
          showPercentage: true,
          onUpdate: () {
            setState(() {});
          },
        ),
      ],
    );
  }

  List<PieChartSectionData> showingSections() {
    var showedData = widget.data.datas.where((element) => element.show);

    return List.generate(showedData.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 20.0 : 10.0;
      final radius = isTouched ? 60.0 : 50.0;

      return PieChartSectionData(
        color: showedData.elementAt(i).color,
        value: showedData.elementAt(i).datas[0].y,
        title: "${percentages.elementAt(i)!.toStringAsFixed(1)} %",
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      );
    });
  }
}
