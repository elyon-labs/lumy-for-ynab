import 'package:dart_mappable/dart_mappable.dart';
import 'package:design/design.dart';
import '../../../common/presentation/_color.dart';

part 'metrics.mapper.dart';

@MappableClass(caseStyle: CaseStyle.camelCase)
class MetricPayload with MetricPayloadMappable {
  MetricPayload({required this.chartData, required this.statData, required this.canBeShown});

  factory MetricPayload.empty({required String reason, required ElyonColors palette}) {
    return MetricPayload(
      canBeShown: false,
      chartData: [
        ChartData(
          colorLight: palette.primary.toHex(),
          colorDark: palette.primary.toHex(),
          points: [],
          isDashed: false,
        ),
      ],
      statData: StatData(
        title: '',
        value: reason,
        textColor: palette.onGood.toHex(),
        backgroundColor: palette.good.toHex(),
      ),
    );
  }

  final bool canBeShown;
  final List<ChartData> chartData;
  final StatData statData;
}

@MappableClass(caseStyle: CaseStyle.camelCase)
class ChartData with ChartDataMappable {
  ChartData({
    required this.colorLight,
    required this.colorDark,
    required this.points,
    required this.isDashed,
  });

  final String colorLight;
  final String colorDark;
  final List<ChartPoint> points;
  final bool isDashed;
}

@MappableClass(caseStyle: CaseStyle.camelCase)
class ChartPoint with ChartPointMappable {
  ChartPoint(this.x, this.y);

  final int x;
  final int y;
}

@MappableClass(caseStyle: CaseStyle.camelCase)
class StatData with StatDataMappable {
  StatData({
    required this.title,
    required this.value,
    required this.textColor,
    required this.backgroundColor,
  });

  final String title;
  final String value;
  final String textColor;
  final String backgroundColor;
}
