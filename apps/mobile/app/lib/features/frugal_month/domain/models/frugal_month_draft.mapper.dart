// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'frugal_month_draft.dart';

class FrugalMonthDraftMapper extends ClassMapperBase<FrugalMonthDraft> {
  FrugalMonthDraftMapper._();

  static FrugalMonthDraftMapper? _instance;
  static FrugalMonthDraftMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FrugalMonthDraftMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'FrugalMonthDraft';

  static LocalDate? _$month(FrugalMonthDraft v) => v.month;
  static const Field<FrugalMonthDraft, LocalDate> _f$month = Field(
    'month',
    _$month,
    opt: true,
  );
  static int? _$targetAmount(FrugalMonthDraft v) => v.targetAmount;
  static const Field<FrugalMonthDraft, int> _f$targetAmount = Field(
    'targetAmount',
    _$targetAmount,
    key: r'target_amount',
    opt: true,
  );
  static List<String>? _$categoryIds(FrugalMonthDraft v) => v.categoryIds;
  static const Field<FrugalMonthDraft, List<String>> _f$categoryIds = Field(
    'categoryIds',
    _$categoryIds,
    key: r'category_ids',
    opt: true,
  );
  static List<String>? _$accountIds(FrugalMonthDraft v) => v.accountIds;
  static const Field<FrugalMonthDraft, List<String>> _f$accountIds = Field(
    'accountIds',
    _$accountIds,
    key: r'account_ids',
    opt: true,
  );
  static bool _$isValid(FrugalMonthDraft v) => v.isValid;
  static const Field<FrugalMonthDraft, bool> _f$isValid = Field(
    'isValid',
    _$isValid,
    key: r'is_valid',
    mode: FieldMode.member,
  );

  @override
  final MappableFields<FrugalMonthDraft> fields = const {
    #month: _f$month,
    #targetAmount: _f$targetAmount,
    #categoryIds: _f$categoryIds,
    #accountIds: _f$accountIds,
    #isValid: _f$isValid,
  };

  static FrugalMonthDraft _instantiate(DecodingData data) {
    return FrugalMonthDraft(
      month: data.dec(_f$month),
      targetAmount: data.dec(_f$targetAmount),
      categoryIds: data.dec(_f$categoryIds),
      accountIds: data.dec(_f$accountIds),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static FrugalMonthDraft fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<FrugalMonthDraft>(map);
  }

  static FrugalMonthDraft fromJson(String json) {
    return ensureInitialized().decodeJson<FrugalMonthDraft>(json);
  }
}

mixin FrugalMonthDraftMappable {
  String toJson() {
    return FrugalMonthDraftMapper.ensureInitialized()
        .encodeJson<FrugalMonthDraft>(this as FrugalMonthDraft);
  }

  Map<String, dynamic> toMap() {
    return FrugalMonthDraftMapper.ensureInitialized()
        .encodeMap<FrugalMonthDraft>(this as FrugalMonthDraft);
  }

  FrugalMonthDraftCopyWith<FrugalMonthDraft, FrugalMonthDraft, FrugalMonthDraft>
  get copyWith =>
      _FrugalMonthDraftCopyWithImpl<FrugalMonthDraft, FrugalMonthDraft>(
        this as FrugalMonthDraft,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return FrugalMonthDraftMapper.ensureInitialized().stringifyValue(
      this as FrugalMonthDraft,
    );
  }

  @override
  bool operator ==(Object other) {
    return FrugalMonthDraftMapper.ensureInitialized().equalsValue(
      this as FrugalMonthDraft,
      other,
    );
  }

  @override
  int get hashCode {
    return FrugalMonthDraftMapper.ensureInitialized().hashValue(
      this as FrugalMonthDraft,
    );
  }
}

extension FrugalMonthDraftValueCopy<$R, $Out>
    on ObjectCopyWith<$R, FrugalMonthDraft, $Out> {
  FrugalMonthDraftCopyWith<$R, FrugalMonthDraft, $Out>
  get $asFrugalMonthDraft =>
      $base.as((v, t, t2) => _FrugalMonthDraftCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class FrugalMonthDraftCopyWith<$R, $In extends FrugalMonthDraft, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>? get categoryIds;
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>? get accountIds;
  $R call({
    LocalDate? month,
    int? targetAmount,
    List<String>? categoryIds,
    List<String>? accountIds,
  });
  FrugalMonthDraftCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _FrugalMonthDraftCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, FrugalMonthDraft, $Out>
    implements FrugalMonthDraftCopyWith<$R, FrugalMonthDraft, $Out> {
  _FrugalMonthDraftCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<FrugalMonthDraft> $mapper =
      FrugalMonthDraftMapper.ensureInitialized();
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>?
  get categoryIds => $value.categoryIds != null
      ? ListCopyWith(
          $value.categoryIds!,
          (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(categoryIds: v),
        )
      : null;
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>>?
  get accountIds => $value.accountIds != null
      ? ListCopyWith(
          $value.accountIds!,
          (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(accountIds: v),
        )
      : null;
  @override
  $R call({
    Object? month = $none,
    Object? targetAmount = $none,
    Object? categoryIds = $none,
    Object? accountIds = $none,
  }) => $apply(
    FieldCopyWithData({
      if (month != $none) #month: month,
      if (targetAmount != $none) #targetAmount: targetAmount,
      if (categoryIds != $none) #categoryIds: categoryIds,
      if (accountIds != $none) #accountIds: accountIds,
    }),
  );
  @override
  FrugalMonthDraft $make(CopyWithData data) => FrugalMonthDraft(
    month: data.get(#month, or: $value.month),
    targetAmount: data.get(#targetAmount, or: $value.targetAmount),
    categoryIds: data.get(#categoryIds, or: $value.categoryIds),
    accountIds: data.get(#accountIds, or: $value.accountIds),
  );

  @override
  FrugalMonthDraftCopyWith<$R2, FrugalMonthDraft, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FrugalMonthDraftCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

