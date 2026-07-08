// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'months_response.dart';

class MonthsResponseMapper extends ClassMapperBase<MonthsResponse> {
  MonthsResponseMapper._();

  static MonthsResponseMapper? _instance;
  static MonthsResponseMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MonthsResponseMapper._());
      MonthsMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'MonthsResponse';

  static Months _$data(MonthsResponse v) => v.data;
  static const Field<MonthsResponse, Months> _f$data = Field('data', _$data);

  @override
  final MappableFields<MonthsResponse> fields = const {#data: _f$data};

  static MonthsResponse _instantiate(DecodingData data) {
    return MonthsResponse(data: data.dec(_f$data));
  }

  @override
  final Function instantiate = _instantiate;

  static MonthsResponse fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MonthsResponse>(map);
  }

  static MonthsResponse fromJson(String json) {
    return ensureInitialized().decodeJson<MonthsResponse>(json);
  }
}

mixin MonthsResponseMappable {
  String toJson() {
    return MonthsResponseMapper.ensureInitialized().encodeJson<MonthsResponse>(
      this as MonthsResponse,
    );
  }

  Map<String, dynamic> toMap() {
    return MonthsResponseMapper.ensureInitialized().encodeMap<MonthsResponse>(
      this as MonthsResponse,
    );
  }

  MonthsResponseCopyWith<MonthsResponse, MonthsResponse, MonthsResponse> get copyWith =>
      _MonthsResponseCopyWithImpl(this as MonthsResponse, $identity, $identity);
  @override
  String toString() {
    return MonthsResponseMapper.ensureInitialized().stringifyValue(this as MonthsResponse);
  }

  @override
  bool operator ==(Object other) {
    return MonthsResponseMapper.ensureInitialized().equalsValue(this as MonthsResponse, other);
  }

  @override
  int get hashCode {
    return MonthsResponseMapper.ensureInitialized().hashValue(this as MonthsResponse);
  }
}

extension MonthsResponseValueCopy<$R, $Out> on ObjectCopyWith<$R, MonthsResponse, $Out> {
  MonthsResponseCopyWith<$R, MonthsResponse, $Out> get $asMonthsResponse =>
      $base.as((v, t, t2) => _MonthsResponseCopyWithImpl(v, t, t2));
}

