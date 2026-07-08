// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'budgets_response.dart';

class BudgetsResponseMapper extends ClassMapperBase<BudgetsResponse> {
  BudgetsResponseMapper._();

  static BudgetsResponseMapper? _instance;
  static BudgetsResponseMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = BudgetsResponseMapper._());
      BudgetsMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'BudgetsResponse';

  static Budgets _$data(BudgetsResponse v) => v.data;
  static const Field<BudgetsResponse, Budgets> _f$data = Field('data', _$data);

  @override
  final MappableFields<BudgetsResponse> fields = const {#data: _f$data};

  static BudgetsResponse _instantiate(DecodingData data) {
    return BudgetsResponse(data: data.dec(_f$data));
  }

  @override
  final Function instantiate = _instantiate;

  static BudgetsResponse fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<BudgetsResponse>(map);
  }

  static BudgetsResponse fromJson(String json) {
    return ensureInitialized().decodeJson<BudgetsResponse>(json);
  }
}

mixin BudgetsResponseMappable {
  String toJson() {
    return BudgetsResponseMapper.ensureInitialized().encodeJson<BudgetsResponse>(
      this as BudgetsResponse,
    );
  }

  Map<String, dynamic> toMap() {
    return BudgetsResponseMapper.ensureInitialized().encodeMap<BudgetsResponse>(
      this as BudgetsResponse,
    );
  }

  BudgetsResponseCopyWith<BudgetsResponse, BudgetsResponse, BudgetsResponse> get copyWith =>
      _BudgetsResponseCopyWithImpl(this as BudgetsResponse, $identity, $identity);
  @override
  String toString() {
    return BudgetsResponseMapper.ensureInitialized().stringifyValue(this as BudgetsResponse);
  }

  @override
  bool operator ==(Object other) {
    return BudgetsResponseMapper.ensureInitialized().equalsValue(this as BudgetsResponse, other);
  }

  @override
  int get hashCode {
    return BudgetsResponseMapper.ensureInitialized().hashValue(this as BudgetsResponse);
  }
}

extension BudgetsResponseValueCopy<$R, $Out> on ObjectCopyWith<$R, BudgetsResponse, $Out> {
  BudgetsResponseCopyWith<$R, BudgetsResponse, $Out> get $asBudgetsResponse =>
      $base.as((v, t, t2) => _BudgetsResponseCopyWithImpl(v, t, t2));
}

