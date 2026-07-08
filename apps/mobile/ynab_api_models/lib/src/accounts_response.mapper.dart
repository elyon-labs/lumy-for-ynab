// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'accounts_response.dart';

class AccountTypeMapper extends EnumMapper<AccountType> {
  AccountTypeMapper._();

  static AccountTypeMapper? _instance;
  static AccountTypeMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AccountTypeMapper._());
    }
    return _instance!;
  }

  static AccountType fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  AccountType decode(dynamic value) {
    switch (value) {
      case 'checking':
        return AccountType.checking;
      case 'savings':
        return AccountType.savings;
      case 'cash':
        return AccountType.cash;
      case 'creditCard':
        return AccountType.creditCard;
      case 'lineOfCredit':
        return AccountType.lineOfCredit;
      case 'otherAsset':
        return AccountType.otherAsset;
      case 'otherLiability':
        return AccountType.otherLiability;
      case 'mortgage':
        return AccountType.mortgage;
      case 'autoLoan':
        return AccountType.autoLoan;
      case 'studentLoan':
        return AccountType.studentLoan;
      case 'personalLoan':
        return AccountType.personalLoan;
      case 'medicalDebt':
        return AccountType.medicalDebt;
      case 'otherDebt':
        return AccountType.otherDebt;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(AccountType self) {
    switch (self) {
      case AccountType.checking:
        return 'checking';
      case AccountType.savings:
        return 'savings';
      case AccountType.cash:
        return 'cash';
      case AccountType.creditCard:
        return 'creditCard';
      case AccountType.lineOfCredit:
        return 'lineOfCredit';
      case AccountType.otherAsset:
        return 'otherAsset';
      case AccountType.otherLiability:
        return 'otherLiability';
      case AccountType.mortgage:
        return 'mortgage';
      case AccountType.autoLoan:
        return 'autoLoan';
      case AccountType.studentLoan:
        return 'studentLoan';
      case AccountType.personalLoan:
        return 'personalLoan';
      case AccountType.medicalDebt:
        return 'medicalDebt';
      case AccountType.otherDebt:
        return 'otherDebt';
    }
  }
}

extension AccountTypeMapperExtension on AccountType {
  String toValue() {
    AccountTypeMapper.ensureInitialized();
    return MapperContainer.globals.toValue<AccountType>(this) as String;
  }
}

class AccountsResponseMapper extends ClassMapperBase<AccountsResponse> {
  AccountsResponseMapper._();

  static AccountsResponseMapper? _instance;
  static AccountsResponseMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AccountsResponseMapper._());
      AccountsMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'AccountsResponse';

  static Accounts _$data(AccountsResponse v) => v.data;
  static const Field<AccountsResponse, Accounts> _f$data = Field('data', _$data);

  @override
  final MappableFields<AccountsResponse> fields = const {#data: _f$data};

  static AccountsResponse _instantiate(DecodingData data) {
    return AccountsResponse(data: data.dec(_f$data));
  }

  @override
  final Function instantiate = _instantiate;

  static AccountsResponse fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<AccountsResponse>(map);
  }

  static AccountsResponse fromJson(String json) {
    return ensureInitialized().decodeJson<AccountsResponse>(json);
  }
}

mixin AccountsResponseMappable {
  String toJson() {
    return AccountsResponseMapper.ensureInitialized().encodeJson<AccountsResponse>(
      this as AccountsResponse,
    );
  }

  Map<String, dynamic> toMap() {
    return AccountsResponseMapper.ensureInitialized().encodeMap<AccountsResponse>(
      this as AccountsResponse,
    );
  }

  AccountsResponseCopyWith<AccountsResponse, AccountsResponse, AccountsResponse> get copyWith =>
      _AccountsResponseCopyWithImpl(this as AccountsResponse, $identity, $identity);
  @override
  String toString() {
    return AccountsResponseMapper.ensureInitialized().stringifyValue(this as AccountsResponse);
  }

  @override
  bool operator ==(Object other) {
    return AccountsResponseMapper.ensureInitialized().equalsValue(this as AccountsResponse, other);
  }

  @override
  int get hashCode {
    return AccountsResponseMapper.ensureInitialized().hashValue(this as AccountsResponse);
  }
}

