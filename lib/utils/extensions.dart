extension StringExtension on String {
  String toTitle() {
    var splits = split(" ");
    for (var i = 0; i < splits.length; i++) {
      splits[i] =
          "${splits[i][0].toUpperCase()}${splits[i].substring(1).toLowerCase()}";
    }
    return splits.join(" ");
  }

  String? nullForEmpty() {
    return isEmpty ? null : this;
  }
}

extension DoubleExtension on double {
  double withPrecision([int n = 2]) {
    return double.parse(toStringAsFixed(n));
  }
}
