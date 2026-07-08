// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'month_response.dart';

class MonthResponseMapper extends ClassMapperBase<MonthResponse> {
  MonthResponseMapper._();

  static MonthResponseMapper? _instance;
  static MonthResponseMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MonthResponseMapper._());
      MonthDataMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'MonthResponse';

  static MonthData _$data(MonthResponse v) => v.data;
  static const Field<MonthResponse, MonthData> _f$data = Field('data', _$data);

  @override
  final MappableFields<MonthResponse> fields = const {#data: _f$data};

  static MonthResponse _instantiate(DecodingData data) {
    return MonthResponse(data: data.dec(_f$data));
  }

  @override
  final Function instantiate = _instantiate;

  static MonthResponse fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MonthResponse>(map);
  }

  static MonthResponse fromJson(String json) {
    return ensureInitialized().decodeJson<MonthResponse>(json);
  }
}

mixin MonthResponseMappable {
  String toJson() {
    return MonthResponseMapper.ensureInitialized().encodeJson<MonthResponse>(this as MonthResponse);
  }

  Map<String, dynamic> toMap() {
    return MonthResponseMapper.ensureInitialized().encodeMap<MonthResponse>(this as MonthResponse);
  }

  MonthResponseCopyWith<MonthResponse, MonthResponse, MonthResponse> get copyWith =>
      _MonthResponseCopyWithImpl(this as MonthResponse, $identity, $identity);
  @override
  String toString() {
    return MonthResponseMapper.ensureInitialized().stringifyValue(this as MonthResponse);
  }

  @override
  bool operator ==(Object other) {
    return MonthResponseMapper.ensureInitialized().equalsValue(this as MonthResponse, other);
  }

  @override
  int get hashCode {
    return MonthResponseMapper.ensureInitialized().hashValue(this as MonthResponse);
  }
}

extension MonthResponseValueCopy<$R, $Out> on ObjectCopyWith<$R, MonthResponse, $Out> {
  MonthResponseCopyWith<$R, MonthResponse, $Out> get $asMonthResponse =>
      $base.as((v, t, t2) => _MonthResponseCopyWithImpl(v, t, t2));
}

