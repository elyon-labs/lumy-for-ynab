// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'transaction_template.dart';

class TransactionTemplateMapper extends ClassMapperBase<TransactionTemplate> {
  TransactionTemplateMapper._();

  static TransactionTemplateMapper? _instance;
  static TransactionTemplateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = TransactionTemplateMapper._());
      FlagMapper.ensureInitialized();
      SubTransactionTemplateMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'TransactionTemplate';

  static String _$id(TransactionTemplate v) => v.id;
  static const Field<TransactionTemplate, String> _f$id = Field('id', _$id);
  static String _$budgetId(TransactionTemplate v) => v.budgetId;
  static const Field<TransactionTemplate, String> _f$budgetId = Field(
    'budgetId',
    _$budgetId,
    key: r'budget_id',
  );
  static String _$name(TransactionTemplate v) => v.name;
  static const Field<TransactionTemplate, String> _f$name = Field(
    'name',
    _$name,
  );
  static int _$amount(TransactionTemplate v) => v.amount;
  static const Field<TransactionTemplate, int> _f$amount = Field(
    'amount',
    _$amount,
  );
  static bool _$isInflow(TransactionTemplate v) => v.isInflow;
  static const Field<TransactionTemplate, bool> _f$isInflow = Field(
    'isInflow',
    _$isInflow,
    key: r'is_inflow',
  );
  static String? _$accountId(TransactionTemplate v) => v.accountId;
  static const Field<TransactionTemplate, String> _f$accountId = Field(
    'accountId',
    _$accountId,
    key: r'account_id',
  );
  static String? _$payeeId(TransactionTemplate v) => v.payeeId;
  static const Field<TransactionTemplate, String> _f$payeeId = Field(
    'payeeId',
    _$payeeId,
    key: r'payee_id',
  );
  static String? _$categoryId(TransactionTemplate v) => v.categoryId;
  static const Field<TransactionTemplate, String> _f$categoryId = Field(
    'categoryId',
    _$categoryId,
    key: r'category_id',
  );
  static String? _$memo(TransactionTemplate v) => v.memo;
  static const Field<TransactionTemplate, String> _f$memo = Field(
    'memo',
    _$memo,
  );
  static Flag? _$flag(TransactionTemplate v) => v.flag;
  static const Field<TransactionTemplate, Flag> _f$flag = Field('flag', _$flag);
  static List<SubTransactionTemplate> _$subTransactions(
    TransactionTemplate v,
  ) => v.subTransactions;
  static const Field<TransactionTemplate, List<SubTransactionTemplate>>
  _f$subTransactions = Field(
    'subTransactions',
    _$subTransactions,
    key: r'sub_transactions',
  );
  static bool _$fireImmediately(TransactionTemplate v) => v.fireImmediately;
  static const Field<TransactionTemplate, bool> _f$fireImmediately = Field(
    'fireImmediately',
    _$fireImmediately,
    key: r'fire_immediately',
  );

  @override
  final MappableFields<TransactionTemplate> fields = const {
    #id: _f$id,
    #budgetId: _f$budgetId,
    #name: _f$name,
    #amount: _f$amount,
    #isInflow: _f$isInflow,
    #accountId: _f$accountId,
    #payeeId: _f$payeeId,
    #categoryId: _f$categoryId,
    #memo: _f$memo,
    #flag: _f$flag,
    #subTransactions: _f$subTransactions,
    #fireImmediately: _f$fireImmediately,
  };

  static TransactionTemplate _instantiate(DecodingData data) {
    return TransactionTemplate(
      id: data.dec(_f$id),
      budgetId: data.dec(_f$budgetId),
      name: data.dec(_f$name),
      amount: data.dec(_f$amount),
      isInflow: data.dec(_f$isInflow),
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

  static TransactionTemplate fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<TransactionTemplate>(map);
  }

  static TransactionTemplate fromJson(String json) {
    return ensureInitialized().decodeJson<TransactionTemplate>(json);
  }
}

mixin TransactionTemplateMappable {
  String toJson() {
    return TransactionTemplateMapper.ensureInitialized()
        .encodeJson<TransactionTemplate>(this as TransactionTemplate);
  }

  Map<String, dynamic> toMap() {
    return TransactionTemplateMapper.ensureInitialized()
        .encodeMap<TransactionTemplate>(this as TransactionTemplate);
  }

  TransactionTemplateCopyWith<
    TransactionTemplate,
    TransactionTemplate,
    TransactionTemplate
  >
  get copyWith =>
      _TransactionTemplateCopyWithImpl<
        TransactionTemplate,
        TransactionTemplate
      >(this as TransactionTemplate, $identity, $identity);
  @override
  String toString() {
    return TransactionTemplateMapper.ensureInitialized().stringifyValue(
      this as TransactionTemplate,
    );
  }

  @override
  bool operator ==(Object other) {
    return TransactionTemplateMapper.ensureInitialized().equalsValue(
      this as TransactionTemplate,
      other,
    );
  }

  @override
  int get hashCode {
    return TransactionTemplateMapper.ensureInitialized().hashValue(
      this as TransactionTemplate,
    );
  }
}

extension TransactionTemplateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, TransactionTemplate, $Out> {
  TransactionTemplateCopyWith<$R, TransactionTemplate, $Out>
  get $asTransactionTemplate => $base.as(
    (v, t, t2) => _TransactionTemplateCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class TransactionTemplateCopyWith<
  $R,
  $In extends TransactionTemplate,
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
    String? budgetId,
    String? name,
    int? amount,
    bool? isInflow,
    String? accountId,
    String? payeeId,
    String? categoryId,
    String? memo,
    Flag? flag,
    List<SubTransactionTemplate>? subTransactions,
    bool? fireImmediately,
  });
  TransactionTemplateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _TransactionTemplateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, TransactionTemplate, $Out>
    implements TransactionTemplateCopyWith<$R, TransactionTemplate, $Out> {
  _TransactionTemplateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<TransactionTemplate> $mapper =
      TransactionTemplateMapper.ensureInitialized();
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
    String? id,
    String? budgetId,
    String? name,
    int? amount,
    bool? isInflow,
    Object? accountId = $none,
    Object? payeeId = $none,
    Object? categoryId = $none,
    Object? memo = $none,
    Object? flag = $none,
    List<SubTransactionTemplate>? subTransactions,
    bool? fireImmediately,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (budgetId != null) #budgetId: budgetId,
      if (name != null) #name: name,
      if (amount != null) #amount: amount,
      if (isInflow != null) #isInflow: isInflow,
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
  TransactionTemplate $make(CopyWithData data) => TransactionTemplate(
    id: data.get(#id, or: $value.id),
    budgetId: data.get(#budgetId, or: $value.budgetId),
    name: data.get(#name, or: $value.name),
    amount: data.get(#amount, or: $value.amount),
    isInflow: data.get(#isInflow, or: $value.isInflow),
    accountId: data.get(#accountId, or: $value.accountId),
    payeeId: data.get(#payeeId, or: $value.payeeId),
    categoryId: data.get(#categoryId, or: $value.categoryId),
    memo: data.get(#memo, or: $value.memo),
    flag: data.get(#flag, or: $value.flag),
    subTransactions: data.get(#subTransactions, or: $value.subTransactions),
    fireImmediately: data.get(#fireImmediately, or: $value.fireImmediately),
  );

  @override
  TransactionTemplateCopyWith<$R2, TransactionTemplate, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _TransactionTemplateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

