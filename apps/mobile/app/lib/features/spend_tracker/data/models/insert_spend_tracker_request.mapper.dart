// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'insert_spend_tracker_request.dart';

class InsertSpendTrackerRequestMapper
    extends ClassMapperBase<InsertSpendTrackerRequest> {
  InsertSpendTrackerRequestMapper._();

  static InsertSpendTrackerRequestMapper? _instance;
  static InsertSpendTrackerRequestMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = InsertSpendTrackerRequestMapper._(),
      );
      MapperContainer.globals.useAll([TransactionConditionSimpleMapper()]);
      _t$_R0Mapper.ensureInitialized();
      CategoryGroupMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'InsertSpendTrackerRequest';

  static String _$userId(InsertSpendTrackerRequest v) => v.userId;
  static const Field<InsertSpendTrackerRequest, String> _f$userId = Field(
    'userId',
    _$userId,
    key: r'user_id',
  );
  static String _$budgetId(InsertSpendTrackerRequest v) => v.budgetId;
  static const Field<InsertSpendTrackerRequest, String> _f$budgetId = Field(
    'budgetId',
    _$budgetId,
    key: r'budget_id',
  );
  static Condition<TransactionTestPayload, TransactionTest> _$condition(
    InsertSpendTrackerRequest v,
  ) => v.condition;
  static const Field<
    InsertSpendTrackerRequest,
    Condition<TransactionTestPayload, TransactionTest>
  >
  _f$condition = Field('condition', _$condition);
  static String _$name(InsertSpendTrackerRequest v) => v.name;
  static const Field<InsertSpendTrackerRequest, String> _f$name = Field(
    'name',
    _$name,
  );
  static String? _$nickName(InsertSpendTrackerRequest v) => v.nickName;
  static const Field<InsertSpendTrackerRequest, String> _f$nickName = Field(
    'nickName',
    _$nickName,
    key: r'nick_name',
    opt: true,
  );
  static DateTime? _$createdAt(InsertSpendTrackerRequest v) => v.createdAt;
  static const Field<InsertSpendTrackerRequest, DateTime> _f$createdAt = Field(
    'createdAt',
    _$createdAt,
    key: r'created_at',
    opt: true,
  );

  @override
  final MappableFields<InsertSpendTrackerRequest> fields = const {
    #userId: _f$userId,
    #budgetId: _f$budgetId,
    #condition: _f$condition,
    #name: _f$name,
    #nickName: _f$nickName,
    #createdAt: _f$createdAt,
  };
  @override
  final bool ignoreNull = true;

  static InsertSpendTrackerRequest _instantiate(DecodingData data) {
    return InsertSpendTrackerRequest(
      userId: data.dec(_f$userId),
      budgetId: data.dec(_f$budgetId),
      condition: data.dec(_f$condition),
      name: data.dec(_f$name),
      nickName: data.dec(_f$nickName),
      createdAt: data.dec(_f$createdAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static InsertSpendTrackerRequest fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<InsertSpendTrackerRequest>(map);
  }

  static InsertSpendTrackerRequest fromJson(String json) {
    return ensureInitialized().decodeJson<InsertSpendTrackerRequest>(json);
  }
}

mixin InsertSpendTrackerRequestMappable {
  String toJson() {
    return InsertSpendTrackerRequestMapper.ensureInitialized()
        .encodeJson<InsertSpendTrackerRequest>(
          this as InsertSpendTrackerRequest,
        );
  }

  Map<String, dynamic> toMap() {
    return InsertSpendTrackerRequestMapper.ensureInitialized()
        .encodeMap<InsertSpendTrackerRequest>(
          this as InsertSpendTrackerRequest,
        );
  }

  InsertSpendTrackerRequestCopyWith<
    InsertSpendTrackerRequest,
    InsertSpendTrackerRequest,
    InsertSpendTrackerRequest
  >
  get copyWith =>
      _InsertSpendTrackerRequestCopyWithImpl<
        InsertSpendTrackerRequest,
        InsertSpendTrackerRequest
      >(this as InsertSpendTrackerRequest, $identity, $identity);
  @override
  String toString() {
    return InsertSpendTrackerRequestMapper.ensureInitialized().stringifyValue(
      this as InsertSpendTrackerRequest,
    );
  }

  @override
  bool operator ==(Object other) {
    return InsertSpendTrackerRequestMapper.ensureInitialized().equalsValue(
      this as InsertSpendTrackerRequest,
      other,
    );
  }

  @override
  int get hashCode {
    return InsertSpendTrackerRequestMapper.ensureInitialized().hashValue(
      this as InsertSpendTrackerRequest,
    );
  }
}

extension InsertSpendTrackerRequestValueCopy<$R, $Out>
    on ObjectCopyWith<$R, InsertSpendTrackerRequest, $Out> {
  InsertSpendTrackerRequestCopyWith<$R, InsertSpendTrackerRequest, $Out>
  get $asInsertSpendTrackerRequest => $base.as(
    (v, t, t2) => _InsertSpendTrackerRequestCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class InsertSpendTrackerRequestCopyWith<
  $R,
  $In extends InsertSpendTrackerRequest,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? userId,
    String? budgetId,
    Condition<TransactionTestPayload, TransactionTest>? condition,
    String? name,
    String? nickName,
    DateTime? createdAt,
  });
  InsertSpendTrackerRequestCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _InsertSpendTrackerRequestCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, InsertSpendTrackerRequest, $Out>
    implements
        InsertSpendTrackerRequestCopyWith<$R, InsertSpendTrackerRequest, $Out> {
  _InsertSpendTrackerRequestCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<InsertSpendTrackerRequest> $mapper =
      InsertSpendTrackerRequestMapper.ensureInitialized();
  @override
  $R call({
    String? userId,
    String? budgetId,
    Condition<TransactionTestPayload, TransactionTest>? condition,
    String? name,
    Object? nickName = $none,
    Object? createdAt = $none,
  }) => $apply(
    FieldCopyWithData({
      if (userId != null) #userId: userId,
      if (budgetId != null) #budgetId: budgetId,
      if (condition != null) #condition: condition,
      if (name != null) #name: name,
      if (nickName != $none) #nickName: nickName,
      if (createdAt != $none) #createdAt: createdAt,
    }),
  );
  @override
  InsertSpendTrackerRequest $make(CopyWithData data) =>
      InsertSpendTrackerRequest(
        userId: data.get(#userId, or: $value.userId),
        budgetId: data.get(#budgetId, or: $value.budgetId),
        condition: data.get(#condition, or: $value.condition),
        name: data.get(#name, or: $value.name),
        nickName: data.get(#nickName, or: $value.nickName),
        createdAt: data.get(#createdAt, or: $value.createdAt),
      );

  @override
  InsertSpendTrackerRequestCopyWith<$R2, InsertSpendTrackerRequest, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _InsertSpendTrackerRequestCopyWithImpl<$R2, $Out2>($value, $cast, t);
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

