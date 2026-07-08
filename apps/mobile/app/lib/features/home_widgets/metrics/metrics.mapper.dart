// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'metrics.dart';

class MetricPayloadMapper extends ClassMapperBase<MetricPayload> {
  MetricPayloadMapper._();

  static MetricPayloadMapper? _instance;
  static MetricPayloadMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MetricPayloadMapper._());
      ChartDataMapper.ensureInitialized();
      StatDataMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'MetricPayload';

  static List<ChartData> _$chartData(MetricPayload v) => v.chartData;
  static const Field<MetricPayload, List<ChartData>> _f$chartData = Field(
    'chartData',
    _$chartData,
  );
  static StatData _$statData(MetricPayload v) => v.statData;
  static const Field<MetricPayload, StatData> _f$statData = Field(
    'statData',
    _$statData,
  );
  static bool _$canBeShown(MetricPayload v) => v.canBeShown;
  static const Field<MetricPayload, bool> _f$canBeShown = Field(
    'canBeShown',
    _$canBeShown,
  );

  @override
  final MappableFields<MetricPayload> fields = const {
    #chartData: _f$chartData,
    #statData: _f$statData,
    #canBeShown: _f$canBeShown,
  };

  static MetricPayload _instantiate(DecodingData data) {
    return MetricPayload(
      chartData: data.dec(_f$chartData),
      statData: data.dec(_f$statData),
      canBeShown: data.dec(_f$canBeShown),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static MetricPayload fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MetricPayload>(map);
  }

  static MetricPayload fromJson(String json) {
    return ensureInitialized().decodeJson<MetricPayload>(json);
  }
}

mixin MetricPayloadMappable {
  String toJson() {
    return MetricPayloadMapper.ensureInitialized().encodeJson<MetricPayload>(
      this as MetricPayload,
    );
  }

  Map<String, dynamic> toMap() {
    return MetricPayloadMapper.ensureInitialized().encodeMap<MetricPayload>(
      this as MetricPayload,
    );
  }

  MetricPayloadCopyWith<MetricPayload, MetricPayload, MetricPayload>
  get copyWith => _MetricPayloadCopyWithImpl<MetricPayload, MetricPayload>(
    this as MetricPayload,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return MetricPayloadMapper.ensureInitialized().stringifyValue(
      this as MetricPayload,
    );
  }

  @override
  bool operator ==(Object other) {
    return MetricPayloadMapper.ensureInitialized().equalsValue(
      this as MetricPayload,
      other,
    );
  }

  @override
  int get hashCode {
    return MetricPayloadMapper.ensureInitialized().hashValue(
      this as MetricPayload,
    );
  }
}

