// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'scheduled_transactions_response.dart';

class ScheduledTransactionsResponseMapper extends ClassMapperBase<ScheduledTransactionsResponse> {
  ScheduledTransactionsResponseMapper._();

  static ScheduledTransactionsResponseMapper? _instance;
  static ScheduledTransactionsResponseMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ScheduledTransactionsResponseMapper._());
      ScheduledTransactionsMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'ScheduledTransactionsResponse';

  static ScheduledTransactions _$data(ScheduledTransactionsResponse v) => v.data;
  static const Field<ScheduledTransactionsResponse, ScheduledTransactions> _f$data = Field(
    'data',
    _$data,
  );

  @override
  final MappableFields<ScheduledTransactionsResponse> fields = const {#data: _f$data};

  static ScheduledTransactionsResponse _instantiate(DecodingData data) {
    return ScheduledTransactionsResponse(data: data.dec(_f$data));
  }

  @override
  final Function instantiate = _instantiate;

  static ScheduledTransactionsResponse fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ScheduledTransactionsResponse>(map);
  }

  static ScheduledTransactionsResponse fromJson(String json) {
    return ensureInitialized().decodeJson<ScheduledTransactionsResponse>(json);
  }
}

mixin ScheduledTransactionsResponseMappable {
  String toJson() {
    return ScheduledTransactionsResponseMapper.ensureInitialized()
        .encodeJson<ScheduledTransactionsResponse>(this as ScheduledTransactionsResponse);
  }

  Map<String, dynamic> toMap() {
    return ScheduledTransactionsResponseMapper.ensureInitialized()
        .encodeMap<ScheduledTransactionsResponse>(this as ScheduledTransactionsResponse);
  }

  ScheduledTransactionsResponseCopyWith<
    ScheduledTransactionsResponse,
    ScheduledTransactionsResponse,
    ScheduledTransactionsResponse
  >
  get copyWith => _ScheduledTransactionsResponseCopyWithImpl(
    this as ScheduledTransactionsResponse,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return ScheduledTransactionsResponseMapper.ensureInitialized().stringifyValue(
      this as ScheduledTransactionsResponse,
    );
  }

  @override
  bool operator ==(Object other) {
    return ScheduledTransactionsResponseMapper.ensureInitialized().equalsValue(
      this as ScheduledTransactionsResponse,
      other,
    );
  }

  @override
  int get hashCode {
    return ScheduledTransactionsResponseMapper.ensureInitialized().hashValue(
      this as ScheduledTransactionsResponse,
    );
  }
}

extension ScheduledTransactionsResponseValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ScheduledTransactionsResponse, $Out> {
  ScheduledTransactionsResponseCopyWith<$R, ScheduledTransactionsResponse, $Out>
  get $asScheduledTransactionsResponse =>
      $base.as((v, t, t2) => _ScheduledTransactionsResponseCopyWithImpl(v, t, t2));
}