abstract class MonthsResponseCopyWith<$R, $In extends MonthsResponse, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  MonthsCopyWith<$R, Months, Months> get data;
  $R call({Months? data});
  MonthsResponseCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _MonthsResponseCopyWithImpl<$R, $Out> extends ClassCopyWithBase<$R, MonthsResponse, $Out>
    implements MonthsResponseCopyWith<$R, MonthsResponse, $Out> {
  _MonthsResponseCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MonthsResponse> $mapper = MonthsResponseMapper.ensureInitialized();
  @override
  MonthsCopyWith<$R, Months, Months> get data => $value.data.copyWith.$chain((v) => call(data: v));
  @override
  $R call({Months? data}) => $apply(FieldCopyWithData({if (data != null) #data: data}));
  @override
  MonthsResponse $make(CopyWithData data) => MonthsResponse(data: data.get(#data, or: $value.data));

  @override
  MonthsResponseCopyWith<$R2, MonthsResponse, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _MonthsResponseCopyWithImpl($value, $cast, t);
}

class MonthsMapper extends ClassMapperBase<Months> {
  MonthsMapper._();

  static MonthsMapper? _instance;
  static MonthsMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MonthsMapper._());
      MonthMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'Months';

  static int _$serverKnowledge(Months v) => v.serverKnowledge;
  static const Field<Months, int> _f$serverKnowledge = Field(
    'serverKnowledge',
    _$serverKnowledge,
    key: 'server_knowledge',
  );
  static List<Month> _$months(Months v) => v.months;
  static const Field<Months, List<Month>> _f$months = Field('months', _$months);

  @override
  final MappableFields<Months> fields = const {
    #serverKnowledge: _f$serverKnowledge,
    #months: _f$months,
  };

  static Months _instantiate(DecodingData data) {
    return Months(serverKnowledge: data.dec(_f$serverKnowledge), months: data.dec(_f$months));
  }

  @override
  final Function instantiate = _instantiate;

  static Months fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Months>(map);
  }

  static Months fromJson(String json) {
    return ensureInitialized().decodeJson<Months>(json);
  }
}

mixin MonthsMappable {
  String toJson() {
    return MonthsMapper.ensureInitialized().encodeJson<Months>(this as Months);
  }

  Map<String, dynamic> toMap() {
    return MonthsMapper.ensureInitialized().encodeMap<Months>(this as Months);
  }

  MonthsCopyWith<Months, Months, Months> get copyWith =>
      _MonthsCopyWithImpl(this as Months, $identity, $identity);
  @override
  String toString() {
    return MonthsMapper.ensureInitialized().stringifyValue(this as Months);
  }

  @override
  bool operator ==(Object other) {
    return MonthsMapper.ensureInitialized().equalsValue(this as Months, other);
  }

  @override
  int get hashCode {
    return MonthsMapper.ensureInitialized().hashValue(this as Months);
  }
}

extension MonthsValueCopy<$R, $Out> on ObjectCopyWith<$R, Months, $Out> {
  MonthsCopyWith<$R, Months, $Out> get $asMonths =>
      $base.as((v, t, t2) => _MonthsCopyWithImpl(v, t, t2));
}

abstract class MonthsCopyWith<$R, $In extends Months, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, Month, MonthCopyWith<$R, Month, Month>> get months;
  $R call({int? serverKnowledge, List<Month>? months});
  MonthsCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _MonthsCopyWithImpl<$R, $Out> extends ClassCopyWithBase<$R, Months, $Out>
    implements MonthsCopyWith<$R, Months, $Out> {
  _MonthsCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Months> $mapper = MonthsMapper.ensureInitialized();
  @override
  ListCopyWith<$R, Month, MonthCopyWith<$R, Month, Month>> get months =>
      ListCopyWith($value.months, (v, t) => v.copyWith.$chain(t), (v) => call(months: v));
  @override
  $R call({int? serverKnowledge, List<Month>? months}) => $apply(
    FieldCopyWithData({
      if (serverKnowledge != null) #serverKnowledge: serverKnowledge,
      if (months != null) #months: months,
    }),
  );
  @override
  Months $make(CopyWithData data) => Months(
    serverKnowledge: data.get(#serverKnowledge, or: $value.serverKnowledge),
    months: data.get(#months, or: $value.months),
  );

  @override
  MonthsCopyWith<$R2, Months, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _MonthsCopyWithImpl($value, $cast, t);
}

class MonthMapper extends ClassMapperBase<Month> {
  MonthMapper._();

  static MonthMapper? _instance;
  static MonthMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MonthMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'Month';

  static String _$month(Month v) => v.month;
  static const Field<Month, String> _f$month = Field('month', _$month);
  static String? _$note(Month v) => v.note;
  static const Field<Month, String> _f$note = Field('note', _$note);
  static int _$income(Month v) => v.income;
  static const Field<Month, int> _f$income = Field('income', _$income);
  static int _$budgeted(Month v) => v.budgeted;
  static const Field<Month, int> _f$budgeted = Field('budgeted', _$budgeted);
  static int _$activity(Month v) => v.activity;
  static const Field<Month, int> _f$activity = Field('activity', _$activity);
  static int _$toBeBudgeted(Month v) => v.toBeBudgeted;
  static const Field<Month, int> _f$toBeBudgeted = Field(
    'toBeBudgeted',
    _$toBeBudgeted,
    key: 'to_be_budgeted',
  );
  static int? _$ageOfMoney(Month v) => v.ageOfMoney;
  static const Field<Month, int> _f$ageOfMoney = Field(
    'ageOfMoney',
    _$ageOfMoney,
    key: 'age_of_money',
  );
  static bool _$isDeleted(Month v) => v.isDeleted;
  static const Field<Month, bool> _f$isDeleted = Field('isDeleted', _$isDeleted, key: 'deleted');

  @override
  final MappableFields<Month> fields = const {
    #month: _f$month,
    #note: _f$note,
    #income: _f$income,
    #budgeted: _f$budgeted,
    #activity: _f$activity,
    #toBeBudgeted: _f$toBeBudgeted,
    #ageOfMoney: _f$ageOfMoney,
    #isDeleted: _f$isDeleted,
  };

  static Month _instantiate(DecodingData data) {
    return Month(
      month: data.dec(_f$month),
      note: data.dec(_f$note),
      income: data.dec(_f$income),
      budgeted: data.dec(_f$budgeted),
      activity: data.dec(_f$activity),
      toBeBudgeted: data.dec(_f$toBeBudgeted),
      ageOfMoney: data.dec(_f$ageOfMoney),
      isDeleted: data.dec(_f$isDeleted),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static Month fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Month>(map);
  }

  static Month fromJson(String json) {
    return ensureInitialized().decodeJson<Month>(json);
  }
}

mixin MonthMappable {
  String toJson() {
    return MonthMapper.ensureInitialized().encodeJson<Month>(this as Month);
  }

  Map<String, dynamic> toMap() {
    return MonthMapper.ensureInitialized().encodeMap<Month>(this as Month);
  }

  MonthCopyWith<Month, Month, Month> get copyWith =>
      _MonthCopyWithImpl(this as Month, $identity, $identity);
  @override
  String toString() {
    return MonthMapper.ensureInitialized().stringifyValue(this as Month);
  }

  @override
  bool operator ==(Object other) {
    return MonthMapper.ensureInitialized().equalsValue(this as Month, other);
  }

  @override
  int get hashCode {
    return MonthMapper.ensureInitialized().hashValue(this as Month);
  }
}

extension MonthValueCopy<$R, $Out> on ObjectCopyWith<$R, Month, $Out> {
  MonthCopyWith<$R, Month, $Out> get $asMonth =>
      $base.as((v, t, t2) => _MonthCopyWithImpl(v, t, t2));
}

abstract class MonthCopyWith<$R, $In extends Month, $Out> implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? month,
    String? note,
    int? income,
    int? budgeted,
    int? activity,
    int? toBeBudgeted,
    int? ageOfMoney,
    bool? isDeleted,
  });
  MonthCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _MonthCopyWithImpl<$R, $Out> extends ClassCopyWithBase<$R, Month, $Out>
    implements MonthCopyWith<$R, Month, $Out> {
  _MonthCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Month> $mapper = MonthMapper.ensureInitialized();
  @override
  $R call({
    String? month,
    Object? note = $none,
    int? income,
    int? budgeted,
    int? activity,
    int? toBeBudgeted,
    Object? ageOfMoney = $none,
    bool? isDeleted,
  }) => $apply(
    FieldCopyWithData({
      if (month != null) #month: month,
      if (note != $none) #note: note,
      if (income != null) #income: income,
      if (budgeted != null) #budgeted: budgeted,
      if (activity != null) #activity: activity,
      if (toBeBudgeted != null) #toBeBudgeted: toBeBudgeted,
      if (ageOfMoney != $none) #ageOfMoney: ageOfMoney,
      if (isDeleted != null) #isDeleted: isDeleted,
    }),
  );
  @override
  Month $make(CopyWithData data) => Month(
    month: data.get(#month, or: $value.month),
    note: data.get(#note, or: $value.note),
    income: data.get(#income, or: $value.income),
    budgeted: data.get(#budgeted, or: $value.budgeted),
    activity: data.get(#activity, or: $value.activity),
    toBeBudgeted: data.get(#toBeBudgeted, or: $value.toBeBudgeted),
    ageOfMoney: data.get(#ageOfMoney, or: $value.ageOfMoney),
    isDeleted: data.get(#isDeleted, or: $value.isDeleted),
  );

  @override
  MonthCopyWith<$R2, Month, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _MonthCopyWithImpl($value, $cast, t);
}
