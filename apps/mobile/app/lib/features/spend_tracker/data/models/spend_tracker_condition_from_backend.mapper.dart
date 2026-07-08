// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'spend_tracker_condition_from_backend.dart';

class SpendTrackerConditionFromBackendMapper
    extends ClassMapperBase<SpendTrackerConditionFromBackend> {
  SpendTrackerConditionFromBackendMapper._();

  static SpendTrackerConditionFromBackendMapper? _instance;
  static SpendTrackerConditionFromBackendMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = SpendTrackerConditionFromBackendMapper._(),
      );
    }
    return _instance!;
  }

  @override
  final String id = 'SpendTrackerConditionFromBackend';

  static String _$spendTrackerId(SpendTrackerConditionFromBackend v) =>
      v.spendTrackerId;
  static const Field<SpendTrackerConditionFromBackend, String>
  _f$spendTrackerId = Field(
    'spendTrackerId',
    _$spendTrackerId,
    key: r'spend_tracker_id',
  );
  static String _$spendTrackerName(SpendTrackerConditionFromBackend v) =>
      v.spendTrackerName;
  static const Field<SpendTrackerConditionFromBackend, String>
  _f$spendTrackerName = Field(
    'spendTrackerName',
    _$spendTrackerName,
    key: r'spend_tracker_name',
  );
  static DateTime _$spendTrackerCreatedAt(SpendTrackerConditionFromBackend v) =>
      v.spendTrackerCreatedAt;
  static const Field<SpendTrackerConditionFromBackend, DateTime>
  _f$spendTrackerCreatedAt = Field(
    'spendTrackerCreatedAt',
    _$spendTrackerCreatedAt,
    key: r'spend_tracker_created_at',
  );
  static String? _$spendTrackerNickname(SpendTrackerConditionFromBackend v) =>
      v.spendTrackerNickname;
  static const Field<SpendTrackerConditionFromBackend, String>
  _f$spendTrackerNickname = Field(
    'spendTrackerNickname',
    _$spendTrackerNickname,
    key: r'spend_tracker_nickname',
    opt: true,
  );
  static String _$budgetId(SpendTrackerConditionFromBackend v) => v.budgetId;
  static const Field<SpendTrackerConditionFromBackend, String> _f$budgetId =
      Field('budgetId', _$budgetId, key: r'budget_id');
  static String _$userId(SpendTrackerConditionFromBackend v) => v.userId;
  static const Field<SpendTrackerConditionFromBackend, String> _f$userId =
      Field('userId', _$userId, key: r'user_id');
  static String _$conditionId(SpendTrackerConditionFromBackend v) =>
      v.conditionId;
  static const Field<SpendTrackerConditionFromBackend, String> _f$conditionId =
      Field('conditionId', _$conditionId, key: r'condition_id');
  static String? _$parentId(SpendTrackerConditionFromBackend v) => v.parentId;
  static const Field<SpendTrackerConditionFromBackend, String> _f$parentId =
      Field('parentId', _$parentId, key: r'parent_id', opt: true);
  static String _$conditionType(SpendTrackerConditionFromBackend v) =>
      v.conditionType;
  static const Field<SpendTrackerConditionFromBackend, String>
  _f$conditionType = Field(
    'conditionType',
    _$conditionType,
    key: r'condition_type',
  );
  static String? _$testId(SpendTrackerConditionFromBackend v) => v.testId;
  static const Field<SpendTrackerConditionFromBackend, String> _f$testId =
      Field('testId', _$testId, key: r'test_id', opt: true);
  static String? _$testType(SpendTrackerConditionFromBackend v) => v.testType;
  static const Field<SpendTrackerConditionFromBackend, String> _f$testType =
      Field('testType', _$testType, key: r'test_type', opt: true);
  static String? _$testValue(SpendTrackerConditionFromBackend v) => v.testValue;
  static const Field<SpendTrackerConditionFromBackend, String> _f$testValue =
      Field('testValue', _$testValue, key: r'test_value', opt: true);
  static int _$depth(SpendTrackerConditionFromBackend v) => v.depth;
  static const Field<SpendTrackerConditionFromBackend, int> _f$depth = Field(
    'depth',
    _$depth,
  );

  @override
  final MappableFields<SpendTrackerConditionFromBackend> fields = const {
    #spendTrackerId: _f$spendTrackerId,
    #spendTrackerName: _f$spendTrackerName,
    #spendTrackerCreatedAt: _f$spendTrackerCreatedAt,
    #spendTrackerNickname: _f$spendTrackerNickname,
    #budgetId: _f$budgetId,
    #userId: _f$userId,
    #conditionId: _f$conditionId,
    #parentId: _f$parentId,
    #conditionType: _f$conditionType,
    #testId: _f$testId,
    #testType: _f$testType,
    #testValue: _f$testValue,
    #depth: _f$depth,
  };

  static SpendTrackerConditionFromBackend _instantiate(DecodingData data) {
    return SpendTrackerConditionFromBackend(
      spendTrackerId: data.dec(_f$spendTrackerId),
      spendTrackerName: data.dec(_f$spendTrackerName),
      spendTrackerCreatedAt: data.dec(_f$spendTrackerCreatedAt),
      spendTrackerNickname: data.dec(_f$spendTrackerNickname),
      budgetId: data.dec(_f$budgetId),
      userId: data.dec(_f$userId),
      conditionId: data.dec(_f$conditionId),
      parentId: data.dec(_f$parentId),
      conditionType: data.dec(_f$conditionType),
      testId: data.dec(_f$testId),
      testType: data.dec(_f$testType),
      testValue: data.dec(_f$testValue),
      depth: data.dec(_f$depth),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static SpendTrackerConditionFromBackend fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SpendTrackerConditionFromBackend>(map);
  }

  static SpendTrackerConditionFromBackend fromJson(String json) {
    return ensureInitialized().decodeJson<SpendTrackerConditionFromBackend>(
      json,
    );
  }
}

