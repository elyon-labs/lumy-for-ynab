// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'transactions_response.dart';

class ScheduledTransactionFrequencyMapper extends EnumMapper<ScheduledTransactionFrequency> {
  ScheduledTransactionFrequencyMapper._();

  static ScheduledTransactionFrequencyMapper? _instance;
  static ScheduledTransactionFrequencyMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ScheduledTransactionFrequencyMapper._());
    }
    return _instance!;
  }

  static ScheduledTransactionFrequency fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  ScheduledTransactionFrequency decode(dynamic value) {
    switch (value) {
      case 'never':
        return ScheduledTransactionFrequency.never;
      case 'daily':
        return ScheduledTransactionFrequency.daily;
      case 'weekly':
        return ScheduledTransactionFrequency.weekly;
      case 'everyOtherWeek':
        return ScheduledTransactionFrequency.everyOtherWeek;
      case 'twiceAMonth':
        return ScheduledTransactionFrequency.twiceAMonth;
      case 'every4Weeks':
        return ScheduledTransactionFrequency.every4Weeks;
      case 'monthly':
        return ScheduledTransactionFrequency.monthly;
      case 'everyOtherMonth':
        return ScheduledTransactionFrequency.everyOtherMonth;
      case 'every3Months':
        return ScheduledTransactionFrequency.every3Months;
      case 'every4Months':
        return ScheduledTransactionFrequency.every4Months;
      case 'twiceAYear':
        return ScheduledTransactionFrequency.twiceAYear;
      case 'yearly':
        return ScheduledTransactionFrequency.yearly;
      case 'everyOtherYear':
        return ScheduledTransactionFrequency.everyOtherYear;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(ScheduledTransactionFrequency self) {
    switch (self) {
      case ScheduledTransactionFrequency.never:
        return 'never';
      case ScheduledTransactionFrequency.daily:
        return 'daily';
      case ScheduledTransactionFrequency.weekly:
        return 'weekly';
      case ScheduledTransactionFrequency.everyOtherWeek:
        return 'everyOtherWeek';
      case ScheduledTransactionFrequency.twiceAMonth:
        return 'twiceAMonth';
      case ScheduledTransactionFrequency.every4Weeks:
        return 'every4Weeks';
      case ScheduledTransactionFrequency.monthly:
        return 'monthly';
      case ScheduledTransactionFrequency.everyOtherMonth:
        return 'everyOtherMonth';
      case ScheduledTransactionFrequency.every3Months:
        return 'every3Months';
      case ScheduledTransactionFrequency.every4Months:
        return 'every4Months';
      case ScheduledTransactionFrequency.twiceAYear:
        return 'twiceAYear';
      case ScheduledTransactionFrequency.yearly:
        return 'yearly';
      case ScheduledTransactionFrequency.everyOtherYear:
        return 'everyOtherYear';
    }
  }
}

extension ScheduledTransactionFrequencyMapperExtension on ScheduledTransactionFrequency {
  String toValue() {
    ScheduledTransactionFrequencyMapper.ensureInitialized();
    return MapperContainer.globals.toValue<ScheduledTransactionFrequency>(this) as String;
  }
}

class TransactionsResponseMapper extends ClassMapperBase<TransactionsResponse> {
  TransactionsResponseMapper._();

  static TransactionsResponseMapper? _instance;
  static TransactionsResponseMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = TransactionsResponseMapper._());
      TransactionsMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'TransactionsResponse';

  static Transactions _$data(TransactionsResponse v) => v.data;
  static const Field<TransactionsResponse, Transactions> _f$data = Field('data', _$data);

  @override
  final MappableFields<TransactionsResponse> fields = const {#data: _f$data};

  static TransactionsResponse _instantiate(DecodingData data) {
    return TransactionsResponse(data: data.dec(_f$data));
  }

  @override
  final Function instantiate = _instantiate;

  static TransactionsResponse fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<TransactionsResponse>(map);
  }

  static TransactionsResponse fromJson(String json) {
    return ensureInitialized().decodeJson<TransactionsResponse>(json);
  }
}

mixin TransactionsResponseMappable {
  String toJson() {
    return TransactionsResponseMapper.ensureInitialized().encodeJson<TransactionsResponse>(
      this as TransactionsResponse,
    );
  }

  Map<String, dynamic> toMap() {
    return TransactionsResponseMapper.ensureInitialized().encodeMap<TransactionsResponse>(
      this as TransactionsResponse,
    );
  }

  TransactionsResponseCopyWith<TransactionsResponse, TransactionsResponse, TransactionsResponse>
  get copyWith =>
      _TransactionsResponseCopyWithImpl(this as TransactionsResponse, $identity, $identity);
  @override
  String toString() {
    return TransactionsResponseMapper.ensureInitialized().stringifyValue(
      this as TransactionsResponse,
    );
  }

  @override
  bool operator ==(Object other) {
    return TransactionsResponseMapper.ensureInitialized().equalsValue(
      this as TransactionsResponse,
      other,
    );
  }

  @override
  int get hashCode {
    return TransactionsResponseMapper.ensureInitialized().hashValue(this as TransactionsResponse);
  }
}

extension TransactionsResponseValueCopy<$R, $Out>
    on ObjectCopyWith<$R, TransactionsResponse, $Out> {
  TransactionsResponseCopyWith<$R, TransactionsResponse, $Out> get $asTransactionsResponse =>
      $base.as((v, t, t2) => _TransactionsResponseCopyWithImpl(v, t, t2));
}

