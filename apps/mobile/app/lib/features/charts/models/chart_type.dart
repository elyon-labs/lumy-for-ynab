enum ChartType { line, bar, pie }

extension ChartTypeX on ChartType {
  String get label {
    switch (this) {
      case ChartType.line:
        return 'Line';
      case ChartType.bar:
        return 'Bar';
      case ChartType.pie:
        return 'Pie';
    }
  }
}
