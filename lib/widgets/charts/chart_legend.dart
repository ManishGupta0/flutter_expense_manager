import 'package:flutter/material.dart';
import 'package:flutter_expense_manager/utils/chart_utils.dart';
import 'package:flutter_expense_manager/utils/widget_utils.dart';

class ChartLegend extends StatelessWidget {
  const ChartLegend({
    Key? key,
    this.foregroundColor,
    required this.data,
    this.showCheckBox = true,
    this.showIcon = true,
    this.showTotal = true,
    this.showPercentage = true,
    this.onUpdate,
  }) : super(key: key);

  final Color? foregroundColor;
  final ChartData data;
  final bool showCheckBox;
  final bool showIcon;
  final bool showTotal;
  final bool showPercentage;
  final void Function()? onUpdate;

  @override
  Widget build(BuildContext context) {
    List<double?> totals = [];
    List<double?> percentages = [];

    double total = data.datas.fold(
      0.0,
      (previousValue, element) {
        if (element.show) {
          return previousValue + element.datas.first.y;
        }
        return previousValue;
      },
    );

    for (var item in data.datas) {
      if (item.show) {
        if (showTotal) {
          totals.add(item.datas.first.y);
        } else {
          totals.add(null);
        }

        if (showPercentage) {
          percentages.add(item.datas.first.y / total * 100);
        } else {
          percentages.add(null);
        }
      } else {
        totals.add(null);
        percentages.add(null);
      }
    }

    int index = -1;

    return Column(
      children: [
        ...data.datas.map(
          (e) {
            index += 1;
            return ChartLegendItem(
              foregroundColor: foregroundColor,
              item: e,
              showCheckBox: showCheckBox,
              showIcon: showIcon,
              total: totals.elementAt(index),
              percentage: percentages.elementAt(index),
              onUpdate: onUpdate,
            );
          },
        ),
      ],
    );
  }
}

class ChartLegendItem extends StatefulWidget {
  const ChartLegendItem({
    Key? key,
    required this.item,
    this.foregroundColor,
    required this.showCheckBox,
    this.showIcon = true,
    this.total,
    this.percentage,
    this.onUpdate,
  }) : super(key: key);

  final Color? foregroundColor;
  final SingleChartItem item;
  final bool showCheckBox;
  final bool showIcon;
  final double? total;
  final double? percentage;
  final void Function()? onUpdate;

  @override
  State<ChartLegendItem> createState() => _ChartLegendItemState();
}

class _ChartLegendItemState extends State<ChartLegendItem> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: !(widget.showCheckBox && widget.showIcon)
          ? null
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.showCheckBox)
                  Checkbox(
                    value: widget.item.show,
                    fillColor: MaterialStateProperty.all(widget.item.color),
                    onChanged: (value) {
                      setState(() {
                        widget.item.show = value!;
                        if (widget.onUpdate != null) {
                          widget.onUpdate!();
                        }
                      });
                    },
                  ),

                //--
                if (widget.showIcon)
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.item.color,
                    ),
                    child: const Icon(Icons.category, size: 20),
                  ),
                if (widget.item.color != null) horizontalSpace(4),
              ],
            ),
      title: Text(
        widget.item.title,
        style: TextStyle(
          color: widget.foregroundColor,
          fontSize: 12,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.total != null && widget.item.show)
            Text(widget.total!.toStringAsFixed(2)),

          if (widget.total != null &&
              widget.percentage != null &&
              widget.item.show)
            const Text(" - "),

          //--
          if (widget.percentage != null && widget.item.show)
            Text("${widget.percentage!.toStringAsFixed(2)} %"),
        ],
      ),
      onTap: () {
        setState(() {
          widget.item.show = !widget.item.show;
          if (widget.onUpdate != null) {
            widget.onUpdate!();
          }
        });
      },
    );
  }
}