abstract class TransactionsResponseCopyWith<$R, $In extends TransactionsResponse, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  TransactionsCopyWith<$R, Transactions, Transactions> get data;
  $R call({Transactions? data});
  TransactionsResponseCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _TransactionsResponseCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, TransactionsResponse, $Out>
    implements TransactionsResponseCopyWith<$R, TransactionsResponse, $Out> {
  _TransactionsResponseCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<TransactionsResponse> $mapper =
      TransactionsResponseMapper.ensureInitialized();
  @override
  TransactionsCopyWith<$R, Transactions, Transactions> get data =>
      $value.data.copyWith.$chain((v) => call(data: v));
  @override
  $R call({Transactions? data}) => $apply(FieldCopyWithData({if (data != null) #data: data}));
  @override
  TransactionsResponse $make(CopyWithData data) =>
      TransactionsResponse(data: data.get(#data, or: $value.data));

  @override
  TransactionsResponseCopyWith<$R2, TransactionsResponse, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _TransactionsResponseCopyWithImpl($value, $cast, t);
}

class TransactionsMapper extends ClassMapperBase<Transactions> {
  TransactionsMapper._();

  static TransactionsMapper? _instance;
  static TransactionsMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = TransactionsMapper._());
      PastTransactionMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'Transactions';

  static int _$serverKnowledge(Transactions v) => v.serverKnowledge;
  static const Field<Transactions, int> _f$serverKnowledge = Field(
    'serverKnowledge',
    _$serverKnowledge,
    key: 'server_knowledge',
  );
  static List<PastTransaction> _$transactions(Transactions v) => v.transactions;
  static const Field<Transactions, List<PastTransaction>> _f$transactions = Field(
    'transactions',
    _$transactions,
  );

  @override
  final MappableFields<Transactions> fields = const {
    #serverKnowledge: _f$serverKnowledge,
    #transactions: _f$transactions,
  };

  static Transactions _instantiate(DecodingData data) {
    return Transactions(
      serverKnowledge: data.dec(_f$serverKnowledge),
      transactions: data.dec(_f$transactions),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static Transactions fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Transactions>(map);
  }

  static Transactions fromJson(String json) {
    return ensureInitialized().decodeJson<Transactions>(json);
  }
}

mixin TransactionsMappable {
  String toJson() {
    return TransactionsMapper.ensureInitialized().encodeJson<Transactions>(this as Transactions);
  }

  Map<String, dynamic> toMap() {
    return TransactionsMapper.ensureInitialized().encodeMap<Transactions>(this as Transactions);
  }

  TransactionsCopyWith<Transactions, Transactions, Transactions> get copyWith =>
      _TransactionsCopyWithImpl(this as Transactions, $identity, $identity);
  @override
  String toString() {
    return TransactionsMapper.ensureInitialized().stringifyValue(this as Transactions);
  }

  @override
  bool operator ==(Object other) {
    return TransactionsMapper.ensureInitialized().equalsValue(this as Transactions, other);
  }

  @override
  int get hashCode {
    return TransactionsMapper.ensureInitialized().hashValue(this as Transactions);
  }
}

extension TransactionsValueCopy<$R, $Out> on ObjectCopyWith<$R, Transactions, $Out> {
  TransactionsCopyWith<$R, Transactions, $Out> get $asTransactions =>
      $base.as((v, t, t2) => _TransactionsCopyWithImpl(v, t, t2));
}

abstract class TransactionsCopyWith<$R, $In extends Transactions, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, PastTransaction, PastTransactionCopyWith<$R, PastTransaction, PastTransaction>>
  get transactions;
  $R call({int? serverKnowledge, List<PastTransaction>? transactions});
  TransactionsCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _TransactionsCopyWithImpl<$R, $Out> extends ClassCopyWithBase<$R, Transactions, $Out>
    implements TransactionsCopyWith<$R, Transactions, $Out> {
  _TransactionsCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Transactions> $mapper = TransactionsMapper.ensureInitialized();
  @override
  ListCopyWith<$R, PastTransaction, PastTransactionCopyWith<$R, PastTransaction, PastTransaction>>
  get transactions => ListCopyWith(
    $value.transactions,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(transactions: v),
  );
  @override
  $R call({int? serverKnowledge, List<PastTransaction>? transactions}) => $apply(
    FieldCopyWithData({
      if (serverKnowledge != null) #serverKnowledge: serverKnowledge,
      if (transactions != null) #transactions: transactions,
    }),
  );
  @override
  Transactions $make(CopyWithData data) => Transactions(
    serverKnowledge: data.get(#serverKnowledge, or: $value.serverKnowledge),
    transactions: data.get(#transactions, or: $value.transactions),
  );

  @override
  TransactionsCopyWith<$R2, Transactions, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _TransactionsCopyWithImpl($value, $cast, t);
}

class PastTransactionMapper extends ClassMapperBase<PastTransaction> {
  PastTransactionMapper._();

  static PastTransactionMapper? _instance;
  static PastTransactionMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = PastTransactionMapper._());
      SubTransactionMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'PastTransaction';

  static String _$id(PastTransaction v) => v.id;
  static const Field<PastTransaction, String> _f$id = Field('id', _$id);
  static String? _$payeeId(PastTransaction v) => v.payeeId;
  static const Field<PastTransaction, String> _f$payeeId = Field(
    'payeeId',
    _$payeeId,
    key: 'payee_id',
  );
  static int _$amount(PastTransaction v) => v.amount;
  static const Field<PastTransaction, int> _f$amount = Field('amount', _$amount);
  static String? _$categoryId(PastTransaction v) => v.categoryId;
  static const Field<PastTransaction, String> _f$categoryId = Field(
    'categoryId',
    _$categoryId,
    key: 'category_id',
  );
  static String? _$memo(PastTransaction v) => v.memo;
  static const Field<PastTransaction, String> _f$memo = Field('memo', _$memo);
  static String? _$transferAccountId(PastTransaction v) => v.transferAccountId;
  static const Field<PastTransaction, String> _f$transferAccountId = Field(
    'transferAccountId',
    _$transferAccountId,
    key: 'transfer_account_id',
  );
  static bool _$isDeleted(PastTransaction v) => v.isDeleted;
  static const Field<PastTransaction, bool> _f$isDeleted = Field(
    'isDeleted',
    _$isDeleted,
    key: 'deleted',
  );
  static String? _$payeeName(PastTransaction v) => v.payeeName;
  static const Field<PastTransaction, String> _f$payeeName = Field(
    'payeeName',
    _$payeeName,
    key: 'payee_name',
  );
  static String? _$categoryName(PastTransaction v) => v.categoryName;
  static const Field<PastTransaction, String> _f$categoryName = Field(
    'categoryName',
    _$categoryName,
    key: 'category_name',
  );
  static String? _$transferTransactionId(PastTransaction v) => v.transferTransactionId;
  static const Field<PastTransaction, String> _f$transferTransactionId = Field(
    'transferTransactionId',
    _$transferTransactionId,
  );
  static String _$date(PastTransaction v) => v.date;
  static const Field<PastTransaction, String> _f$date = Field('date', _$date);
  static String _$accountId(PastTransaction v) => v.accountId;
  static const Field<PastTransaction, String> _f$accountId = Field(
    'accountId',
    _$accountId,
    key: 'account_id',
  );
  static String? _$matchedTransactionId(PastTransaction v) => v.matchedTransactionId;
  static const Field<PastTransaction, String> _f$matchedTransactionId = Field(
    'matchedTransactionId',
    _$matchedTransactionId,
    key: 'matched_transaction_id',
  );
  static String? _$importId(PastTransaction v) => v.importId;
  static const Field<PastTransaction, String> _f$importId = Field(
    'importId',
    _$importId,
    key: 'import_id',
  );
  static String? _$flagColor(PastTransaction v) => v.flagColor;
  static const Field<PastTransaction, String> _f$flagColor = Field(
    'flagColor',
    _$flagColor,
    key: 'flag_color',
  );
  static List<SubTransaction> _$subTransactions(PastTransaction v) => v.subTransactions;
  static const Field<PastTransaction, List<SubTransaction>> _f$subTransactions = Field(
    'subTransactions',
    _$subTransactions,
    key: 'subtransactions',
  );

  @override
  final MappableFields<PastTransaction> fields = const {
    #id: _f$id,
    #payeeId: _f$payeeId,
    #amount: _f$amount,
    #categoryId: _f$categoryId,
    #memo: _f$memo,
    #transferAccountId: _f$transferAccountId,
    #isDeleted: _f$isDeleted,
    #payeeName: _f$payeeName,
    #categoryName: _f$categoryName,
    #transferTransactionId: _f$transferTransactionId,
    #date: _f$date,
    #accountId: _f$accountId,
    #matchedTransactionId: _f$matchedTransactionId,
    #importId: _f$importId,
    #flagColor: _f$flagColor,
    #subTransactions: _f$subTransactions,
  };

  static PastTransaction _instantiate(DecodingData data) {
    return PastTransaction(
      id: data.dec(_f$id),
      payeeId: data.dec(_f$payeeId),
      amount: data.dec(_f$amount),
      categoryId: data.dec(_f$categoryId),
      memo: data.dec(_f$memo),
      transferAccountId: data.dec(_f$transferAccountId),
      isDeleted: data.dec(_f$isDeleted),
      payeeName: data.dec(_f$payeeName),
      categoryName: data.dec(_f$categoryName),
      transferTransactionId: data.dec(_f$transferTransactionId),
      date: data.dec(_f$date),
      accountId: data.dec(_f$accountId),
      matchedTransactionId: data.dec(_f$matchedTransactionId),
      importId: data.dec(_f$importId),
      flagColor: data.dec(_f$flagColor),
      subTransactions: data.dec(_f$subTransactions),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static PastTransaction fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<PastTransaction>(map);
  }

  static PastTransaction fromJson(String json) {
    return ensureInitialized().decodeJson<PastTransaction>(json);
  }
}

mixin PastTransactionMappable {
  String toJson() {
    return PastTransactionMapper.ensureInitialized().encodeJson<PastTransaction>(
      this as PastTransaction,
    );
  }

  Map<String, dynamic> toMap() {
    return PastTransactionMapper.ensureInitialized().encodeMap<PastTransaction>(
      this as PastTransaction,
    );
  }

  PastTransactionCopyWith<PastTransaction, PastTransaction, PastTransaction> get copyWith =>
      _PastTransactionCopyWithImpl(this as PastTransaction, $identity, $identity);
  @override
  String toString() {
    return PastTransactionMapper.ensureInitialized().stringifyValue(this as PastTransaction);
  }

  @override
  bool operator ==(Object other) {
    return PastTransactionMapper.ensureInitialized().equalsValue(this as PastTransaction, other);
  }

  @override
  int get hashCode {
    return PastTransactionMapper.ensureInitialized().hashValue(this as PastTransaction);
  }
}

extension PastTransactionValueCopy<$R, $Out> on ObjectCopyWith<$R, PastTransaction, $Out> {
  PastTransactionCopyWith<$R, PastTransaction, $Out> get $asPastTransaction =>
      $base.as((v, t, t2) => _PastTransactionCopyWithImpl(v, t, t2));
}

abstract class PastTransactionCopyWith<$R, $In extends PastTransaction, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, SubTransaction, SubTransactionCopyWith<$R, SubTransaction, SubTransaction>>
  get subTransactions;
  $R call({
    String? id,
    String? payeeId,
    int? amount,
    String? categoryId,
    String? memo,
    String? transferAccountId,
    bool? isDeleted,
    String? payeeName,
    String? categoryName,
    String? transferTransactionId,
    String? date,
    String? accountId,
    String? matchedTransactionId,
    String? importId,
    String? flagColor,
    List<SubTransaction>? subTransactions,
  });
  PastTransactionCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _PastTransactionCopyWithImpl<$R, $Out> extends ClassCopyWithBase<$R, PastTransaction, $Out>
    implements PastTransactionCopyWith<$R, PastTransaction, $Out> {
  _PastTransactionCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<PastTransaction> $mapper = PastTransactionMapper.ensureInitialized();
  @override
  ListCopyWith<$R, SubTransaction, SubTransactionCopyWith<$R, SubTransaction, SubTransaction>>
  get subTransactions => ListCopyWith(
    $value.subTransactions,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(subTransactions: v),
  );
  @override
  $R call({
    String? id,
    Object? payeeId = $none,
    int? amount,
    Object? categoryId = $none,
    Object? memo = $none,
    Object? transferAccountId = $none,
    bool? isDeleted,
    Object? payeeName = $none,
    Object? categoryName = $none,
    Object? transferTransactionId = $none,
    String? date,
    String? accountId,
    Object? matchedTransactionId = $none,
    Object? importId = $none,
    Object? flagColor = $none,
    List<SubTransaction>? subTransactions,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (payeeId != $none) #payeeId: payeeId,
      if (amount != null) #amount: amount,
      if (categoryId != $none) #categoryId: categoryId,
      if (memo != $none) #memo: memo,
      if (transferAccountId != $none) #transferAccountId: transferAccountId,
      if (isDeleted != null) #isDeleted: isDeleted,
      if (payeeName != $none) #payeeName: payeeName,
      if (categoryName != $none) #categoryName: categoryName,
      if (transferTransactionId != $none) #transferTransactionId: transferTransactionId,
      if (date != null) #date: date,
      if (accountId != null) #accountId: accountId,
      if (matchedTransactionId != $none) #matchedTransactionId: matchedTransactionId,
      if (importId != $none) #importId: importId,
      if (flagColor != $none) #flagColor: flagColor,
      if (subTransactions != null) #subTransactions: subTransactions,
    }),
  );
  @override
  PastTransaction $make(CopyWithData data) => PastTransaction(
    id: data.get(#id, or: $value.id),
    payeeId: data.get(#payeeId, or: $value.payeeId),
    amount: data.get(#amount, or: $value.amount),
    categoryId: data.get(#categoryId, or: $value.categoryId),
    memo: data.get(#memo, or: $value.memo),
    transferAccountId: data.get(#transferAccountId, or: $value.transferAccountId),
    isDeleted: data.get(#isDeleted, or: $value.isDeleted),
    payeeName: data.get(#payeeName, or: $value.payeeName),
    categoryName: data.get(#categoryName, or: $value.categoryName),
    transferTransactionId: data.get(#transferTransactionId, or: $value.transferTransactionId),
    date: data.get(#date, or: $value.date),
    accountId: data.get(#accountId, or: $value.accountId),
    matchedTransactionId: data.get(#matchedTransactionId, or: $value.matchedTransactionId),
    importId: data.get(#importId, or: $value.importId),
    flagColor: data.get(#flagColor, or: $value.flagColor),
    subTransactions: data.get(#subTransactions, or: $value.subTransactions),
  );

  @override
  PastTransactionCopyWith<$R2, PastTransaction, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _PastTransactionCopyWithImpl($value, $cast, t);
}

class SubTransactionMapper extends ClassMapperBase<SubTransaction> {
  SubTransactionMapper._();

  static SubTransactionMapper? _instance;
  static SubTransactionMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SubTransactionMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'SubTransaction';

  static String _$transactionId(SubTransaction v) => v.transactionId;
  static const Field<SubTransaction, String> _f$transactionId = Field(
    'transactionId',
    _$transactionId,
    key: 'transaction_id',
  );
  static String _$id(SubTransaction v) => v.id;
  static const Field<SubTransaction, String> _f$id = Field('id', _$id);
  static String? _$payeeName(SubTransaction v) => v.payeeName;
  static const Field<SubTransaction, String> _f$payeeName = Field(
    'payeeName',
    _$payeeName,
    key: 'payee_name',
  );
  static String? _$payeeId(SubTransaction v) => v.payeeId;
  static const Field<SubTransaction, String> _f$payeeId = Field(
    'payeeId',
    _$payeeId,
    key: 'payee_id',
  );
  static int _$amount(SubTransaction v) => v.amount;
  static const Field<SubTransaction, int> _f$amount = Field('amount', _$amount);
  static String? _$categoryId(SubTransaction v) => v.categoryId;
  static const Field<SubTransaction, String> _f$categoryId = Field(
    'categoryId',
    _$categoryId,
    key: 'category_id',
  );
  static String? _$categoryName(SubTransaction v) => v.categoryName;
  static const Field<SubTransaction, String> _f$categoryName = Field(
    'categoryName',
    _$categoryName,
    key: 'category_name',
  );
  static String? _$memo(SubTransaction v) => v.memo;
  static const Field<SubTransaction, String> _f$memo = Field('memo', _$memo);
  static String? _$transferAccountId(SubTransaction v) => v.transferAccountId;
  static const Field<SubTransaction, String> _f$transferAccountId = Field(
    'transferAccountId',
    _$transferAccountId,
    key: 'transfer_account_id',
  );
  static String? _$transferTransactionId(SubTransaction v) => v.transferTransactionId;
  static const Field<SubTransaction, String> _f$transferTransactionId = Field(
    'transferTransactionId',
    _$transferTransactionId,
  );
  static bool _$isDeleted(SubTransaction v) => v.isDeleted;
  static const Field<SubTransaction, bool> _f$isDeleted = Field(
    'isDeleted',
    _$isDeleted,
    key: 'deleted',
  );

  @override
  final MappableFields<SubTransaction> fields = const {
    #transactionId: _f$transactionId,
    #id: _f$id,
    #payeeName: _f$payeeName,
    #payeeId: _f$payeeId,
    #amount: _f$amount,
    #categoryId: _f$categoryId,
    #categoryName: _f$categoryName,
    #memo: _f$memo,
    #transferAccountId: _f$transferAccountId,
    #transferTransactionId: _f$transferTransactionId,
    #isDeleted: _f$isDeleted,
  };

  static SubTransaction _instantiate(DecodingData data) {
    return SubTransaction(
      transactionId: data.dec(_f$transactionId),
      id: data.dec(_f$id),
      payeeName: data.dec(_f$payeeName),
      payeeId: data.dec(_f$payeeId),
      amount: data.dec(_f$amount),
      categoryId: data.dec(_f$categoryId),
      categoryName: data.dec(_f$categoryName),
      memo: data.dec(_f$memo),
      transferAccountId: data.dec(_f$transferAccountId),
      transferTransactionId: data.dec(_f$transferTransactionId),
      isDeleted: data.dec(_f$isDeleted),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static SubTransaction fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SubTransaction>(map);
  }

  static SubTransaction fromJson(String json) {
    return ensureInitialized().decodeJson<SubTransaction>(json);
  }
}

mixin SubTransactionMappable {
  String toJson() {
    return SubTransactionMapper.ensureInitialized().encodeJson<SubTransaction>(
      this as SubTransaction,
    );
  }

  Map<String, dynamic> toMap() {
    return SubTransactionMapper.ensureInitialized().encodeMap<SubTransaction>(
      this as SubTransaction,
    );
  }

  SubTransactionCopyWith<SubTransaction, SubTransaction, SubTransaction> get copyWith =>
      _SubTransactionCopyWithImpl(this as SubTransaction, $identity, $identity);
  @override
  String toString() {
    return SubTransactionMapper.ensureInitialized().stringifyValue(this as SubTransaction);
  }

  @override
  bool operator ==(Object other) {
    return SubTransactionMapper.ensureInitialized().equalsValue(this as SubTransaction, other);
  }

  @override
  int get hashCode {
    return SubTransactionMapper.ensureInitialized().hashValue(this as SubTransaction);
  }
}

extension SubTransactionValueCopy<$R, $Out> on ObjectCopyWith<$R, SubTransaction, $Out> {
  SubTransactionCopyWith<$R, SubTransaction, $Out> get $asSubTransaction =>
      $base.as((v, t, t2) => _SubTransactionCopyWithImpl(v, t, t2));
}

abstract class SubTransactionCopyWith<$R, $In extends SubTransaction, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? transactionId,
    String? id,
    String? payeeName,
    String? payeeId,
    int? amount,
    String? categoryId,
    String? categoryName,
    String? memo,
    String? transferAccountId,
    String? transferTransactionId,
    bool? isDeleted,
  });
  SubTransactionCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _SubTransactionCopyWithImpl<$R, $Out> extends ClassCopyWithBase<$R, SubTransaction, $Out>
    implements SubTransactionCopyWith<$R, SubTransaction, $Out> {
  _SubTransactionCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SubTransaction> $mapper = SubTransactionMapper.ensureInitialized();
  @override
  $R call({
    String? transactionId,
    String? id,
    Object? payeeName = $none,
    Object? payeeId = $none,
    int? amount,
    Object? categoryId = $none,
    Object? categoryName = $none,
    Object? memo = $none,
    Object? transferAccountId = $none,
    Object? transferTransactionId = $none,
    bool? isDeleted,
  }) => $apply(
    FieldCopyWithData({
      if (transactionId != null) #transactionId: transactionId,
      if (id != null) #id: id,
      if (payeeName != $none) #payeeName: payeeName,
      if (payeeId != $none) #payeeId: payeeId,
      if (amount != null) #amount: amount,
      if (categoryId != $none) #categoryId: categoryId,
      if (categoryName != $none) #categoryName: categoryName,
      if (memo != $none) #memo: memo,
      if (transferAccountId != $none) #transferAccountId: transferAccountId,
      if (transferTransactionId != $none) #transferTransactionId: transferTransactionId,
      if (isDeleted != null) #isDeleted: isDeleted,
    }),
  );
  @override
  SubTransaction $make(CopyWithData data) => SubTransaction(
    transactionId: data.get(#transactionId, or: $value.transactionId),
    id: data.get(#id, or: $value.id),
    payeeName: data.get(#payeeName, or: $value.payeeName),
    payeeId: data.get(#payeeId, or: $value.payeeId),
    amount: data.get(#amount, or: $value.amount),
    categoryId: data.get(#categoryId, or: $value.categoryId),
    categoryName: data.get(#categoryName, or: $value.categoryName),
    memo: data.get(#memo, or: $value.memo),
    transferAccountId: data.get(#transferAccountId, or: $value.transferAccountId),
    transferTransactionId: data.get(#transferTransactionId, or: $value.transferTransactionId),
    isDeleted: data.get(#isDeleted, or: $value.isDeleted),
  );

  @override
  SubTransactionCopyWith<$R2, SubTransaction, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _SubTransactionCopyWithImpl($value, $cast, t);
}

class ScheduledTransactionMapper extends ClassMapperBase<ScheduledTransaction> {
  ScheduledTransactionMapper._();

  static ScheduledTransactionMapper? _instance;
  static ScheduledTransactionMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ScheduledTransactionMapper._());
      ScheduledTransactionFrequencyMapper.ensureInitialized();
      ScheduledSubTransactionMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'ScheduledTransaction';

  static String _$id(ScheduledTransaction v) => v.id;
  static const Field<ScheduledTransaction, String> _f$id = Field('id', _$id);
  static String? _$payeeId(ScheduledTransaction v) => v.payeeId;
  static const Field<ScheduledTransaction, String> _f$payeeId = Field(
    'payeeId',
    _$payeeId,
    key: 'payee_id',
  );
  static int _$amount(ScheduledTransaction v) => v.amount;
  static const Field<ScheduledTransaction, int> _f$amount = Field('amount', _$amount);
  static String? _$categoryId(ScheduledTransaction v) => v.categoryId;
  static const Field<ScheduledTransaction, String> _f$categoryId = Field(
    'categoryId',
    _$categoryId,
    key: 'category_id',
  );
  static String? _$memo(ScheduledTransaction v) => v.memo;
  static const Field<ScheduledTransaction, String> _f$memo = Field('memo', _$memo);
  static String? _$transferAccountId(ScheduledTransaction v) => v.transferAccountId;
  static const Field<ScheduledTransaction, String> _f$transferAccountId = Field(
    'transferAccountId',
    _$transferAccountId,
    key: 'transfer_account_id',
  );
  static bool _$isDeleted(ScheduledTransaction v) => v.isDeleted;
  static const Field<ScheduledTransaction, bool> _f$isDeleted = Field(
    'isDeleted',
    _$isDeleted,
    key: 'deleted',
  );
  static String _$dateFirst(ScheduledTransaction v) => v.dateFirst;
  static const Field<ScheduledTransaction, String> _f$dateFirst = Field(
    'dateFirst',
    _$dateFirst,
    key: 'date_first',
  );
  static String _$dateNext(ScheduledTransaction v) => v.dateNext;
  static const Field<ScheduledTransaction, String> _f$dateNext = Field(
    'dateNext',
    _$dateNext,
    key: 'date_next',
  );
  static ScheduledTransactionFrequency _$frequency(ScheduledTransaction v) => v.frequency;
  static const Field<ScheduledTransaction, ScheduledTransactionFrequency> _f$frequency = Field(
    'frequency',
    _$frequency,
  );
  static String? _$flagColor(ScheduledTransaction v) => v.flagColor;
  static const Field<ScheduledTransaction, String> _f$flagColor = Field(
    'flagColor',
    _$flagColor,
    key: 'flag_color',
  );
  static String? _$flagName(ScheduledTransaction v) => v.flagName;
  static const Field<ScheduledTransaction, String> _f$flagName = Field(
    'flagName',
    _$flagName,
    key: 'flag_name',
  );
  static String _$accountId(ScheduledTransaction v) => v.accountId;
  static const Field<ScheduledTransaction, String> _f$accountId = Field(
    'accountId',
    _$accountId,
    key: 'account_id',
  );
  static String _$accountName(ScheduledTransaction v) => v.accountName;
  static const Field<ScheduledTransaction, String> _f$accountName = Field(
    'accountName',
    _$accountName,
    key: 'account_name',
  );
  static String? _$payeeName(ScheduledTransaction v) => v.payeeName;
  static const Field<ScheduledTransaction, String> _f$payeeName = Field(
    'payeeName',
    _$payeeName,
    key: 'payee_name',
  );
  static String? _$categoryName(ScheduledTransaction v) => v.categoryName;
  static const Field<ScheduledTransaction, String> _f$categoryName = Field(
    'categoryName',
    _$categoryName,
    key: 'category_name',
  );
  static List<ScheduledSubTransaction> _$subTransactions(ScheduledTransaction v) =>
      v.subTransactions;
  static const Field<ScheduledTransaction, List<ScheduledSubTransaction>> _f$subTransactions =
      Field('subTransactions', _$subTransactions, key: 'subtransactions');

  @override
  final MappableFields<ScheduledTransaction> fields = const {
    #id: _f$id,
    #payeeId: _f$payeeId,
    #amount: _f$amount,
    #categoryId: _f$categoryId,
    #memo: _f$memo,
    #transferAccountId: _f$transferAccountId,
    #isDeleted: _f$isDeleted,
    #dateFirst: _f$dateFirst,
    #dateNext: _f$dateNext,
    #frequency: _f$frequency,
    #flagColor: _f$flagColor,
    #flagName: _f$flagName,
    #accountId: _f$accountId,
    #accountName: _f$accountName,
    #payeeName: _f$payeeName,
    #categoryName: _f$categoryName,
    #subTransactions: _f$subTransactions,
  };

  static ScheduledTransaction _instantiate(DecodingData data) {
    return ScheduledTransaction(
      id: data.dec(_f$id),
      payeeId: data.dec(_f$payeeId),
      amount: data.dec(_f$amount),
      categoryId: data.dec(_f$categoryId),
      memo: data.dec(_f$memo),
      transferAccountId: data.dec(_f$transferAccountId),
      isDeleted: data.dec(_f$isDeleted),
      dateFirst: data.dec(_f$dateFirst),
      dateNext: data.dec(_f$dateNext),
      frequency: data.dec(_f$frequency),
      flagColor: data.dec(_f$flagColor),
      flagName: data.dec(_f$flagName),
      accountId: data.dec(_f$accountId),
      accountName: data.dec(_f$accountName),
      payeeName: data.dec(_f$payeeName),
      categoryName: data.dec(_f$categoryName),
      subTransactions: data.dec(_f$subTransactions),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ScheduledTransaction fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ScheduledTransaction>(map);
  }

  static ScheduledTransaction fromJson(String json) {
    return ensureInitialized().decodeJson<ScheduledTransaction>(json);
  }
}

mixin ScheduledTransactionMappable {
  String toJson() {
    return ScheduledTransactionMapper.ensureInitialized().encodeJson<ScheduledTransaction>(
      this as ScheduledTransaction,
    );
  }

  Map<String, dynamic> toMap() {
    return ScheduledTransactionMapper.ensureInitialized().encodeMap<ScheduledTransaction>(
      this as ScheduledTransaction,
    );
  }

  ScheduledTransactionCopyWith<ScheduledTransaction, ScheduledTransaction, ScheduledTransaction>
  get copyWith =>
      _ScheduledTransactionCopyWithImpl(this as ScheduledTransaction, $identity, $identity);
  @override
  String toString() {
    return ScheduledTransactionMapper.ensureInitialized().stringifyValue(
      this as ScheduledTransaction,
    );
  }

  @override
  bool operator ==(Object other) {
    return ScheduledTransactionMapper.ensureInitialized().equalsValue(
      this as ScheduledTransaction,
      other,
    );
  }

  @override
  int get hashCode {
    return ScheduledTransactionMapper.ensureInitialized().hashValue(this as ScheduledTransaction);
  }
}

extension ScheduledTransactionValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ScheduledTransaction, $Out> {
  ScheduledTransactionCopyWith<$R, ScheduledTransaction, $Out> get $asScheduledTransaction =>
      $base.as((v, t, t2) => _ScheduledTransactionCopyWithImpl(v, t, t2));
}

abstract class ScheduledTransactionCopyWith<$R, $In extends ScheduledTransaction, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<
    $R,
    ScheduledSubTransaction,
    ScheduledSubTransactionCopyWith<$R, ScheduledSubTransaction, ScheduledSubTransaction>
  >
  get subTransactions;
  $R call({
    String? id,
    String? payeeId,
    int? amount,
    String? categoryId,
    String? memo,
    String? transferAccountId,
    bool? isDeleted,
    String? dateFirst,
    String? dateNext,
    ScheduledTransactionFrequency? frequency,
    String? flagColor,
    String? flagName,
    String? accountId,
    String? accountName,
    String? payeeName,
    String? categoryName,
    List<ScheduledSubTransaction>? subTransactions,
  });
  ScheduledTransactionCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _ScheduledTransactionCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ScheduledTransaction, $Out>
    implements ScheduledTransactionCopyWith<$R, ScheduledTransaction, $Out> {
  _ScheduledTransactionCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ScheduledTransaction> $mapper =
      ScheduledTransactionMapper.ensureInitialized();
  @override
  ListCopyWith<
    $R,
    ScheduledSubTransaction,
    ScheduledSubTransactionCopyWith<$R, ScheduledSubTransaction, ScheduledSubTransaction>
  >
  get subTransactions => ListCopyWith(
    $value.subTransactions,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(subTransactions: v),
  );
  @override
  $R call({
    String? id,
    Object? payeeId = $none,
    int? amount,
    Object? categoryId = $none,
    Object? memo = $none,
    Object? transferAccountId = $none,
    bool? isDeleted,
    String? dateFirst,
    String? dateNext,
    ScheduledTransactionFrequency? frequency,
    Object? flagColor = $none,
    Object? flagName = $none,
    String? accountId,
    String? accountName,
    Object? payeeName = $none,
    Object? categoryName = $none,
    List<ScheduledSubTransaction>? subTransactions,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (payeeId != $none) #payeeId: payeeId,
      if (amount != null) #amount: amount,
      if (categoryId != $none) #categoryId: categoryId,
      if (memo != $none) #memo: memo,
      if (transferAccountId != $none) #transferAccountId: transferAccountId,
      if (isDeleted != null) #isDeleted: isDeleted,
      if (dateFirst != null) #dateFirst: dateFirst,
      if (dateNext != null) #dateNext: dateNext,
      if (frequency != null) #frequency: frequency,
      if (flagColor != $none) #flagColor: flagColor,
      if (flagName != $none) #flagName: flagName,
      if (accountId != null) #accountId: accountId,
      if (accountName != null) #accountName: accountName,
      if (payeeName != $none) #payeeName: payeeName,
      if (categoryName != $none) #categoryName: categoryName,
      if (subTransactions != null) #subTransactions: subTransactions,
    }),
  );
  @override
  ScheduledTransaction $make(CopyWithData data) => ScheduledTransaction(
    id: data.get(#id, or: $value.id),
    payeeId: data.get(#payeeId, or: $value.payeeId),
    amount: data.get(#amount, or: $value.amount),
    categoryId: data.get(#categoryId, or: $value.categoryId),
    memo: data.get(#memo, or: $value.memo),
    transferAccountId: data.get(#transferAccountId, or: $value.transferAccountId),
    isDeleted: data.get(#isDeleted, or: $value.isDeleted),
    dateFirst: data.get(#dateFirst, or: $value.dateFirst),
    dateNext: data.get(#dateNext, or: $value.dateNext),
    frequency: data.get(#frequency, or: $value.frequency),
    flagColor: data.get(#flagColor, or: $value.flagColor),
    flagName: data.get(#flagName, or: $value.flagName),
    accountId: data.get(#accountId, or: $value.accountId),
    accountName: data.get(#accountName, or: $value.accountName),
    payeeName: data.get(#payeeName, or: $value.payeeName),
    categoryName: data.get(#categoryName, or: $value.categoryName),
    subTransactions: data.get(#subTransactions, or: $value.subTransactions),
  );

  @override
  ScheduledTransactionCopyWith<$R2, ScheduledTransaction, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ScheduledTransactionCopyWithImpl($value, $cast, t);
}

class ScheduledSubTransactionMapper extends ClassMapperBase<ScheduledSubTransaction> {
  ScheduledSubTransactionMapper._();

  static ScheduledSubTransactionMapper? _instance;
  static ScheduledSubTransactionMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ScheduledSubTransactionMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'ScheduledSubTransaction';

  static String _$id(ScheduledSubTransaction v) => v.id;
  static const Field<ScheduledSubTransaction, String> _f$id = Field('id', _$id);
  static String? _$payeeId(ScheduledSubTransaction v) => v.payeeId;
  static const Field<ScheduledSubTransaction, String> _f$payeeId = Field(
    'payeeId',
    _$payeeId,
    key: 'payee_id',
  );
  static int _$amount(ScheduledSubTransaction v) => v.amount;
  static const Field<ScheduledSubTransaction, int> _f$amount = Field('amount', _$amount);
  static String? _$categoryId(ScheduledSubTransaction v) => v.categoryId;
  static const Field<ScheduledSubTransaction, String> _f$categoryId = Field(
    'categoryId',
    _$categoryId,
    key: 'category_id',
  );
  static String? _$memo(ScheduledSubTransaction v) => v.memo;
  static const Field<ScheduledSubTransaction, String> _f$memo = Field('memo', _$memo);
  static String? _$transferAccountId(ScheduledSubTransaction v) => v.transferAccountId;
  static const Field<ScheduledSubTransaction, String> _f$transferAccountId = Field(
    'transferAccountId',
    _$transferAccountId,
    key: 'transfer_account_id',
  );
  static bool _$isDeleted(ScheduledSubTransaction v) => v.isDeleted;
  static const Field<ScheduledSubTransaction, bool> _f$isDeleted = Field(
    'isDeleted',
    _$isDeleted,
    key: 'deleted',
  );
  static String _$scheduledTransactionId(ScheduledSubTransaction v) => v.scheduledTransactionId;
  static const Field<ScheduledSubTransaction, String> _f$scheduledTransactionId = Field(
    'scheduledTransactionId',
    _$scheduledTransactionId,
    key: 'scheduled_transaction_id',
  );

  @override
  final MappableFields<ScheduledSubTransaction> fields = const {
    #id: _f$id,
    #payeeId: _f$payeeId,
    #amount: _f$amount,
    #categoryId: _f$categoryId,
    #memo: _f$memo,
    #transferAccountId: _f$transferAccountId,
    #isDeleted: _f$isDeleted,
    #scheduledTransactionId: _f$scheduledTransactionId,
  };

  static ScheduledSubTransaction _instantiate(DecodingData data) {
    return ScheduledSubTransaction(
      id: data.dec(_f$id),
      payeeId: data.dec(_f$payeeId),
      amount: data.dec(_f$amount),
      categoryId: data.dec(_f$categoryId),
      memo: data.dec(_f$memo),
      transferAccountId: data.dec(_f$transferAccountId),
      isDeleted: data.dec(_f$isDeleted),
      scheduledTransactionId: data.dec(_f$scheduledTransactionId),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ScheduledSubTransaction fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ScheduledSubTransaction>(map);
  }

  static ScheduledSubTransaction fromJson(String json) {
    return ensureInitialized().decodeJson<ScheduledSubTransaction>(json);
  }
}

mixin ScheduledSubTransactionMappable {
  String toJson() {
    return ScheduledSubTransactionMapper.ensureInitialized().encodeJson<ScheduledSubTransaction>(
      this as ScheduledSubTransaction,
    );
  }

  Map<String, dynamic> toMap() {
    return ScheduledSubTransactionMapper.ensureInitialized().encodeMap<ScheduledSubTransaction>(
      this as ScheduledSubTransaction,
    );
  }

  ScheduledSubTransactionCopyWith<
    ScheduledSubTransaction,
    ScheduledSubTransaction,
    ScheduledSubTransaction
  >
  get copyWith =>
      _ScheduledSubTransactionCopyWithImpl(this as ScheduledSubTransaction, $identity, $identity);
  @override
  String toString() {
    return ScheduledSubTransactionMapper.ensureInitialized().stringifyValue(
      this as ScheduledSubTransaction,
    );
  }

  @override
  bool operator ==(Object other) {
    return ScheduledSubTransactionMapper.ensureInitialized().equalsValue(
      this as ScheduledSubTransaction,
      other,
    );
  }

  @override
  int get hashCode {
    return ScheduledSubTransactionMapper.ensureInitialized().hashValue(
      this as ScheduledSubTransaction,
    );
  }
}

extension ScheduledSubTransactionValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ScheduledSubTransaction, $Out> {
  ScheduledSubTransactionCopyWith<$R, ScheduledSubTransaction, $Out>
  get $asScheduledSubTransaction =>
      $base.as((v, t, t2) => _ScheduledSubTransactionCopyWithImpl(v, t, t2));
}

abstract class ScheduledSubTransactionCopyWith<$R, $In extends ScheduledSubTransaction, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? id,
    String? payeeId,
    int? amount,
    String? categoryId,
    String? memo,
    String? transferAccountId,
    bool? isDeleted,
    String? scheduledTransactionId,
  });
  ScheduledSubTransactionCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _ScheduledSubTransactionCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ScheduledSubTransaction, $Out>
    implements ScheduledSubTransactionCopyWith<$R, ScheduledSubTransaction, $Out> {
  _ScheduledSubTransactionCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ScheduledSubTransaction> $mapper =
      ScheduledSubTransactionMapper.ensureInitialized();
  @override
  $R call({
    String? id,
    Object? payeeId = $none,
    int? amount,
    Object? categoryId = $none,
    Object? memo = $none,
    Object? transferAccountId = $none,
    bool? isDeleted,
    String? scheduledTransactionId,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (payeeId != $none) #payeeId: payeeId,
      if (amount != null) #amount: amount,
      if (categoryId != $none) #categoryId: categoryId,
      if (memo != $none) #memo: memo,
      if (transferAccountId != $none) #transferAccountId: transferAccountId,
      if (isDeleted != null) #isDeleted: isDeleted,
      if (scheduledTransactionId != null) #scheduledTransactionId: scheduledTransactionId,
    }),
  );
  @override
  ScheduledSubTransaction $make(CopyWithData data) => ScheduledSubTransaction(
    id: data.get(#id, or: $value.id),
    payeeId: data.get(#payeeId, or: $value.payeeId),
    amount: data.get(#amount, or: $value.amount),
    categoryId: data.get(#categoryId, or: $value.categoryId),
    memo: data.get(#memo, or: $value.memo),
    transferAccountId: data.get(#transferAccountId, or: $value.transferAccountId),
    isDeleted: data.get(#isDeleted, or: $value.isDeleted),
    scheduledTransactionId: data.get(#scheduledTransactionId, or: $value.scheduledTransactionId),
  );

  @override
  ScheduledSubTransactionCopyWith<$R2, ScheduledSubTransaction, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ScheduledSubTransactionCopyWithImpl($value, $cast, t);
}