abstract class BudgetsResponseCopyWith<$R, $In extends BudgetsResponse, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  BudgetsCopyWith<$R, Budgets, Budgets> get data;
  $R call({Budgets? data});
  BudgetsResponseCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _BudgetsResponseCopyWithImpl<$R, $Out> extends ClassCopyWithBase<$R, BudgetsResponse, $Out>
    implements BudgetsResponseCopyWith<$R, BudgetsResponse, $Out> {
  _BudgetsResponseCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<BudgetsResponse> $mapper = BudgetsResponseMapper.ensureInitialized();
  @override
  BudgetsCopyWith<$R, Budgets, Budgets> get data =>
      $value.data.copyWith.$chain((v) => call(data: v));
  @override
  $R call({Budgets? data}) => $apply(FieldCopyWithData({if (data != null) #data: data}));
  @override
  BudgetsResponse $make(CopyWithData data) =>
      BudgetsResponse(data: data.get(#data, or: $value.data));

  @override
  BudgetsResponseCopyWith<$R2, BudgetsResponse, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _BudgetsResponseCopyWithImpl($value, $cast, t);
}

class BudgetsMapper extends ClassMapperBase<Budgets> {
  BudgetsMapper._();

  static BudgetsMapper? _instance;
  static BudgetsMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = BudgetsMapper._());
      BudgetMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'Budgets';

  static List<Budget> _$budgets(Budgets v) => v.budgets;
  static const Field<Budgets, List<Budget>> _f$budgets = Field('budgets', _$budgets);

  @override
  final MappableFields<Budgets> fields = const {#budgets: _f$budgets};

  static Budgets _instantiate(DecodingData data) {
    return Budgets(budgets: data.dec(_f$budgets));
  }

  @override
  final Function instantiate = _instantiate;

  static Budgets fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Budgets>(map);
  }

  static Budgets fromJson(String json) {
    return ensureInitialized().decodeJson<Budgets>(json);
  }
}

mixin BudgetsMappable {
  String toJson() {
    return BudgetsMapper.ensureInitialized().encodeJson<Budgets>(this as Budgets);
  }

  Map<String, dynamic> toMap() {
    return BudgetsMapper.ensureInitialized().encodeMap<Budgets>(this as Budgets);
  }

  BudgetsCopyWith<Budgets, Budgets, Budgets> get copyWith =>
      _BudgetsCopyWithImpl(this as Budgets, $identity, $identity);
  @override
  String toString() {
    return BudgetsMapper.ensureInitialized().stringifyValue(this as Budgets);
  }

  @override
  bool operator ==(Object other) {
    return BudgetsMapper.ensureInitialized().equalsValue(this as Budgets, other);
  }

  @override
  int get hashCode {
    return BudgetsMapper.ensureInitialized().hashValue(this as Budgets);
  }
}

extension BudgetsValueCopy<$R, $Out> on ObjectCopyWith<$R, Budgets, $Out> {
  BudgetsCopyWith<$R, Budgets, $Out> get $asBudgets =>
      $base.as((v, t, t2) => _BudgetsCopyWithImpl(v, t, t2));
}

abstract class BudgetsCopyWith<$R, $In extends Budgets, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, Budget, BudgetCopyWith<$R, Budget, Budget>> get budgets;
  $R call({List<Budget>? budgets});
  BudgetsCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _BudgetsCopyWithImpl<$R, $Out> extends ClassCopyWithBase<$R, Budgets, $Out>
    implements BudgetsCopyWith<$R, Budgets, $Out> {
  _BudgetsCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Budgets> $mapper = BudgetsMapper.ensureInitialized();
  @override
  ListCopyWith<$R, Budget, BudgetCopyWith<$R, Budget, Budget>> get budgets =>
      ListCopyWith($value.budgets, (v, t) => v.copyWith.$chain(t), (v) => call(budgets: v));
  @override
  $R call({List<Budget>? budgets}) =>
      $apply(FieldCopyWithData({if (budgets != null) #budgets: budgets}));
  @override
  Budgets $make(CopyWithData data) => Budgets(budgets: data.get(#budgets, or: $value.budgets));

  @override
  BudgetsCopyWith<$R2, Budgets, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _BudgetsCopyWithImpl($value, $cast, t);
}

class BudgetMapper extends ClassMapperBase<Budget> {
  BudgetMapper._();

  static BudgetMapper? _instance;
  static BudgetMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = BudgetMapper._());
      CurrencyFormatMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'Budget';

  static String _$id(Budget v) => v.id;
  static const Field<Budget, String> _f$id = Field('id', _$id);
  static String _$name(Budget v) => v.name;
  static const Field<Budget, String> _f$name = Field('name', _$name);
  static String? _$lastModifiedOn(Budget v) => v.lastModifiedOn;
  static const Field<Budget, String> _f$lastModifiedOn = Field(
    'lastModifiedOn',
    _$lastModifiedOn,
    key: 'last_modified_on',
  );
  static String? _$firstMonth(Budget v) => v.firstMonth;
  static const Field<Budget, String> _f$firstMonth = Field(
    'firstMonth',
    _$firstMonth,
    key: 'first_month',
  );
  static String? _$lastMonth(Budget v) => v.lastMonth;
  static const Field<Budget, String> _f$lastMonth = Field(
    'lastMonth',
    _$lastMonth,
    key: 'last_month',
  );
  static CurrencyFormat? _$currencyFormat(Budget v) => v.currencyFormat;
  static const Field<Budget, CurrencyFormat> _f$currencyFormat = Field(
    'currencyFormat',
    _$currencyFormat,
    key: 'currency_format',
    opt: true,
  );

  @override
  final MappableFields<Budget> fields = const {
    #id: _f$id,
    #name: _f$name,
    #lastModifiedOn: _f$lastModifiedOn,
    #firstMonth: _f$firstMonth,
    #lastMonth: _f$lastMonth,
    #currencyFormat: _f$currencyFormat,
  };

  static Budget _instantiate(DecodingData data) {
    return Budget(
      id: data.dec(_f$id),
      name: data.dec(_f$name),
      lastModifiedOn: data.dec(_f$lastModifiedOn),
      firstMonth: data.dec(_f$firstMonth),
      lastMonth: data.dec(_f$lastMonth),
      currencyFormat: data.dec(_f$currencyFormat),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static Budget fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Budget>(map);
  }

  static Budget fromJson(String json) {
    return ensureInitialized().decodeJson<Budget>(json);
  }
}

mixin BudgetMappable {
  String toJson() {
    return BudgetMapper.ensureInitialized().encodeJson<Budget>(this as Budget);
  }

  Map<String, dynamic> toMap() {
    return BudgetMapper.ensureInitialized().encodeMap<Budget>(this as Budget);
  }

  BudgetCopyWith<Budget, Budget, Budget> get copyWith =>
      _BudgetCopyWithImpl(this as Budget, $identity, $identity);
  @override
  String toString() {
    return BudgetMapper.ensureInitialized().stringifyValue(this as Budget);
  }

  @override
  bool operator ==(Object other) {
    return BudgetMapper.ensureInitialized().equalsValue(this as Budget, other);
  }

  @override
  int get hashCode {
    return BudgetMapper.ensureInitialized().hashValue(this as Budget);
  }
}

extension BudgetValueCopy<$R, $Out> on ObjectCopyWith<$R, Budget, $Out> {
  BudgetCopyWith<$R, Budget, $Out> get $asBudget =>
      $base.as((v, t, t2) => _BudgetCopyWithImpl(v, t, t2));
}

abstract class BudgetCopyWith<$R, $In extends Budget, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  CurrencyFormatCopyWith<$R, CurrencyFormat, CurrencyFormat>? get currencyFormat;
  $R call({
    String? id,
    String? name,
    String? lastModifiedOn,
    String? firstMonth,
    String? lastMonth,
    CurrencyFormat? currencyFormat,
  });
  BudgetCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _BudgetCopyWithImpl<$R, $Out> extends ClassCopyWithBase<$R, Budget, $Out>
    implements BudgetCopyWith<$R, Budget, $Out> {
  _BudgetCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Budget> $mapper = BudgetMapper.ensureInitialized();
  @override
  CurrencyFormatCopyWith<$R, CurrencyFormat, CurrencyFormat>? get currencyFormat =>
      $value.currencyFormat?.copyWith.$chain((v) => call(currencyFormat: v));
  @override
  $R call({
    String? id,
    String? name,
    Object? lastModifiedOn = $none,
    Object? firstMonth = $none,
    Object? lastMonth = $none,
    Object? currencyFormat = $none,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (name != null) #name: name,
      if (lastModifiedOn != $none) #lastModifiedOn: lastModifiedOn,
      if (firstMonth != $none) #firstMonth: firstMonth,
      if (lastMonth != $none) #lastMonth: lastMonth,
      if (currencyFormat != $none) #currencyFormat: currencyFormat,
    }),
  );
  @override
  Budget $make(CopyWithData data) => Budget(
    id: data.get(#id, or: $value.id),
    name: data.get(#name, or: $value.name),
    lastModifiedOn: data.get(#lastModifiedOn, or: $value.lastModifiedOn),
    firstMonth: data.get(#firstMonth, or: $value.firstMonth),
    lastMonth: data.get(#lastMonth, or: $value.lastMonth),
    currencyFormat: data.get(#currencyFormat, or: $value.currencyFormat),
  );

  @override
  BudgetCopyWith<$R2, Budget, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _BudgetCopyWithImpl($value, $cast, t);
}

class CurrencyFormatMapper extends ClassMapperBase<CurrencyFormat> {
  CurrencyFormatMapper._();

  static CurrencyFormatMapper? _instance;
  static CurrencyFormatMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = CurrencyFormatMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'CurrencyFormat';

  static String _$isoCode(CurrencyFormat v) => v.isoCode;
  static const Field<CurrencyFormat, String> _f$isoCode = Field(
    'isoCode',
    _$isoCode,
    key: 'iso_code',
  );
  static int _$decimalDigits(CurrencyFormat v) => v.decimalDigits;
  static const Field<CurrencyFormat, int> _f$decimalDigits = Field(
    'decimalDigits',
    _$decimalDigits,
    key: 'decimal_digits',
  );
  static String _$decimalSeparator(CurrencyFormat v) => v.decimalSeparator;
  static const Field<CurrencyFormat, String> _f$decimalSeparator = Field(
    'decimalSeparator',
    _$decimalSeparator,
    key: 'decimal_separator',
  );
  static bool _$isSymbolFirst(CurrencyFormat v) => v.isSymbolFirst;
  static const Field<CurrencyFormat, bool> _f$isSymbolFirst = Field(
    'isSymbolFirst',
    _$isSymbolFirst,
    key: 'symbol_first',
  );
  static String _$groupSeparator(CurrencyFormat v) => v.groupSeparator;
  static const Field<CurrencyFormat, String> _f$groupSeparator = Field(
    'groupSeparator',
    _$groupSeparator,
    key: 'group_separator',
  );
  static String _$currencySymbol(CurrencyFormat v) => v.currencySymbol;
  static const Field<CurrencyFormat, String> _f$currencySymbol = Field(
    'currencySymbol',
    _$currencySymbol,
    key: 'currency_symbol',
  );
  static bool _$shouldDisplaySymbol(CurrencyFormat v) => v.shouldDisplaySymbol;
  static const Field<CurrencyFormat, bool> _f$shouldDisplaySymbol = Field(
    'shouldDisplaySymbol',
    _$shouldDisplaySymbol,
    key: 'display_symbol',
  );
  static String _$exampleFormat(CurrencyFormat v) => v.exampleFormat;
  static const Field<CurrencyFormat, String> _f$exampleFormat = Field(
    'exampleFormat',
    _$exampleFormat,
    key: 'example_format',
  );

  @override
  final MappableFields<CurrencyFormat> fields = const {
    #isoCode: _f$isoCode,
    #decimalDigits: _f$decimalDigits,
    #decimalSeparator: _f$decimalSeparator,
    #isSymbolFirst: _f$isSymbolFirst,
    #groupSeparator: _f$groupSeparator,
    #currencySymbol: _f$currencySymbol,
    #shouldDisplaySymbol: _f$shouldDisplaySymbol,
    #exampleFormat: _f$exampleFormat,
  };

  static CurrencyFormat _instantiate(DecodingData data) {
    return CurrencyFormat(
      isoCode: data.dec(_f$isoCode),
      decimalDigits: data.dec(_f$decimalDigits),
      decimalSeparator: data.dec(_f$decimalSeparator),
      isSymbolFirst: data.dec(_f$isSymbolFirst),
      groupSeparator: data.dec(_f$groupSeparator),
      currencySymbol: data.dec(_f$currencySymbol),
      shouldDisplaySymbol: data.dec(_f$shouldDisplaySymbol),
      exampleFormat: data.dec(_f$exampleFormat),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static CurrencyFormat fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<CurrencyFormat>(map);
  }

  static CurrencyFormat fromJson(String json) {
    return ensureInitialized().decodeJson<CurrencyFormat>(json);
  }
}

mixin CurrencyFormatMappable {
  String toJson() {
    return CurrencyFormatMapper.ensureInitialized().encodeJson<CurrencyFormat>(
      this as CurrencyFormat,
    );
  }

  Map<String, dynamic> toMap() {
    return CurrencyFormatMapper.ensureInitialized().encodeMap<CurrencyFormat>(
      this as CurrencyFormat,
    );
  }

  CurrencyFormatCopyWith<CurrencyFormat, CurrencyFormat, CurrencyFormat> get copyWith =>
      _CurrencyFormatCopyWithImpl(this as CurrencyFormat, $identity, $identity);
  @override
  String toString() {
    return CurrencyFormatMapper.ensureInitialized().stringifyValue(this as CurrencyFormat);
  }

  @override
  bool operator ==(Object other) {
    return CurrencyFormatMapper.ensureInitialized().equalsValue(this as CurrencyFormat, other);
  }

  @override
  int get hashCode {
    return CurrencyFormatMapper.ensureInitialized().hashValue(this as CurrencyFormat);
  }
}

extension CurrencyFormatValueCopy<$R, $Out> on ObjectCopyWith<$R, CurrencyFormat, $Out> {
  CurrencyFormatCopyWith<$R, CurrencyFormat, $Out> get $asCurrencyFormat =>
      $base.as((v, t, t2) => _CurrencyFormatCopyWithImpl(v, t, t2));
}

abstract class CurrencyFormatCopyWith<$R, $In extends CurrencyFormat, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? isoCode,
    int? decimalDigits,
    String? decimalSeparator,
    bool? isSymbolFirst,
    String? groupSeparator,
    String? currencySymbol,
    bool? shouldDisplaySymbol,
    String? exampleFormat,
  });
  CurrencyFormatCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _CurrencyFormatCopyWithImpl<$R, $Out> extends ClassCopyWithBase<$R, CurrencyFormat, $Out>
    implements CurrencyFormatCopyWith<$R, CurrencyFormat, $Out> {
  _CurrencyFormatCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<CurrencyFormat> $mapper = CurrencyFormatMapper.ensureInitialized();
  @override
  $R call({
    String? isoCode,
    int? decimalDigits,
    String? decimalSeparator,
    bool? isSymbolFirst,
    String? groupSeparator,
    String? currencySymbol,
    bool? shouldDisplaySymbol,
    String? exampleFormat,
  }) => $apply(
    FieldCopyWithData({
      if (isoCode != null) #isoCode: isoCode,
      if (decimalDigits != null) #decimalDigits: decimalDigits,
      if (decimalSeparator != null) #decimalSeparator: decimalSeparator,
      if (isSymbolFirst != null) #isSymbolFirst: isSymbolFirst,
      if (groupSeparator != null) #groupSeparator: groupSeparator,
      if (currencySymbol != null) #currencySymbol: currencySymbol,
      if (shouldDisplaySymbol != null) #shouldDisplaySymbol: shouldDisplaySymbol,
      if (exampleFormat != null) #exampleFormat: exampleFormat,
    }),
  );
  @override
  CurrencyFormat $make(CopyWithData data) => CurrencyFormat(
    isoCode: data.get(#isoCode, or: $value.isoCode),
    decimalDigits: data.get(#decimalDigits, or: $value.decimalDigits),
    decimalSeparator: data.get(#decimalSeparator, or: $value.decimalSeparator),
    isSymbolFirst: data.get(#isSymbolFirst, or: $value.isSymbolFirst),
    groupSeparator: data.get(#groupSeparator, or: $value.groupSeparator),
    currencySymbol: data.get(#currencySymbol, or: $value.currencySymbol),
    shouldDisplaySymbol: data.get(#shouldDisplaySymbol, or: $value.shouldDisplaySymbol),
    exampleFormat: data.get(#exampleFormat, or: $value.exampleFormat),
  );

  @override
  CurrencyFormatCopyWith<$R2, CurrencyFormat, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _CurrencyFormatCopyWithImpl($value, $cast, t);
}
