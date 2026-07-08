// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'hydrated_scheduled_transaction.dart';

class HydratedScheduledTransactionMapper
    extends ClassMapperBase<HydratedScheduledTransaction> {
  HydratedScheduledTransactionMapper._();

  static HydratedScheduledTransactionMapper? _instance;
  static HydratedScheduledTransactionMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = HydratedScheduledTransactionMapper._(),
      );
      ScheduledTransactionMapper.ensureInitialized();
      ScheduledTransactionFrequencyMapper.ensureInitialized();
      ScheduledSubTransactionMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'HydratedScheduledTransaction';

  static String _$id(HydratedScheduledTransaction v) => v.id;
  static const Field<HydratedScheduledTransaction, String> _f$id = Field(
    'id',
    _$id,
  );
  static String? _$payeeId(HydratedScheduledTransaction v) => v.payeeId;
  static const Field<HydratedScheduledTransaction, String> _f$payeeId = Field(
    'payeeId',
    _$payeeId,
    key: r'payee_id',
  );
  static int _$amount(HydratedScheduledTransaction v) => v.amount;
  static const Field<HydratedScheduledTransaction, int> _f$amount = Field(
    'amount',
    _$amount,
  );
  static String? _$categoryId(HydratedScheduledTransaction v) => v.categoryId;
  static const Field<HydratedScheduledTransaction, String> _f$categoryId =
      Field('categoryId', _$categoryId, key: r'category_id');
  static String? _$memo(HydratedScheduledTransaction v) => v.memo;
  static const Field<HydratedScheduledTransaction, String> _f$memo = Field(
    'memo',
    _$memo,
  );
  static String? _$transferAccountId(HydratedScheduledTransaction v) =>
      v.transferAccountId;
  static const Field<HydratedScheduledTransaction, String>
  _f$transferAccountId = Field(
    'transferAccountId',
    _$transferAccountId,
    key: r'transfer_account_id',
  );
  static bool _$isDeleted(HydratedScheduledTransaction v) => v.isDeleted;
  static const Field<HydratedScheduledTransaction, bool> _f$isDeleted = Field(
    'isDeleted',
    _$isDeleted,
    key: r'deleted',
  );
  static String _$dateFirst(HydratedScheduledTransaction v) => v.dateFirst;
  static const Field<HydratedScheduledTransaction, String> _f$dateFirst = Field(
    'dateFirst',
    _$dateFirst,
    key: r'date_first',
  );
  static String _$dateNext(HydratedScheduledTransaction v) => v.dateNext;
  static const Field<HydratedScheduledTransaction, String> _f$dateNext = Field(
    'dateNext',
    _$dateNext,
    key: r'date_next',
  );
  static ScheduledTransactionFrequency _$frequency(
    HydratedScheduledTransaction v,
  ) => v.frequency;
  static const Field<
    HydratedScheduledTransaction,
    ScheduledTransactionFrequency
  >
  _f$frequency = Field('frequency', _$frequency);
  static String? _$flagColor(HydratedScheduledTransaction v) => v.flagColor;
  static const Field<HydratedScheduledTransaction, String> _f$flagColor = Field(
    'flagColor',
    _$flagColor,
    key: r'flag_color',
  );
  static String? _$flagName(HydratedScheduledTransaction v) => v.flagName;
  static const Field<HydratedScheduledTransaction, String> _f$flagName = Field(
    'flagName',
    _$flagName,
    key: r'flag_name',
  );
  static String _$accountId(HydratedScheduledTransaction v) => v.accountId;
  static const Field<HydratedScheduledTransaction, String> _f$accountId = Field(
    'accountId',
    _$accountId,
    key: r'account_id',
  );
  static String _$accountName(HydratedScheduledTransaction v) => v.accountName;
  static const Field<HydratedScheduledTransaction, String> _f$accountName =
      Field('accountName', _$accountName, key: r'account_name');
  static String? _$payeeName(HydratedScheduledTransaction v) => v.payeeName;
  static const Field<HydratedScheduledTransaction, String> _f$payeeName = Field(
    'payeeName',
    _$payeeName,
    key: r'payee_name',
  );
  static String? _$categoryName(HydratedScheduledTransaction v) =>
      v.categoryName;
  static const Field<HydratedScheduledTransaction, String> _f$categoryName =
      Field('categoryName', _$categoryName, key: r'category_name');
  static List<ScheduledSubTransaction> _$subTransactions(
    HydratedScheduledTransaction v,
  ) => v.subTransactions;
  static const Field<
    HydratedScheduledTransaction,
    List<ScheduledSubTransaction>
  >
  _f$subTransactions = Field(
    'subTransactions',
    _$subTransactions,
    key: r'subtransactions',
  );
  static List<Object?> _$props(HydratedScheduledTransaction v) => v.props;
  static const Field<HydratedScheduledTransaction, List<Object?>> _f$props =
      Field('props', _$props, mode: FieldMode.member);

  @override
  final MappableFields<HydratedScheduledTransaction> fields = const {
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
    #props: _f$props,
  };

  static HydratedScheduledTransaction _instantiate(DecodingData data) {
    return HydratedScheduledTransaction(
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

  static HydratedScheduledTransaction fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<HydratedScheduledTransaction>(map);
  }

  static HydratedScheduledTransaction fromJson(String json) {
    return ensureInitialized().decodeJson<HydratedScheduledTransaction>(json);
  }
}

