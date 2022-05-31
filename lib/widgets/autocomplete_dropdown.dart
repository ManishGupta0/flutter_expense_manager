import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class AutocompleteOptions<T extends Object> extends StatelessWidget {
  const AutocompleteOptions({
    Key? key,
    required this.options,
    required this.maxOptionsWidth,
    required this.onSelected,
    required this.builder,
    this.maxOptionsHeight = 200.0,
  }) : super(key: key);

  final AutocompleteOnSelected<T> onSelected;

  final Iterable<T> options;
  final double maxOptionsWidth;
  final double maxOptionsHeight;
  final Widget Function(BuildContext context, T option) builder;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Material(
        elevation: 4.0,
        child: ConstrainedBox(
          constraints: BoxConstraints(
              maxHeight: maxOptionsHeight, maxWidth: maxOptionsWidth),
          child: ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: options.length,
            itemBuilder: (BuildContext context, int index) {
              final T option = options.elementAt(index);

              return InkWell(
                onTap: () {
                  onSelected(option);
                },
                child: Builder(builder: (BuildContext context) {
                  final bool highlight =
                      AutocompleteHighlightedOption.of(context) == index;
                  if (highlight) {
                    SchedulerBinding.instance
                        .addPostFrameCallback((Duration timeStamp) {
                      Scrollable.ensureVisible(context, alignment: 0.5);
                    });
                  }
                  return Container(
                    color: highlight ? Theme.of(context).focusColor : null,
                    child: builder(context, option),
                  );
                }),
              );
            },
          ),
        ),
      ),
    );
  }
}