abstract class MonthResponseCopyWith<$R, $In extends MonthResponse, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  MonthDataCopyWith<$R, MonthData, MonthData> get data;
  $R call({MonthData? data});
  MonthResponseCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _MonthResponseCopyWithImpl<$R, $Out> extends ClassCopyWithBase<$R, MonthResponse, $Out>
    implements MonthResponseCopyWith<$R, MonthResponse, $Out> {
  _MonthResponseCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MonthResponse> $mapper = MonthResponseMapper.ensureInitialized();
  @override
  MonthDataCopyWith<$R, MonthData, MonthData> get data =>
      $value.data.copyWith.$chain((v) => call(data: v));
  @override
  $R call({MonthData? data}) => $apply(FieldCopyWithData({if (data != null) #data: data}));
  @override
  MonthResponse $make(CopyWithData data) => MonthResponse(data: data.get(#data, or: $value.data));

  @override
  MonthResponseCopyWith<$R2, MonthResponse, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _MonthResponseCopyWithImpl($value, $cast, t);
}

class MonthDataMapper extends ClassMapperBase<MonthData> {
  MonthDataMapper._();

  static MonthDataMapper? _instance;
  static MonthDataMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MonthDataMapper._());
      SingleMonthMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'MonthData';

  static SingleMonth _$month(MonthData v) => v.month;
  static const Field<MonthData, SingleMonth> _f$month = Field('month', _$month);

  @override
  final MappableFields<MonthData> fields = const {#month: _f$month};

  static MonthData _instantiate(DecodingData data) {
    return MonthData(month: data.dec(_f$month));
  }

  @override
  final Function instantiate = _instantiate;

  static MonthData fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MonthData>(map);
  }

  static MonthData fromJson(String json) {
    return ensureInitialized().decodeJson<MonthData>(json);
  }
}

mixin MonthDataMappable {
  String toJson() {
    return MonthDataMapper.ensureInitialized().encodeJson<MonthData>(this as MonthData);
  }

  Map<String, dynamic> toMap() {
    return MonthDataMapper.ensureInitialized().encodeMap<MonthData>(this as MonthData);
  }

  MonthDataCopyWith<MonthData, MonthData, MonthData> get copyWith =>
      _MonthDataCopyWithImpl(this as MonthData, $identity, $identity);
  @override
  String toString() {
    return MonthDataMapper.ensureInitialized().stringifyValue(this as MonthData);
  }

  @override
  bool operator ==(Object other) {
    return MonthDataMapper.ensureInitialized().equalsValue(this as MonthData, other);
  }

  @override
  int get hashCode {
    return MonthDataMapper.ensureInitialized().hashValue(this as MonthData);
  }
}

extension MonthDataValueCopy<$R, $Out> on ObjectCopyWith<$R, MonthData, $Out> {
  MonthDataCopyWith<$R, MonthData, $Out> get $asMonthData =>
      $base.as((v, t, t2) => _MonthDataCopyWithImpl(v, t, t2));
}

abstract class MonthDataCopyWith<$R, $In extends MonthData, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  SingleMonthCopyWith<$R, SingleMonth, SingleMonth> get month;
  $R call({SingleMonth? month});
  MonthDataCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _MonthDataCopyWithImpl<$R, $Out> extends ClassCopyWithBase<$R, MonthData, $Out>
    implements MonthDataCopyWith<$R, MonthData, $Out> {
  _MonthDataCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MonthData> $mapper = MonthDataMapper.ensureInitialized();
  @override
  SingleMonthCopyWith<$R, SingleMonth, SingleMonth> get month =>
      $value.month.copyWith.$chain((v) => call(month: v));
  @override
  $R call({SingleMonth? month}) => $apply(FieldCopyWithData({if (month != null) #month: month}));
  @override
  MonthData $make(CopyWithData data) => MonthData(month: data.get(#month, or: $value.month));

  @override
  MonthDataCopyWith<$R2, MonthData, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _MonthDataCopyWithImpl($value, $cast, t);
}

class SingleMonthMapper extends ClassMapperBase<SingleMonth> {
  SingleMonthMapper._();

  static SingleMonthMapper? _instance;
  static SingleMonthMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SingleMonthMapper._());
      CategoryMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'SingleMonth';

  static String _$month(SingleMonth v) => v.month;
  static const Field<SingleMonth, String> _f$month = Field('month', _$month);
  static String? _$note(SingleMonth v) => v.note;
  static const Field<SingleMonth, String> _f$note = Field('note', _$note);
  static int _$income(SingleMonth v) => v.income;
  static const Field<SingleMonth, int> _f$income = Field('income', _$income);
  static int _$budgeted(SingleMonth v) => v.budgeted;
  static const Field<SingleMonth, int> _f$budgeted = Field('budgeted', _$budgeted);
  static int _$activity(SingleMonth v) => v.activity;
  static const Field<SingleMonth, int> _f$activity = Field('activity', _$activity);
  static int _$toBeBudgeted(SingleMonth v) => v.toBeBudgeted;
  static const Field<SingleMonth, int> _f$toBeBudgeted = Field(
    'toBeBudgeted',
    _$toBeBudgeted,
    key: 'to_be_budgeted',
  );
  static int? _$ageOfMoney(SingleMonth v) => v.ageOfMoney;
  static const Field<SingleMonth, int> _f$ageOfMoney = Field(
    'ageOfMoney',
    _$ageOfMoney,
    key: 'age_of_money',
  );
  static bool _$isDeleted(SingleMonth v) => v.isDeleted;
  static const Field<SingleMonth, bool> _f$isDeleted = Field(
    'isDeleted',
    _$isDeleted,
    key: 'deleted',
  );
  static List<Category> _$categories(SingleMonth v) => v.categories;
  static const Field<SingleMonth, List<Category>> _f$categories = Field('categories', _$categories);

  @override
  final MappableFields<SingleMonth> fields = const {
    #month: _f$month,
    #note: _f$note,
    #income: _f$income,
    #budgeted: _f$budgeted,
    #activity: _f$activity,
    #toBeBudgeted: _f$toBeBudgeted,
    #ageOfMoney: _f$ageOfMoney,
    #isDeleted: _f$isDeleted,
    #categories: _f$categories,
  };

  static SingleMonth _instantiate(DecodingData data) {
    return SingleMonth(
      month: data.dec(_f$month),
      note: data.dec(_f$note),
      income: data.dec(_f$income),
      budgeted: data.dec(_f$budgeted),
      activity: data.dec(_f$activity),
      toBeBudgeted: data.dec(_f$toBeBudgeted),
      ageOfMoney: data.dec(_f$ageOfMoney),
      isDeleted: data.dec(_f$isDeleted),
      categories: data.dec(_f$categories),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static SingleMonth fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SingleMonth>(map);
  }

  static SingleMonth fromJson(String json) {
    return ensureInitialized().decodeJson<SingleMonth>(json);
  }
}

mixin SingleMonthMappable {
  String toJson() {
    return SingleMonthMapper.ensureInitialized().encodeJson<SingleMonth>(this as SingleMonth);
  }

  Map<String, dynamic> toMap() {
    return SingleMonthMapper.ensureInitialized().encodeMap<SingleMonth>(this as SingleMonth);
  }

  SingleMonthCopyWith<SingleMonth, SingleMonth, SingleMonth> get copyWith =>
      _SingleMonthCopyWithImpl(this as SingleMonth, $identity, $identity);
  @override
  String toString() {
    return SingleMonthMapper.ensureInitialized().stringifyValue(this as SingleMonth);
  }

  @override
  bool operator ==(Object other) {
    return SingleMonthMapper.ensureInitialized().equalsValue(this as SingleMonth, other);
  }

  @override
  int get hashCode {
    return SingleMonthMapper.ensureInitialized().hashValue(this as SingleMonth);
  }
}

extension SingleMonthValueCopy<$R, $Out> on ObjectCopyWith<$R, SingleMonth, $Out> {
  SingleMonthCopyWith<$R, SingleMonth, $Out> get $asSingleMonth =>
      $base.as((v, t, t2) => _SingleMonthCopyWithImpl(v, t, t2));
}

abstract class SingleMonthCopyWith<$R, $In extends SingleMonth, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, Category, CategoryCopyWith<$R, Category, Category>> get categories;
  $R call({
    String? month,
    String? note,
    int? income,
    int? budgeted,
    int? activity,
    int? toBeBudgeted,
    int? ageOfMoney,
    bool? isDeleted,
    List<Category>? categories,
  });
  SingleMonthCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _SingleMonthCopyWithImpl<$R, $Out> extends ClassCopyWithBase<$R, SingleMonth, $Out>
    implements SingleMonthCopyWith<$R, SingleMonth, $Out> {
  _SingleMonthCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SingleMonth> $mapper = SingleMonthMapper.ensureInitialized();
  @override
  ListCopyWith<$R, Category, CategoryCopyWith<$R, Category, Category>> get categories =>
      ListCopyWith($value.categories, (v, t) => v.copyWith.$chain(t), (v) => call(categories: v));
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
    List<Category>? categories,
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
      if (categories != null) #categories: categories,
    }),
  );
  @override
  SingleMonth $make(CopyWithData data) => SingleMonth(
    month: data.get(#month, or: $value.month),
    note: data.get(#note, or: $value.note),
    income: data.get(#income, or: $value.income),
    budgeted: data.get(#budgeted, or: $value.budgeted),
    activity: data.get(#activity, or: $value.activity),
    toBeBudgeted: data.get(#toBeBudgeted, or: $value.toBeBudgeted),
    ageOfMoney: data.get(#ageOfMoney, or: $value.ageOfMoney),
    isDeleted: data.get(#isDeleted, or: $value.isDeleted),
    categories: data.get(#categories, or: $value.categories),
  );

  @override
  SingleMonthCopyWith<$R2, SingleMonth, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _SingleMonthCopyWithImpl($value, $cast, t);
}