mixin HydratedScheduledTransactionMappable {
  String toJson() {
    return HydratedScheduledTransactionMapper.ensureInitialized()
        .encodeJson<HydratedScheduledTransaction>(
          this as HydratedScheduledTransaction,
        );
  }

  Map<String, dynamic> toMap() {
    return HydratedScheduledTransactionMapper.ensureInitialized()
        .encodeMap<HydratedScheduledTransaction>(
          this as HydratedScheduledTransaction,
        );
  }

  HydratedScheduledTransactionCopyWith<
    HydratedScheduledTransaction,
    HydratedScheduledTransaction,
    HydratedScheduledTransaction
  >
  get copyWith =>
      _HydratedScheduledTransactionCopyWithImpl<
        HydratedScheduledTransaction,
        HydratedScheduledTransaction
      >(this as HydratedScheduledTransaction, $identity, $identity);
  @override
  String toString() {
    return HydratedScheduledTransactionMapper.ensureInitialized()
        .stringifyValue(this as HydratedScheduledTransaction);
  }

  @override
  bool operator ==(Object other) {
    return HydratedScheduledTransactionMapper.ensureInitialized().equalsValue(
      this as HydratedScheduledTransaction,
      other,
    );
  }

  @override
  int get hashCode {
    return HydratedScheduledTransactionMapper.ensureInitialized().hashValue(
      this as HydratedScheduledTransaction,
    );
  }
}

