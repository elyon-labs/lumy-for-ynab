// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'transaction_template_draft.dart';

class TransactionTemplateDraftMapper
    extends ClassMapperBase<TransactionTemplateDraft> {
  TransactionTemplateDraftMapper._();

  static TransactionTemplateDraftMapper? _instance;
  static TransactionTemplateDraftMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = TransactionTemplateDraftMapper._(),
      );
      FlagMapper.ensureInitialized();
      SubTransactionTemplateMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'TransactionTemplateDraft';

  static String _$id(TransactionTemplateDraft v) => v.id;
  static const Field<TransactionTemplateDraft, String> _f$id = Field(
    'id',
    _$id,
    opt: true,
  );
  static int _$amount(TransactionTemplateDraft v) => v.amount;
  static const Field<TransactionTemplateDraft, int> _f$amount = Field(
    'amount',
    _$amount,
    opt: true,
    def: 0,
  );
  static bool _$isInflow(TransactionTemplateDraft v) => v.isInflow;
  static const Field<TransactionTemplateDraft, bool> _f$isInflow = Field(
    'isInflow',
    _$isInflow,
    key: r'is_inflow',
    opt: true,
    def: false,
  );
  static String? _$name(TransactionTemplateDraft v) => v.name;
  static const Field<TransactionTemplateDraft, String> _f$name = Field(
    'name',
    _$name,
    opt: true,
  );
  static String? _$accountId(TransactionTemplateDraft v) => v.accountId;
  static const Field<TransactionTemplateDraft, String> _f$accountId = Field(
    'accountId',
    _$accountId,
    key: r'account_id',
    opt: true,
  );
  static String? _$payeeId(TransactionTemplateDraft v) => v.payeeId;
  static const Field<TransactionTemplateDraft, String> _f$payeeId = Field(
    'payeeId',
    _$payeeId,
    key: r'payee_id',
    opt: true,
  );
  static String? _$categoryId(TransactionTemplateDraft v) => v.categoryId;
  static const Field<TransactionTemplateDraft, String> _f$categoryId = Field(
    'categoryId',
    _$categoryId,
    key: r'category_id',
    opt: true,
  );
  static String? _$memo(TransactionTemplateDraft v) => v.memo;
  static const Field<TransactionTemplateDraft, String> _f$memo = Field(
    'memo',
    _$memo,
    opt: true,
  );
  static Flag? _$flag(TransactionTemplateDraft v) => v.flag;
  static const Field<TransactionTemplateDraft, Flag> _f$flag = Field(
    'flag',
    _$flag,
    opt: true,
  );
  static List<SubTransactionTemplate> _$subTransactions(
    TransactionTemplateDraft v,
  ) => v.subTransactions;
  static const Field<TransactionTemplateDraft, List<SubTransactionTemplate>>
  _f$subTransactions = Field(
    'subTransactions',
    _$subTransactions,
    key: r'sub_transactions',
    opt: true,
    def: const [],
  );
  static bool _$fireImmediately(TransactionTemplateDraft v) =>
      v.fireImmediately;
  static const Field<TransactionTemplateDraft, bool> _f$fireImmediately = Field(
    'fireImmediately',
    _$fireImmediately,
    key: r'fire_immediately',
    opt: true,
    def: false,
  );

  @override
  final MappableFields<TransactionTemplateDraft> fields = const {
    #id: _f$id,
    #amount: _f$amount,
    #isInflow: _f$isInflow,
    #name: _f$name,
    #accountId: _f$accountId,
    #payeeId: _f$payeeId,
    #categoryId: _f$categoryId,
    #memo: _f$memo,
    #flag: _f$flag,
    #subTransactions: _f$subTransactions,
    #fireImmediately: _f$fireImmediately,
  };

  static TransactionTemplateDraft _instantiate(DecodingData data) {
    return TransactionTemplateDraft(
      id: data.dec(_f$id),
      amount: data.dec(_f$amount),
      isInflow: data.dec(_f$isInflow),
      name: data.dec(_f$name),
      accountId: data.dec(_f$accountId),
      payeeId: data.dec(_f$payeeId),
      categoryId: data.dec(_f$categoryId),
      memo: data.dec(_f$memo),
      flag: data.dec(_f$flag),
      subTransactions: data.dec(_f$subTransactions),
      fireImmediately: data.dec(_f$fireImmediately),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static TransactionTemplateDraft fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<TransactionTemplateDraft>(map);
  }

  static TransactionTemplateDraft fromJson(String json) {
    return ensureInitialized().decodeJson<TransactionTemplateDraft>(json);
  }
}

