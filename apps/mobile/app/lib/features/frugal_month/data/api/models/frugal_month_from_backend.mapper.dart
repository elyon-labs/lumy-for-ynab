// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'frugal_month_from_backend.dart';

class FrugalMonthFromBackendMapper
    extends ClassMapperBase<FrugalMonthFromBackend> {
  FrugalMonthFromBackendMapper._();

  static FrugalMonthFromBackendMapper? _instance;
  static FrugalMonthFromBackendMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FrugalMonthFromBackendMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'FrugalMonthFromBackend';

  static String _$id(FrugalMonthFromBackend v) => v.id;
  static const Field<FrugalMonthFromBackend, String> _f$id = Field('id', _$id);
  static String _$budgetId(FrugalMonthFromBackend v) => v.budgetId;
  static const Field<FrugalMonthFromBackend, String> _f$budgetId = Field(
    'budgetId',
    _$budgetId,
    key: r'budget_id',
  );
  static LocalDate _$month(FrugalMonthFromBackend v) => v.month;
  static const Field<FrugalMonthFromBackend, LocalDate> _f$month = Field(
    'month',
    _$month,
  );
  static int _$targetAmount(FrugalMonthFromBackend v) => v.targetAmount;
  static const Field<FrugalMonthFromBackend, int> _f$targetAmount = Field(
    'targetAmount',
    _$targetAmount,
    key: r'target_amount',
  );

  @override
  final MappableFields<FrugalMonthFromBackend> fields = const {
    #id: _f$id,
    #budgetId: _f$budgetId,
    #month: _f$month,
    #targetAmount: _f$targetAmount,
  };

  static FrugalMonthFromBackend _instantiate(DecodingData data) {
    return FrugalMonthFromBackend(
      id: data.dec(_f$id),
      budgetId: data.dec(_f$budgetId),
      month: data.dec(_f$month),
      targetAmount: data.dec(_f$targetAmount),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FrugalMonthFromBackend fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FrugalMonthFromBackend>(map);
  }

  static FrugalMonthFromBackend fromJson(String json) {
    return ensureInitialized().decodeJson<FrugalMonthFromBackend>(json);
  }
}

mixin FrugalMonthFromBackendMappable {
  String toJson() {
    return FrugalMonthFromBackendMapper.ensureInitialized()
        .encodeJson<FrugalMonthFromBackend>(this as FrugalMonthFromBackend);
  }

  Map<String, dynamic> toMap() {
    return FrugalMonthFromBackendMapper.ensureInitialized()
        .encodeMap<FrugalMonthFromBackend>(this as FrugalMonthFromBackend);
  }

  FrugalMonthFromBackendCopyWith<
    FrugalMonthFromBackend,
    FrugalMonthFromBackend,
    FrugalMonthFromBackend
  >
  get copyWith =>
      _FrugalMonthFromBackendCopyWithImpl<
        FrugalMonthFromBackend,
        FrugalMonthFromBackend
      >(this as FrugalMonthFromBackend, $identity, $identity);
  @override
  String toString() {
    return FrugalMonthFromBackendMapper.ensureInitialized().stringifyValue(
      this as FrugalMonthFromBackend,
    );
  }

  @override
  bool operator ==(Object other) {
    return FrugalMonthFromBackendMapper.ensureInitialized().equalsValue(
      this as FrugalMonthFromBackend,
      other,
    );
  }

  @override
  int get hashCode {
    return FrugalMonthFromBackendMapper.ensureInitialized().hashValue(
      this as FrugalMonthFromBackend,
    );
  }
}

extension FrugalMonthFromBackendValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FrugalMonthFromBackend, $Out> {
  FrugalMonthFromBackendCopyWith<$R, FrugalMonthFromBackend, $Out>
  get $asFrugalMonthFromBackend => $base.as(
    (v, t, t2) => _FrugalMonthFromBackendCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class FrugalMonthFromBackendCopyWith<
  $R,
  $In extends FrugalMonthFromBackend,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? id, String? budgetId, LocalDate? month, int? targetAmount});
  FrugalMonthFromBackendCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FrugalMonthFromBackendCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FrugalMonthFromBackend, $Out>
    implements
        FrugalMonthFromBackendCopyWith<$R, FrugalMonthFromBackend, $Out> {
  _FrugalMonthFromBackendCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FrugalMonthFromBackend> $mapper =
      FrugalMonthFromBackendMapper.ensureInitialized();
  @override
  $R call({
    String? id,
    String? budgetId,
    LocalDate? month,
    int? targetAmount,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (budgetId != null) #budgetId: budgetId,
      if (month != null) #month: month,
      if (targetAmount != null) #targetAmount: targetAmount,
    }),
  );
  @override
  FrugalMonthFromBackend $make(CopyWithData data) => FrugalMonthFromBackend(
    id: data.get(#id, or: $value.id),
    budgetId: data.get(#budgetId, or: $value.budgetId),
    month: data.get(#month, or: $value.month),
    targetAmount: data.get(#targetAmount, or: $value.targetAmount),
  );

  @override
  FrugalMonthFromBackendCopyWith<$R2, FrugalMonthFromBackend, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _FrugalMonthFromBackendCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class JoinedFrugalMonthFromBackendMapper
    extends ClassMapperBase<JoinedFrugalMonthFromBackend> {
  JoinedFrugalMonthFromBackendMapper._();

  static JoinedFrugalMonthFromBackendMapper? _instance;
  static JoinedFrugalMonthFromBackendMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = JoinedFrugalMonthFromBackendMapper._(),
      );
    }
    return _instance!;
  }

  @override
  final String id = 'JoinedFrugalMonthFromBackend';

  static String _$id(JoinedFrugalMonthFromBackend v) => v.id;
  static const Field<JoinedFrugalMonthFromBackend, String> _f$id = Field(
    'id',
    _$id,
  );
  static String _$budgetId(JoinedFrugalMonthFromBackend v) => v.budgetId;
  static const Field<JoinedFrugalMonthFromBackend, String> _f$budgetId = Field(
    'budgetId',
    _$budgetId,
    key: r'budget_id',
  );
  static LocalDate _$month(JoinedFrugalMonthFromBackend v) => v.month;
  static const Field<JoinedFrugalMonthFromBackend, LocalDate> _f$month = Field(
    'month',
    _$month,
  );
  static int _$targetAmount(JoinedFrugalMonthFromBackend v) => v.targetAmount;
  static const Field<JoinedFrugalMonthFromBackend, int> _f$targetAmount = Field(
    'targetAmount',
    _$targetAmount,
    key: r'target_amount',
  );
  static List<String> _$categoryIds(JoinedFrugalMonthFromBackend v) =>
      v.categoryIds;
  static const Field<JoinedFrugalMonthFromBackend, List<String>>
  _f$categoryIds = Field('categoryIds', _$categoryIds, key: r'category_ids');
  static List<String> _$accountIds(JoinedFrugalMonthFromBackend v) =>
      v.accountIds;
  static const Field<JoinedFrugalMonthFromBackend, List<String>> _f$accountIds =
      Field('accountIds', _$accountIds, key: r'account_ids');

  @override
  final MappableFields<JoinedFrugalMonthFromBackend> fields = const {
    #id: _f$id,
    #budgetId: _f$budgetId,
    #month: _f$month,
    #targetAmount: _f$targetAmount,
    #categoryIds: _f$categoryIds,
    #accountIds: _f$accountIds,
  };

  static JoinedFrugalMonthFromBackend _instantiate(DecodingData data) {
    return JoinedFrugalMonthFromBackend(
      id: data.dec(_f$id),
      budgetId: data.dec(_f$budgetId),
      month: data.dec(_f$month),
      targetAmount: data.dec(_f$targetAmount),
      categoryIds: data.dec(_f$categoryIds),
      accountIds: data.dec(_f$accountIds),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static JoinedFrugalMonthFromBackend fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<JoinedFrugalMonthFromBackend>(map);
  }

  static JoinedFrugalMonthFromBackend fromJson(String json) {
    return ensureInitialized().decodeJson<JoinedFrugalMonthFromBackend>(json);
  }
}

mixin JoinedFrugalMonthFromBackendMappable {
  String toJson() {
    return JoinedFrugalMonthFromBackendMapper.ensureInitialized()
        .encodeJson<JoinedFrugalMonthFromBackend>(
          this as JoinedFrugalMonthFromBackend,
        );
  }

  Map<String, dynamic> toMap() {
    return JoinedFrugalMonthFromBackendMapper.ensureInitialized()
        .encodeMap<JoinedFrugalMonthFromBackend>(
          this as JoinedFrugalMonthFromBackend,
        );
  }

  JoinedFrugalMonthFromBackendCopyWith<
    JoinedFrugalMonthFromBackend,
    JoinedFrugalMonthFromBackend,
    JoinedFrugalMonthFromBackend
  >
  get copyWith =>
      _JoinedFrugalMonthFromBackendCopyWithImpl<
        JoinedFrugalMonthFromBackend,
        JoinedFrugalMonthFromBackend
      >(this as JoinedFrugalMonthFromBackend, $identity, $identity);
  @override
  String toString() {
    return JoinedFrugalMonthFromBackendMapper.ensureInitialized()
        .stringifyValue(this as JoinedFrugalMonthFromBackend);
  }

  @override
  bool operator ==(Object other) {
    return JoinedFrugalMonthFromBackendMapper.ensureInitialized().equalsValue(
      this as JoinedFrugalMonthFromBackend,
      other,
    );
  }

  @override
  int get hashCode {
    return JoinedFrugalMonthFromBackendMapper.ensureInitialized().hashValue(
      this as JoinedFrugalMonthFromBackend,
    );
  }
}

extension JoinedFrugalMonthFromBackendValueCopy<$R, $Out>
    on ObjectCopyWith<$R, JoinedFrugalMonthFromBackend, $Out> {
  JoinedFrugalMonthFromBackendCopyWith<$R, JoinedFrugalMonthFromBackend, $Out>
  get $asJoinedFrugalMonthFromBackend => $base.as(
    (v, t, t2) => _JoinedFrugalMonthFromBackendCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class JoinedFrugalMonthFromBackendCopyWith<
  $R,
  $In extends JoinedFrugalMonthFromBackend,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get categoryIds;
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get accountIds;
  $R call({
    String? id,
    String? budgetId,
    LocalDate? month,
    int? targetAmount,
    List<String>? categoryIds,
    List<String>? accountIds,
  });
  JoinedFrugalMonthFromBackendCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _JoinedFrugalMonthFromBackendCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, JoinedFrugalMonthFromBackend, $Out>
    implements
        JoinedFrugalMonthFromBackendCopyWith<
          $R,
          JoinedFrugalMonthFromBackend,
          $Out
        > {
  _JoinedFrugalMonthFromBackendCopyWithImpl(
    super.value,
    super.then,
    super.then2,
  );

  @override
  late final ClassMapperBase<JoinedFrugalMonthFromBackend> $mapper =
      JoinedFrugalMonthFromBackendMapper.ensureInitialized();
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
    String? budgetId,
    LocalDate? month,
    int? targetAmount,
    List<String>? categoryIds,
    List<String>? accountIds,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (budgetId != null) #budgetId: budgetId,
      if (month != null) #month: month,
      if (targetAmount != null) #targetAmount: targetAmount,
      if (categoryIds != null) #categoryIds: categoryIds,
      if (accountIds != null) #accountIds: accountIds,
    }),
  );
  @override
  JoinedFrugalMonthFromBackend $make(CopyWithData data) =>
      JoinedFrugalMonthFromBackend(
        id: data.get(#id, or: $value.id),
        budgetId: data.get(#budgetId, or: $value.budgetId),
        month: data.get(#month, or: $value.month),
        targetAmount: data.get(#targetAmount, or: $value.targetAmount),
        categoryIds: data.get(#categoryIds, or: $value.categoryIds),
        accountIds: data.get(#accountIds, or: $value.accountIds),
      );

  @override
  JoinedFrugalMonthFromBackendCopyWith<$R2, JoinedFrugalMonthFromBackend, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _JoinedFrugalMonthFromBackendCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

