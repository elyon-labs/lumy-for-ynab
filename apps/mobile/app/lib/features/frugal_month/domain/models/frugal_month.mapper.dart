// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'frugal_month.dart';

class FrugalMonthMapper extends ClassMapperBase<FrugalMonth> {
  FrugalMonthMapper._();

  static FrugalMonthMapper? _instance;
  static FrugalMonthMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FrugalMonthMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'FrugalMonth';

  static String _$id(FrugalMonth v) => v.id;
  static const Field<FrugalMonth, String> _f$id = Field('id', _$id);
  static LocalDate _$month(FrugalMonth v) => v.month;
  static const Field<FrugalMonth, LocalDate> _f$month = Field('month', _$month);
  static String _$budgetId(FrugalMonth v) => v.budgetId;
  static const Field<FrugalMonth, String> _f$budgetId = Field(
    'budgetId',
    _$budgetId,
    key: r'budget_id',
  );
  static int _$targetAmount(FrugalMonth v) => v.targetAmount;
  static const Field<FrugalMonth, int> _f$targetAmount = Field(
    'targetAmount',
    _$targetAmount,
    key: r'target_amount',
  );
  static List<String> _$categoryIds(FrugalMonth v) => v.categoryIds;
  static const Field<FrugalMonth, List<String>> _f$categoryIds = Field(
    'categoryIds',
    _$categoryIds,
    key: r'category_ids',
  );
  static List<String> _$accountIds(FrugalMonth v) => v.accountIds;
  static const Field<FrugalMonth, List<String>> _f$accountIds = Field(
    'accountIds',
    _$accountIds,
    key: r'account_ids',
  );
  static List<Object?> _$props(FrugalMonth v) => v.props;
  static const Field<FrugalMonth, List<Object?>> _f$props = Field(
    'props',
    _$props,
    mode: FieldMode.member,
  );

  @override
  final MappableFields<FrugalMonth> fields = const {
    #id: _f$id,
    #month: _f$month,
    #budgetId: _f$budgetId,
    #targetAmount: _f$targetAmount,
    #categoryIds: _f$categoryIds,
    #accountIds: _f$accountIds,
    #props: _f$props,
  };

  static FrugalMonth _instantiate(DecodingData data) {
    return FrugalMonth(
      id: data.dec(_f$id),
      month: data.dec(_f$month),
      budgetId: data.dec(_f$budgetId),
      targetAmount: data.dec(_f$targetAmount),
      categoryIds: data.dec(_f$categoryIds),
      accountIds: data.dec(_f$accountIds),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FrugalMonth fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FrugalMonth>(map);
  }

  static FrugalMonth fromJson(String json) {
    return ensureInitialized().decodeJson<FrugalMonth>(json);
  }
}

mixin FrugalMonthMappable {
  String toJson() {
    return FrugalMonthMapper.ensureInitialized().encodeJson<FrugalMonth>(
      this as FrugalMonth,
    );
  }

  Map<String, dynamic> toMap() {
    return FrugalMonthMapper.ensureInitialized().encodeMap<FrugalMonth>(
      this as FrugalMonth,
    );
  }

  FrugalMonthCopyWith<FrugalMonth, FrugalMonth, FrugalMonth> get copyWith =>
      _FrugalMonthCopyWithImpl<FrugalMonth, FrugalMonth>(
        this as FrugalMonth,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return FrugalMonthMapper.ensureInitialized().stringifyValue(
      this as FrugalMonth,
    );
  }

  @override
  bool operator ==(Object other) {
    return FrugalMonthMapper.ensureInitialized().equalsValue(
      this as FrugalMonth,
      other,
    );
  }

  @override
  int get hashCode {
    return FrugalMonthMapper.ensureInitialized().hashValue(this as FrugalMonth);
  }
}

extension FrugalMonthValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FrugalMonth, $Out> {
  FrugalMonthCopyWith<$R, FrugalMonth, $Out> get $asFrugalMonth =>
      $base.as((v, t, t2) => _FrugalMonthCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class FrugalMonthCopyWith<$R, $In extends FrugalMonth, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get categoryIds;
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get accountIds;
  $R call({
    String? id,
    LocalDate? month,
    String? budgetId,
    int? targetAmount,
    List<String>? categoryIds,
    List<String>? accountIds,
  });
  FrugalMonthCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _FrugalMonthCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FrugalMonth, $Out>
    implements FrugalMonthCopyWith<$R, FrugalMonth, $Out> {
  _FrugalMonthCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FrugalMonth> $mapper =
      FrugalMonthMapper.ensureInitialized();
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>
  get categoryIds => ListCopyWith(
    $value.categoryIds,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(categoryIds: v),
  );
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get accountIds =>
      ListCopyWith(
        $value.accountIds,
        (v, t) => ObjectCopyWith(v, $identity, t),
        (v) => call(accountIds: v),
      );
  @override
  $R call({
    String? id,
    LocalDate? month,
    String? budgetId,
    int? targetAmount,
    List<String>? categoryIds,
    List<String>? accountIds,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (month != null) #month: month,
      if (budgetId != null) #budgetId: budgetId,
      if (targetAmount != null) #targetAmount: targetAmount,
      if (categoryIds != null) #categoryIds: categoryIds,
      if (accountIds != null) #accountIds: accountIds,
    }),
  );
  @override
  FrugalMonth $make(CopyWithData data) => FrugalMonth(
    id: data.get(#id, or: $value.id),
    month: data.get(#month, or: $value.month),
    budgetId: data.get(#budgetId, or: $value.budgetId),
    targetAmount: data.get(#targetAmount, or: $value.targetAmount),
    categoryIds: data.get(#categoryIds, or: $value.categoryIds),
    accountIds: data.get(#accountIds, or: $value.accountIds),
  );

  @override
  FrugalMonthCopyWith<$R2, FrugalMonth, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FrugalMonthCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

