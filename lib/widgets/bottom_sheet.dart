import 'package:flutter/material.dart';

void showDraggableBottomSheet(
  BuildContext context, {
  Widget? child,
  Color? color,
  double initialChildSize = 0.5,
}) {
  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) => DraggableBottomSheet(
      color: color ?? Theme.of(context).cardColor,
      initialChildSize: initialChildSize,
      child: child,
    ),
  );
}

class DraggableBottomSheet extends StatelessWidget {
  final Widget? child;
  final Color? color;
  final double initialChildSize;

  const DraggableBottomSheet(
      {Key? key, this.child, this.color, this.initialChildSize = 0.5})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.of(context).pop(),
      child: GestureDetector(
        onTap: () {},
        child: DraggableScrollableSheet(
          initialChildSize: initialChildSize,
          minChildSize: 0.4,
          maxChildSize: 1,
          builder: (_, ScrollController scrollController) => Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20.0),
              ),
            ),
            child: ListView(
              controller: scrollController,
              children: [
                if (child != null) child!,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
