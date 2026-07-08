// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'transaction_template_from_backend.dart';

class TransactionTemplateFromBackendMapper
    extends ClassMapperBase<TransactionTemplateFromBackend> {
  TransactionTemplateFromBackendMapper._();

  static TransactionTemplateFromBackendMapper? _instance;
  static TransactionTemplateFromBackendMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = TransactionTemplateFromBackendMapper._(),
      );
      TransactionTemplateSubTransactionFromBackendMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'TransactionTemplateFromBackend';

  static String _$id(TransactionTemplateFromBackend v) => v.id;
  static const Field<TransactionTemplateFromBackend, String> _f$id = Field(
    'id',
    _$id,
  );
  static String _$budgetId(TransactionTemplateFromBackend v) => v.budgetId;
  static const Field<TransactionTemplateFromBackend, String> _f$budgetId =
      Field('budgetId', _$budgetId, key: r'budget_id');
  static String _$name(TransactionTemplateFromBackend v) => v.name;
  static const Field<TransactionTemplateFromBackend, String> _f$name = Field(
    'name',
    _$name,
  );
  static DateTime _$createdAt(TransactionTemplateFromBackend v) => v.createdAt;
  static const Field<TransactionTemplateFromBackend, DateTime> _f$createdAt =
      Field('createdAt', _$createdAt, key: r'created_at');
  static String _$userId(TransactionTemplateFromBackend v) => v.userId;
  static const Field<TransactionTemplateFromBackend, String> _f$userId = Field(
    'userId',
    _$userId,
    key: r'user_id',
  );
  static int _$amount(TransactionTemplateFromBackend v) => v.amount;
  static const Field<TransactionTemplateFromBackend, int> _f$amount = Field(
    'amount',
    _$amount,
  );
  static bool _$isInflow(TransactionTemplateFromBackend v) => v.isInflow;
  static const Field<TransactionTemplateFromBackend, bool> _f$isInflow = Field(
    'isInflow',
    _$isInflow,
    key: r'is_inflow',
  );
  static String? _$accountId(TransactionTemplateFromBackend v) => v.accountId;
  static const Field<TransactionTemplateFromBackend, String> _f$accountId =
      Field('accountId', _$accountId, key: r'account_id', opt: true);
  static String? _$payeeId(TransactionTemplateFromBackend v) => v.payeeId;
  static const Field<TransactionTemplateFromBackend, String> _f$payeeId = Field(
    'payeeId',
    _$payeeId,
    key: r'payee_id',
    opt: true,
  );
  static String? _$categoryId(TransactionTemplateFromBackend v) => v.categoryId;
  static const Field<TransactionTemplateFromBackend, String> _f$categoryId =
      Field('categoryId', _$categoryId, key: r'category_id', opt: true);
  static String? _$memo(TransactionTemplateFromBackend v) => v.memo;
  static const Field<TransactionTemplateFromBackend, String> _f$memo = Field(
    'memo',
    _$memo,
    opt: true,
  );
  static String? _$flag(TransactionTemplateFromBackend v) => v.flag;
  static const Field<TransactionTemplateFromBackend, String> _f$flag = Field(
    'flag',
    _$flag,
    opt: true,
  );
  static bool _$fireImmediately(TransactionTemplateFromBackend v) =>
      v.fireImmediately;
  static const Field<TransactionTemplateFromBackend, bool> _f$fireImmediately =
      Field('fireImmediately', _$fireImmediately, key: r'fire_immediately');
  static List<TransactionTemplateSubTransactionFromBackend> _$subTransactions(
    TransactionTemplateFromBackend v,
  ) => v.subTransactions;
  static const Field<
    TransactionTemplateFromBackend,
    List<TransactionTemplateSubTransactionFromBackend>
  >
  _f$subTransactions = Field(
    'subTransactions',
    _$subTransactions,
    key: r'sub_transactions',
  );

  @override
  final MappableFields<TransactionTemplateFromBackend> fields = const {
    #id: _f$id,
    #budgetId: _f$budgetId,
    #name: _f$name,
    #createdAt: _f$createdAt,
    #userId: _f$userId,
    #amount: _f$amount,
    #isInflow: _f$isInflow,
    #accountId: _f$accountId,
    #payeeId: _f$payeeId,
    #categoryId: _f$categoryId,
    #memo: _f$memo,
    #flag: _f$flag,
    #fireImmediately: _f$fireImmediately,
    #subTransactions: _f$subTransactions,
  };

  static TransactionTemplateFromBackend _instantiate(DecodingData data) {
    return TransactionTemplateFromBackend(
      id: data.dec(_f$id),
      budgetId: data.dec(_f$budgetId),
      name: data.dec(_f$name),
      createdAt: data.dec(_f$createdAt),
      userId: data.dec(_f$userId),
      amount: data.dec(_f$amount),
      isInflow: data.dec(_f$isInflow),
      accountId: data.dec(_f$accountId),
      payeeId: data.dec(_f$payeeId),
      categoryId: data.dec(_f$categoryId),
      memo: data.dec(_f$memo),
      flag: data.dec(_f$flag),
      fireImmediately: data.dec(_f$fireImmediately),
      subTransactions: data.dec(_f$subTransactions),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static TransactionTemplateFromBackend fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<TransactionTemplateFromBackend>(map);
  }

  static TransactionTemplateFromBackend fromJson(String json) {
    return ensureInitialized().decodeJson<TransactionTemplateFromBackend>(json);
  }
}