extension AccountsResponseValueCopy<$R, $Out> on ObjectCopyWith<$R, AccountsResponse, $Out> {
  AccountsResponseCopyWith<$R, AccountsResponse, $Out> get $asAccountsResponse =>
      $base.as((v, t, t2) => _AccountsResponseCopyWithImpl(v, t, t2));
}

abstract class AccountsResponseCopyWith<$R, $In extends AccountsResponse, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  AccountsCopyWith<$R, Accounts, Accounts> get data;
  $R call({Accounts? data});
  AccountsResponseCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _AccountsResponseCopyWithImpl<$R, $Out> extends ClassCopyWithBase<$R, AccountsResponse, $Out>
    implements AccountsResponseCopyWith<$R, AccountsResponse, $Out> {
  _AccountsResponseCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<AccountsResponse> $mapper = AccountsResponseMapper.ensureInitialized();
  @override
  AccountsCopyWith<$R, Accounts, Accounts> get data =>
      $value.data.copyWith.$chain((v) => call(data: v));
  @override
  $R call({Accounts? data}) => $apply(FieldCopyWithData({if (data != null) #data: data}));
  @override
  AccountsResponse $make(CopyWithData data) =>
      AccountsResponse(data: data.get(#data, or: $value.data));

  @override
  AccountsResponseCopyWith<$R2, AccountsResponse, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _AccountsResponseCopyWithImpl($value, $cast, t);
}

class AccountsMapper extends ClassMapperBase<Accounts> {
  AccountsMapper._();

  static AccountsMapper? _instance;
  static AccountsMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AccountsMapper._());
      AccountMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'Accounts';

  static int _$serverKnowledge(Accounts v) => v.serverKnowledge;
  static const Field<Accounts, int> _f$serverKnowledge = Field(
    'serverKnowledge',
    _$serverKnowledge,
    key: 'server_knowledge',
  );
  static List<Account> _$accounts(Accounts v) => v.accounts;
  static const Field<Accounts, List<Account>> _f$accounts = Field('accounts', _$accounts);

  @override
  final MappableFields<Accounts> fields = const {
    #serverKnowledge: _f$serverKnowledge,
    #accounts: _f$accounts,
  };

  static Accounts _instantiate(DecodingData data) {
    return Accounts(serverKnowledge: data.dec(_f$serverKnowledge), accounts: data.dec(_f$accounts));
  }

  @override
  final Function instantiate = _instantiate;

  static Accounts fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Accounts>(map);
  }

  static Accounts fromJson(String json) {
    return ensureInitialized().decodeJson<Accounts>(json);
  }
}

mixin AccountsMappable {
  String toJson() {
    return AccountsMapper.ensureInitialized().encodeJson<Accounts>(this as Accounts);
  }

  Map<String, dynamic> toMap() {
    return AccountsMapper.ensureInitialized().encodeMap<Accounts>(this as Accounts);
  }

  AccountsCopyWith<Accounts, Accounts, Accounts> get copyWith =>
      _AccountsCopyWithImpl(this as Accounts, $identity, $identity);
  @override
  String toString() {
    return AccountsMapper.ensureInitialized().stringifyValue(this as Accounts);
  }

  @override
  bool operator ==(Object other) {
    return AccountsMapper.ensureInitialized().equalsValue(this as Accounts, other);
  }

  @override
  int get hashCode {
    return AccountsMapper.ensureInitialized().hashValue(this as Accounts);
  }
}

extension AccountsValueCopy<$R, $Out> on ObjectCopyWith<$R, Accounts, $Out> {
  AccountsCopyWith<$R, Accounts, $Out> get $asAccounts =>
      $base.as((v, t, t2) => _AccountsCopyWithImpl(v, t, t2));
}

abstract class AccountsCopyWith<$R, $In extends Accounts, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, Account, AccountCopyWith<$R, Account, Account>> get accounts;
  $R call({int? serverKnowledge, List<Account>? accounts});
  AccountsCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _AccountsCopyWithImpl<$R, $Out> extends ClassCopyWithBase<$R, Accounts, $Out>
    implements AccountsCopyWith<$R, Accounts, $Out> {
  _AccountsCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Accounts> $mapper = AccountsMapper.ensureInitialized();
  @override
  ListCopyWith<$R, Account, AccountCopyWith<$R, Account, Account>> get accounts =>
      ListCopyWith($value.accounts, (v, t) => v.copyWith.$chain(t), (v) => call(accounts: v));
  @override
  $R call({int? serverKnowledge, List<Account>? accounts}) => $apply(
    FieldCopyWithData({
      if (serverKnowledge != null) #serverKnowledge: serverKnowledge,
      if (accounts != null) #accounts: accounts,
    }),
  );
  @override
  Accounts $make(CopyWithData data) => Accounts(
    serverKnowledge: data.get(#serverKnowledge, or: $value.serverKnowledge),
    accounts: data.get(#accounts, or: $value.accounts),
  );

  @override
  AccountsCopyWith<$R2, Accounts, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _AccountsCopyWithImpl($value, $cast, t);
}

class AccountMapper extends ClassMapperBase<Account> {
  AccountMapper._();

  static AccountMapper? _instance;
  static AccountMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = AccountMapper._());
      AccountTypeMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'Account';

  static String _$id(Account v) => v.id;
  static const Field<Account, String> _f$id = Field('id', _$id);
  static String _$name(Account v) => v.name;
  static const Field<Account, String> _f$name = Field('name', _$name);
  static bool _$isOnBudget(Account v) => v.isOnBudget;
  static const Field<Account, bool> _f$isOnBudget = Field(
    'isOnBudget',
    _$isOnBudget,
    key: 'on_budget',
  );
  static bool _$isClosed(Account v) => v.isClosed;
  static const Field<Account, bool> _f$isClosed = Field('isClosed', _$isClosed, key: 'closed');
  static bool _$isDeleted(Account v) => v.isDeleted;
  static const Field<Account, bool> _f$isDeleted = Field('isDeleted', _$isDeleted, key: 'deleted');
  static AccountType _$type(Account v) => v.type;
  static const Field<Account, AccountType> _f$type = Field('type', _$type);
  static int _$balance(Account v) => v.balance;
  static const Field<Account, int> _f$balance = Field('balance', _$balance);
  static Map<String, int> _$debtInterestRates(Account v) => v.debtInterestRates;
  static const Field<Account, Map<String, int>> _f$debtInterestRates = Field(
    'debtInterestRates',
    _$debtInterestRates,
    key: 'debt_interest_rates',
  );
  static Map<String, int> _$debtMinimumPayments(Account v) => v.debtMinimumPayments;
  static const Field<Account, Map<String, int>> _f$debtMinimumPayments = Field(
    'debtMinimumPayments',
    _$debtMinimumPayments,
    key: 'debt_minimum_payments',
  );
  static Map<String, int> _$debtEscrowAmounts(Account v) => v.debtEscrowAmounts;
  static const Field<Account, Map<String, int>> _f$debtEscrowAmounts = Field(
    'debtEscrowAmounts',
    _$debtEscrowAmounts,
    key: 'debt_escrow_amounts',
  );

  @override
  final MappableFields<Account> fields = const {
    #id: _f$id,
    #name: _f$name,
    #isOnBudget: _f$isOnBudget,
    #isClosed: _f$isClosed,
    #isDeleted: _f$isDeleted,
    #type: _f$type,
    #balance: _f$balance,
    #debtInterestRates: _f$debtInterestRates,
    #debtMinimumPayments: _f$debtMinimumPayments,
    #debtEscrowAmounts: _f$debtEscrowAmounts,
  };

  static Account _instantiate(DecodingData data) {
    return Account(
      id: data.dec(_f$id),
      name: data.dec(_f$name),
      isOnBudget: data.dec(_f$isOnBudget),
      isClosed: data.dec(_f$isClosed),
      isDeleted: data.dec(_f$isDeleted),
      type: data.dec(_f$type),
      balance: data.dec(_f$balance),
      debtInterestRates: data.dec(_f$debtInterestRates),
      debtMinimumPayments: data.dec(_f$debtMinimumPayments),
      debtEscrowAmounts: data.dec(_f$debtEscrowAmounts),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static Account fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Account>(map);
  }

  static Account fromJson(String json) {
    return ensureInitialized().decodeJson<Account>(json);
  }
}

mixin AccountMappable {
  String toJson() {
    return AccountMapper.ensureInitialized().encodeJson<Account>(this as Account);
  }

  Map<String, dynamic> toMap() {
    return AccountMapper.ensureInitialized().encodeMap<Account>(this as Account);
  }

  AccountCopyWith<Account, Account, Account> get copyWith =>
      _AccountCopyWithImpl(this as Account, $identity, $identity);
  @override
  String toString() {
    return AccountMapper.ensureInitialized().stringifyValue(this as Account);
  }

  @override
  bool operator ==(Object other) {
    return AccountMapper.ensureInitialized().equalsValue(this as Account, other);
  }

  @override
  int get hashCode {
    return AccountMapper.ensureInitialized().hashValue(this as Account);
  }
}

extension AccountValueCopy<$R, $Out> on ObjectCopyWith<$R, Account, $Out> {
  AccountCopyWith<$R, Account, $Out> get $asAccount =>
      $base.as((v, t, t2) => _AccountCopyWithImpl(v, t, t2));
}

abstract class AccountCopyWith<$R, $In extends Account, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  MapCopyWith<$R, String, int, ObjectCopyWith<$R, int, int>> get debtInterestRates;
  MapCopyWith<$R, String, int, ObjectCopyWith<$R, int, int>> get debtMinimumPayments;
  MapCopyWith<$R, String, int, ObjectCopyWith<$R, int, int>> get debtEscrowAmounts;
  $R call({
    String? id,
    String? name,
    bool? isOnBudget,
    bool? isClosed,
    bool? isDeleted,
    AccountType? type,
    int? balance,
    Map<String, int>? debtInterestRates,
    Map<String, int>? debtMinimumPayments,
    Map<String, int>? debtEscrowAmounts,
  });
  AccountCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _AccountCopyWithImpl<$R, $Out> extends ClassCopyWithBase<$R, Account, $Out>
    implements AccountCopyWith<$R, Account, $Out> {
  _AccountCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Account> $mapper = AccountMapper.ensureInitialized();
  @override
  MapCopyWith<$R, String, int, ObjectCopyWith<$R, int, int>> get debtInterestRates => MapCopyWith(
    $value.debtInterestRates,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(debtInterestRates: v),
  );
  @override
  MapCopyWith<$R, String, int, ObjectCopyWith<$R, int, int>> get debtMinimumPayments => MapCopyWith(
    $value.debtMinimumPayments,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(debtMinimumPayments: v),
  );
  @override
  MapCopyWith<$R, String, int, ObjectCopyWith<$R, int, int>> get debtEscrowAmounts => MapCopyWith(
    $value.debtEscrowAmounts,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(debtEscrowAmounts: v),
  );
  @override
  $R call({
    String? id,
    String? name,
    bool? isOnBudget,
    bool? isClosed,
    bool? isDeleted,
    AccountType? type,
    int? balance,
    Map<String, int>? debtInterestRates,
    Map<String, int>? debtMinimumPayments,
    Map<String, int>? debtEscrowAmounts,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (name != null) #name: name,
      if (isOnBudget != null) #isOnBudget: isOnBudget,
      if (isClosed != null) #isClosed: isClosed,
      if (isDeleted != null) #isDeleted: isDeleted,
      if (type != null) #type: type,
      if (balance != null) #balance: balance,
      if (debtInterestRates != null) #debtInterestRates: debtInterestRates,
      if (debtMinimumPayments != null) #debtMinimumPayments: debtMinimumPayments,
      if (debtEscrowAmounts != null) #debtEscrowAmounts: debtEscrowAmounts,
    }),
  );
  @override
  Account $make(CopyWithData data) => Account(
    id: data.get(#id, or: $value.id),
    name: data.get(#name, or: $value.name),
    isOnBudget: data.get(#isOnBudget, or: $value.isOnBudget),
    isClosed: data.get(#isClosed, or: $value.isClosed),
    isDeleted: data.get(#isDeleted, or: $value.isDeleted),
    type: data.get(#type, or: $value.type),
    balance: data.get(#balance, or: $value.balance),
    debtInterestRates: data.get(#debtInterestRates, or: $value.debtInterestRates),
    debtMinimumPayments: data.get(#debtMinimumPayments, or: $value.debtMinimumPayments),
    debtEscrowAmounts: data.get(#debtEscrowAmounts, or: $value.debtEscrowAmounts),
  );

  @override
  AccountCopyWith<$R2, Account, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _AccountCopyWithImpl($value, $cast, t);
}