mixin TransactionTemplateDraftMappable {
  String toJson() {
    return TransactionTemplateDraftMapper.ensureInitialized()
        .encodeJson<TransactionTemplateDraft>(this as TransactionTemplateDraft);
  }

  Map<String, dynamic> toMap() {
    return TransactionTemplateDraftMapper.ensureInitialized()
        .encodeMap<TransactionTemplateDraft>(this as TransactionTemplateDraft);
  }

  TransactionTemplateDraftCopyWith<
    TransactionTemplateDraft,
    TransactionTemplateDraft,
    TransactionTemplateDraft
  >
  get copyWith =>
      _TransactionTemplateDraftCopyWithImpl<
        TransactionTemplateDraft,
        TransactionTemplateDraft
      >(this as TransactionTemplateDraft, $identity, $identity);
  @override
  String toString() {
    return TransactionTemplateDraftMapper.ensureInitialized().stringifyValue(
      this as TransactionTemplateDraft,
    );
  }

  @override
  bool operator ==(Object other) {
    return TransactionTemplateDraftMapper.ensureInitialized().equalsValue(
      this as TransactionTemplateDraft,
      other,
    );
  }

  @override
  int get hashCode {
    return TransactionTemplateDraftMapper.ensureInitialized().hashValue(
      this as TransactionTemplateDraft,
    );
  }
}

extension TransactionTemplateDraftValueCopy<$R, $Out>
    on ObjectCopyWith<$R, TransactionTemplateDraft, $Out> {
  TransactionTemplateDraftCopyWith<$R, TransactionTemplateDraft, $Out>
  get $asTransactionTemplateDraft => $base.as(
    (v, t, t2) => _TransactionTemplateDraftCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class TransactionTemplateDraftCopyWith<
  $R,
  $In extends TransactionTemplateDraft,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<
    $R,
    SubTransactionTemplate,
    SubTransactionTemplateCopyWith<
      $R,
      SubTransactionTemplate,
      SubTransactionTemplate
    >
  >
  get subTransactions;
  $R call({
    String? id,
    int? amount,
    bool? isInflow,
    String? name,
    String? accountId,
    String? payeeId,
    String? categoryId,
    String? memo,
    Flag? flag,
    List<SubTransactionTemplate>? subTransactions,
    bool? fireImmediately,
  });
  TransactionTemplateDraftCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _TransactionTemplateDraftCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, TransactionTemplateDraft, $Out>
    implements
        TransactionTemplateDraftCopyWith<$R, TransactionTemplateDraft, $Out> {
  _TransactionTemplateDraftCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<TransactionTemplateDraft> $mapper =
      TransactionTemplateDraftMapper.ensureInitialized();
  @override
  ListCopyWith<
    $R,
    SubTransactionTemplate,
    SubTransactionTemplateCopyWith<
      $R,
      SubTransactionTemplate,
      SubTransactionTemplate
    >
  >
  get subTransactions => ListCopyWith(
    $value.subTransactions,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(subTransactions: v),
  );
  @override
  $R call({
    Object? id = $none,
    int? amount,
    bool? isInflow,
    Object? name = $none,
    Object? accountId = $none,
    Object? payeeId = $none,
    Object? categoryId = $none,
    Object? memo = $none,
    Object? flag = $none,
    List<SubTransactionTemplate>? subTransactions,
    bool? fireImmediately,
  }) => $apply(
    FieldCopyWithData({
      if (id != $none) #id: id,
      if (amount != null) #amount: amount,
      if (isInflow != null) #isInflow: isInflow,
      if (name != $none) #name: name,
      if (accountId != $none) #accountId: accountId,
      if (payeeId != $none) #payeeId: payeeId,
      if (categoryId != $none) #categoryId: categoryId,
      if (memo != $none) #memo: memo,
      if (flag != $none) #flag: flag,
      if (subTransactions != null) #subTransactions: subTransactions,
      if (fireImmediately != null) #fireImmediately: fireImmediately,
    }),
  );
  @override
  TransactionTemplateDraft $make(CopyWithData data) => TransactionTemplateDraft(
    id: data.get(#id, or: $value.id),
    amount: data.get(#amount, or: $value.amount),
    isInflow: data.get(#isInflow, or: $value.isInflow),
    name: data.get(#name, or: $value.name),
    accountId: data.get(#accountId, or: $value.accountId),
    payeeId: data.get(#payeeId, or: $value.payeeId),
    categoryId: data.get(#categoryId, or: $value.categoryId),
    memo: data.get(#memo, or: $value.memo),
    flag: data.get(#flag, or: $value.flag),
    subTransactions: data.get(#subTransactions, or: $value.subTransactions),
    fireImmediately: data.get(#fireImmediately, or: $value.fireImmediately),
  );

  @override
  TransactionTemplateDraftCopyWith<$R2, TransactionTemplateDraft, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _TransactionTemplateDraftCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