mixin TransactionTemplateFromBackendMappable {
  String toJson() {
    return TransactionTemplateFromBackendMapper.ensureInitialized()
        .encodeJson<TransactionTemplateFromBackend>(
          this as TransactionTemplateFromBackend,
        );
  }

  Map<String, dynamic> toMap() {
    return TransactionTemplateFromBackendMapper.ensureInitialized()
        .encodeMap<TransactionTemplateFromBackend>(
          this as TransactionTemplateFromBackend,
        );
  }

  TransactionTemplateFromBackendCopyWith<
    TransactionTemplateFromBackend,
    TransactionTemplateFromBackend,
    TransactionTemplateFromBackend
  >
  get copyWith =>
      _TransactionTemplateFromBackendCopyWithImpl<
        TransactionTemplateFromBackend,
        TransactionTemplateFromBackend
      >(this as TransactionTemplateFromBackend, $identity, $identity);
  @override
  String toString() {
    return TransactionTemplateFromBackendMapper.ensureInitialized()
        .stringifyValue(this as TransactionTemplateFromBackend);
  }

  @override
  bool operator ==(Object other) {
    return TransactionTemplateFromBackendMapper.ensureInitialized().equalsValue(
      this as TransactionTemplateFromBackend,
      other,
    );
  }

  @override
  int get hashCode {
    return TransactionTemplateFromBackendMapper.ensureInitialized().hashValue(
      this as TransactionTemplateFromBackend,
    );
  }
}

