// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'legacy_transaction_template.dart';

class LegacyTransactionTemplateMapper
    extends ClassMapperBase<LegacyTransactionTemplate> {
  LegacyTransactionTemplateMapper._();

  static LegacyTransactionTemplateMapper? _instance;
  static LegacyTransactionTemplateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = LegacyTransactionTemplateMapper._(),
      );
      FlagMapper.ensureInitialized();
      SubTransactionTemplateMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'LegacyTransactionTemplate';

  static String _$name(LegacyTransactionTemplate v) => v.name;
  static const Field<LegacyTransactionTemplate, String> _f$name = Field(
    'name',
    _$name,
  );
  static String _$id(LegacyTransactionTemplate v) => v.id;
  static const Field<LegacyTransactionTemplate, String> _f$id = Field(
    'id',
    _$id,
    opt: true,
  );
  static int _$amount(LegacyTransactionTemplate v) => v.amount;
  static const Field<LegacyTransactionTemplate, int> _f$amount = Field(
    'amount',
    _$amount,
    opt: true,
    def: 0,
  );
  static bool _$isInflow(LegacyTransactionTemplate v) => v.isInflow;
  static const Field<LegacyTransactionTemplate, bool> _f$isInflow = Field(
    'isInflow',
    _$isInflow,
    key: r'is_inflow',
    opt: true,
    def: false,
  );
  static String? _$accountId(LegacyTransactionTemplate v) => v.accountId;
  static const Field<LegacyTransactionTemplate, String> _f$accountId = Field(
    'accountId',
    _$accountId,
    key: r'account_id',
    opt: true,
  );
  static String? _$payeeId(LegacyTransactionTemplate v) => v.payeeId;
  static const Field<LegacyTransactionTemplate, String> _f$payeeId = Field(
    'payeeId',
    _$payeeId,
    key: r'payee_id',
    opt: true,
  );
  static String? _$categoryId(LegacyTransactionTemplate v) => v.categoryId;
  static const Field<LegacyTransactionTemplate, String> _f$categoryId = Field(
    'categoryId',
    _$categoryId,
    key: r'category_id',
    opt: true,
  );
  static String? _$memo(LegacyTransactionTemplate v) => v.memo;
  static const Field<LegacyTransactionTemplate, String> _f$memo = Field(
    'memo',
    _$memo,
    opt: true,
  );
  static Flag? _$flag(LegacyTransactionTemplate v) => v.flag;
  static const Field<LegacyTransactionTemplate, Flag> _f$flag = Field(
    'flag',
    _$flag,
    opt: true,
  );
  static List<SubTransactionTemplate> _$subTransactions(
    LegacyTransactionTemplate v,
  ) => v.subTransactions;
  static const Field<LegacyTransactionTemplate, List<SubTransactionTemplate>>
  _f$subTransactions = Field(
    'subTransactions',
    _$subTransactions,
    key: r'sub_transactions',
    opt: true,
    def: const [],
  );
  static bool _$fireImmediately(LegacyTransactionTemplate v) =>
      v.fireImmediately;
  static const Field<LegacyTransactionTemplate, bool> _f$fireImmediately =
      Field(
        'fireImmediately',
        _$fireImmediately,
        key: r'fire_immediately',
        opt: true,
        def: false,
      );

  @override
  final MappableFields<LegacyTransactionTemplate> fields = const {
    #name: _f$name,
    #id: _f$id,
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

  static LegacyTransactionTemplate _instantiate(DecodingData data) {
    return LegacyTransactionTemplate(
      name: data.dec(_f$name),
      id: data.dec(_f$id),
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

  static LegacyTransactionTemplate fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<LegacyTransactionTemplate>(map);
  }

  static LegacyTransactionTemplate fromJson(String json) {
    return ensureInitialized().decodeJson<LegacyTransactionTemplate>(json);
  }
}

mixin LegacyTransactionTemplateMappable {
  String toJson() {
    return LegacyTransactionTemplateMapper.ensureInitialized()
        .encodeJson<LegacyTransactionTemplate>(
          this as LegacyTransactionTemplate,
        );
  }

  Map<String, dynamic> toMap() {
    return LegacyTransactionTemplateMapper.ensureInitialized()
        .encodeMap<LegacyTransactionTemplate>(
          this as LegacyTransactionTemplate,
        );
  }

  LegacyTransactionTemplateCopyWith<
    LegacyTransactionTemplate,
    LegacyTransactionTemplate,
    LegacyTransactionTemplate
  >
  get copyWith =>
      _LegacyTransactionTemplateCopyWithImpl<
        LegacyTransactionTemplate,
        LegacyTransactionTemplate
      >(this as LegacyTransactionTemplate, $identity, $identity);
  @override
  String toString() {
    return LegacyTransactionTemplateMapper.ensureInitialized().stringifyValue(
      this as LegacyTransactionTemplate,
    );
  }

  @override
  bool operator ==(Object other) {
    return LegacyTransactionTemplateMapper.ensureInitialized().equalsValue(
      this as LegacyTransactionTemplate,
      other,
    );
  }

  @override
  int get hashCode {
    return LegacyTransactionTemplateMapper.ensureInitialized().hashValue(
      this as LegacyTransactionTemplate,
    );
  }
}

extension LegacyTransactionTemplateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, LegacyTransactionTemplate, $Out> {
  LegacyTransactionTemplateCopyWith<$R, LegacyTransactionTemplate, $Out>
  get $asLegacyTransactionTemplate => $base.as(
    (v, t, t2) => _LegacyTransactionTemplateCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class LegacyTransactionTemplateCopyWith<
  $R,
  $In extends LegacyTransactionTemplate,
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
    String? name,
    String? id,
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
  LegacyTransactionTemplateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _LegacyTransactionTemplateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, LegacyTransactionTemplate, $Out>
    implements
        LegacyTransactionTemplateCopyWith<$R, LegacyTransactionTemplate, $Out> {
  _LegacyTransactionTemplateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<LegacyTransactionTemplate> $mapper =
      LegacyTransactionTemplateMapper.ensureInitialized();
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
    String? name,
    Object? id = $none,
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
      if (name != null) #name: name,
      if (id != $none) #id: id,
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
  LegacyTransactionTemplate $make(CopyWithData data) =>
      LegacyTransactionTemplate(
        name: data.get(#name, or: $value.name),
        id: data.get(#id, or: $value.id),
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
  LegacyTransactionTemplateCopyWith<$R2, LegacyTransactionTemplate, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _LegacyTransactionTemplateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class SubTransactionTemplateMapper
    extends ClassMapperBase<SubTransactionTemplate> {
  SubTransactionTemplateMapper._();

  static SubTransactionTemplateMapper? _instance;
  static SubTransactionTemplateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SubTransactionTemplateMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'SubTransactionTemplate';

  static String _$id(SubTransactionTemplate v) => v.id;
  static const Field<SubTransactionTemplate, String> _f$id = Field(
    'id',
    _$id,
    opt: true,
  );
  static String? _$categoryId(SubTransactionTemplate v) => v.categoryId;
  static const Field<SubTransactionTemplate, String> _f$categoryId = Field(
    'categoryId',
    _$categoryId,
    key: r'category_id',
    opt: true,
  );
  static int _$amount(SubTransactionTemplate v) => v.amount;
  static const Field<SubTransactionTemplate, int> _f$amount = Field(
    'amount',
    _$amount,
    opt: true,
    def: 0,
  );
  static bool _$isInflow(SubTransactionTemplate v) => v.isInflow;
  static const Field<SubTransactionTemplate, bool> _f$isInflow = Field(
    'isInflow',
    _$isInflow,
    key: r'is_inflow',
    opt: true,
    def: false,
  );
  static String? _$payeeId(SubTransactionTemplate v) => v.payeeId;
  static const Field<SubTransactionTemplate, String> _f$payeeId = Field(
    'payeeId',
    _$payeeId,
    key: r'payee_id',
    opt: true,
  );
  static String? _$memo(SubTransactionTemplate v) => v.memo;
  static const Field<SubTransactionTemplate, String> _f$memo = Field(
    'memo',
    _$memo,
    opt: true,
  );

  @override
  final MappableFields<SubTransactionTemplate> fields = const {
    #id: _f$id,
    #categoryId: _f$categoryId,
    #amount: _f$amount,
    #isInflow: _f$isInflow,
    #payeeId: _f$payeeId,
    #memo: _f$memo,
  };

  static SubTransactionTemplate _instantiate(DecodingData data) {
    return SubTransactionTemplate(
      id: data.dec(_f$id),
      categoryId: data.dec(_f$categoryId),
      amount: data.dec(_f$amount),
      isInflow: data.dec(_f$isInflow),
      payeeId: data.dec(_f$payeeId),
      memo: data.dec(_f$memo),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static SubTransactionTemplate fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SubTransactionTemplate>(map);
  }

  static SubTransactionTemplate fromJson(String json) {
    return ensureInitialized().decodeJson<SubTransactionTemplate>(json);
  }
}

mixin SubTransactionTemplateMappable {
  String toJson() {
    return SubTransactionTemplateMapper.ensureInitialized()
        .encodeJson<SubTransactionTemplate>(this as SubTransactionTemplate);
  }

  Map<String, dynamic> toMap() {
    return SubTransactionTemplateMapper.ensureInitialized()
        .encodeMap<SubTransactionTemplate>(this as SubTransactionTemplate);
  }

  SubTransactionTemplateCopyWith<
    SubTransactionTemplate,
    SubTransactionTemplate,
    SubTransactionTemplate
  >
  get copyWith =>
      _SubTransactionTemplateCopyWithImpl<
        SubTransactionTemplate,
        SubTransactionTemplate
      >(this as SubTransactionTemplate, $identity, $identity);
  @override
  String toString() {
    return SubTransactionTemplateMapper.ensureInitialized().stringifyValue(
      this as SubTransactionTemplate,
    );
  }

  @override
  bool operator ==(Object other) {
    return SubTransactionTemplateMapper.ensureInitialized().equalsValue(
      this as SubTransactionTemplate,
      other,
    );
  }

  @override
  int get hashCode {
    return SubTransactionTemplateMapper.ensureInitialized().hashValue(
      this as SubTransactionTemplate,
    );
  }
}

extension SubTransactionTemplateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SubTransactionTemplate, $Out> {
  SubTransactionTemplateCopyWith<$R, SubTransactionTemplate, $Out>
  get $asSubTransactionTemplate => $base.as(
    (v, t, t2) => _SubTransactionTemplateCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class SubTransactionTemplateCopyWith<
  $R,
  $In extends SubTransactionTemplate,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? id,
    String? categoryId,
    int? amount,
    bool? isInflow,
    String? payeeId,
    String? memo,
  });
  SubTransactionTemplateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _SubTransactionTemplateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SubTransactionTemplate, $Out>
    implements
        SubTransactionTemplateCopyWith<$R, SubTransactionTemplate, $Out> {
  _SubTransactionTemplateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SubTransactionTemplate> $mapper =
      SubTransactionTemplateMapper.ensureInitialized();
  @override
  $R call({
    Object? id = $none,
    Object? categoryId = $none,
    int? amount,
    bool? isInflow,
    Object? payeeId = $none,
    Object? memo = $none,
  }) => $apply(
    FieldCopyWithData({
      if (id != $none) #id: id,
      if (categoryId != $none) #categoryId: categoryId,
      if (amount != null) #amount: amount,
      if (isInflow != null) #isInflow: isInflow,
      if (payeeId != $none) #payeeId: payeeId,
      if (memo != $none) #memo: memo,
    }),
  );
  @override
  SubTransactionTemplate $make(CopyWithData data) => SubTransactionTemplate(
    id: data.get(#id, or: $value.id),
    categoryId: data.get(#categoryId, or: $value.categoryId),
    amount: data.get(#amount, or: $value.amount),
    isInflow: data.get(#isInflow, or: $value.isInflow),
    payeeId: data.get(#payeeId, or: $value.payeeId),
    memo: data.get(#memo, or: $value.memo),
  );

  @override
  SubTransactionTemplateCopyWith<$R2, SubTransactionTemplate, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _SubTransactionTemplateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