abstract class ScheduledTransactionsResponseCopyWith<
  $R,
  $In extends ScheduledTransactionsResponse,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  ScheduledTransactionsCopyWith<$R, ScheduledTransactions, ScheduledTransactions> get data;
  $R call({ScheduledTransactions? data});
  ScheduledTransactionsResponseCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _ScheduledTransactionsResponseCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ScheduledTransactionsResponse, $Out>
    implements ScheduledTransactionsResponseCopyWith<$R, ScheduledTransactionsResponse, $Out> {
  _ScheduledTransactionsResponseCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ScheduledTransactionsResponse> $mapper =
      ScheduledTransactionsResponseMapper.ensureInitialized();
  @override
  ScheduledTransactionsCopyWith<$R, ScheduledTransactions, ScheduledTransactions> get data =>
      $value.data.copyWith.$chain((v) => call(data: v));
  @override
  $R call({ScheduledTransactions? data}) =>
      $apply(FieldCopyWithData({if (data != null) #data: data}));
  @override
  ScheduledTransactionsResponse $make(CopyWithData data) =>
      ScheduledTransactionsResponse(data: data.get(#data, or: $value.data));

  @override
  ScheduledTransactionsResponseCopyWith<$R2, ScheduledTransactionsResponse, $Out2> $chain<
    $R2,
    $Out2
  >(Then<$Out2, $R2> t) => _ScheduledTransactionsResponseCopyWithImpl($value, $cast, t);
}

class ScheduledTransactionsMapper extends ClassMapperBase<ScheduledTransactions> {
  ScheduledTransactionsMapper._();

  static ScheduledTransactionsMapper? _instance;
  static ScheduledTransactionsMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ScheduledTransactionsMapper._());
      ScheduledTransactionMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'ScheduledTransactions';

  static int _$serverKnowledge(ScheduledTransactions v) => v.serverKnowledge;
  static const Field<ScheduledTransactions, int> _f$serverKnowledge = Field(
    'serverKnowledge',
    _$serverKnowledge,
    key: 'server_knowledge',
  );
  static List<ScheduledTransaction> _$scheduledTransactions(ScheduledTransactions v) =>
      v.scheduledTransactions;
  static const Field<ScheduledTransactions, List<ScheduledTransaction>> _f$scheduledTransactions =
      Field('scheduledTransactions', _$scheduledTransactions, key: 'scheduled_transactions');

  @override
  final MappableFields<ScheduledTransactions> fields = const {
    #serverKnowledge: _f$serverKnowledge,
    #scheduledTransactions: _f$scheduledTransactions,
  };

  static ScheduledTransactions _instantiate(DecodingData data) {
    return ScheduledTransactions(
      serverKnowledge: data.dec(_f$serverKnowledge),
      scheduledTransactions: data.dec(_f$scheduledTransactions),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static ScheduledTransactions fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<ScheduledTransactions>(map);
  }

  static ScheduledTransactions fromJson(String json) {
    return ensureInitialized().decodeJson<ScheduledTransactions>(json);
  }
}

mixin ScheduledTransactionsMappable {
  String toJson() {
    return ScheduledTransactionsMapper.ensureInitialized().encodeJson<ScheduledTransactions>(
      this as ScheduledTransactions,
    );
  }

  Map<String, dynamic> toMap() {
    return ScheduledTransactionsMapper.ensureInitialized().encodeMap<ScheduledTransactions>(
      this as ScheduledTransactions,
    );
  }

  ScheduledTransactionsCopyWith<ScheduledTransactions, ScheduledTransactions, ScheduledTransactions>
  get copyWith =>
      _ScheduledTransactionsCopyWithImpl(this as ScheduledTransactions, $identity, $identity);
  @override
  String toString() {
    return ScheduledTransactionsMapper.ensureInitialized().stringifyValue(
      this as ScheduledTransactions,
    );
  }

  @override
  bool operator ==(Object other) {
    return ScheduledTransactionsMapper.ensureInitialized().equalsValue(
      this as ScheduledTransactions,
      other,
    );
  }

  @override
  int get hashCode {
    return ScheduledTransactionsMapper.ensureInitialized().hashValue(this as ScheduledTransactions);
  }
}

extension ScheduledTransactionsValueCopy<$R, $Out>
    on ObjectCopyWith<$R, ScheduledTransactions, $Out> {
  ScheduledTransactionsCopyWith<$R, ScheduledTransactions, $Out> get $asScheduledTransactions =>
      $base.as((v, t, t2) => _ScheduledTransactionsCopyWithImpl(v, t, t2));
}

abstract class ScheduledTransactionsCopyWith<$R, $In extends ScheduledTransactions, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<
    $R,
    ScheduledTransaction,
    ScheduledTransactionCopyWith<$R, ScheduledTransaction, ScheduledTransaction>
  >
  get scheduledTransactions;
  $R call({int? serverKnowledge, List<ScheduledTransaction>? scheduledTransactions});
  ScheduledTransactionsCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _ScheduledTransactionsCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, ScheduledTransactions, $Out>
    implements ScheduledTransactionsCopyWith<$R, ScheduledTransactions, $Out> {
  _ScheduledTransactionsCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<ScheduledTransactions> $mapper =
      ScheduledTransactionsMapper.ensureInitialized();
  @override
  ListCopyWith<
    $R,
    ScheduledTransaction,
    ScheduledTransactionCopyWith<$R, ScheduledTransaction, ScheduledTransaction>
  >
  get scheduledTransactions => ListCopyWith(
    $value.scheduledTransactions,
    (v, t) => v.copyWith.$chain(t),
    (v) => call(scheduledTransactions: v),
  );
  @override
  $R call({int? serverKnowledge, List<ScheduledTransaction>? scheduledTransactions}) => $apply(
    FieldCopyWithData({
      if (serverKnowledge != null) #serverKnowledge: serverKnowledge,
      if (scheduledTransactions != null) #scheduledTransactions: scheduledTransactions,
    }),
  );
  @override
  ScheduledTransactions $make(CopyWithData data) => ScheduledTransactions(
    serverKnowledge: data.get(#serverKnowledge, or: $value.serverKnowledge),
    scheduledTransactions: data.get(#scheduledTransactions, or: $value.scheduledTransactions),
  );

  @override
  ScheduledTransactionsCopyWith<$R2, ScheduledTransactions, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _ScheduledTransactionsCopyWithImpl($value, $cast, t);
}
