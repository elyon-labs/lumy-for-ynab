// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'create_transaction.dart';

class CreateTransactionMapper extends ClassMapperBase<CreateTransaction> {
  CreateTransactionMapper._();

  static CreateTransactionMapper? _instance;
  static CreateTransactionMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = CreateTransactionMapper._());
      TransactionToCreateMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'CreateTransaction';

  static TransactionToCreate _$transaction(CreateTransaction v) =>
      v.transaction;
  static const Field<CreateTransaction, TransactionToCreate> _f$transaction =
      Field('transaction', _$transaction);

  @override
  final MappableFields<CreateTransaction> fields = const {
    #transaction: _f$transaction,
  };

  static CreateTransaction _instantiate(DecodingData data) {
    return CreateTransaction(transaction: data.dec(_f$transaction));
  }

  @override
  final Function instantiate = _instantiate;

  static CreateTransaction fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<CreateTransaction>(map);
  }

  static CreateTransaction fromJson(String json) {
    return ensureInitialized().decodeJson<CreateTransaction>(json);
  }
}

mixin CreateTransactionMappable {
  String toJson() {
    return CreateTransactionMapper.ensureInitialized()
        .encodeJson<CreateTransaction>(this as CreateTransaction);
  }

  Map<String, dynamic> toMap() {
    return CreateTransactionMapper.ensureInitialized()
        .encodeMap<CreateTransaction>(this as CreateTransaction);
  }

  CreateTransactionCopyWith<
    CreateTransaction,
    CreateTransaction,
    CreateTransaction
  >
  get copyWith =>
      _CreateTransactionCopyWithImpl<CreateTransaction, CreateTransaction>(
        this as CreateTransaction,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return CreateTransactionMapper.ensureInitialized().stringifyValue(
      this as CreateTransaction,
    );
  }

  @override
  bool operator ==(Object other) {
    return CreateTransactionMapper.ensureInitialized().equalsValue(
      this as CreateTransaction,
      other,
    );
  }

  @override
  int get hashCode {
    return CreateTransactionMapper.ensureInitialized().hashValue(
      this as CreateTransaction,
    );
  }
}

