// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'spend_tracker_draft.dart';

class SpendTrackerDraftMapper extends ClassMapperBase<SpendTrackerDraft> {
  SpendTrackerDraftMapper._();

  static SpendTrackerDraftMapper? _instance;
  static SpendTrackerDraftMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SpendTrackerDraftMapper._());
      _t$_R0Mapper.ensureInitialized();
      CategoryGroupMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'SpendTrackerDraft';

  static String? _$name(SpendTrackerDraft v) => v.name;
  static const Field<SpendTrackerDraft, String> _f$name = Field(
    'name',
    _$name,
    opt: true,
  );
  static SpendTrackerTypeChoice? _$type(SpendTrackerDraft v) => v.type;
  static const Field<SpendTrackerDraft, SpendTrackerTypeChoice> _f$type = Field(
    'type',
    _$type,
    opt: true,
  );
  static Condition<TransactionTestPayload, TransactionTest>? _$condition(
    SpendTrackerDraft v,
  ) => v.condition;
  static const Field<
    SpendTrackerDraft,
    Condition<TransactionTestPayload, TransactionTest>
  >
  _f$condition = Field('condition', _$condition, opt: true);

  @override
  final MappableFields<SpendTrackerDraft> fields = const {
    #name: _f$name,
    #type: _f$type,
    #condition: _f$condition,
  };

  static SpendTrackerDraft _instantiate(DecodingData data) {
    return SpendTrackerDraft(
      name: data.dec(_f$name),
      type: data.dec(_f$type),
      condition: data.dec(_f$condition),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static SpendTrackerDraft fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SpendTrackerDraft>(map);
  }

  static SpendTrackerDraft fromJson(String json) {
    return ensureInitialized().decodeJson<SpendTrackerDraft>(json);
  }
}

mixin SpendTrackerDraftMappable {
  String toJson() {
    return SpendTrackerDraftMapper.ensureInitialized()
        .encodeJson<SpendTrackerDraft>(this as SpendTrackerDraft);
  }

  Map<String, dynamic> toMap() {
    return SpendTrackerDraftMapper.ensureInitialized()
        .encodeMap<SpendTrackerDraft>(this as SpendTrackerDraft);
  }

  SpendTrackerDraftCopyWith<
    SpendTrackerDraft,
    SpendTrackerDraft,
    SpendTrackerDraft
  >
  get copyWith =>
      _SpendTrackerDraftCopyWithImpl<SpendTrackerDraft, SpendTrackerDraft>(
        this as SpendTrackerDraft,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return SpendTrackerDraftMapper.ensureInitialized().stringifyValue(
      this as SpendTrackerDraft,
    );
  }

  @override
  bool operator ==(Object other) {
    return SpendTrackerDraftMapper.ensureInitialized().equalsValue(
      this as SpendTrackerDraft,
      other,
    );
  }

  @override
  int get hashCode {
    return SpendTrackerDraftMapper.ensureInitialized().hashValue(
      this as SpendTrackerDraft,
    );
  }
}

extension SpendTrackerDraftValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SpendTrackerDraft, $Out> {
  SpendTrackerDraftCopyWith<$R, SpendTrackerDraft, $Out>
  get $asSpendTrackerDraft => $base.as(
    (v, t, t2) => _SpendTrackerDraftCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class SpendTrackerDraftCopyWith<
  $R,
  $In extends SpendTrackerDraft,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? name,
    SpendTrackerTypeChoice? type,
    Condition<TransactionTestPayload, TransactionTest>? condition,
  });
  SpendTrackerDraftCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _SpendTrackerDraftCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SpendTrackerDraft, $Out>
    implements SpendTrackerDraftCopyWith<$R, SpendTrackerDraft, $Out> {
  _SpendTrackerDraftCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SpendTrackerDraft> $mapper =
      SpendTrackerDraftMapper.ensureInitialized();
  @override
  $R call({
    Object? name = $none,
    Object? type = $none,
    Object? condition = $none,
  }) => $apply(
    FieldCopyWithData({
      if (name != $none) #name: name,
      if (type != $none) #type: type,
      if (condition != $none) #condition: condition,
    }),
  );
  @override
  SpendTrackerDraft $make(CopyWithData data) => SpendTrackerDraft(
    name: data.get(#name, or: $value.name),
    type: data.get(#type, or: $value.type),
    condition: data.get(#condition, or: $value.condition),
  );

  @override
  SpendTrackerDraftCopyWith<$R2, SpendTrackerDraft, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _SpendTrackerDraftCopyWithImpl<$R2, $Out2>($value, $cast, t);
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