extension MetricPayloadValueCopy<$R, $Out>
    on ObjectCopyWith<$R, MetricPayload, $Out> {
  MetricPayloadCopyWith<$R, MetricPayload, $Out> get $asMetricPayload =>
      $base.as((v, t, t2) => _MetricPayloadCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class MetricPayloadCopyWith<$R, $In extends MetricPayload, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, ChartData, ChartDataCopyWith<$R, ChartData, ChartData>>
  get chartData;
  StatDataCopyWith<$R, StatData, StatData> get statData;
  $R call({List<ChartData>? chartData, StatData? statData, bool? canBeShown});
  MetricPayloadCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _MetricPayloadCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MetricPayload, $Out>
    implements MetricPayloadCopyWith<$R, MetricPayload, $Out> {
  _MetricPayloadCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MetricPayload> $mapper =
      MetricPayloadMapper.ensureInitialized();
  @override
  ListCopyWith<$R, ChartData, ChartDataCopyWith<$R, ChartData, ChartData>>
  get chartData => ListCopyWith(
    $value.chartData,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(chartData: v),
  );
  @override
  StatDataCopyWith<$R, StatData, StatData> get statData =>
      $value.statData.copyWith.$chain((v) => call(statData: v));
  @override
  $R call({List<ChartData>? chartData, StatData? statData, bool? canBeShown}) =>
      $apply(
        FieldCopyWithData({
          if (chartData != null) #chartData: chartData,
          if (statData != null) #statData: statData,
          if (canBeShown != null) #canBeShown: canBeShown,
        }),
      );
  @override
  MetricPayload $make(CopyWithData data) => MetricPayload(
    chartData: data.get(#chartData, or: $value.chartData),
    statData: data.get(#statData, or: $value.statData),
    canBeShown: data.get(#canBeShown, or: $value.canBeShown),
  );

  @override
  MetricPayloadCopyWith<$R2, MetricPayload, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _MetricPayloadCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class ChartDataMapper extends ClassMapperBase<ChartData> {
  ChartDataMapper._();

  static ChartDataMapper? _instance;
  static ChartDataMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ChartDataMapper._());
      ChartPointMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'ChartData';

  static String _$colorLight(ChartData v) => v.colorLight;
  static const Field<ChartData, String> _f$colorLight = Field(
    'colorLight',
    _$colorLight,
  );
  static String _$colorDark(ChartData v) => v.colorDark;
  static const Field<ChartData, String> _f$colorDark = Field(
    'colorDark',
    _$colorDark,
  );
  static List<ChartPoint> _$points(ChartData v) => v.points;
  static const Field<ChartData, List<ChartPoint>> _f$points = Field(
    'points',
    _$points,
  );
  static bool _$isDashed(ChartData v) => v.isDashed;
  static const Field<ChartData, bool> _f$isDashed = Field(
    'isDashed',
    _$isDashed,
  );

  @override
  final MappableFields<ChartData> fields = const {
    #colorLight: _f$colorLight,
    #colorDark: _f$colorDark,
    #points: _f$points,
    #isDashed: _f$isDashed,
  };

  static ChartData _instantiate(DecodingData data) {
    return ChartData(
      colorLight: data.dec(_f$colorLight),
      colorDark: data.dec(_f$colorDark),
      points: data.dec(_f$points),
      isDashed: data.dec(_f$isDashed),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ChartData fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ChartData>(map);
  }

  static ChartData fromJson(String json) {
    return ensureInitialized().decodeJson<ChartData>(json);
  }
}

mixin ChartDataMappable {
  String toJson() {
    return ChartDataMapper.ensureInitialized().encodeJson<ChartData>(
      this as ChartData,
    );
  }

  Map<String, dynamic> toMap() {
    return ChartDataMapper.ensureInitialized().encodeMap<ChartData>(
      this as ChartData,
    );
  }

  ChartDataCopyWith<ChartData, ChartData, ChartData> get copyWith =>
      _ChartDataCopyWithImpl<ChartData, ChartData>(
        this as ChartData,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return ChartDataMapper.ensureInitialized().stringifyValue(
      this as ChartData,
    );
  }

  @override
  bool operator ==(Object other) {
    return ChartDataMapper.ensureInitialized().equalsValue(
      this as ChartData,
      other,
    );
  }

  @override
  int get hashCode {
    return ChartDataMapper.ensureInitialized().hashValue(this as ChartData);
  }
}

extension ChartDataValueCopy<$R, $Out> on ObjectCopyWith<$R, ChartData, $Out> {
  ChartDataCopyWith<$R, ChartData, $Out> get $asChartData =>
      $base.as((v, t, t2) => _ChartDataCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ChartDataCopyWith<$R, $In extends ChartData, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, ChartPoint, ChartPointCopyWith<$R, ChartPoint, ChartPoint>>
  get points;
  $R call({
    String? colorLight,
    String? colorDark,
    List<ChartPoint>? points,
    bool? isDashed,
  });
  ChartDataCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _ChartDataCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ChartData, $Out>
    implements ChartDataCopyWith<$R, ChartData, $Out> {
  _ChartDataCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ChartData> $mapper =
      ChartDataMapper.ensureInitialized();
  @override
  ListCopyWith<$R, ChartPoint, ChartPointCopyWith<$R, ChartPoint, ChartPoint>>
  get points => ListCopyWith(
    $value.points,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(points: v),
  );
  @override
  $R call({
    String? colorLight,
    String? colorDark,
    List<ChartPoint>? points,
    bool? isDashed,
  }) => $apply(
    FieldCopyWithData({
      if (colorLight != null) #colorLight: colorLight,
      if (colorDark != null) #colorDark: colorDark,
      if (points != null) #points: points,
      if (isDashed != null) #isDashed: isDashed,
    }),
  );
  @override
  ChartData $make(CopyWithData data) => ChartData(
    colorLight: data.get(#colorLight, or: $value.colorLight),
    colorDark: data.get(#colorDark, or: $value.colorDark),
    points: data.get(#points, or: $value.points),
    isDashed: data.get(#isDashed, or: $value.isDashed),
  );

  @override
  ChartDataCopyWith<$R2, ChartData, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ChartDataCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class ChartPointMapper extends ClassMapperBase<ChartPoint> {
  ChartPointMapper._();

  static ChartPointMapper? _instance;
  static ChartPointMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ChartPointMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'ChartPoint';

  static int _$x(ChartPoint v) => v.x;
  static const Field<ChartPoint, int> _f$x = Field('x', _$x);
  static int _$y(ChartPoint v) => v.y;
  static const Field<ChartPoint, int> _f$y = Field('y', _$y);

  @override
  final MappableFields<ChartPoint> fields = const {#x: _f$x, #y: _f$y};

  static ChartPoint _instantiate(DecodingData data) {
    return ChartPoint(data.dec(_f$x), data.dec(_f$y));
  }

  @override
  final Function instantiate = _instantiate;

  static ChartPoint fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ChartPoint>(map);
  }

  static ChartPoint fromJson(String json) {
    return ensureInitialized().decodeJson<ChartPoint>(json);
  }
}

mixin ChartPointMappable {
  String toJson() {
    return ChartPointMapper.ensureInitialized().encodeJson<ChartPoint>(
      this as ChartPoint,
    );
  }

  Map<String, dynamic> toMap() {
    return ChartPointMapper.ensureInitialized().encodeMap<ChartPoint>(
      this as ChartPoint,
    );
  }

  ChartPointCopyWith<ChartPoint, ChartPoint, ChartPoint> get copyWith =>
      _ChartPointCopyWithImpl<ChartPoint, ChartPoint>(
        this as ChartPoint,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return ChartPointMapper.ensureInitialized().stringifyValue(
      this as ChartPoint,
    );
  }

  @override
  bool operator ==(Object other) {
    return ChartPointMapper.ensureInitialized().equalsValue(
      this as ChartPoint,
      other,
    );
  }

  @override
  int get hashCode {
    return ChartPointMapper.ensureInitialized().hashValue(this as ChartPoint);
  }
}

extension ChartPointValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ChartPoint, $Out> {
  ChartPointCopyWith<$R, ChartPoint, $Out> get $asChartPoint =>
      $base.as((v, t, t2) => _ChartPointCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class ChartPointCopyWith<$R, $In extends ChartPoint, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({int? x, int? y});
  ChartPointCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _ChartPointCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ChartPoint, $Out>
    implements ChartPointCopyWith<$R, ChartPoint, $Out> {
  _ChartPointCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ChartPoint> $mapper =
      ChartPointMapper.ensureInitialized();
  @override
  $R call({int? x, int? y}) =>
      $apply(FieldCopyWithData({if (x != null) #x: x, if (y != null) #y: y}));
  @override
  ChartPoint $make(CopyWithData data) =>
      ChartPoint(data.get(#x, or: $value.x), data.get(#y, or: $value.y));

  @override
  ChartPointCopyWith<$R2, ChartPoint, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ChartPointCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class StatDataMapper extends ClassMapperBase<StatData> {
  StatDataMapper._();

  static StatDataMapper? _instance;
  static StatDataMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = StatDataMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'StatData';

  static String _$title(StatData v) => v.title;
  static const Field<StatData, String> _f$title = Field('title', _$title);
  static String _$value(StatData v) => v.value;
  static const Field<StatData, String> _f$value = Field('value', _$value);
  static String _$textColor(StatData v) => v.textColor;
  static const Field<StatData, String> _f$textColor = Field(
    'textColor',
    _$textColor,
  );
  static String _$backgroundColor(StatData v) => v.backgroundColor;
  static const Field<StatData, String> _f$backgroundColor = Field(
    'backgroundColor',
    _$backgroundColor,
  );

  @override
  final MappableFields<StatData> fields = const {
    #title: _f$title,
    #value: _f$value,
    #textColor: _f$textColor,
    #backgroundColor: _f$backgroundColor,
  };

  static StatData _instantiate(DecodingData data) {
    return StatData(
      title: data.dec(_f$title),
      value: data.dec(_f$value),
      textColor: data.dec(_f$textColor),
      backgroundColor: data.dec(_f$backgroundColor),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static StatData fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<StatData>(map);
  }

  static StatData fromJson(String json) {
    return ensureInitialized().decodeJson<StatData>(json);
  }
}

mixin StatDataMappable {
  String toJson() {
    return StatDataMapper.ensureInitialized().encodeJson<StatData>(
      this as StatData,
    );
  }

  Map<String, dynamic> toMap() {
    return StatDataMapper.ensureInitialized().encodeMap<StatData>(
      this as StatData,
    );
  }

  StatDataCopyWith<StatData, StatData, StatData> get copyWith =>
      _StatDataCopyWithImpl<StatData, StatData>(
        this as StatData,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return StatDataMapper.ensureInitialized().stringifyValue(this as StatData);
  }

  @override
  bool operator ==(Object other) {
    return StatDataMapper.ensureInitialized().equalsValue(
      this as StatData,
      other,
    );
  }

  @override
  int get hashCode {
    return StatDataMapper.ensureInitialized().hashValue(this as StatData);
  }
}

extension StatDataValueCopy<$R, $Out> on ObjectCopyWith<$R, StatData, $Out> {
  StatDataCopyWith<$R, StatData, $Out> get $asStatData =>
      $base.as((v, t, t2) => _StatDataCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class StatDataCopyWith<$R, $In extends StatData, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? title,
    String? value,
    String? textColor,
    String? backgroundColor,
  });
  StatDataCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _StatDataCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, StatData, $Out>
    implements StatDataCopyWith<$R, StatData, $Out> {
  _StatDataCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<StatData> $mapper =
      StatDataMapper.ensureInitialized();
  @override
  $R call({
    String? title,
    String? value,
    String? textColor,
    String? backgroundColor,
  }) => $apply(
    FieldCopyWithData({
      if (title != null) #title: title,
      if (value != null) #value: value,
      if (textColor != null) #textColor: textColor,
      if (backgroundColor != null) #backgroundColor: backgroundColor,
    }),
  );
  @override
  StatData $make(CopyWithData data) => StatData(
    title: data.get(#title, or: $value.title),
    value: data.get(#value, or: $value.value),
    textColor: data.get(#textColor, or: $value.textColor),
    backgroundColor: data.get(#backgroundColor, or: $value.backgroundColor),
  );

  @override
  StatDataCopyWith<$R2, StatData, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _StatDataCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