extension CreateTransactionValueCopy<$R, $Out>
    on ObjectCopyWith<$R, CreateTransaction, $Out> {
  CreateTransactionCopyWith<$R, CreateTransaction, $Out>
  get $asCreateTransaction => $base.as(
    (v, t, t2) => _CreateTransactionCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class CreateTransactionCopyWith<
  $R,
  $In extends CreateTransaction,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  TransactionToCreateCopyWith<$R, TransactionToCreate, TransactionToCreate>
  get transaction;
  $R call({TransactionToCreate? transaction});
  CreateTransactionCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _CreateTransactionCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, CreateTransaction, $Out>
    implements CreateTransactionCopyWith<$R, CreateTransaction, $Out> {
  _CreateTransactionCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<CreateTransaction> $mapper =
      CreateTransactionMapper.ensureInitialized();
  @override
  TransactionToCreateCopyWith<$R, TransactionToCreate, TransactionToCreate>
  get transaction =>
      $value.transaction.copyWith.$chain((v) => call(transaction: v));
  @override
  $R call({TransactionToCreate? transaction}) => $apply(
    FieldCopyWithData({if (transaction != null) #transaction: transaction}),
  );
  @override
  CreateTransaction $make(CopyWithData data) => CreateTransaction(
    transaction: data.get(#transaction, or: $value.transaction),
  );

  @override
  CreateTransactionCopyWith<$R2, CreateTransaction, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _CreateTransactionCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class TransactionToCreateMapper extends ClassMapperBase<TransactionToCreate> {
  TransactionToCreateMapper._();

  static TransactionToCreateMapper? _instance;
  static TransactionToCreateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = TransactionToCreateMapper._());
      SubTransactionToCreateMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'TransactionToCreate';

  static String _$accountId(TransactionToCreate v) => v.accountId;
  static const Field<TransactionToCreate, String> _f$accountId = Field(
    'accountId',
    _$accountId,
    key: r'account_id',
  );
  static String? _$date(TransactionToCreate v) => v.date;
  static const Field<TransactionToCreate, String> _f$date = Field(
    'date',
    _$date,
  );
  static int _$amount(TransactionToCreate v) => v.amount;
  static const Field<TransactionToCreate, int> _f$amount = Field(
    'amount',
    _$amount,
  );
  static String? _$payeeId(TransactionToCreate v) => v.payeeId;
  static const Field<TransactionToCreate, String> _f$payeeId = Field(
    'payeeId',
    _$payeeId,
    key: r'payee_id',
  );
  static String? _$payeeName(TransactionToCreate v) => v.payeeName;
  static const Field<TransactionToCreate, String> _f$payeeName = Field(
    'payeeName',
    _$payeeName,
    key: r'payee_name',
  );
  static String? _$categoryId(TransactionToCreate v) => v.categoryId;
  static const Field<TransactionToCreate, String> _f$categoryId = Field(
    'categoryId',
    _$categoryId,
    key: r'category_id',
  );
  static String? _$memo(TransactionToCreate v) => v.memo;
  static const Field<TransactionToCreate, String> _f$memo = Field(
    'memo',
    _$memo,
  );
  static bool? _$cleared(TransactionToCreate v) => v.cleared;
  static const Field<TransactionToCreate, bool> _f$cleared = Field(
    'cleared',
    _$cleared,
  );
  static bool? _$approved(TransactionToCreate v) => v.approved;
  static const Field<TransactionToCreate, bool> _f$approved = Field(
    'approved',
    _$approved,
  );
  static String? _$flagColor(TransactionToCreate v) => v.flagColor;
  static const Field<TransactionToCreate, String> _f$flagColor = Field(
    'flagColor',
    _$flagColor,
    key: r'flag_color',
  );
  static List<SubTransactionToCreate>? _$subtransactions(
    TransactionToCreate v,
  ) => v.subtransactions;
  static const Field<TransactionToCreate, List<SubTransactionToCreate>>
  _f$subtransactions = Field('subtransactions', _$subtransactions);

  @override
  final MappableFields<TransactionToCreate> fields = const {
    #accountId: _f$accountId,
    #date: _f$date,
    #amount: _f$amount,
    #payeeId: _f$payeeId,
    #payeeName: _f$payeeName,
    #categoryId: _f$categoryId,
    #memo: _f$memo,
    #cleared: _f$cleared,
    #approved: _f$approved,
    #flagColor: _f$flagColor,
    #subtransactions: _f$subtransactions,
  };

  static TransactionToCreate _instantiate(DecodingData data) {
    return TransactionToCreate(
      accountId: data.dec(_f$accountId),
      date: data.dec(_f$date),
      amount: data.dec(_f$amount),
      payeeId: data.dec(_f$payeeId),
      payeeName: data.dec(_f$payeeName),
      categoryId: data.dec(_f$categoryId),
      memo: data.dec(_f$memo),
      cleared: data.dec(_f$cleared),
      approved: data.dec(_f$approved),
      flagColor: data.dec(_f$flagColor),
      subtransactions: data.dec(_f$subtransactions),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static TransactionToCreate fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<TransactionToCreate>(map);
  }

  static TransactionToCreate fromJson(String json) {
    return ensureInitialized().decodeJson<TransactionToCreate>(json);
  }
}

mixin TransactionToCreateMappable {
  String toJson() {
    return TransactionToCreateMapper.ensureInitialized()
        .encodeJson<TransactionToCreate>(this as TransactionToCreate);
  }

  Map<String, dynamic> toMap() {
    return TransactionToCreateMapper.ensureInitialized()
        .encodeMap<TransactionToCreate>(this as TransactionToCreate);
  }

  TransactionToCreateCopyWith<
    TransactionToCreate,
    TransactionToCreate,
    TransactionToCreate
  >
  get copyWith =>
      _TransactionToCreateCopyWithImpl<
        TransactionToCreate,
        TransactionToCreate
      >(this as TransactionToCreate, $identity, $identity);
  @override
  String toString() {
    return TransactionToCreateMapper.ensureInitialized().stringifyValue(
      this as TransactionToCreate,
    );
  }

  @override
  bool operator ==(Object other) {
    return TransactionToCreateMapper.ensureInitialized().equalsValue(
      this as TransactionToCreate,
      other,
    );
  }

  @override
  int get hashCode {
    return TransactionToCreateMapper.ensureInitialized().hashValue(
      this as TransactionToCreate,
    );
  }
}

extension TransactionToCreateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, TransactionToCreate, $Out> {
  TransactionToCreateCopyWith<$R, TransactionToCreate, $Out>
  get $asTransactionToCreate => $base.as(
    (v, t, t2) => _TransactionToCreateCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class TransactionToCreateCopyWith<
  $R,
  $In extends TransactionToCreate,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<
    $R,
    SubTransactionToCreate,
    SubTransactionToCreateCopyWith<
      $R,
      SubTransactionToCreate,
      SubTransactionToCreate
    >
  >?
  get subtransactions;
  $R call({
    String? accountId,
    String? date,
    int? amount,
    String? payeeId,
    String? payeeName,
    String? categoryId,
    String? memo,
    bool? cleared,
    bool? approved,
    String? flagColor,
    List<SubTransactionToCreate>? subtransactions,
  });
  TransactionToCreateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _TransactionToCreateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, TransactionToCreate, $Out>
    implements TransactionToCreateCopyWith<$R, TransactionToCreate, $Out> {
  _TransactionToCreateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<TransactionToCreate> $mapper =
      TransactionToCreateMapper.ensureInitialized();
  @override
  ListCopyWith<
    $R,
    SubTransactionToCreate,
    SubTransactionToCreateCopyWith<
      $R,
      SubTransactionToCreate,
      SubTransactionToCreate
    >
  >?
  get subtransactions => $value.subtransactions != null
      ? ListCopyWith(
          $value.subtransactions!,
          (v, t) => v.copyWith.$chain(t),
          (v) => call(subtransactions: v),
        )
      : null;
  @override
  $R call({
    String? accountId,
    Object? date = $none,
    int? amount,
    Object? payeeId = $none,
    Object? payeeName = $none,
    Object? categoryId = $none,
    Object? memo = $none,
    Object? cleared = $none,
    Object? approved = $none,
    Object? flagColor = $none,
    Object? subtransactions = $none,
  }) => $apply(
    FieldCopyWithData({
      if (accountId != null) #accountId: accountId,
      if (date != $none) #date: date,
      if (amount != null) #amount: amount,
      if (payeeId != $none) #payeeId: payeeId,
      if (payeeName != $none) #payeeName: payeeName,
      if (categoryId != $none) #categoryId: categoryId,
      if (memo != $none) #memo: memo,
      if (cleared != $none) #cleared: cleared,
      if (approved != $none) #approved: approved,
      if (flagColor != $none) #flagColor: flagColor,
      if (subtransactions != $none) #subtransactions: subtransactions,
    }),
  );
  @override
  TransactionToCreate $make(CopyWithData data) => TransactionToCreate(
    accountId: data.get(#accountId, or: $value.accountId),
    date: data.get(#date, or: $value.date),
    amount: data.get(#amount, or: $value.amount),
    payeeId: data.get(#payeeId, or: $value.payeeId),
    payeeName: data.get(#payeeName, or: $value.payeeName),
    categoryId: data.get(#categoryId, or: $value.categoryId),
    memo: data.get(#memo, or: $value.memo),
    cleared: data.get(#cleared, or: $value.cleared),
    approved: data.get(#approved, or: $value.approved),
    flagColor: data.get(#flagColor, or: $value.flagColor),
    subtransactions: data.get(#subtransactions, or: $value.subtransactions),
  );

  @override
  TransactionToCreateCopyWith<$R2, TransactionToCreate, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _TransactionToCreateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class SubTransactionToCreateMapper
    extends ClassMapperBase<SubTransactionToCreate> {
  SubTransactionToCreateMapper._();

  static SubTransactionToCreateMapper? _instance;
  static SubTransactionToCreateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SubTransactionToCreateMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'SubTransactionToCreate';

  static int _$amount(SubTransactionToCreate v) => v.amount;
  static const Field<SubTransactionToCreate, int> _f$amount = Field(
    'amount',
    _$amount,
  );
  static String? _$categoryId(SubTransactionToCreate v) => v.categoryId;
  static const Field<SubTransactionToCreate, String> _f$categoryId = Field(
    'categoryId',
    _$categoryId,
    key: r'category_id',
  );
  static String? _$memo(SubTransactionToCreate v) => v.memo;
  static const Field<SubTransactionToCreate, String> _f$memo = Field(
    'memo',
    _$memo,
  );
  static bool? _$cleared(SubTransactionToCreate v) => v.cleared;
  static const Field<SubTransactionToCreate, bool> _f$cleared = Field(
    'cleared',
    _$cleared,
  );
  static bool? _$approved(SubTransactionToCreate v) => v.approved;
  static const Field<SubTransactionToCreate, bool> _f$approved = Field(
    'approved',
    _$approved,
  );

  @override
  final MappableFields<SubTransactionToCreate> fields = const {
    #amount: _f$amount,
    #categoryId: _f$categoryId,
    #memo: _f$memo,
    #cleared: _f$cleared,
    #approved: _f$approved,
  };

  static SubTransactionToCreate _instantiate(DecodingData data) {
    return SubTransactionToCreate(
      amount: data.dec(_f$amount),
      categoryId: data.dec(_f$categoryId),
      memo: data.dec(_f$memo),
      cleared: data.dec(_f$cleared),
      approved: data.dec(_f$approved),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static SubTransactionToCreate fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SubTransactionToCreate>(map);
  }

  static SubTransactionToCreate fromJson(String json) {
    return ensureInitialized().decodeJson<SubTransactionToCreate>(json);
  }
}

mixin SubTransactionToCreateMappable {
  String toJson() {
    return SubTransactionToCreateMapper.ensureInitialized()
        .encodeJson<SubTransactionToCreate>(this as SubTransactionToCreate);
  }

  Map<String, dynamic> toMap() {
    return SubTransactionToCreateMapper.ensureInitialized()
        .encodeMap<SubTransactionToCreate>(this as SubTransactionToCreate);
  }

  SubTransactionToCreateCopyWith<
    SubTransactionToCreate,
    SubTransactionToCreate,
    SubTransactionToCreate
  >
  get copyWith =>
      _SubTransactionToCreateCopyWithImpl<
        SubTransactionToCreate,
        SubTransactionToCreate
      >(this as SubTransactionToCreate, $identity, $identity);
  @override
  String toString() {
    return SubTransactionToCreateMapper.ensureInitialized().stringifyValue(
      this as SubTransactionToCreate,
    );
  }

  @override
  bool operator ==(Object other) {
    return SubTransactionToCreateMapper.ensureInitialized().equalsValue(
      this as SubTransactionToCreate,
      other,
    );
  }

  @override
  int get hashCode {
    return SubTransactionToCreateMapper.ensureInitialized().hashValue(
      this as SubTransactionToCreate,
    );
  }
}

extension SubTransactionToCreateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SubTransactionToCreate, $Out> {
  SubTransactionToCreateCopyWith<$R, SubTransactionToCreate, $Out>
  get $asSubTransactionToCreate => $base.as(
    (v, t, t2) => _SubTransactionToCreateCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class SubTransactionToCreateCopyWith<
  $R,
  $In extends SubTransactionToCreate,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    int? amount,
    String? categoryId,
    String? memo,
    bool? cleared,
    bool? approved,
  });
  SubTransactionToCreateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _SubTransactionToCreateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SubTransactionToCreate, $Out>
    implements
        SubTransactionToCreateCopyWith<$R, SubTransactionToCreate, $Out> {
  _SubTransactionToCreateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SubTransactionToCreate> $mapper =
      SubTransactionToCreateMapper.ensureInitialized();
  @override
  $R call({
    int? amount,
    Object? categoryId = $none,
    Object? memo = $none,
    Object? cleared = $none,
    Object? approved = $none,
  }) => $apply(
    FieldCopyWithData({
      if (amount != null) #amount: amount,
      if (categoryId != $none) #categoryId: categoryId,
      if (memo != $none) #memo: memo,
      if (cleared != $none) #cleared: cleared,
      if (approved != $none) #approved: approved,
    }),
  );
  @override
  SubTransactionToCreate $make(CopyWithData data) => SubTransactionToCreate(
    amount: data.get(#amount, or: $value.amount),
    categoryId: data.get(#categoryId, or: $value.categoryId),
    memo: data.get(#memo, or: $value.memo),
    cleared: data.get(#cleared, or: $value.cleared),
    approved: data.get(#approved, or: $value.approved),
  );

  @override
  SubTransactionToCreateCopyWith<$R2, SubTransactionToCreate, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _SubTransactionToCreateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

