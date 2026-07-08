// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'update_spend_tracker_request.dart';

class UpdateSpendTrackerRequestMapper
    extends ClassMapperBase<UpdateSpendTrackerRequest> {
  UpdateSpendTrackerRequestMapper._();

  static UpdateSpendTrackerRequestMapper? _instance;
  static UpdateSpendTrackerRequestMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = UpdateSpendTrackerRequestMapper._(),
      );
      MapperContainer.globals.useAll([TransactionConditionSimpleMapper()]);
      _t$_R0Mapper.ensureInitialized();
      CategoryGroupMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'UpdateSpendTrackerRequest';

  static String _$spendTrackerId(UpdateSpendTrackerRequest v) =>
      v.spendTrackerId;
  static const Field<UpdateSpendTrackerRequest, String> _f$spendTrackerId =
      Field('spendTrackerId', _$spendTrackerId, key: r'spend_tracker_id');
  static String _$userId(UpdateSpendTrackerRequest v) => v.userId;
  static const Field<UpdateSpendTrackerRequest, String> _f$userId = Field(
    'userId',
    _$userId,
    key: r'user_id',
  );
  static Condition<TransactionTestPayload, TransactionTest> _$condition(
    UpdateSpendTrackerRequest v,
  ) => v.condition;
  static const Field<
    UpdateSpendTrackerRequest,
    Condition<TransactionTestPayload, TransactionTest>
  >
  _f$condition = Field('condition', _$condition);

  @override
  final MappableFields<UpdateSpendTrackerRequest> fields = const {
    #spendTrackerId: _f$spendTrackerId,
    #userId: _f$userId,
    #condition: _f$condition,
  };

  static UpdateSpendTrackerRequest _instantiate(DecodingData data) {
    return UpdateSpendTrackerRequest(
      spendTrackerId: data.dec(_f$spendTrackerId),
      userId: data.dec(_f$userId),
      condition: data.dec(_f$condition),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static UpdateSpendTrackerRequest fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<UpdateSpendTrackerRequest>(map);
  }

  static UpdateSpendTrackerRequest fromJson(String json) {
    return ensureInitialized().decodeJson<UpdateSpendTrackerRequest>(json);
  }
}

mixin UpdateSpendTrackerRequestMappable {
  String toJson() {
    return UpdateSpendTrackerRequestMapper.ensureInitialized()
        .encodeJson<UpdateSpendTrackerRequest>(
          this as UpdateSpendTrackerRequest,
        );
  }

  Map<String, dynamic> toMap() {
    return UpdateSpendTrackerRequestMapper.ensureInitialized()
        .encodeMap<UpdateSpendTrackerRequest>(
          this as UpdateSpendTrackerRequest,
        );
  }

  UpdateSpendTrackerRequestCopyWith<
    UpdateSpendTrackerRequest,
    UpdateSpendTrackerRequest,
    UpdateSpendTrackerRequest
  >
  get copyWith =>
      _UpdateSpendTrackerRequestCopyWithImpl<
        UpdateSpendTrackerRequest,
        UpdateSpendTrackerRequest
      >(this as UpdateSpendTrackerRequest, $identity, $identity);
  @override
  String toString() {
    return UpdateSpendTrackerRequestMapper.ensureInitialized().stringifyValue(
      this as UpdateSpendTrackerRequest,
    );
  }

  @override
  bool operator ==(Object other) {
    return UpdateSpendTrackerRequestMapper.ensureInitialized().equalsValue(
      this as UpdateSpendTrackerRequest,
      other,
    );
  }

  @override
  int get hashCode {
    return UpdateSpendTrackerRequestMapper.ensureInitialized().hashValue(
      this as UpdateSpendTrackerRequest,
    );
  }
}

extension UpdateSpendTrackerRequestValueCopy<$R, $Out>
    on ObjectCopyWith<$R, UpdateSpendTrackerRequest, $Out> {
  UpdateSpendTrackerRequestCopyWith<$R, UpdateSpendTrackerRequest, $Out>
  get $asUpdateSpendTrackerRequest => $base.as(
    (v, t, t2) => _UpdateSpendTrackerRequestCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class UpdateSpendTrackerRequestCopyWith<
  $R,
  $In extends UpdateSpendTrackerRequest,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? spendTrackerId,
    String? userId,
    Condition<TransactionTestPayload, TransactionTest>? condition,
  });
  UpdateSpendTrackerRequestCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _UpdateSpendTrackerRequestCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, UpdateSpendTrackerRequest, $Out>
    implements
        UpdateSpendTrackerRequestCopyWith<$R, UpdateSpendTrackerRequest, $Out> {
  _UpdateSpendTrackerRequestCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<UpdateSpendTrackerRequest> $mapper =
      UpdateSpendTrackerRequestMapper.ensureInitialized();
  @override
  $R call({
    String? spendTrackerId,
    String? userId,
    Condition<TransactionTestPayload, TransactionTest>? condition,
  }) => $apply(
    FieldCopyWithData({
      if (spendTrackerId != null) #spendTrackerId: spendTrackerId,
      if (userId != null) #userId: userId,
      if (condition != null) #condition: condition,
    }),
  );
  @override
  UpdateSpendTrackerRequest $make(CopyWithData data) =>
      UpdateSpendTrackerRequest(
        spendTrackerId: data.get(#spendTrackerId, or: $value.spendTrackerId),
        userId: data.get(#userId, or: $value.userId),
        condition: data.get(#condition, or: $value.condition),
      );

  @override
  UpdateSpendTrackerRequestCopyWith<$R2, UpdateSpendTrackerRequest, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _UpdateSpendTrackerRequestCopyWithImpl<$R2, $Out2>($value, $cast, t);
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