mixin SpendTrackerConditionFromBackendMappable {
  String toJson() {
    return SpendTrackerConditionFromBackendMapper.ensureInitialized()
        .encodeJson<SpendTrackerConditionFromBackend>(
          this as SpendTrackerConditionFromBackend,
        );
  }

  Map<String, dynamic> toMap() {
    return SpendTrackerConditionFromBackendMapper.ensureInitialized()
        .encodeMap<SpendTrackerConditionFromBackend>(
          this as SpendTrackerConditionFromBackend,
        );
  }

  SpendTrackerConditionFromBackendCopyWith<
    SpendTrackerConditionFromBackend,
    SpendTrackerConditionFromBackend,
    SpendTrackerConditionFromBackend
  >
  get copyWith =>
      _SpendTrackerConditionFromBackendCopyWithImpl<
        SpendTrackerConditionFromBackend,
        SpendTrackerConditionFromBackend
      >(this as SpendTrackerConditionFromBackend, $identity, $identity);
  @override
  String toString() {
    return SpendTrackerConditionFromBackendMapper.ensureInitialized()
        .stringifyValue(this as SpendTrackerConditionFromBackend);
  }

  @override
  bool operator ==(Object other) {
    return SpendTrackerConditionFromBackendMapper.ensureInitialized()
        .equalsValue(this as SpendTrackerConditionFromBackend, other);
  }

  @override
  int get hashCode {
    return SpendTrackerConditionFromBackendMapper.ensureInitialized().hashValue(
      this as SpendTrackerConditionFromBackend,
    );
  }
}

extension SpendTrackerConditionFromBackendValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SpendTrackerConditionFromBackend, $Out> {
  SpendTrackerConditionFromBackendCopyWith<
    $R,
    SpendTrackerConditionFromBackend,
    $Out
  >
  get $asSpendTrackerConditionFromBackend => $base.as(
    (v, t, t2) =>
        _SpendTrackerConditionFromBackendCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class SpendTrackerConditionFromBackendCopyWith<
  $R,
  $In extends SpendTrackerConditionFromBackend,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? spendTrackerId,
    String? spendTrackerName,
    DateTime? spendTrackerCreatedAt,
    String? spendTrackerNickname,
    String? budgetId,
    String? userId,
    String? conditionId,
    String? parentId,
    String? conditionType,
    String? testId,
    String? testType,
    String? testValue,
    int? depth,
  });
  SpendTrackerConditionFromBackendCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _SpendTrackerConditionFromBackendCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SpendTrackerConditionFromBackend, $Out>
    implements
        SpendTrackerConditionFromBackendCopyWith<
          $R,
          SpendTrackerConditionFromBackend,
          $Out
        > {
  _SpendTrackerConditionFromBackendCopyWithImpl(
    super.value,
    super.then,
    super.then2,
  );

  @override
  late final ClassMapperBase<SpendTrackerConditionFromBackend> $mapper =
      SpendTrackerConditionFromBackendMapper.ensureInitialized();
  @override
  $R call({
    String? spendTrackerId,
    String? spendTrackerName,
    DateTime? spendTrackerCreatedAt,
    Object? spendTrackerNickname = $none,
    String? budgetId,
    String? userId,
    String? conditionId,
    Object? parentId = $none,
    String? conditionType,
    Object? testId = $none,
    Object? testType = $none,
    Object? testValue = $none,
    int? depth,
  }) => $apply(
    FieldCopyWithData({
      if (spendTrackerId != null) #spendTrackerId: spendTrackerId,
      if (spendTrackerName != null) #spendTrackerName: spendTrackerName,
      if (spendTrackerCreatedAt != null)
        #spendTrackerCreatedAt: spendTrackerCreatedAt,
      if (spendTrackerNickname != $none)
        #spendTrackerNickname: spendTrackerNickname,
      if (budgetId != null) #budgetId: budgetId,
      if (userId != null) #userId: userId,
      if (conditionId != null) #conditionId: conditionId,
      if (parentId != $none) #parentId: parentId,
      if (conditionType != null) #conditionType: conditionType,
      if (testId != $none) #testId: testId,
      if (testType != $none) #testType: testType,
      if (testValue != $none) #testValue: testValue,
      if (depth != null) #depth: depth,
    }),
  );
  @override
  SpendTrackerConditionFromBackend $make(CopyWithData data) =>
      SpendTrackerConditionFromBackend(
        spendTrackerId: data.get(#spendTrackerId, or: $value.spendTrackerId),
        spendTrackerName: data.get(
          #spendTrackerName,
          or: $value.spendTrackerName,
        ),
        spendTrackerCreatedAt: data.get(
          #spendTrackerCreatedAt,
          or: $value.spendTrackerCreatedAt,
        ),
        spendTrackerNickname: data.get(
          #spendTrackerNickname,
          or: $value.spendTrackerNickname,
        ),
        budgetId: data.get(#budgetId, or: $value.budgetId),
        userId: data.get(#userId, or: $value.userId),
        conditionId: data.get(#conditionId, or: $value.conditionId),
        parentId: data.get(#parentId, or: $value.parentId),
        conditionType: data.get(#conditionType, or: $value.conditionType),
        testId: data.get(#testId, or: $value.testId),
        testType: data.get(#testType, or: $value.testType),
        testValue: data.get(#testValue, or: $value.testValue),
        depth: data.get(#depth, or: $value.depth),
      );

  @override
  SpendTrackerConditionFromBackendCopyWith<
    $R2,
    SpendTrackerConditionFromBackend,
    $Out2
  >
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _SpendTrackerConditionFromBackendCopyWithImpl<$R2, $Out2>(
        $value,
        $cast,
        t,
      );
}