extension HydratedScheduledTransactionValueCopy<$R, $Out>
    on ObjectCopyWith<$R, HydratedScheduledTransaction, $Out> {
  HydratedScheduledTransactionCopyWith<$R, HydratedScheduledTransaction, $Out>
  get $asHydratedScheduledTransaction => $base.as(
    (v, t, t2) => _HydratedScheduledTransactionCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class HydratedScheduledTransactionCopyWith<
  $R,
  $In extends HydratedScheduledTransaction,
  $Out
>
    implements ScheduledTransactionCopyWith<$R, $In, $Out> {
  @override
  ListCopyWith<
    $R,
    ScheduledSubTransaction,
    ScheduledSubTransactionCopyWith<
      $R,
      ScheduledSubTransaction,
      ScheduledSubTransaction
    >
  >
  get subTransactions;
  @override
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
  HydratedScheduledTransactionCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _HydratedScheduledTransactionCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, HydratedScheduledTransaction, $Out>
    implements
        HydratedScheduledTransactionCopyWith<
          $R,
          HydratedScheduledTransaction,
          $Out
        > {
  _HydratedScheduledTransactionCopyWithImpl(
    super.value,
    super.then,
    super.then2,
  );

  @override
  late final ClassMapperBase<HydratedScheduledTransaction> $mapper =
      HydratedScheduledTransactionMapper.ensureInitialized();
  @override
  ListCopyWith<
    $R,
    ScheduledSubTransaction,
    ScheduledSubTransactionCopyWith<
      $R,
      ScheduledSubTransaction,
      ScheduledSubTransaction
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
  HydratedScheduledTransaction $make(CopyWithData data) =>
      HydratedScheduledTransaction(
        id: data.get(#id, or: $value.id),
        payeeId: data.get(#payeeId, or: $value.payeeId),
        amount: data.get(#amount, or: $value.amount),
        categoryId: data.get(#categoryId, or: $value.categoryId),
        memo: data.get(#memo, or: $value.memo),
        transferAccountId: data.get(
          #transferAccountId,
          or: $value.transferAccountId,
        ),
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
  HydratedScheduledTransactionCopyWith<$R2, HydratedScheduledTransaction, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _HydratedScheduledTransactionCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class HydratedScheduledSubTransactionMapper
    extends ClassMapperBase<HydratedScheduledSubTransaction> {
  HydratedScheduledSubTransactionMapper._();

  static HydratedScheduledSubTransactionMapper? _instance;
  static HydratedScheduledSubTransactionMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = HydratedScheduledSubTransactionMapper._(),
      );
      ScheduledSubTransactionMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'HydratedScheduledSubTransaction';

  static String _$id(HydratedScheduledSubTransaction v) => v.id;
  static const Field<HydratedScheduledSubTransaction, String> _f$id = Field(
    'id',
    _$id,
  );
  static String? _$payeeId(HydratedScheduledSubTransaction v) => v.payeeId;
  static const Field<HydratedScheduledSubTransaction, String> _f$payeeId =
      Field('payeeId', _$payeeId, key: r'payee_id');
  static int _$amount(HydratedScheduledSubTransaction v) => v.amount;
  static const Field<HydratedScheduledSubTransaction, int> _f$amount = Field(
    'amount',
    _$amount,
  );
  static String? _$categoryId(HydratedScheduledSubTransaction v) =>
      v.categoryId;
  static const Field<HydratedScheduledSubTransaction, String> _f$categoryId =
      Field('categoryId', _$categoryId, key: r'category_id');
  static String? _$memo(HydratedScheduledSubTransaction v) => v.memo;
  static const Field<HydratedScheduledSubTransaction, String> _f$memo = Field(
    'memo',
    _$memo,
  );
  static String? _$transferAccountId(HydratedScheduledSubTransaction v) =>
      v.transferAccountId;
  static const Field<HydratedScheduledSubTransaction, String>
  _f$transferAccountId = Field(
    'transferAccountId',
    _$transferAccountId,
    key: r'transfer_account_id',
  );
  static bool _$isDeleted(HydratedScheduledSubTransaction v) => v.isDeleted;
  static const Field<HydratedScheduledSubTransaction, bool> _f$isDeleted =
      Field('isDeleted', _$isDeleted, key: r'deleted');
  static String _$scheduledTransactionId(HydratedScheduledSubTransaction v) =>
      v.scheduledTransactionId;
  static const Field<HydratedScheduledSubTransaction, String>
  _f$scheduledTransactionId = Field(
    'scheduledTransactionId',
    _$scheduledTransactionId,
    key: r'scheduled_transaction_id',
  );
  static String? _$categoryName(HydratedScheduledSubTransaction v) =>
      v.categoryName;
  static const Field<HydratedScheduledSubTransaction, String> _f$categoryName =
      Field('categoryName', _$categoryName, key: r'category_name');
  static String? _$payeeName(HydratedScheduledSubTransaction v) => v.payeeName;
  static const Field<HydratedScheduledSubTransaction, String> _f$payeeName =
      Field('payeeName', _$payeeName, key: r'payee_name');
  static List<Object?> _$props(HydratedScheduledSubTransaction v) => v.props;
  static const Field<HydratedScheduledSubTransaction, List<Object?>> _f$props =
      Field('props', _$props, mode: FieldMode.member);

  @override
  final MappableFields<HydratedScheduledSubTransaction> fields = const {
    #id: _f$id,
    #payeeId: _f$payeeId,
    #amount: _f$amount,
    #categoryId: _f$categoryId,
    #memo: _f$memo,
    #transferAccountId: _f$transferAccountId,
    #isDeleted: _f$isDeleted,
    #scheduledTransactionId: _f$scheduledTransactionId,
    #categoryName: _f$categoryName,
    #payeeName: _f$payeeName,
    #props: _f$props,
  };

  static HydratedScheduledSubTransaction _instantiate(DecodingData data) {
    return HydratedScheduledSubTransaction(
      id: data.dec(_f$id),
      payeeId: data.dec(_f$payeeId),
      amount: data.dec(_f$amount),
      categoryId: data.dec(_f$categoryId),
      memo: data.dec(_f$memo),
      transferAccountId: data.dec(_f$transferAccountId),
      isDeleted: data.dec(_f$isDeleted),
      scheduledTransactionId: data.dec(_f$scheduledTransactionId),
      categoryName: data.dec(_f$categoryName),
      payeeName: data.dec(_f$payeeName),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static HydratedScheduledSubTransaction fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<HydratedScheduledSubTransaction>(map);
  }

  static HydratedScheduledSubTransaction fromJson(String json) {
    return ensureInitialized().decodeJson<HydratedScheduledSubTransaction>(
      json,
    );
  }
}

mixin HydratedScheduledSubTransactionMappable {
  String toJson() {
    return HydratedScheduledSubTransactionMapper.ensureInitialized()
        .encodeJson<HydratedScheduledSubTransaction>(
          this as HydratedScheduledSubTransaction,
        );
  }

  Map<String, dynamic> toMap() {
    return HydratedScheduledSubTransactionMapper.ensureInitialized()
        .encodeMap<HydratedScheduledSubTransaction>(
          this as HydratedScheduledSubTransaction,
        );
  }

  HydratedScheduledSubTransactionCopyWith<
    HydratedScheduledSubTransaction,
    HydratedScheduledSubTransaction,
    HydratedScheduledSubTransaction
  >
  get copyWith =>
      _HydratedScheduledSubTransactionCopyWithImpl<
        HydratedScheduledSubTransaction,
        HydratedScheduledSubTransaction
      >(this as HydratedScheduledSubTransaction, $identity, $identity);
  @override
  String toString() {
    return HydratedScheduledSubTransactionMapper.ensureInitialized()
        .stringifyValue(this as HydratedScheduledSubTransaction);
  }

  @override
  bool operator ==(Object other) {
    return HydratedScheduledSubTransactionMapper.ensureInitialized()
        .equalsValue(this as HydratedScheduledSubTransaction, other);
  }

  @override
  int get hashCode {
    return HydratedScheduledSubTransactionMapper.ensureInitialized().hashValue(
      this as HydratedScheduledSubTransaction,
    );
  }
}

extension HydratedScheduledSubTransactionValueCopy<$R, $Out>
    on ObjectCopyWith<$R, HydratedScheduledSubTransaction, $Out> {
  HydratedScheduledSubTransactionCopyWith<
    $R,
    HydratedScheduledSubTransaction,
    $Out
  >
  get $asHydratedScheduledSubTransaction => $base.as(
    (v, t, t2) =>
        _HydratedScheduledSubTransactionCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class HydratedScheduledSubTransactionCopyWith<
  $R,
  $In extends HydratedScheduledSubTransaction,
  $Out
>
    implements ScheduledSubTransactionCopyWith<$R, $In, $Out> {
  @override
  $R call({
    String? id,
    String? payeeId,
    int? amount,
    String? categoryId,
    String? memo,
    String? transferAccountId,
    bool? isDeleted,
    String? scheduledTransactionId,
    String? categoryName,
    String? payeeName,
  });
  HydratedScheduledSubTransactionCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _HydratedScheduledSubTransactionCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, HydratedScheduledSubTransaction, $Out>
    implements
        HydratedScheduledSubTransactionCopyWith<
          $R,
          HydratedScheduledSubTransaction,
          $Out
        > {
  _HydratedScheduledSubTransactionCopyWithImpl(
    super.value,
    super.then,
    super.then2,
  );

  @override
  late final ClassMapperBase<HydratedScheduledSubTransaction> $mapper =
      HydratedScheduledSubTransactionMapper.ensureInitialized();
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
    Object? categoryName = $none,
    Object? payeeName = $none,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (payeeId != $none) #payeeId: payeeId,
      if (amount != null) #amount: amount,
      if (categoryId != $none) #categoryId: categoryId,
      if (memo != $none) #memo: memo,
      if (transferAccountId != $none) #transferAccountId: transferAccountId,
      if (isDeleted != null) #isDeleted: isDeleted,
      if (scheduledTransactionId != null)
        #scheduledTransactionId: scheduledTransactionId,
      if (categoryName != $none) #categoryName: categoryName,
      if (payeeName != $none) #payeeName: payeeName,
    }),
  );
  @override
  HydratedScheduledSubTransaction $make(CopyWithData data) =>
      HydratedScheduledSubTransaction(
        id: data.get(#id, or: $value.id),
        payeeId: data.get(#payeeId, or: $value.payeeId),
        amount: data.get(#amount, or: $value.amount),
        categoryId: data.get(#categoryId, or: $value.categoryId),
        memo: data.get(#memo, or: $value.memo),
        transferAccountId: data.get(
          #transferAccountId,
          or: $value.transferAccountId,
        ),
        isDeleted: data.get(#isDeleted, or: $value.isDeleted),
        scheduledTransactionId: data.get(
          #scheduledTransactionId,
          or: $value.scheduledTransactionId,
        ),
        categoryName: data.get(#categoryName, or: $value.categoryName),
        payeeName: data.get(#payeeName, or: $value.payeeName),
      );

  @override
  HydratedScheduledSubTransactionCopyWith<
    $R2,
    HydratedScheduledSubTransaction,
    $Out2
  >
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _HydratedScheduledSubTransactionCopyWithImpl<$R2, $Out2>(
        $value,
        $cast,
        t,
      );
}

