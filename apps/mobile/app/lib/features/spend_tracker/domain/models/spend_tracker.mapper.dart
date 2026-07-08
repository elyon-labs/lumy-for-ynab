// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'spend_tracker.dart';

class SpendTrackerMapper extends ClassMapperBase<SpendTracker> {
  SpendTrackerMapper._();

  static SpendTrackerMapper? _instance;
  static SpendTrackerMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SpendTrackerMapper._());
      MapperContainer.globals.useAll([TransactionConditionSimpleMapper()]);
      _t$_R0Mapper.ensureInitialized();
      CategoryGroupMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'SpendTracker';

  static String _$id(SpendTracker v) => v.id;
  static const Field<SpendTracker, String> _f$id = Field('id', _$id);
  static String _$budgetId(SpendTracker v) => v.budgetId;
  static const Field<SpendTracker, String> _f$budgetId = Field(
    'budgetId',
    _$budgetId,
    key: r'budget_id',
  );
  static String _$name(SpendTracker v) => v.name;
  static const Field<SpendTracker, String> _f$name = Field('name', _$name);
  static Condition<TransactionTestPayload, TransactionTest> _$condition(
    SpendTracker v,
  ) => v.condition;
  static const Field<
    SpendTracker,
    Condition<TransactionTestPayload, TransactionTest>
  >
  _f$condition = Field('condition', _$condition);
  static DateTime _$createdAt(SpendTracker v) => v.createdAt;
  static const Field<SpendTracker, DateTime> _f$createdAt = Field(
    'createdAt',
    _$createdAt,
    key: r'created_at',
  );
  static String? _$nickname(SpendTracker v) => v.nickname;
  static const Field<SpendTracker, String> _f$nickname = Field(
    'nickname',
    _$nickname,
    opt: true,
  );
  static List<Object?> _$props(SpendTracker v) => v.props;
  static const Field<SpendTracker, List<Object?>> _f$props = Field(
    'props',
    _$props,
    mode: FieldMode.member,
  );

  @override
  final MappableFields<SpendTracker> fields = const {
    #id: _f$id,
    #budgetId: _f$budgetId,
    #name: _f$name,
    #condition: _f$condition,
    #createdAt: _f$createdAt,
    #nickname: _f$nickname,
    #props: _f$props,
  };

  static SpendTracker _instantiate(DecodingData data) {
    return SpendTracker(
      id: data.dec(_f$id),
      budgetId: data.dec(_f$budgetId),
      name: data.dec(_f$name),
      condition: data.dec(_f$condition),
      createdAt: data.dec(_f$createdAt),
      nickname: data.dec(_f$nickname),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static SpendTracker fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SpendTracker>(map);
  }

  static SpendTracker fromJson(String json) {
    return ensureInitialized().decodeJson<SpendTracker>(json);
  }
}

mixin SpendTrackerMappable {
  String toJson() {
    return SpendTrackerMapper.ensureInitialized().encodeJson<SpendTracker>(
      this as SpendTracker,
    );
  }

  Map<String, dynamic> toMap() {
    return SpendTrackerMapper.ensureInitialized().encodeMap<SpendTracker>(
      this as SpendTracker,
    );
  }

  SpendTrackerCopyWith<SpendTracker, SpendTracker, SpendTracker> get copyWith =>
      _SpendTrackerCopyWithImpl<SpendTracker, SpendTracker>(
        this as SpendTracker,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return SpendTrackerMapper.ensureInitialized().stringifyValue(
      this as SpendTracker,
    );
  }

  @override
  bool operator ==(Object other) {
    return SpendTrackerMapper.ensureInitialized().equalsValue(
      this as SpendTracker,
      other,
    );
  }

  @override
  int get hashCode {
    return SpendTrackerMapper.ensureInitialized().hashValue(
      this as SpendTracker,
    );
  }
}

extension SpendTrackerValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SpendTracker, $Out> {
  SpendTrackerCopyWith<$R, SpendTracker, $Out> get $asSpendTracker =>
      $base.as((v, t, t2) => _SpendTrackerCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class SpendTrackerCopyWith<$R, $In extends SpendTracker, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? id,
    String? budgetId,
    String? name,
    Condition<TransactionTestPayload, TransactionTest>? condition,
    DateTime? createdAt,
    String? nickname,
  });
  SpendTrackerCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _SpendTrackerCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SpendTracker, $Out>
    implements SpendTrackerCopyWith<$R, SpendTracker, $Out> {
  _SpendTrackerCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SpendTracker> $mapper =
      SpendTrackerMapper.ensureInitialized();
  @override
  $R call({
    String? id,
    String? budgetId,
    String? name,
    Condition<TransactionTestPayload, TransactionTest>? condition,
    DateTime? createdAt,
    Object? nickname = $none,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (budgetId != null) #budgetId: budgetId,
      if (name != null) #name: name,
      if (condition != null) #condition: condition,
      if (createdAt != null) #createdAt: createdAt,
      if (nickname != $none) #nickname: nickname,
    }),
  );
  @override
  SpendTracker $make(CopyWithData data) => SpendTracker(
    id: data.get(#id, or: $value.id),
    budgetId: data.get(#budgetId, or: $value.budgetId),
    name: data.get(#name, or: $value.name),
    condition: data.get(#condition, or: $value.condition),
    createdAt: data.get(#createdAt, or: $value.createdAt),
    nickname: data.get(#nickname, or: $value.nickname),
  );

  @override
  SpendTrackerCopyWith<$R2, SpendTracker, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _SpendTrackerCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

typedef _t$_R0<A, B, C> = ({A groups, B parent, C txn});

class _t$_R0Mapper extends RecordMapperBase<_t$_R0> {
  static _t$_R0Mapper? _instance;
  _t$_R0Mapper._();

  static _t$_R0Mapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = _t$_R0Mapper._());
      MapperBase.addType(<A, B, C>(f) => f<({A groups, B parent, C txn})>());
    }
    return _instance!;
  }

  static dynamic _$groups(_t$_R0 v) => v.groups;
  static dynamic _arg$groups<A, B, C>(f) => f<A>();
  static const Field<_t$_R0, dynamic> _f$groups = Field(
    'groups',
    _$groups,
    arg: _arg$groups,
  );
  static dynamic _$parent(_t$_R0 v) => v.parent;
  static dynamic _arg$parent<A, B, C>(f) => f<B>();
  static const Field<_t$_R0, dynamic> _f$parent = Field(
    'parent',
    _$parent,
    arg: _arg$parent,
  );
  static dynamic _$txn(_t$_R0 v) => v.txn;
  static dynamic _arg$txn<A, B, C>(f) => f<C>();
  static const Field<_t$_R0, dynamic> _f$txn = Field(
    'txn',
    _$txn,
    arg: _arg$txn,
  );

  @override
  final MappableFields<_t$_R0> fields = const {
    #groups: _f$groups,
    #parent: _f$parent,
    #txn: _f$txn,
  };

  @override
  Function get typeFactory =>
      <A, B, C>(f) => f<_t$_R0<A, B, C>>();

  static _t$_R0<A, B, C> _instantiate<A, B, C>(DecodingData<_t$_R0> data) {
    return (
      groups: data.dec(_f$groups),
      parent: data.dec(_f$parent),
      txn: data.dec(_f$txn),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static _t$_R0<A, B, C> fromMap<A, B, C>(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<_t$_R0<A, B, C>>(map);
  }

  static _t$_R0<A, B, C> fromJson<A, B, C>(String json) {
    return ensureInitialized().decodeJson<_t$_R0<A, B, C>>(json);
  }
}