extension TransactionTemplateFromBackendValueCopy<$R, $Out>
    on ObjectCopyWith<$R, TransactionTemplateFromBackend, $Out> {
  TransactionTemplateFromBackendCopyWith<
    $R,
    TransactionTemplateFromBackend,
    $Out
  >
  get $asTransactionTemplateFromBackend => $base.as(
    (v, t, t2) =>
        _TransactionTemplateFromBackendCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class TransactionTemplateFromBackendCopyWith<
  $R,
  $In extends TransactionTemplateFromBackend,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<
    $R,
    TransactionTemplateSubTransactionFromBackend,
    TransactionTemplateSubTransactionFromBackendCopyWith<
      $R,
      TransactionTemplateSubTransactionFromBackend,
      TransactionTemplateSubTransactionFromBackend
    >
  >
  get subTransactions;
  $R call({
    String? id,
    String? budgetId,
    String? name,
    DateTime? createdAt,
    String? userId,
    int? amount,
    bool? isInflow,
    String? accountId,
    String? payeeId,
    String? categoryId,
    String? memo,
    String? flag,
    bool? fireImmediately,
    List<TransactionTemplateSubTransactionFromBackend>? subTransactions,
  });
  TransactionTemplateFromBackendCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _TransactionTemplateFromBackendCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, TransactionTemplateFromBackend, $Out>
    implements
        TransactionTemplateFromBackendCopyWith<
          $R,
          TransactionTemplateFromBackend,
          $Out
        > {
  _TransactionTemplateFromBackendCopyWithImpl(
    super.value,
    super.then,
    super.then2,
  );

  @override
  late final ClassMapperBase<TransactionTemplateFromBackend> $mapper =
      TransactionTemplateFromBackendMapper.ensureInitialized();
  @override
  ListCopyWith<
    $R,
    TransactionTemplateSubTransactionFromBackend,
    TransactionTemplateSubTransactionFromBackendCopyWith<
      $R,
      TransactionTemplateSubTransactionFromBackend,
      TransactionTemplateSubTransactionFromBackend
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
    DateTime? createdAt,
    String? userId,
    int? amount,
    bool? isInflow,
    Object? accountId = $none,
    Object? payeeId = $none,
    Object? categoryId = $none,
    Object? memo = $none,
    Object? flag = $none,
    bool? fireImmediately,
    List<TransactionTemplateSubTransactionFromBackend>? subTransactions,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (budgetId != null) #budgetId: budgetId,
      if (name != null) #name: name,
      if (createdAt != null) #createdAt: createdAt,
      if (userId != null) #userId: userId,
      if (amount != null) #amount: amount,
      if (isInflow != null) #isInflow: isInflow,
      if (accountId != $none) #accountId: accountId,
      if (payeeId != $none) #payeeId: payeeId,
      if (categoryId != $none) #categoryId: categoryId,
      if (memo != $none) #memo: memo,
      if (flag != $none) #flag: flag,
      if (fireImmediately != null) #fireImmediately: fireImmediately,
      if (subTransactions != null) #subTransactions: subTransactions,
    }),
  );
  @override
  TransactionTemplateFromBackend $make(CopyWithData data) =>
      TransactionTemplateFromBackend(
        id: data.get(#id, or: $value.id),
        budgetId: data.get(#budgetId, or: $value.budgetId),
        name: data.get(#name, or: $value.name),
        createdAt: data.get(#createdAt, or: $value.createdAt),
        userId: data.get(#userId, or: $value.userId),
        amount: data.get(#amount, or: $value.amount),
        isInflow: data.get(#isInflow, or: $value.isInflow),
        accountId: data.get(#accountId, or: $value.accountId),
        payeeId: data.get(#payeeId, or: $value.payeeId),
        categoryId: data.get(#categoryId, or: $value.categoryId),
        memo: data.get(#memo, or: $value.memo),
        flag: data.get(#flag, or: $value.flag),
        fireImmediately: data.get(#fireImmediately, or: $value.fireImmediately),
        subTransactions: data.get(#subTransactions, or: $value.subTransactions),
      );

  @override
  TransactionTemplateFromBackendCopyWith<
    $R2,
    TransactionTemplateFromBackend,
    $Out2
  >
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _TransactionTemplateFromBackendCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class TransactionTemplateSubTransactionFromBackendMapper
    extends ClassMapperBase<TransactionTemplateSubTransactionFromBackend> {
  TransactionTemplateSubTransactionFromBackendMapper._();

  static TransactionTemplateSubTransactionFromBackendMapper? _instance;
  static TransactionTemplateSubTransactionFromBackendMapper
  ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = TransactionTemplateSubTransactionFromBackendMapper._(),
      );
    }
    return _instance!;
  }

  @override
  final String id = 'TransactionTemplateSubTransactionFromBackend';

  static String _$id(TransactionTemplateSubTransactionFromBackend v) => v.id;
  static const Field<TransactionTemplateSubTransactionFromBackend, String>
  _f$id = Field('id', _$id);
  static DateTime _$createdAt(TransactionTemplateSubTransactionFromBackend v) =>
      v.createdAt;
  static const Field<TransactionTemplateSubTransactionFromBackend, DateTime>
  _f$createdAt = Field('createdAt', _$createdAt, key: r'created_at');
  static String? _$categoryId(TransactionTemplateSubTransactionFromBackend v) =>
      v.categoryId;
  static const Field<TransactionTemplateSubTransactionFromBackend, String>
  _f$categoryId = Field(
    'categoryId',
    _$categoryId,
    key: r'category_id',
    opt: true,
  );
  static int _$amount(TransactionTemplateSubTransactionFromBackend v) =>
      v.amount;
  static const Field<TransactionTemplateSubTransactionFromBackend, int>
  _f$amount = Field('amount', _$amount);
  static bool _$isInflow(TransactionTemplateSubTransactionFromBackend v) =>
      v.isInflow;
  static const Field<TransactionTemplateSubTransactionFromBackend, bool>
  _f$isInflow = Field('isInflow', _$isInflow, key: r'is_inflow');
  static String? _$payeeId(TransactionTemplateSubTransactionFromBackend v) =>
      v.payeeId;
  static const Field<TransactionTemplateSubTransactionFromBackend, String>
  _f$payeeId = Field('payeeId', _$payeeId, key: r'payee_id', opt: true);
  static String? _$memo(TransactionTemplateSubTransactionFromBackend v) =>
      v.memo;
  static const Field<TransactionTemplateSubTransactionFromBackend, String>
  _f$memo = Field('memo', _$memo, opt: true);
  static String? _$templateId(TransactionTemplateSubTransactionFromBackend v) =>
      v.templateId;
  static const Field<TransactionTemplateSubTransactionFromBackend, String>
  _f$templateId = Field(
    'templateId',
    _$templateId,
    key: r'template_id',
    opt: true,
  );

  @override
  final MappableFields<TransactionTemplateSubTransactionFromBackend> fields =
      const {
        #id: _f$id,
        #createdAt: _f$createdAt,
        #categoryId: _f$categoryId,
        #amount: _f$amount,
        #isInflow: _f$isInflow,
        #payeeId: _f$payeeId,
        #memo: _f$memo,
        #templateId: _f$templateId,
      };

  static TransactionTemplateSubTransactionFromBackend _instantiate(
    DecodingData data,
  ) {
    return TransactionTemplateSubTransactionFromBackend(
      id: data.dec(_f$id),
      createdAt: data.dec(_f$createdAt),
      categoryId: data.dec(_f$categoryId),
      amount: data.dec(_f$amount),
      isInflow: data.dec(_f$isInflow),
      payeeId: data.dec(_f$payeeId),
      memo: data.dec(_f$memo),
      templateId: data.dec(_f$templateId),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static TransactionTemplateSubTransactionFromBackend fromMap(
    Map<String, dynamic> map,
  ) {
    return ensureInitialized()
        .decodeMap<TransactionTemplateSubTransactionFromBackend>(map);
  }

  static TransactionTemplateSubTransactionFromBackend fromJson(String json) {
    return ensureInitialized()
        .decodeJson<TransactionTemplateSubTransactionFromBackend>(json);
  }
}

mixin TransactionTemplateSubTransactionFromBackendMappable {
  String toJson() {
    return TransactionTemplateSubTransactionFromBackendMapper.ensureInitialized()
        .encodeJson<TransactionTemplateSubTransactionFromBackend>(
          this as TransactionTemplateSubTransactionFromBackend,
        );
  }

  Map<String, dynamic> toMap() {
    return TransactionTemplateSubTransactionFromBackendMapper.ensureInitialized()
        .encodeMap<TransactionTemplateSubTransactionFromBackend>(
          this as TransactionTemplateSubTransactionFromBackend,
        );
  }

  TransactionTemplateSubTransactionFromBackendCopyWith<
    TransactionTemplateSubTransactionFromBackend,
    TransactionTemplateSubTransactionFromBackend,
    TransactionTemplateSubTransactionFromBackend
  >
  get copyWith =>
      _TransactionTemplateSubTransactionFromBackendCopyWithImpl<
        TransactionTemplateSubTransactionFromBackend,
        TransactionTemplateSubTransactionFromBackend
      >(
        this as TransactionTemplateSubTransactionFromBackend,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return TransactionTemplateSubTransactionFromBackendMapper.ensureInitialized()
        .stringifyValue(this as TransactionTemplateSubTransactionFromBackend);
  }

  @override
  bool operator ==(Object other) {
    return TransactionTemplateSubTransactionFromBackendMapper.ensureInitialized()
        .equalsValue(
          this as TransactionTemplateSubTransactionFromBackend,
          other,
        );
  }

  @override
  int get hashCode {
    return TransactionTemplateSubTransactionFromBackendMapper.ensureInitialized()
        .hashValue(this as TransactionTemplateSubTransactionFromBackend);
  }
}

extension TransactionTemplateSubTransactionFromBackendValueCopy<$R, $Out>
    on ObjectCopyWith<$R, TransactionTemplateSubTransactionFromBackend, $Out> {
  TransactionTemplateSubTransactionFromBackendCopyWith<
    $R,
    TransactionTemplateSubTransactionFromBackend,
    $Out
  >
  get $asTransactionTemplateSubTransactionFromBackend => $base.as(
    (v, t, t2) =>
        _TransactionTemplateSubTransactionFromBackendCopyWithImpl<$R, $Out>(
          v,
          t,
          t2,
        ),
  );
}

abstract class TransactionTemplateSubTransactionFromBackendCopyWith<
  $R,
  $In extends TransactionTemplateSubTransactionFromBackend,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? id,
    DateTime? createdAt,
    String? categoryId,
    int? amount,
    bool? isInflow,
    String? payeeId,
    String? memo,
    String? templateId,
  });
  TransactionTemplateSubTransactionFromBackendCopyWith<$R2, $In, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _TransactionTemplateSubTransactionFromBackendCopyWithImpl<$R, $Out>
    extends
        ClassCopyWithBase<
          $R,
          TransactionTemplateSubTransactionFromBackend,
          $Out
        >
    implements
        TransactionTemplateSubTransactionFromBackendCopyWith<
          $R,
          TransactionTemplateSubTransactionFromBackend,
          $Out
        > {
  _TransactionTemplateSubTransactionFromBackendCopyWithImpl(
    super.value,
    super.then,
    super.then2,
  );

  @override
  late final ClassMapperBase<TransactionTemplateSubTransactionFromBackend>
  $mapper =
      TransactionTemplateSubTransactionFromBackendMapper.ensureInitialized();
  @override
  $R call({
    String? id,
    DateTime? createdAt,
    Object? categoryId = $none,
    int? amount,
    bool? isInflow,
    Object? payeeId = $none,
    Object? memo = $none,
    Object? templateId = $none,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (createdAt != null) #createdAt: createdAt,
      if (categoryId != $none) #categoryId: categoryId,
      if (amount != null) #amount: amount,
      if (isInflow != null) #isInflow: isInflow,
      if (payeeId != $none) #payeeId: payeeId,
      if (memo != $none) #memo: memo,
      if (templateId != $none) #templateId: templateId,
    }),
  );
  @override
  TransactionTemplateSubTransactionFromBackend $make(CopyWithData data) =>
      TransactionTemplateSubTransactionFromBackend(
        id: data.get(#id, or: $value.id),
        createdAt: data.get(#createdAt, or: $value.createdAt),
        categoryId: data.get(#categoryId, or: $value.categoryId),
        amount: data.get(#amount, or: $value.amount),
        isInflow: data.get(#isInflow, or: $value.isInflow),
        payeeId: data.get(#payeeId, or: $value.payeeId),
        memo: data.get(#memo, or: $value.memo),
        templateId: data.get(#templateId, or: $value.templateId),
      );

  @override
  TransactionTemplateSubTransactionFromBackendCopyWith<
    $R2,
    TransactionTemplateSubTransactionFromBackend,
    $Out2
  >
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _TransactionTemplateSubTransactionFromBackendCopyWithImpl<$R2, $Out2>(
        $value,
        $cast,
        t,
      );
}

