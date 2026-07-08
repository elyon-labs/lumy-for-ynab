// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'insert_frugal_month_request.dart';

class InsertFrugalMonthRequestMapper
    extends ClassMapperBase<InsertFrugalMonthRequest> {
  InsertFrugalMonthRequestMapper._();

  static InsertFrugalMonthRequestMapper? _instance;
  static InsertFrugalMonthRequestMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = InsertFrugalMonthRequestMapper._(),
      );
    }
    return _instance!;
  }

  @override
  final String id = 'InsertFrugalMonthRequest';

  static String _$userId(InsertFrugalMonthRequest v) => v.userId;
  static const Field<InsertFrugalMonthRequest, String> _f$userId = Field(
    'userId',
    _$userId,
    key: r'user_id',
  );
  static String _$budgetId(InsertFrugalMonthRequest v) => v.budgetId;
  static const Field<InsertFrugalMonthRequest, String> _f$budgetId = Field(
    'budgetId',
    _$budgetId,
    key: r'budget_id',
  );
  static LocalDate _$month(InsertFrugalMonthRequest v) => v.month;
  static const Field<InsertFrugalMonthRequest, LocalDate> _f$month = Field(
    'month',
    _$month,
  );
  static int _$targetAmount(InsertFrugalMonthRequest v) => v.targetAmount;
  static const Field<InsertFrugalMonthRequest, int> _f$targetAmount = Field(
    'targetAmount',
    _$targetAmount,
    key: r'target_amount',
  );
  static List<String> _$categoryIds(InsertFrugalMonthRequest v) =>
      v.categoryIds;
  static const Field<InsertFrugalMonthRequest, List<String>> _f$categoryIds =
      Field('categoryIds', _$categoryIds, key: r'category_ids');
  static List<String> _$accountIds(InsertFrugalMonthRequest v) => v.accountIds;
  static const Field<InsertFrugalMonthRequest, List<String>> _f$accountIds =
      Field('accountIds', _$accountIds, key: r'account_ids');

  @override
  final MappableFields<InsertFrugalMonthRequest> fields = const {
    #userId: _f$userId,
    #budgetId: _f$budgetId,
    #month: _f$month,
    #targetAmount: _f$targetAmount,
    #categoryIds: _f$categoryIds,
    #accountIds: _f$accountIds,
  };

  static InsertFrugalMonthRequest _instantiate(DecodingData data) {
    return InsertFrugalMonthRequest(
      userId: data.dec(_f$userId),
      budgetId: data.dec(_f$budgetId),
      month: data.dec(_f$month),
      targetAmount: data.dec(_f$targetAmount),
      categoryIds: data.dec(_f$categoryIds),
      accountIds: data.dec(_f$accountIds),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static InsertFrugalMonthRequest fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<InsertFrugalMonthRequest>(map);
  }

  static InsertFrugalMonthRequest fromJson(String json) {
    return ensureInitialized().decodeJson<InsertFrugalMonthRequest>(json);
  }
}

mixin InsertFrugalMonthRequestMappable {
  String toJson() {
    return InsertFrugalMonthRequestMapper.ensureInitialized()
        .encodeJson<InsertFrugalMonthRequest>(this as InsertFrugalMonthRequest);
  }

  Map<String, dynamic> toMap() {
    return InsertFrugalMonthRequestMapper.ensureInitialized()
        .encodeMap<InsertFrugalMonthRequest>(this as InsertFrugalMonthRequest);
  }

  InsertFrugalMonthRequestCopyWith<
    InsertFrugalMonthRequest,
    InsertFrugalMonthRequest,
    InsertFrugalMonthRequest
  >
  get copyWith =>
      _InsertFrugalMonthRequestCopyWithImpl<
        InsertFrugalMonthRequest,
        InsertFrugalMonthRequest
      >(this as InsertFrugalMonthRequest, $identity, $identity);
  @override
  String toString() {
    return InsertFrugalMonthRequestMapper.ensureInitialized().stringifyValue(
      this as InsertFrugalMonthRequest,
    );
  }

  @override
  bool operator ==(Object other) {
    return InsertFrugalMonthRequestMapper.ensureInitialized().equalsValue(
      this as InsertFrugalMonthRequest,
      other,
    );
  }

  @override
  int get hashCode {
    return InsertFrugalMonthRequestMapper.ensureInitialized().hashValue(
      this as InsertFrugalMonthRequest,
    );
  }
}

extension InsertFrugalMonthRequestValueCopy<$R, $Out>
    on ObjectCopyWith<$R, InsertFrugalMonthRequest, $Out> {
  InsertFrugalMonthRequestCopyWith<$R, InsertFrugalMonthRequest, $Out>
  get $asInsertFrugalMonthRequest => $base.as(
    (v, t, t2) => _InsertFrugalMonthRequestCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class InsertFrugalMonthRequestCopyWith<
  $R,
  $In extends InsertFrugalMonthRequest,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get categoryIds;
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get accountIds;
  $R call({
    String? userId,
    String? budgetId,
    LocalDate? month,
    int? targetAmount,
    List<String>? categoryIds,
    List<String>? accountIds,
  });
  InsertFrugalMonthRequestCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _InsertFrugalMonthRequestCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, InsertFrugalMonthRequest, $Out>
    implements
        InsertFrugalMonthRequestCopyWith<$R, InsertFrugalMonthRequest, $Out> {
  _InsertFrugalMonthRequestCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<InsertFrugalMonthRequest> $mapper =
      InsertFrugalMonthRequestMapper.ensureInitialized();
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
    String? userId,
    String? budgetId,
    LocalDate? month,
    int? targetAmount,
    List<String>? categoryIds,
    List<String>? accountIds,
  }) => $apply(
    FieldCopyWithData({
      if (userId != null) #userId: userId,
      if (budgetId != null) #budgetId: budgetId,
      if (month != null) #month: month,
      if (targetAmount != null) #targetAmount: targetAmount,
      if (categoryIds != null) #categoryIds: categoryIds,
      if (accountIds != null) #accountIds: accountIds,
    }),
  );
  @override
  InsertFrugalMonthRequest $make(CopyWithData data) => InsertFrugalMonthRequest(
    userId: data.get(#userId, or: $value.userId),
    budgetId: data.get(#budgetId, or: $value.budgetId),
    month: data.get(#month, or: $value.month),
    targetAmount: data.get(#targetAmount, or: $value.targetAmount),
    categoryIds: data.get(#categoryIds, or: $value.categoryIds),
    accountIds: data.get(#accountIds, or: $value.accountIds),
  );

  @override
  InsertFrugalMonthRequestCopyWith<$R2, InsertFrugalMonthRequest, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _InsertFrugalMonthRequestCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

