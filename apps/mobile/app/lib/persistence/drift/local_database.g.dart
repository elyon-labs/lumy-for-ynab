// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_database.dart';

// ignore_for_file: type=lint
class $DbBudgetsTable extends DbBudgets with TableInfo<$DbBudgetsTable, DbBudget> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DbBudgetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
    'uuid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _firstMonthMeta = const VerificationMeta('firstMonth');
  @override
  late final GeneratedColumn<String> firstMonth = GeneratedColumn<String>(
    'first_month',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastMonthMeta = const VerificationMeta('lastMonth');
  @override
  late final GeneratedColumn<String> lastMonth = GeneratedColumn<String>(
    'last_month',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastModifiedOnMeta = const VerificationMeta('lastModifiedOn');
  @override
  late final GeneratedColumn<String> lastModifiedOn = GeneratedColumn<String>(
    'last_modified_on',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [uuid, name, firstMonth, lastMonth, lastModifiedOn];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'db_budgets';
  @override
  VerificationContext validateIntegrity(Insertable<DbBudget> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('uuid')) {
      context.handle(_uuidMeta, uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta));
    } else if (isInserting) {
      context.missing(_uuidMeta);
    }
    if (data.containsKey('name')) {
      context.handle(_nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('first_month')) {
      context.handle(
        _firstMonthMeta,
        firstMonth.isAcceptableOrUnknown(data['first_month']!, _firstMonthMeta),
      );
    }
    if (data.containsKey('last_month')) {
      context.handle(
        _lastMonthMeta,
        lastMonth.isAcceptableOrUnknown(data['last_month']!, _lastMonthMeta),
      );
    }
    if (data.containsKey('last_modified_on')) {
      context.handle(
        _lastModifiedOnMeta,
        lastModifiedOn.isAcceptableOrUnknown(data['last_modified_on']!, _lastModifiedOnMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {uuid};
  @override
  DbBudget map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DbBudget(
      uuid: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}uuid'])!,
      name: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      firstMonth: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}first_month'],
      ),
      lastMonth: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_month'],
      ),
      lastModifiedOn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_modified_on'],
      ),
    );
  }

  @override
  $DbBudgetsTable createAlias(String alias) {
    return $DbBudgetsTable(attachedDatabase, alias);
  }
}

class DbBudget extends DataClass implements Insertable<DbBudget> {
  final String uuid;
  final String name;
  final String? firstMonth;
  final String? lastMonth;
  final String? lastModifiedOn;
  const DbBudget({
    required this.uuid,
    required this.name,
    this.firstMonth,
    this.lastMonth,
    this.lastModifiedOn,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['uuid'] = Variable<String>(uuid);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || firstMonth != null) {
      map['first_month'] = Variable<String>(firstMonth);
    }
    if (!nullToAbsent || lastMonth != null) {
      map['last_month'] = Variable<String>(lastMonth);
    }
    if (!nullToAbsent || lastModifiedOn != null) {
      map['last_modified_on'] = Variable<String>(lastModifiedOn);
    }
    return map;
  }

  DbBudgetsCompanion toCompanion(bool nullToAbsent) {
    return DbBudgetsCompanion(
      uuid: Value(uuid),
      name: Value(name),
      firstMonth: firstMonth == null && nullToAbsent ? const Value.absent() : Value(firstMonth),
      lastMonth: lastMonth == null && nullToAbsent ? const Value.absent() : Value(lastMonth),
      lastModifiedOn: lastModifiedOn == null && nullToAbsent
          ? const Value.absent()
          : Value(lastModifiedOn),
    );
  }

  factory DbBudget.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DbBudget(
      uuid: serializer.fromJson<String>(json['uuid']),
      name: serializer.fromJson<String>(json['name']),
      firstMonth: serializer.fromJson<String?>(json['firstMonth']),
      lastMonth: serializer.fromJson<String?>(json['lastMonth']),
      lastModifiedOn: serializer.fromJson<String?>(json['lastModifiedOn']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'uuid': serializer.toJson<String>(uuid),
      'name': serializer.toJson<String>(name),
      'firstMonth': serializer.toJson<String?>(firstMonth),
      'lastMonth': serializer.toJson<String?>(lastMonth),
      'lastModifiedOn': serializer.toJson<String?>(lastModifiedOn),
    };
  }

  DbBudget copyWith({
    String? uuid,
    String? name,
    Value<String?> firstMonth = const Value.absent(),
    Value<String?> lastMonth = const Value.absent(),
    Value<String?> lastModifiedOn = const Value.absent(),
  }) => DbBudget(
    uuid: uuid ?? this.uuid,
    name: name ?? this.name,
    firstMonth: firstMonth.present ? firstMonth.value : this.firstMonth,
    lastMonth: lastMonth.present ? lastMonth.value : this.lastMonth,
    lastModifiedOn: lastModifiedOn.present ? lastModifiedOn.value : this.lastModifiedOn,
  );
  DbBudget copyWithCompanion(DbBudgetsCompanion data) {
    return DbBudget(
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      name: data.name.present ? data.name.value : this.name,
      firstMonth: data.firstMonth.present ? data.firstMonth.value : this.firstMonth,
      lastMonth: data.lastMonth.present ? data.lastMonth.value : this.lastMonth,
      lastModifiedOn: data.lastModifiedOn.present ? data.lastModifiedOn.value : this.lastModifiedOn,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DbBudget(')
          ..write('uuid: $uuid, ')
          ..write('name: $name, ')
          ..write('firstMonth: $firstMonth, ')
          ..write('lastMonth: $lastMonth, ')
          ..write('lastModifiedOn: $lastModifiedOn')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(uuid, name, firstMonth, lastMonth, lastModifiedOn);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DbBudget &&
          other.uuid == this.uuid &&
          other.name == this.name &&
          other.firstMonth == this.firstMonth &&
          other.lastMonth == this.lastMonth &&
          other.lastModifiedOn == this.lastModifiedOn);
}

class DbBudgetsCompanion extends UpdateCompanion<DbBudget> {
  final Value<String> uuid;
  final Value<String> name;
  final Value<String?> firstMonth;
  final Value<String?> lastMonth;
  final Value<String?> lastModifiedOn;
  final Value<int> rowid;
  const DbBudgetsCompanion({
    this.uuid = const Value.absent(),
    this.name = const Value.absent(),
    this.firstMonth = const Value.absent(),
    this.lastMonth = const Value.absent(),
    this.lastModifiedOn = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DbBudgetsCompanion.insert({
    required String uuid,
    required String name,
    this.firstMonth = const Value.absent(),
    this.lastMonth = const Value.absent(),
    this.lastModifiedOn = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : uuid = Value(uuid),
       name = Value(name);
  static Insertable<DbBudget> custom({
    Expression<String>? uuid,
    Expression<String>? name,
    Expression<String>? firstMonth,
    Expression<String>? lastMonth,
    Expression<String>? lastModifiedOn,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (uuid != null) 'uuid': uuid,
      if (name != null) 'name': name,
      if (firstMonth != null) 'first_month': firstMonth,
      if (lastMonth != null) 'last_month': lastMonth,
      if (lastModifiedOn != null) 'last_modified_on': lastModifiedOn,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DbBudgetsCompanion copyWith({
    Value<String>? uuid,
    Value<String>? name,
    Value<String?>? firstMonth,
    Value<String?>? lastMonth,
    Value<String?>? lastModifiedOn,
    Value<int>? rowid,
  }) {
    return DbBudgetsCompanion(
      uuid: uuid ?? this.uuid,
      name: name ?? this.name,
      firstMonth: firstMonth ?? this.firstMonth,
      lastMonth: lastMonth ?? this.lastMonth,
      lastModifiedOn: lastModifiedOn ?? this.lastModifiedOn,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (firstMonth.present) {
      map['first_month'] = Variable<String>(firstMonth.value);
    }
    if (lastMonth.present) {
      map['last_month'] = Variable<String>(lastMonth.value);
    }
    if (lastModifiedOn.present) {
      map['last_modified_on'] = Variable<String>(lastModifiedOn.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DbBudgetsCompanion(')
          ..write('uuid: $uuid, ')
          ..write('name: $name, ')
          ..write('firstMonth: $firstMonth, ')
          ..write('lastMonth: $lastMonth, ')
          ..write('lastModifiedOn: $lastModifiedOn, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DbCurrencyFormatsTable extends DbCurrencyFormats
    with TableInfo<$DbCurrencyFormatsTable, DbCurrencyFormat> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DbCurrencyFormatsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _budgetIdMeta = const VerificationMeta('budgetId');
  @override
  late final GeneratedColumn<String> budgetId = GeneratedColumn<String>(
    'budget_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isoCodeMeta = const VerificationMeta('isoCode');
  @override
  late final GeneratedColumn<String> isoCode = GeneratedColumn<String>(
    'iso_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _decimalDigitsMeta = const VerificationMeta('decimalDigits');
  @override
  late final GeneratedColumn<int> decimalDigits = GeneratedColumn<int>(
    'decimal_digits',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _decimalSeparatorMeta = const VerificationMeta('decimalSeparator');
  @override
  late final GeneratedColumn<String> decimalSeparator = GeneratedColumn<String>(
    'decimal_separator',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isSymbolFirstMeta = const VerificationMeta('isSymbolFirst');
  @override
  late final GeneratedColumn<bool> isSymbolFirst = GeneratedColumn<bool>(
    'is_symbol_first',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("is_symbol_first" IN (0, 1))'),
  );
  static const VerificationMeta _groupSeparatorMeta = const VerificationMeta('groupSeparator');
  @override
  late final GeneratedColumn<String> groupSeparator = GeneratedColumn<String>(
    'group_separator',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencySymbolMeta = const VerificationMeta('currencySymbol');
  @override
  late final GeneratedColumn<String> currencySymbol = GeneratedColumn<String>(
    'currency_symbol',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _shouldDisplaySymbolMeta = const VerificationMeta(
    'shouldDisplaySymbol',
  );
  @override
  late final GeneratedColumn<bool> shouldDisplaySymbol = GeneratedColumn<bool>(
    'should_display_symbol',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("should_display_symbol" IN (0, 1))',
    ),
  );
  static const VerificationMeta _exampleFormatMeta = const VerificationMeta('exampleFormat');
  @override
  late final GeneratedColumn<String> exampleFormat = GeneratedColumn<String>(
    'example_format',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    budgetId,
    isoCode,
    decimalDigits,
    decimalSeparator,
    isSymbolFirst,
    groupSeparator,
    currencySymbol,
    shouldDisplaySymbol,
    exampleFormat,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'db_currency_formats';
  @override
  VerificationContext validateIntegrity(
    Insertable<DbCurrencyFormat> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('budget_id')) {
      context.handle(
        _budgetIdMeta,
        budgetId.isAcceptableOrUnknown(data['budget_id']!, _budgetIdMeta),
      );
    } else if (isInserting) {
      context.missing(_budgetIdMeta);
    }
    if (data.containsKey('iso_code')) {
      context.handle(_isoCodeMeta, isoCode.isAcceptableOrUnknown(data['iso_code']!, _isoCodeMeta));
    } else if (isInserting) {
      context.missing(_isoCodeMeta);
    }
    if (data.containsKey('decimal_digits')) {
      context.handle(
        _decimalDigitsMeta,
        decimalDigits.isAcceptableOrUnknown(data['decimal_digits']!, _decimalDigitsMeta),
      );
    } else if (isInserting) {
      context.missing(_decimalDigitsMeta);
    }
    if (data.containsKey('decimal_separator')) {
      context.handle(
        _decimalSeparatorMeta,
        decimalSeparator.isAcceptableOrUnknown(data['decimal_separator']!, _decimalSeparatorMeta),
      );
    } else if (isInserting) {
      context.missing(_decimalSeparatorMeta);
    }
    if (data.containsKey('is_symbol_first')) {
      context.handle(
        _isSymbolFirstMeta,
        isSymbolFirst.isAcceptableOrUnknown(data['is_symbol_first']!, _isSymbolFirstMeta),
      );
    } else if (isInserting) {
      context.missing(_isSymbolFirstMeta);
    }
    if (data.containsKey('group_separator')) {
      context.handle(
        _groupSeparatorMeta,
        groupSeparator.isAcceptableOrUnknown(data['group_separator']!, _groupSeparatorMeta),
      );
    } else if (isInserting) {
      context.missing(_groupSeparatorMeta);
    }
    if (data.containsKey('currency_symbol')) {
      context.handle(
        _currencySymbolMeta,
        currencySymbol.isAcceptableOrUnknown(data['currency_symbol']!, _currencySymbolMeta),
      );
    } else if (isInserting) {
      context.missing(_currencySymbolMeta);
    }
    if (data.containsKey('should_display_symbol')) {
      context.handle(
        _shouldDisplaySymbolMeta,
        shouldDisplaySymbol.isAcceptableOrUnknown(
          data['should_display_symbol']!,
          _shouldDisplaySymbolMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_shouldDisplaySymbolMeta);
    }
    if (data.containsKey('example_format')) {
      context.handle(
        _exampleFormatMeta,
        exampleFormat.isAcceptableOrUnknown(data['example_format']!, _exampleFormatMeta),
      );
    } else if (isInserting) {
      context.missing(_exampleFormatMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {budgetId};
  @override
  DbCurrencyFormat map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DbCurrencyFormat(
      budgetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}budget_id'],
      )!,
      isoCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}iso_code'],
      )!,
      decimalDigits: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}decimal_digits'],
      )!,
      decimalSeparator: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}decimal_separator'],
      )!,
      isSymbolFirst: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_symbol_first'],
      )!,
      groupSeparator: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}group_separator'],
      )!,
      currencySymbol: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency_symbol'],
      )!,
      shouldDisplaySymbol: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}should_display_symbol'],
      )!,
      exampleFormat: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}example_format'],
      )!,
    );
  }

  @override
  $DbCurrencyFormatsTable createAlias(String alias) {
    return $DbCurrencyFormatsTable(attachedDatabase, alias);
  }
}

class DbCurrencyFormat extends DataClass implements Insertable<DbCurrencyFormat> {
  final String budgetId;
  final String isoCode;
  final int decimalDigits;
  final String decimalSeparator;
  final bool isSymbolFirst;
  final String groupSeparator;
  final String currencySymbol;
  final bool shouldDisplaySymbol;
  final String exampleFormat;
  const DbCurrencyFormat({
    required this.budgetId,
    required this.isoCode,
    required this.decimalDigits,
    required this.decimalSeparator,
    required this.isSymbolFirst,
    required this.groupSeparator,
    required this.currencySymbol,
    required this.shouldDisplaySymbol,
    required this.exampleFormat,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['budget_id'] = Variable<String>(budgetId);
    map['iso_code'] = Variable<String>(isoCode);
    map['decimal_digits'] = Variable<int>(decimalDigits);
    map['decimal_separator'] = Variable<String>(decimalSeparator);
    map['is_symbol_first'] = Variable<bool>(isSymbolFirst);
    map['group_separator'] = Variable<String>(groupSeparator);
    map['currency_symbol'] = Variable<String>(currencySymbol);
    map['should_display_symbol'] = Variable<bool>(shouldDisplaySymbol);
    map['example_format'] = Variable<String>(exampleFormat);
    return map;
  }

  DbCurrencyFormatsCompanion toCompanion(bool nullToAbsent) {
    return DbCurrencyFormatsCompanion(
      budgetId: Value(budgetId),
      isoCode: Value(isoCode),
      decimalDigits: Value(decimalDigits),
      decimalSeparator: Value(decimalSeparator),
      isSymbolFirst: Value(isSymbolFirst),
      groupSeparator: Value(groupSeparator),
      currencySymbol: Value(currencySymbol),
      shouldDisplaySymbol: Value(shouldDisplaySymbol),
      exampleFormat: Value(exampleFormat),
    );
  }

  factory DbCurrencyFormat.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DbCurrencyFormat(
      budgetId: serializer.fromJson<String>(json['budgetId']),
      isoCode: serializer.fromJson<String>(json['isoCode']),
      decimalDigits: serializer.fromJson<int>(json['decimalDigits']),
      decimalSeparator: serializer.fromJson<String>(json['decimalSeparator']),
      isSymbolFirst: serializer.fromJson<bool>(json['isSymbolFirst']),
      groupSeparator: serializer.fromJson<String>(json['groupSeparator']),
      currencySymbol: serializer.fromJson<String>(json['currencySymbol']),
      shouldDisplaySymbol: serializer.fromJson<bool>(json['shouldDisplaySymbol']),
      exampleFormat: serializer.fromJson<String>(json['exampleFormat']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'budgetId': serializer.toJson<String>(budgetId),
      'isoCode': serializer.toJson<String>(isoCode),
      'decimalDigits': serializer.toJson<int>(decimalDigits),
      'decimalSeparator': serializer.toJson<String>(decimalSeparator),
      'isSymbolFirst': serializer.toJson<bool>(isSymbolFirst),
      'groupSeparator': serializer.toJson<String>(groupSeparator),
      'currencySymbol': serializer.toJson<String>(currencySymbol),
      'shouldDisplaySymbol': serializer.toJson<bool>(shouldDisplaySymbol),
      'exampleFormat': serializer.toJson<String>(exampleFormat),
    };
  }

  DbCurrencyFormat copyWith({
    String? budgetId,
    String? isoCode,
    int? decimalDigits,
    String? decimalSeparator,
    bool? isSymbolFirst,
    String? groupSeparator,
    String? currencySymbol,
    bool? shouldDisplaySymbol,
    String? exampleFormat,
  }) => DbCurrencyFormat(
    budgetId: budgetId ?? this.budgetId,
    isoCode: isoCode ?? this.isoCode,
    decimalDigits: decimalDigits ?? this.decimalDigits,
    decimalSeparator: decimalSeparator ?? this.decimalSeparator,
    isSymbolFirst: isSymbolFirst ?? this.isSymbolFirst,
    groupSeparator: groupSeparator ?? this.groupSeparator,
    currencySymbol: currencySymbol ?? this.currencySymbol,
    shouldDisplaySymbol: shouldDisplaySymbol ?? this.shouldDisplaySymbol,
    exampleFormat: exampleFormat ?? this.exampleFormat,
  );
  DbCurrencyFormat copyWithCompanion(DbCurrencyFormatsCompanion data) {
    return DbCurrencyFormat(
      budgetId: data.budgetId.present ? data.budgetId.value : this.budgetId,
      isoCode: data.isoCode.present ? data.isoCode.value : this.isoCode,
      decimalDigits: data.decimalDigits.present ? data.decimalDigits.value : this.decimalDigits,
      decimalSeparator: data.decimalSeparator.present
          ? data.decimalSeparator.value
          : this.decimalSeparator,
      isSymbolFirst: data.isSymbolFirst.present ? data.isSymbolFirst.value : this.isSymbolFirst,
      groupSeparator: data.groupSeparator.present ? data.groupSeparator.value : this.groupSeparator,
      currencySymbol: data.currencySymbol.present ? data.currencySymbol.value : this.currencySymbol,
      shouldDisplaySymbol: data.shouldDisplaySymbol.present
          ? data.shouldDisplaySymbol.value
          : this.shouldDisplaySymbol,
      exampleFormat: data.exampleFormat.present ? data.exampleFormat.value : this.exampleFormat,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DbCurrencyFormat(')
          ..write('budgetId: $budgetId, ')
          ..write('isoCode: $isoCode, ')
          ..write('decimalDigits: $decimalDigits, ')
          ..write('decimalSeparator: $decimalSeparator, ')
          ..write('isSymbolFirst: $isSymbolFirst, ')
          ..write('groupSeparator: $groupSeparator, ')
          ..write('currencySymbol: $currencySymbol, ')
          ..write('shouldDisplaySymbol: $shouldDisplaySymbol, ')
          ..write('exampleFormat: $exampleFormat')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    budgetId,
    isoCode,
    decimalDigits,
    decimalSeparator,
    isSymbolFirst,
    groupSeparator,
    currencySymbol,
    shouldDisplaySymbol,
    exampleFormat,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DbCurrencyFormat &&
          other.budgetId == this.budgetId &&
          other.isoCode == this.isoCode &&
          other.decimalDigits == this.decimalDigits &&
          other.decimalSeparator == this.decimalSeparator &&
          other.isSymbolFirst == this.isSymbolFirst &&
          other.groupSeparator == this.groupSeparator &&
          other.currencySymbol == this.currencySymbol &&
          other.shouldDisplaySymbol == this.shouldDisplaySymbol &&
          other.exampleFormat == this.exampleFormat);
}

class DbCurrencyFormatsCompanion extends UpdateCompanion<DbCurrencyFormat> {
  final Value<String> budgetId;
  final Value<String> isoCode;
  final Value<int> decimalDigits;
  final Value<String> decimalSeparator;
  final Value<bool> isSymbolFirst;
  final Value<String> groupSeparator;
  final Value<String> currencySymbol;
  final Value<bool> shouldDisplaySymbol;
  final Value<String> exampleFormat;
  final Value<int> rowid;
  const DbCurrencyFormatsCompanion({
    this.budgetId = const Value.absent(),
    this.isoCode = const Value.absent(),
    this.decimalDigits = const Value.absent(),
    this.decimalSeparator = const Value.absent(),
    this.isSymbolFirst = const Value.absent(),
    this.groupSeparator = const Value.absent(),
    this.currencySymbol = const Value.absent(),
    this.shouldDisplaySymbol = const Value.absent(),
    this.exampleFormat = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DbCurrencyFormatsCompanion.insert({
    required String budgetId,
    required String isoCode,
    required int decimalDigits,
    required String decimalSeparator,
    required bool isSymbolFirst,
    required String groupSeparator,
    required String currencySymbol,
    required bool shouldDisplaySymbol,
    required String exampleFormat,
    this.rowid = const Value.absent(),
  }) : budgetId = Value(budgetId),
       isoCode = Value(isoCode),
       decimalDigits = Value(decimalDigits),
       decimalSeparator = Value(decimalSeparator),
       isSymbolFirst = Value(isSymbolFirst),
       groupSeparator = Value(groupSeparator),
       currencySymbol = Value(currencySymbol),
       shouldDisplaySymbol = Value(shouldDisplaySymbol),
       exampleFormat = Value(exampleFormat);
  static Insertable<DbCurrencyFormat> custom({
    Expression<String>? budgetId,
    Expression<String>? isoCode,
    Expression<int>? decimalDigits,
    Expression<String>? decimalSeparator,
    Expression<bool>? isSymbolFirst,
    Expression<String>? groupSeparator,
    Expression<String>? currencySymbol,
    Expression<bool>? shouldDisplaySymbol,
    Expression<String>? exampleFormat,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (budgetId != null) 'budget_id': budgetId,
      if (isoCode != null) 'iso_code': isoCode,
      if (decimalDigits != null) 'decimal_digits': decimalDigits,
      if (decimalSeparator != null) 'decimal_separator': decimalSeparator,
      if (isSymbolFirst != null) 'is_symbol_first': isSymbolFirst,
      if (groupSeparator != null) 'group_separator': groupSeparator,
      if (currencySymbol != null) 'currency_symbol': currencySymbol,
      if (shouldDisplaySymbol != null) 'should_display_symbol': shouldDisplaySymbol,
      if (exampleFormat != null) 'example_format': exampleFormat,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DbCurrencyFormatsCompanion copyWith({
    Value<String>? budgetId,
    Value<String>? isoCode,
    Value<int>? decimalDigits,
    Value<String>? decimalSeparator,
    Value<bool>? isSymbolFirst,
    Value<String>? groupSeparator,
    Value<String>? currencySymbol,
    Value<bool>? shouldDisplaySymbol,
    Value<String>? exampleFormat,
    Value<int>? rowid,
  }) {
    return DbCurrencyFormatsCompanion(
      budgetId: budgetId ?? this.budgetId,
      isoCode: isoCode ?? this.isoCode,
      decimalDigits: decimalDigits ?? this.decimalDigits,
      decimalSeparator: decimalSeparator ?? this.decimalSeparator,
      isSymbolFirst: isSymbolFirst ?? this.isSymbolFirst,
      groupSeparator: groupSeparator ?? this.groupSeparator,
      currencySymbol: currencySymbol ?? this.currencySymbol,
      shouldDisplaySymbol: shouldDisplaySymbol ?? this.shouldDisplaySymbol,
      exampleFormat: exampleFormat ?? this.exampleFormat,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (budgetId.present) {
      map['budget_id'] = Variable<String>(budgetId.value);
    }
    if (isoCode.present) {
      map['iso_code'] = Variable<String>(isoCode.value);
    }
    if (decimalDigits.present) {
      map['decimal_digits'] = Variable<int>(decimalDigits.value);
    }
    if (decimalSeparator.present) {
      map['decimal_separator'] = Variable<String>(decimalSeparator.value);
    }
    if (isSymbolFirst.present) {
      map['is_symbol_first'] = Variable<bool>(isSymbolFirst.value);
    }
    if (groupSeparator.present) {
      map['group_separator'] = Variable<String>(groupSeparator.value);
    }
    if (currencySymbol.present) {
      map['currency_symbol'] = Variable<String>(currencySymbol.value);
    }
    if (shouldDisplaySymbol.present) {
      map['should_display_symbol'] = Variable<bool>(shouldDisplaySymbol.value);
    }
    if (exampleFormat.present) {
      map['example_format'] = Variable<String>(exampleFormat.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DbCurrencyFormatsCompanion(')
          ..write('budgetId: $budgetId, ')
          ..write('isoCode: $isoCode, ')
          ..write('decimalDigits: $decimalDigits, ')
          ..write('decimalSeparator: $decimalSeparator, ')
          ..write('isSymbolFirst: $isSymbolFirst, ')
          ..write('groupSeparator: $groupSeparator, ')
          ..write('currencySymbol: $currencySymbol, ')
          ..write('shouldDisplaySymbol: $shouldDisplaySymbol, ')
          ..write('exampleFormat: $exampleFormat, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DbAccountsTable extends DbAccounts with TableInfo<$DbAccountsTable, DbAccount> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DbAccountsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
    'uuid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _budgetIdMeta = const VerificationMeta('budgetId');
  @override
  late final GeneratedColumn<String> budgetId = GeneratedColumn<String>(
    'budget_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _balanceMeta = const VerificationMeta('balance');
  @override
  late final GeneratedColumn<int> balance = GeneratedColumn<int>(
    'balance',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<AccountType, String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<AccountType>($DbAccountsTable.$convertertype);
  static const VerificationMeta _isOnBudgetMeta = const VerificationMeta('isOnBudget');
  @override
  late final GeneratedColumn<bool> isOnBudget = GeneratedColumn<bool>(
    'is_on_budget',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("is_on_budget" IN (0, 1))'),
  );
  static const VerificationMeta _isClosedMeta = const VerificationMeta('isClosed');
  @override
  late final GeneratedColumn<bool> isClosed = GeneratedColumn<bool>(
    'is_closed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("is_closed" IN (0, 1))'),
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("is_deleted" IN (0, 1))'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    uuid,
    budgetId,
    balance,
    name,
    type,
    isOnBudget,
    isClosed,
    isDeleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'db_accounts';
  @override
  VerificationContext validateIntegrity(
    Insertable<DbAccount> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('uuid')) {
      context.handle(_uuidMeta, uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta));
    } else if (isInserting) {
      context.missing(_uuidMeta);
    }
    if (data.containsKey('budget_id')) {
      context.handle(
        _budgetIdMeta,
        budgetId.isAcceptableOrUnknown(data['budget_id']!, _budgetIdMeta),
      );
    } else if (isInserting) {
      context.missing(_budgetIdMeta);
    }
    if (data.containsKey('balance')) {
      context.handle(_balanceMeta, balance.isAcceptableOrUnknown(data['balance']!, _balanceMeta));
    } else if (isInserting) {
      context.missing(_balanceMeta);
    }
    if (data.containsKey('name')) {
      context.handle(_nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('is_on_budget')) {
      context.handle(
        _isOnBudgetMeta,
        isOnBudget.isAcceptableOrUnknown(data['is_on_budget']!, _isOnBudgetMeta),
      );
    } else if (isInserting) {
      context.missing(_isOnBudgetMeta);
    }
    if (data.containsKey('is_closed')) {
      context.handle(
        _isClosedMeta,
        isClosed.isAcceptableOrUnknown(data['is_closed']!, _isClosedMeta),
      );
    } else if (isInserting) {
      context.missing(_isClosedMeta);
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    } else if (isInserting) {
      context.missing(_isDeletedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {uuid};
  @override
  DbAccount map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DbAccount(
      uuid: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}uuid'])!,
      budgetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}budget_id'],
      )!,
      balance: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}balance'],
      )!,
      name: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      type: $DbAccountsTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      ),
      isOnBudget: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_on_budget'],
      )!,
      isClosed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_closed'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
    );
  }

  @override
  $DbAccountsTable createAlias(String alias) {
    return $DbAccountsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<AccountType, String, String> $convertertype =
      const EnumNameConverter<AccountType>(AccountType.values);
}

class DbAccount extends DataClass implements Insertable<DbAccount> {
  final String uuid;
  final String budgetId;
  final int balance;
  final String name;
  final AccountType type;
  final bool isOnBudget;
  final bool isClosed;
  final bool isDeleted;
  const DbAccount({
    required this.uuid,
    required this.budgetId,
    required this.balance,
    required this.name,
    required this.type,
    required this.isOnBudget,
    required this.isClosed,
    required this.isDeleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['uuid'] = Variable<String>(uuid);
    map['budget_id'] = Variable<String>(budgetId);
    map['balance'] = Variable<int>(balance);
    map['name'] = Variable<String>(name);
    {
      map['type'] = Variable<String>($DbAccountsTable.$convertertype.toSql(type));
    }
    map['is_on_budget'] = Variable<bool>(isOnBudget);
    map['is_closed'] = Variable<bool>(isClosed);
    map['is_deleted'] = Variable<bool>(isDeleted);
    return map;
  }

  DbAccountsCompanion toCompanion(bool nullToAbsent) {
    return DbAccountsCompanion(
      uuid: Value(uuid),
      budgetId: Value(budgetId),
      balance: Value(balance),
      name: Value(name),
      type: Value(type),
      isOnBudget: Value(isOnBudget),
      isClosed: Value(isClosed),
      isDeleted: Value(isDeleted),
    );
  }

  factory DbAccount.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DbAccount(
      uuid: serializer.fromJson<String>(json['uuid']),
      budgetId: serializer.fromJson<String>(json['budgetId']),
      balance: serializer.fromJson<int>(json['balance']),
      name: serializer.fromJson<String>(json['name']),
      type: $DbAccountsTable.$convertertype.fromJson(serializer.fromJson<String>(json['type'])),
      isOnBudget: serializer.fromJson<bool>(json['isOnBudget']),
      isClosed: serializer.fromJson<bool>(json['isClosed']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'uuid': serializer.toJson<String>(uuid),
      'budgetId': serializer.toJson<String>(budgetId),
      'balance': serializer.toJson<int>(balance),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>($DbAccountsTable.$convertertype.toJson(type)),
      'isOnBudget': serializer.toJson<bool>(isOnBudget),
      'isClosed': serializer.toJson<bool>(isClosed),
      'isDeleted': serializer.toJson<bool>(isDeleted),
    };
  }

  DbAccount copyWith({
    String? uuid,
    String? budgetId,
    int? balance,
    String? name,
    AccountType? type,
    bool? isOnBudget,
    bool? isClosed,
    bool? isDeleted,
  }) => DbAccount(
    uuid: uuid ?? this.uuid,
    budgetId: budgetId ?? this.budgetId,
    balance: balance ?? this.balance,
    name: name ?? this.name,
    type: type ?? this.type,
    isOnBudget: isOnBudget ?? this.isOnBudget,
    isClosed: isClosed ?? this.isClosed,
    isDeleted: isDeleted ?? this.isDeleted,
  );
  DbAccount copyWithCompanion(DbAccountsCompanion data) {
    return DbAccount(
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      budgetId: data.budgetId.present ? data.budgetId.value : this.budgetId,
      balance: data.balance.present ? data.balance.value : this.balance,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      isOnBudget: data.isOnBudget.present ? data.isOnBudget.value : this.isOnBudget,
      isClosed: data.isClosed.present ? data.isClosed.value : this.isClosed,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DbAccount(')
          ..write('uuid: $uuid, ')
          ..write('budgetId: $budgetId, ')
          ..write('balance: $balance, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('isOnBudget: $isOnBudget, ')
          ..write('isClosed: $isClosed, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(uuid, budgetId, balance, name, type, isOnBudget, isClosed, isDeleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DbAccount &&
          other.uuid == this.uuid &&
          other.budgetId == this.budgetId &&
          other.balance == this.balance &&
          other.name == this.name &&
          other.type == this.type &&
          other.isOnBudget == this.isOnBudget &&
          other.isClosed == this.isClosed &&
          other.isDeleted == this.isDeleted);
}

class DbAccountsCompanion extends UpdateCompanion<DbAccount> {
  final Value<String> uuid;
  final Value<String> budgetId;
  final Value<int> balance;
  final Value<String> name;
  final Value<AccountType> type;
  final Value<bool> isOnBudget;
  final Value<bool> isClosed;
  final Value<bool> isDeleted;
  final Value<int> rowid;
  const DbAccountsCompanion({
    this.uuid = const Value.absent(),
    this.budgetId = const Value.absent(),
    this.balance = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.isOnBudget = const Value.absent(),
    this.isClosed = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DbAccountsCompanion.insert({
    required String uuid,
    required String budgetId,
    required int balance,
    required String name,
    required AccountType type,
    required bool isOnBudget,
    required bool isClosed,
    required bool isDeleted,
    this.rowid = const Value.absent(),
  }) : uuid = Value(uuid),
       budgetId = Value(budgetId),
       balance = Value(balance),
       name = Value(name),
       type = Value(type),
       isOnBudget = Value(isOnBudget),
       isClosed = Value(isClosed),
       isDeleted = Value(isDeleted);
  static Insertable<DbAccount> custom({
    Expression<String>? uuid,
    Expression<String>? budgetId,
    Expression<int>? balance,
    Expression<String>? name,
    Expression<String>? type,
    Expression<bool>? isOnBudget,
    Expression<bool>? isClosed,
    Expression<bool>? isDeleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (uuid != null) 'uuid': uuid,
      if (budgetId != null) 'budget_id': budgetId,
      if (balance != null) 'balance': balance,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (isOnBudget != null) 'is_on_budget': isOnBudget,
      if (isClosed != null) 'is_closed': isClosed,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DbAccountsCompanion copyWith({
    Value<String>? uuid,
    Value<String>? budgetId,
    Value<int>? balance,
    Value<String>? name,
    Value<AccountType>? type,
    Value<bool>? isOnBudget,
    Value<bool>? isClosed,
    Value<bool>? isDeleted,
    Value<int>? rowid,
  }) {
    return DbAccountsCompanion(
      uuid: uuid ?? this.uuid,
      budgetId: budgetId ?? this.budgetId,
      balance: balance ?? this.balance,
      name: name ?? this.name,
      type: type ?? this.type,
      isOnBudget: isOnBudget ?? this.isOnBudget,
      isClosed: isClosed ?? this.isClosed,
      isDeleted: isDeleted ?? this.isDeleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (budgetId.present) {
      map['budget_id'] = Variable<String>(budgetId.value);
    }
    if (balance.present) {
      map['balance'] = Variable<int>(balance.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>($DbAccountsTable.$convertertype.toSql(type.value));
    }
    if (isOnBudget.present) {
      map['is_on_budget'] = Variable<bool>(isOnBudget.value);
    }
    if (isClosed.present) {
      map['is_closed'] = Variable<bool>(isClosed.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DbAccountsCompanion(')
          ..write('uuid: $uuid, ')
          ..write('budgetId: $budgetId, ')
          ..write('balance: $balance, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('isOnBudget: $isOnBudget, ')
          ..write('isClosed: $isClosed, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DbAccountInterestRatesTable extends DbAccountInterestRates
    with TableInfo<$DbAccountInterestRatesTable, DbAccountInterestRate> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DbAccountInterestRatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _budgetIdMeta = const VerificationMeta('budgetId');
  @override
  late final GeneratedColumn<String> budgetId = GeneratedColumn<String>(
    'budget_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta('accountId');
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _monthMeta = const VerificationMeta('month');
  @override
  late final GeneratedColumn<String> month = GeneratedColumn<String>(
    'month',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _interestRateMeta = const VerificationMeta('interestRate');
  @override
  late final GeneratedColumn<int> interestRate = GeneratedColumn<int>(
    'interest_rate',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [budgetId, accountId, month, interestRate];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'db_account_interest_rates';
  @override
  VerificationContext validateIntegrity(
    Insertable<DbAccountInterestRate> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('budget_id')) {
      context.handle(
        _budgetIdMeta,
        budgetId.isAcceptableOrUnknown(data['budget_id']!, _budgetIdMeta),
      );
    } else if (isInserting) {
      context.missing(_budgetIdMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('month')) {
      context.handle(_monthMeta, month.isAcceptableOrUnknown(data['month']!, _monthMeta));
    } else if (isInserting) {
      context.missing(_monthMeta);
    }
    if (data.containsKey('interest_rate')) {
      context.handle(
        _interestRateMeta,
        interestRate.isAcceptableOrUnknown(data['interest_rate']!, _interestRateMeta),
      );
    } else if (isInserting) {
      context.missing(_interestRateMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {budgetId, accountId, month};
  @override
  DbAccountInterestRate map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DbAccountInterestRate(
      budgetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}budget_id'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_id'],
      )!,
      month: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}month'],
      )!,
      interestRate: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}interest_rate'],
      )!,
    );
  }

  @override
  $DbAccountInterestRatesTable createAlias(String alias) {
    return $DbAccountInterestRatesTable(attachedDatabase, alias);
  }
}

class DbAccountInterestRate extends DataClass implements Insertable<DbAccountInterestRate> {
  final String budgetId;
  final String accountId;
  final String month;
  final int interestRate;
  const DbAccountInterestRate({
    required this.budgetId,
    required this.accountId,
    required this.month,
    required this.interestRate,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['budget_id'] = Variable<String>(budgetId);
    map['account_id'] = Variable<String>(accountId);
    map['month'] = Variable<String>(month);
    map['interest_rate'] = Variable<int>(interestRate);
    return map;
  }

  DbAccountInterestRatesCompanion toCompanion(bool nullToAbsent) {
    return DbAccountInterestRatesCompanion(
      budgetId: Value(budgetId),
      accountId: Value(accountId),
      month: Value(month),
      interestRate: Value(interestRate),
    );
  }

  factory DbAccountInterestRate.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DbAccountInterestRate(
      budgetId: serializer.fromJson<String>(json['budgetId']),
      accountId: serializer.fromJson<String>(json['accountId']),
      month: serializer.fromJson<String>(json['month']),
      interestRate: serializer.fromJson<int>(json['interestRate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'budgetId': serializer.toJson<String>(budgetId),
      'accountId': serializer.toJson<String>(accountId),
      'month': serializer.toJson<String>(month),
      'interestRate': serializer.toJson<int>(interestRate),
    };
  }

  DbAccountInterestRate copyWith({
    String? budgetId,
    String? accountId,
    String? month,
    int? interestRate,
  }) => DbAccountInterestRate(
    budgetId: budgetId ?? this.budgetId,
    accountId: accountId ?? this.accountId,
    month: month ?? this.month,
    interestRate: interestRate ?? this.interestRate,
  );
  DbAccountInterestRate copyWithCompanion(DbAccountInterestRatesCompanion data) {
    return DbAccountInterestRate(
      budgetId: data.budgetId.present ? data.budgetId.value : this.budgetId,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      month: data.month.present ? data.month.value : this.month,
      interestRate: data.interestRate.present ? data.interestRate.value : this.interestRate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DbAccountInterestRate(')
          ..write('budgetId: $budgetId, ')
          ..write('accountId: $accountId, ')
          ..write('month: $month, ')
          ..write('interestRate: $interestRate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(budgetId, accountId, month, interestRate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DbAccountInterestRate &&
          other.budgetId == this.budgetId &&
          other.accountId == this.accountId &&
          other.month == this.month &&
          other.interestRate == this.interestRate);
}

class DbAccountInterestRatesCompanion extends UpdateCompanion<DbAccountInterestRate> {
  final Value<String> budgetId;
  final Value<String> accountId;
  final Value<String> month;
  final Value<int> interestRate;
  final Value<int> rowid;
  const DbAccountInterestRatesCompanion({
    this.budgetId = const Value.absent(),
    this.accountId = const Value.absent(),
    this.month = const Value.absent(),
    this.interestRate = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DbAccountInterestRatesCompanion.insert({
    required String budgetId,
    required String accountId,
    required String month,
    required int interestRate,
    this.rowid = const Value.absent(),
  }) : budgetId = Value(budgetId),
       accountId = Value(accountId),
       month = Value(month),
       interestRate = Value(interestRate);
  static Insertable<DbAccountInterestRate> custom({
    Expression<String>? budgetId,
    Expression<String>? accountId,
    Expression<String>? month,
    Expression<int>? interestRate,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (budgetId != null) 'budget_id': budgetId,
      if (accountId != null) 'account_id': accountId,
      if (month != null) 'month': month,
      if (interestRate != null) 'interest_rate': interestRate,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DbAccountInterestRatesCompanion copyWith({
    Value<String>? budgetId,
    Value<String>? accountId,
    Value<String>? month,
    Value<int>? interestRate,
    Value<int>? rowid,
  }) {
    return DbAccountInterestRatesCompanion(
      budgetId: budgetId ?? this.budgetId,
      accountId: accountId ?? this.accountId,
      month: month ?? this.month,
      interestRate: interestRate ?? this.interestRate,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (budgetId.present) {
      map['budget_id'] = Variable<String>(budgetId.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (month.present) {
      map['month'] = Variable<String>(month.value);
    }
    if (interestRate.present) {
      map['interest_rate'] = Variable<int>(interestRate.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DbAccountInterestRatesCompanion(')
          ..write('budgetId: $budgetId, ')
          ..write('accountId: $accountId, ')
          ..write('month: $month, ')
          ..write('interestRate: $interestRate, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DbAccountMinimumPaymentsTable extends DbAccountMinimumPayments
    with TableInfo<$DbAccountMinimumPaymentsTable, DbAccountMinimumPayment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DbAccountMinimumPaymentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _budgetIdMeta = const VerificationMeta('budgetId');
  @override
  late final GeneratedColumn<String> budgetId = GeneratedColumn<String>(
    'budget_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta('accountId');
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _monthMeta = const VerificationMeta('month');
  @override
  late final GeneratedColumn<String> month = GeneratedColumn<String>(
    'month',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mininumPaymentMeta = const VerificationMeta('mininumPayment');
  @override
  late final GeneratedColumn<int> mininumPayment = GeneratedColumn<int>(
    'mininum_payment',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [budgetId, accountId, month, mininumPayment];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'db_account_minimum_payments';
  @override
  VerificationContext validateIntegrity(
    Insertable<DbAccountMinimumPayment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('budget_id')) {
      context.handle(
        _budgetIdMeta,
        budgetId.isAcceptableOrUnknown(data['budget_id']!, _budgetIdMeta),
      );
    } else if (isInserting) {
      context.missing(_budgetIdMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('month')) {
      context.handle(_monthMeta, month.isAcceptableOrUnknown(data['month']!, _monthMeta));
    } else if (isInserting) {
      context.missing(_monthMeta);
    }
    if (data.containsKey('mininum_payment')) {
      context.handle(
        _mininumPaymentMeta,
        mininumPayment.isAcceptableOrUnknown(data['mininum_payment']!, _mininumPaymentMeta),
      );
    } else if (isInserting) {
      context.missing(_mininumPaymentMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {budgetId, accountId, month};
  @override
  DbAccountMinimumPayment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DbAccountMinimumPayment(
      budgetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}budget_id'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_id'],
      )!,
      month: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}month'],
      )!,
      mininumPayment: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}mininum_payment'],
      )!,
    );
  }

  @override
  $DbAccountMinimumPaymentsTable createAlias(String alias) {
    return $DbAccountMinimumPaymentsTable(attachedDatabase, alias);
  }
}

class DbAccountMinimumPayment extends DataClass implements Insertable<DbAccountMinimumPayment> {
  final String budgetId;
  final String accountId;
  final String month;
  final int mininumPayment;
  const DbAccountMinimumPayment({
    required this.budgetId,
    required this.accountId,
    required this.month,
    required this.mininumPayment,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['budget_id'] = Variable<String>(budgetId);
    map['account_id'] = Variable<String>(accountId);
    map['month'] = Variable<String>(month);
    map['mininum_payment'] = Variable<int>(mininumPayment);
    return map;
  }

  DbAccountMinimumPaymentsCompanion toCompanion(bool nullToAbsent) {
    return DbAccountMinimumPaymentsCompanion(
      budgetId: Value(budgetId),
      accountId: Value(accountId),
      month: Value(month),
      mininumPayment: Value(mininumPayment),
    );
  }

  factory DbAccountMinimumPayment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DbAccountMinimumPayment(
      budgetId: serializer.fromJson<String>(json['budgetId']),
      accountId: serializer.fromJson<String>(json['accountId']),
      month: serializer.fromJson<String>(json['month']),
      mininumPayment: serializer.fromJson<int>(json['mininumPayment']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'budgetId': serializer.toJson<String>(budgetId),
      'accountId': serializer.toJson<String>(accountId),
      'month': serializer.toJson<String>(month),
      'mininumPayment': serializer.toJson<int>(mininumPayment),
    };
  }

  DbAccountMinimumPayment copyWith({
    String? budgetId,
    String? accountId,
    String? month,
    int? mininumPayment,
  }) => DbAccountMinimumPayment(
    budgetId: budgetId ?? this.budgetId,
    accountId: accountId ?? this.accountId,
    month: month ?? this.month,
    mininumPayment: mininumPayment ?? this.mininumPayment,
  );
  DbAccountMinimumPayment copyWithCompanion(DbAccountMinimumPaymentsCompanion data) {
    return DbAccountMinimumPayment(
      budgetId: data.budgetId.present ? data.budgetId.value : this.budgetId,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      month: data.month.present ? data.month.value : this.month,
      mininumPayment: data.mininumPayment.present ? data.mininumPayment.value : this.mininumPayment,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DbAccountMinimumPayment(')
          ..write('budgetId: $budgetId, ')
          ..write('accountId: $accountId, ')
          ..write('month: $month, ')
          ..write('mininumPayment: $mininumPayment')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(budgetId, accountId, month, mininumPayment);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DbAccountMinimumPayment &&
          other.budgetId == this.budgetId &&
          other.accountId == this.accountId &&
          other.month == this.month &&
          other.mininumPayment == this.mininumPayment);
}

class DbAccountMinimumPaymentsCompanion extends UpdateCompanion<DbAccountMinimumPayment> {
  final Value<String> budgetId;
  final Value<String> accountId;
  final Value<String> month;
  final Value<int> mininumPayment;
  final Value<int> rowid;
  const DbAccountMinimumPaymentsCompanion({
    this.budgetId = const Value.absent(),
    this.accountId = const Value.absent(),
    this.month = const Value.absent(),
    this.mininumPayment = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DbAccountMinimumPaymentsCompanion.insert({
    required String budgetId,
    required String accountId,
    required String month,
    required int mininumPayment,
    this.rowid = const Value.absent(),
  }) : budgetId = Value(budgetId),
       accountId = Value(accountId),
       month = Value(month),
       mininumPayment = Value(mininumPayment);
  static Insertable<DbAccountMinimumPayment> custom({
    Expression<String>? budgetId,
    Expression<String>? accountId,
    Expression<String>? month,
    Expression<int>? mininumPayment,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (budgetId != null) 'budget_id': budgetId,
      if (accountId != null) 'account_id': accountId,
      if (month != null) 'month': month,
      if (mininumPayment != null) 'mininum_payment': mininumPayment,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DbAccountMinimumPaymentsCompanion copyWith({
    Value<String>? budgetId,
    Value<String>? accountId,
    Value<String>? month,
    Value<int>? mininumPayment,
    Value<int>? rowid,
  }) {
    return DbAccountMinimumPaymentsCompanion(
      budgetId: budgetId ?? this.budgetId,
      accountId: accountId ?? this.accountId,
      month: month ?? this.month,
      mininumPayment: mininumPayment ?? this.mininumPayment,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (budgetId.present) {
      map['budget_id'] = Variable<String>(budgetId.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (month.present) {
      map['month'] = Variable<String>(month.value);
    }
    if (mininumPayment.present) {
      map['mininum_payment'] = Variable<int>(mininumPayment.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DbAccountMinimumPaymentsCompanion(')
          ..write('budgetId: $budgetId, ')
          ..write('accountId: $accountId, ')
          ..write('month: $month, ')
          ..write('mininumPayment: $mininumPayment, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DbAccountEscrowAmountsTable extends DbAccountEscrowAmounts
    with TableInfo<$DbAccountEscrowAmountsTable, DbAccountEscrowAmount> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DbAccountEscrowAmountsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _budgetIdMeta = const VerificationMeta('budgetId');
  @override
  late final GeneratedColumn<String> budgetId = GeneratedColumn<String>(
    'budget_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta('accountId');
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _monthMeta = const VerificationMeta('month');
  @override
  late final GeneratedColumn<String> month = GeneratedColumn<String>(
    'month',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _escrowPaymentMeta = const VerificationMeta('escrowPayment');
  @override
  late final GeneratedColumn<int> escrowPayment = GeneratedColumn<int>(
    'escrow_payment',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [budgetId, accountId, month, escrowPayment];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'db_account_escrow_amounts';
  @override
  VerificationContext validateIntegrity(
    Insertable<DbAccountEscrowAmount> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('budget_id')) {
      context.handle(
        _budgetIdMeta,
        budgetId.isAcceptableOrUnknown(data['budget_id']!, _budgetIdMeta),
      );
    } else if (isInserting) {
      context.missing(_budgetIdMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('month')) {
      context.handle(_monthMeta, month.isAcceptableOrUnknown(data['month']!, _monthMeta));
    } else if (isInserting) {
      context.missing(_monthMeta);
    }
    if (data.containsKey('escrow_payment')) {
      context.handle(
        _escrowPaymentMeta,
        escrowPayment.isAcceptableOrUnknown(data['escrow_payment']!, _escrowPaymentMeta),
      );
    } else if (isInserting) {
      context.missing(_escrowPaymentMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {budgetId, accountId, month};
  @override
  DbAccountEscrowAmount map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DbAccountEscrowAmount(
      budgetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}budget_id'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_id'],
      )!,
      month: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}month'],
      )!,
      escrowPayment: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}escrow_payment'],
      )!,
    );
  }

  @override
  $DbAccountEscrowAmountsTable createAlias(String alias) {
    return $DbAccountEscrowAmountsTable(attachedDatabase, alias);
  }
}

class DbAccountEscrowAmount extends DataClass implements Insertable<DbAccountEscrowAmount> {
  final String budgetId;
  final String accountId;
  final String month;
  final int escrowPayment;
  const DbAccountEscrowAmount({
    required this.budgetId,
    required this.accountId,
    required this.month,
    required this.escrowPayment,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['budget_id'] = Variable<String>(budgetId);
    map['account_id'] = Variable<String>(accountId);
    map['month'] = Variable<String>(month);
    map['escrow_payment'] = Variable<int>(escrowPayment);
    return map;
  }

  DbAccountEscrowAmountsCompanion toCompanion(bool nullToAbsent) {
    return DbAccountEscrowAmountsCompanion(
      budgetId: Value(budgetId),
      accountId: Value(accountId),
      month: Value(month),
      escrowPayment: Value(escrowPayment),
    );
  }

  factory DbAccountEscrowAmount.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DbAccountEscrowAmount(
      budgetId: serializer.fromJson<String>(json['budgetId']),
      accountId: serializer.fromJson<String>(json['accountId']),
      month: serializer.fromJson<String>(json['month']),
      escrowPayment: serializer.fromJson<int>(json['escrowPayment']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'budgetId': serializer.toJson<String>(budgetId),
      'accountId': serializer.toJson<String>(accountId),
      'month': serializer.toJson<String>(month),
      'escrowPayment': serializer.toJson<int>(escrowPayment),
    };
  }

  DbAccountEscrowAmount copyWith({
    String? budgetId,
    String? accountId,
    String? month,
    int? escrowPayment,
  }) => DbAccountEscrowAmount(
    budgetId: budgetId ?? this.budgetId,
    accountId: accountId ?? this.accountId,
    month: month ?? this.month,
    escrowPayment: escrowPayment ?? this.escrowPayment,
  );
  DbAccountEscrowAmount copyWithCompanion(DbAccountEscrowAmountsCompanion data) {
    return DbAccountEscrowAmount(
      budgetId: data.budgetId.present ? data.budgetId.value : this.budgetId,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      month: data.month.present ? data.month.value : this.month,
      escrowPayment: data.escrowPayment.present ? data.escrowPayment.value : this.escrowPayment,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DbAccountEscrowAmount(')
          ..write('budgetId: $budgetId, ')
          ..write('accountId: $accountId, ')
          ..write('month: $month, ')
          ..write('escrowPayment: $escrowPayment')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(budgetId, accountId, month, escrowPayment);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DbAccountEscrowAmount &&
          other.budgetId == this.budgetId &&
          other.accountId == this.accountId &&
          other.month == this.month &&
          other.escrowPayment == this.escrowPayment);
}

class DbAccountEscrowAmountsCompanion extends UpdateCompanion<DbAccountEscrowAmount> {
  final Value<String> budgetId;
  final Value<String> accountId;
  final Value<String> month;
  final Value<int> escrowPayment;
  final Value<int> rowid;
  const DbAccountEscrowAmountsCompanion({
    this.budgetId = const Value.absent(),
    this.accountId = const Value.absent(),
    this.month = const Value.absent(),
    this.escrowPayment = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DbAccountEscrowAmountsCompanion.insert({
    required String budgetId,
    required String accountId,
    required String month,
    required int escrowPayment,
    this.rowid = const Value.absent(),
  }) : budgetId = Value(budgetId),
       accountId = Value(accountId),
       month = Value(month),
       escrowPayment = Value(escrowPayment);
  static Insertable<DbAccountEscrowAmount> custom({
    Expression<String>? budgetId,
    Expression<String>? accountId,
    Expression<String>? month,
    Expression<int>? escrowPayment,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (budgetId != null) 'budget_id': budgetId,
      if (accountId != null) 'account_id': accountId,
      if (month != null) 'month': month,
      if (escrowPayment != null) 'escrow_payment': escrowPayment,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DbAccountEscrowAmountsCompanion copyWith({
    Value<String>? budgetId,
    Value<String>? accountId,
    Value<String>? month,
    Value<int>? escrowPayment,
    Value<int>? rowid,
  }) {
    return DbAccountEscrowAmountsCompanion(
      budgetId: budgetId ?? this.budgetId,
      accountId: accountId ?? this.accountId,
      month: month ?? this.month,
      escrowPayment: escrowPayment ?? this.escrowPayment,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (budgetId.present) {
      map['budget_id'] = Variable<String>(budgetId.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (month.present) {
      map['month'] = Variable<String>(month.value);
    }
    if (escrowPayment.present) {
      map['escrow_payment'] = Variable<int>(escrowPayment.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DbAccountEscrowAmountsCompanion(')
          ..write('budgetId: $budgetId, ')
          ..write('accountId: $accountId, ')
          ..write('month: $month, ')
          ..write('escrowPayment: $escrowPayment, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DbPayeesTable extends DbPayees with TableInfo<$DbPayeesTable, DbPayee> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DbPayeesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
    'uuid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _budgetIdMeta = const VerificationMeta('budgetId');
  @override
  late final GeneratedColumn<String> budgetId = GeneratedColumn<String>(
    'budget_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta('deleted');
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("deleted" IN (0, 1))'),
  );
  @override
  List<GeneratedColumn> get $columns => [uuid, budgetId, name, deleted];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'db_payees';
  @override
  VerificationContext validateIntegrity(Insertable<DbPayee> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('uuid')) {
      context.handle(_uuidMeta, uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta));
    } else if (isInserting) {
      context.missing(_uuidMeta);
    }
    if (data.containsKey('budget_id')) {
      context.handle(
        _budgetIdMeta,
        budgetId.isAcceptableOrUnknown(data['budget_id']!, _budgetIdMeta),
      );
    } else if (isInserting) {
      context.missing(_budgetIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(_nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('deleted')) {
      context.handle(_deletedMeta, deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta));
    } else if (isInserting) {
      context.missing(_deletedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {uuid};
  @override
  DbPayee map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DbPayee(
      uuid: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}uuid'])!,
      budgetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}budget_id'],
      )!,
      name: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
    );
  }

  @override
  $DbPayeesTable createAlias(String alias) {
    return $DbPayeesTable(attachedDatabase, alias);
  }
}

class DbPayee extends DataClass implements Insertable<DbPayee> {
  final String uuid;
  final String budgetId;
  final String name;
  final bool deleted;
  const DbPayee({
    required this.uuid,
    required this.budgetId,
    required this.name,
    required this.deleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['uuid'] = Variable<String>(uuid);
    map['budget_id'] = Variable<String>(budgetId);
    map['name'] = Variable<String>(name);
    map['deleted'] = Variable<bool>(deleted);
    return map;
  }

  DbPayeesCompanion toCompanion(bool nullToAbsent) {
    return DbPayeesCompanion(
      uuid: Value(uuid),
      budgetId: Value(budgetId),
      name: Value(name),
      deleted: Value(deleted),
    );
  }

  factory DbPayee.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DbPayee(
      uuid: serializer.fromJson<String>(json['uuid']),
      budgetId: serializer.fromJson<String>(json['budgetId']),
      name: serializer.fromJson<String>(json['name']),
      deleted: serializer.fromJson<bool>(json['deleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'uuid': serializer.toJson<String>(uuid),
      'budgetId': serializer.toJson<String>(budgetId),
      'name': serializer.toJson<String>(name),
      'deleted': serializer.toJson<bool>(deleted),
    };
  }

  DbPayee copyWith({String? uuid, String? budgetId, String? name, bool? deleted}) => DbPayee(
    uuid: uuid ?? this.uuid,
    budgetId: budgetId ?? this.budgetId,
    name: name ?? this.name,
    deleted: deleted ?? this.deleted,
  );
  DbPayee copyWithCompanion(DbPayeesCompanion data) {
    return DbPayee(
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      budgetId: data.budgetId.present ? data.budgetId.value : this.budgetId,
      name: data.name.present ? data.name.value : this.name,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DbPayee(')
          ..write('uuid: $uuid, ')
          ..write('budgetId: $budgetId, ')
          ..write('name: $name, ')
          ..write('deleted: $deleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(uuid, budgetId, name, deleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DbPayee &&
          other.uuid == this.uuid &&
          other.budgetId == this.budgetId &&
          other.name == this.name &&
          other.deleted == this.deleted);
}

class DbPayeesCompanion extends UpdateCompanion<DbPayee> {
  final Value<String> uuid;
  final Value<String> budgetId;
  final Value<String> name;
  final Value<bool> deleted;
  final Value<int> rowid;
  const DbPayeesCompanion({
    this.uuid = const Value.absent(),
    this.budgetId = const Value.absent(),
    this.name = const Value.absent(),
    this.deleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DbPayeesCompanion.insert({
    required String uuid,
    required String budgetId,
    required String name,
    required bool deleted,
    this.rowid = const Value.absent(),
  }) : uuid = Value(uuid),
       budgetId = Value(budgetId),
       name = Value(name),
       deleted = Value(deleted);
  static Insertable<DbPayee> custom({
    Expression<String>? uuid,
    Expression<String>? budgetId,
    Expression<String>? name,
    Expression<bool>? deleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (uuid != null) 'uuid': uuid,
      if (budgetId != null) 'budget_id': budgetId,
      if (name != null) 'name': name,
      if (deleted != null) 'deleted': deleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DbPayeesCompanion copyWith({
    Value<String>? uuid,
    Value<String>? budgetId,
    Value<String>? name,
    Value<bool>? deleted,
    Value<int>? rowid,
  }) {
    return DbPayeesCompanion(
      uuid: uuid ?? this.uuid,
      budgetId: budgetId ?? this.budgetId,
      name: name ?? this.name,
      deleted: deleted ?? this.deleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (budgetId.present) {
      map['budget_id'] = Variable<String>(budgetId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DbPayeesCompanion(')
          ..write('uuid: $uuid, ')
          ..write('budgetId: $budgetId, ')
          ..write('name: $name, ')
          ..write('deleted: $deleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DbCategoryGroupsTable extends DbCategoryGroups
    with TableInfo<$DbCategoryGroupsTable, DbCategoryGroup> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DbCategoryGroupsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
    'uuid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _budgetIdMeta = const VerificationMeta('budgetId');
  @override
  late final GeneratedColumn<String> budgetId = GeneratedColumn<String>(
    'budget_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isHiddenMeta = const VerificationMeta('isHidden');
  @override
  late final GeneratedColumn<bool> isHidden = GeneratedColumn<bool>(
    'is_hidden',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("is_hidden" IN (0, 1))'),
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("is_deleted" IN (0, 1))'),
  );
  static const VerificationMeta _orderMeta = const VerificationMeta('order');
  @override
  late final GeneratedColumn<int> order = GeneratedColumn<int>(
    'order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [uuid, budgetId, name, isHidden, isDeleted, order];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'db_category_groups';
  @override
  VerificationContext validateIntegrity(
    Insertable<DbCategoryGroup> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('uuid')) {
      context.handle(_uuidMeta, uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta));
    } else if (isInserting) {
      context.missing(_uuidMeta);
    }
    if (data.containsKey('budget_id')) {
      context.handle(
        _budgetIdMeta,
        budgetId.isAcceptableOrUnknown(data['budget_id']!, _budgetIdMeta),
      );
    } else if (isInserting) {
      context.missing(_budgetIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(_nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('is_hidden')) {
      context.handle(
        _isHiddenMeta,
        isHidden.isAcceptableOrUnknown(data['is_hidden']!, _isHiddenMeta),
      );
    } else if (isInserting) {
      context.missing(_isHiddenMeta);
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    } else if (isInserting) {
      context.missing(_isDeletedMeta);
    }
    if (data.containsKey('order')) {
      context.handle(_orderMeta, order.isAcceptableOrUnknown(data['order']!, _orderMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {uuid};
  @override
  DbCategoryGroup map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DbCategoryGroup(
      uuid: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}uuid'])!,
      budgetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}budget_id'],
      )!,
      name: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      isHidden: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_hidden'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
      order: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}order'])!,
    );
  }

  @override
  $DbCategoryGroupsTable createAlias(String alias) {
    return $DbCategoryGroupsTable(attachedDatabase, alias);
  }
}

class DbCategoryGroup extends DataClass implements Insertable<DbCategoryGroup> {
  final String uuid;
  final String budgetId;
  final String name;
  final bool isHidden;
  final bool isDeleted;
  final int order;
  const DbCategoryGroup({
    required this.uuid,
    required this.budgetId,
    required this.name,
    required this.isHidden,
    required this.isDeleted,
    required this.order,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['uuid'] = Variable<String>(uuid);
    map['budget_id'] = Variable<String>(budgetId);
    map['name'] = Variable<String>(name);
    map['is_hidden'] = Variable<bool>(isHidden);
    map['is_deleted'] = Variable<bool>(isDeleted);
    map['order'] = Variable<int>(order);
    return map;
  }

  DbCategoryGroupsCompanion toCompanion(bool nullToAbsent) {
    return DbCategoryGroupsCompanion(
      uuid: Value(uuid),
      budgetId: Value(budgetId),
      name: Value(name),
      isHidden: Value(isHidden),
      isDeleted: Value(isDeleted),
      order: Value(order),
    );
  }

  factory DbCategoryGroup.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DbCategoryGroup(
      uuid: serializer.fromJson<String>(json['uuid']),
      budgetId: serializer.fromJson<String>(json['budgetId']),
      name: serializer.fromJson<String>(json['name']),
      isHidden: serializer.fromJson<bool>(json['isHidden']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      order: serializer.fromJson<int>(json['order']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'uuid': serializer.toJson<String>(uuid),
      'budgetId': serializer.toJson<String>(budgetId),
      'name': serializer.toJson<String>(name),
      'isHidden': serializer.toJson<bool>(isHidden),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'order': serializer.toJson<int>(order),
    };
  }

  DbCategoryGroup copyWith({
    String? uuid,
    String? budgetId,
    String? name,
    bool? isHidden,
    bool? isDeleted,
    int? order,
  }) => DbCategoryGroup(
    uuid: uuid ?? this.uuid,
    budgetId: budgetId ?? this.budgetId,
    name: name ?? this.name,
    isHidden: isHidden ?? this.isHidden,
    isDeleted: isDeleted ?? this.isDeleted,
    order: order ?? this.order,
  );
  DbCategoryGroup copyWithCompanion(DbCategoryGroupsCompanion data) {
    return DbCategoryGroup(
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      budgetId: data.budgetId.present ? data.budgetId.value : this.budgetId,
      name: data.name.present ? data.name.value : this.name,
      isHidden: data.isHidden.present ? data.isHidden.value : this.isHidden,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      order: data.order.present ? data.order.value : this.order,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DbCategoryGroup(')
          ..write('uuid: $uuid, ')
          ..write('budgetId: $budgetId, ')
          ..write('name: $name, ')
          ..write('isHidden: $isHidden, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('order: $order')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(uuid, budgetId, name, isHidden, isDeleted, order);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DbCategoryGroup &&
          other.uuid == this.uuid &&
          other.budgetId == this.budgetId &&
          other.name == this.name &&
          other.isHidden == this.isHidden &&
          other.isDeleted == this.isDeleted &&
          other.order == this.order);
}

class DbCategoryGroupsCompanion extends UpdateCompanion<DbCategoryGroup> {
  final Value<String> uuid;
  final Value<String> budgetId;
  final Value<String> name;
  final Value<bool> isHidden;
  final Value<bool> isDeleted;
  final Value<int> order;
  final Value<int> rowid;
  const DbCategoryGroupsCompanion({
    this.uuid = const Value.absent(),
    this.budgetId = const Value.absent(),
    this.name = const Value.absent(),
    this.isHidden = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.order = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DbCategoryGroupsCompanion.insert({
    required String uuid,
    required String budgetId,
    required String name,
    required bool isHidden,
    required bool isDeleted,
    this.order = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : uuid = Value(uuid),
       budgetId = Value(budgetId),
       name = Value(name),
       isHidden = Value(isHidden),
       isDeleted = Value(isDeleted);
  static Insertable<DbCategoryGroup> custom({
    Expression<String>? uuid,
    Expression<String>? budgetId,
    Expression<String>? name,
    Expression<bool>? isHidden,
    Expression<bool>? isDeleted,
    Expression<int>? order,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (uuid != null) 'uuid': uuid,
      if (budgetId != null) 'budget_id': budgetId,
      if (name != null) 'name': name,
      if (isHidden != null) 'is_hidden': isHidden,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (order != null) 'order': order,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DbCategoryGroupsCompanion copyWith({
    Value<String>? uuid,
    Value<String>? budgetId,
    Value<String>? name,
    Value<bool>? isHidden,
    Value<bool>? isDeleted,
    Value<int>? order,
    Value<int>? rowid,
  }) {
    return DbCategoryGroupsCompanion(
      uuid: uuid ?? this.uuid,
      budgetId: budgetId ?? this.budgetId,
      name: name ?? this.name,
      isHidden: isHidden ?? this.isHidden,
      isDeleted: isDeleted ?? this.isDeleted,
      order: order ?? this.order,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (budgetId.present) {
      map['budget_id'] = Variable<String>(budgetId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (isHidden.present) {
      map['is_hidden'] = Variable<bool>(isHidden.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (order.present) {
      map['order'] = Variable<int>(order.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DbCategoryGroupsCompanion(')
          ..write('uuid: $uuid, ')
          ..write('budgetId: $budgetId, ')
          ..write('name: $name, ')
          ..write('isHidden: $isHidden, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('order: $order, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DbCategoriesTable extends DbCategories with TableInfo<$DbCategoriesTable, DbCategory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DbCategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
    'uuid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryGroupIdMeta = const VerificationMeta('categoryGroupId');
  @override
  late final GeneratedColumn<String> categoryGroupId = GeneratedColumn<String>(
    'category_group_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _budgetIdMeta = const VerificationMeta('budgetId');
  @override
  late final GeneratedColumn<String> budgetId = GeneratedColumn<String>(
    'budget_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isHiddenMeta = const VerificationMeta('isHidden');
  @override
  late final GeneratedColumn<bool> isHidden = GeneratedColumn<bool>(
    'is_hidden',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("is_hidden" IN (0, 1))'),
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("is_deleted" IN (0, 1))'),
  );
  static const VerificationMeta _orderMeta = const VerificationMeta('order');
  @override
  late final GeneratedColumn<int> order = GeneratedColumn<int>(
    'order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _activityMeta = const VerificationMeta('activity');
  @override
  late final GeneratedColumn<int> activity = GeneratedColumn<int>(
    'activity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _budgetedMeta = const VerificationMeta('budgeted');
  @override
  late final GeneratedColumn<int> budgeted = GeneratedColumn<int>(
    'budgeted',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _balanceMeta = const VerificationMeta('balance');
  @override
  late final GeneratedColumn<int> balance = GeneratedColumn<int>(
    'balance',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  late final GeneratedColumnWithTypeConverter<TargetType?, String> targetType =
      GeneratedColumn<String>(
        'target_type',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<TargetType?>($DbCategoriesTable.$convertertargetTypen);
  static const VerificationMeta _targetNeedsWholeAmountMeta = const VerificationMeta(
    'targetNeedsWholeAmount',
  );
  @override
  late final GeneratedColumn<bool> targetNeedsWholeAmount = GeneratedColumn<bool>(
    'target_needs_whole_amount',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("target_needs_whole_amount" IN (0, 1))',
    ),
  );
  static const VerificationMeta _targetDayMeta = const VerificationMeta('targetDay');
  @override
  late final GeneratedColumn<int> targetDay = GeneratedColumn<int>(
    'target_day',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _targetCadenceMeta = const VerificationMeta('targetCadence');
  @override
  late final GeneratedColumn<int> targetCadence = GeneratedColumn<int>(
    'target_cadence',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _targetCadenceFrequencyMeta = const VerificationMeta(
    'targetCadenceFrequency',
  );
  @override
  late final GeneratedColumn<int> targetCadenceFrequency = GeneratedColumn<int>(
    'target_cadence_frequency',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _targetCreationMonthMeta = const VerificationMeta(
    'targetCreationMonth',
  );
  @override
  late final GeneratedColumn<String> targetCreationMonth = GeneratedColumn<String>(
    'target_creation_month',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _targetBalanceMeta = const VerificationMeta('targetBalance');
  @override
  late final GeneratedColumn<int> targetBalance = GeneratedColumn<int>(
    'target_balance',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _targetMonthMeta = const VerificationMeta('targetMonth');
  @override
  late final GeneratedColumn<String> targetMonth = GeneratedColumn<String>(
    'target_month',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _targetPercentageCompleteMeta = const VerificationMeta(
    'targetPercentageComplete',
  );
  @override
  late final GeneratedColumn<int> targetPercentageComplete = GeneratedColumn<int>(
    'target_percentage_complete',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _targetMonthsToBudgetMeta = const VerificationMeta(
    'targetMonthsToBudget',
  );
  @override
  late final GeneratedColumn<int> targetMonthsToBudget = GeneratedColumn<int>(
    'target_months_to_budget',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _targetUnderFundedMeta = const VerificationMeta(
    'targetUnderFunded',
  );
  @override
  late final GeneratedColumn<int> targetUnderFunded = GeneratedColumn<int>(
    'target_under_funded',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _targetOverallFundedMeta = const VerificationMeta(
    'targetOverallFunded',
  );
  @override
  late final GeneratedColumn<int> targetOverallFunded = GeneratedColumn<int>(
    'target_overall_funded',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _targetOverallLeftMeta = const VerificationMeta(
    'targetOverallLeft',
  );
  @override
  late final GeneratedColumn<int> targetOverallLeft = GeneratedColumn<int>(
    'target_overall_left',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    uuid,
    categoryGroupId,
    budgetId,
    name,
    isHidden,
    isDeleted,
    order,
    activity,
    budgeted,
    balance,
    targetType,
    targetNeedsWholeAmount,
    targetDay,
    targetCadence,
    targetCadenceFrequency,
    targetCreationMonth,
    targetBalance,
    targetMonth,
    targetPercentageComplete,
    targetMonthsToBudget,
    targetUnderFunded,
    targetOverallFunded,
    targetOverallLeft,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'db_categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<DbCategory> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('uuid')) {
      context.handle(_uuidMeta, uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta));
    } else if (isInserting) {
      context.missing(_uuidMeta);
    }
    if (data.containsKey('category_group_id')) {
      context.handle(
        _categoryGroupIdMeta,
        categoryGroupId.isAcceptableOrUnknown(data['category_group_id']!, _categoryGroupIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryGroupIdMeta);
    }
    if (data.containsKey('budget_id')) {
      context.handle(
        _budgetIdMeta,
        budgetId.isAcceptableOrUnknown(data['budget_id']!, _budgetIdMeta),
      );
    } else if (isInserting) {
      context.missing(_budgetIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(_nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('is_hidden')) {
      context.handle(
        _isHiddenMeta,
        isHidden.isAcceptableOrUnknown(data['is_hidden']!, _isHiddenMeta),
      );
    } else if (isInserting) {
      context.missing(_isHiddenMeta);
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    } else if (isInserting) {
      context.missing(_isDeletedMeta);
    }
    if (data.containsKey('order')) {
      context.handle(_orderMeta, order.isAcceptableOrUnknown(data['order']!, _orderMeta));
    }
    if (data.containsKey('activity')) {
      context.handle(
        _activityMeta,
        activity.isAcceptableOrUnknown(data['activity']!, _activityMeta),
      );
    }
    if (data.containsKey('budgeted')) {
      context.handle(
        _budgetedMeta,
        budgeted.isAcceptableOrUnknown(data['budgeted']!, _budgetedMeta),
      );
    }
    if (data.containsKey('balance')) {
      context.handle(_balanceMeta, balance.isAcceptableOrUnknown(data['balance']!, _balanceMeta));
    }
    if (data.containsKey('target_needs_whole_amount')) {
      context.handle(
        _targetNeedsWholeAmountMeta,
        targetNeedsWholeAmount.isAcceptableOrUnknown(
          data['target_needs_whole_amount']!,
          _targetNeedsWholeAmountMeta,
        ),
      );
    }
    if (data.containsKey('target_day')) {
      context.handle(
        _targetDayMeta,
        targetDay.isAcceptableOrUnknown(data['target_day']!, _targetDayMeta),
      );
    }
    if (data.containsKey('target_cadence')) {
      context.handle(
        _targetCadenceMeta,
        targetCadence.isAcceptableOrUnknown(data['target_cadence']!, _targetCadenceMeta),
      );
    }
    if (data.containsKey('target_cadence_frequency')) {
      context.handle(
        _targetCadenceFrequencyMeta,
        targetCadenceFrequency.isAcceptableOrUnknown(
          data['target_cadence_frequency']!,
          _targetCadenceFrequencyMeta,
        ),
      );
    }
    if (data.containsKey('target_creation_month')) {
      context.handle(
        _targetCreationMonthMeta,
        targetCreationMonth.isAcceptableOrUnknown(
          data['target_creation_month']!,
          _targetCreationMonthMeta,
        ),
      );
    }
    if (data.containsKey('target_balance')) {
      context.handle(
        _targetBalanceMeta,
        targetBalance.isAcceptableOrUnknown(data['target_balance']!, _targetBalanceMeta),
      );
    }
    if (data.containsKey('target_month')) {
      context.handle(
        _targetMonthMeta,
        targetMonth.isAcceptableOrUnknown(data['target_month']!, _targetMonthMeta),
      );
    }
    if (data.containsKey('target_percentage_complete')) {
      context.handle(
        _targetPercentageCompleteMeta,
        targetPercentageComplete.isAcceptableOrUnknown(
          data['target_percentage_complete']!,
          _targetPercentageCompleteMeta,
        ),
      );
    }
    if (data.containsKey('target_months_to_budget')) {
      context.handle(
        _targetMonthsToBudgetMeta,
        targetMonthsToBudget.isAcceptableOrUnknown(
          data['target_months_to_budget']!,
          _targetMonthsToBudgetMeta,
        ),
      );
    }
    if (data.containsKey('target_under_funded')) {
      context.handle(
        _targetUnderFundedMeta,
        targetUnderFunded.isAcceptableOrUnknown(
          data['target_under_funded']!,
          _targetUnderFundedMeta,
        ),
      );
    }
    if (data.containsKey('target_overall_funded')) {
      context.handle(
        _targetOverallFundedMeta,
        targetOverallFunded.isAcceptableOrUnknown(
          data['target_overall_funded']!,
          _targetOverallFundedMeta,
        ),
      );
    }
    if (data.containsKey('target_overall_left')) {
      context.handle(
        _targetOverallLeftMeta,
        targetOverallLeft.isAcceptableOrUnknown(
          data['target_overall_left']!,
          _targetOverallLeftMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {uuid};
  @override
  DbCategory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DbCategory(
      uuid: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}uuid'])!,
      categoryGroupId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_group_id'],
      )!,
      budgetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}budget_id'],
      )!,
      name: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      isHidden: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_hidden'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
      order: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}order'])!,
      activity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}activity'],
      )!,
      budgeted: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}budgeted'],
      )!,
      balance: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}balance'],
      )!,
      targetType: $DbCategoriesTable.$convertertargetTypen.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}target_type'],
        ),
      ),
      targetNeedsWholeAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}target_needs_whole_amount'],
      ),
      targetDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_day'],
      ),
      targetCadence: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_cadence'],
      ),
      targetCadenceFrequency: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_cadence_frequency'],
      ),
      targetCreationMonth: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_creation_month'],
      ),
      targetBalance: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_balance'],
      ),
      targetMonth: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_month'],
      ),
      targetPercentageComplete: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_percentage_complete'],
      ),
      targetMonthsToBudget: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_months_to_budget'],
      ),
      targetUnderFunded: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_under_funded'],
      ),
      targetOverallFunded: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_overall_funded'],
      ),
      targetOverallLeft: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_overall_left'],
      ),
    );
  }

  @override
  $DbCategoriesTable createAlias(String alias) {
    return $DbCategoriesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TargetType, String, String> $convertertargetType =
      const EnumNameConverter<TargetType>(TargetType.values);
  static JsonTypeConverter2<TargetType?, String?, String?> $convertertargetTypen =
      JsonTypeConverter2.asNullable($convertertargetType);
}

class DbCategory extends DataClass implements Insertable<DbCategory> {
  final String uuid;
  final String categoryGroupId;
  final String budgetId;
  final String name;
  final bool isHidden;
  final bool isDeleted;
  final int order;
  final int activity;
  final int budgeted;
  final int balance;
  final TargetType? targetType;
  final bool? targetNeedsWholeAmount;
  final int? targetDay;
  final int? targetCadence;
  final int? targetCadenceFrequency;
  final String? targetCreationMonth;
  final int? targetBalance;
  final String? targetMonth;
  final int? targetPercentageComplete;
  final int? targetMonthsToBudget;
  final int? targetUnderFunded;
  final int? targetOverallFunded;
  final int? targetOverallLeft;
  const DbCategory({
    required this.uuid,
    required this.categoryGroupId,
    required this.budgetId,
    required this.name,
    required this.isHidden,
    required this.isDeleted,
    required this.order,
    required this.activity,
    required this.budgeted,
    required this.balance,
    this.targetType,
    this.targetNeedsWholeAmount,
    this.targetDay,
    this.targetCadence,
    this.targetCadenceFrequency,
    this.targetCreationMonth,
    this.targetBalance,
    this.targetMonth,
    this.targetPercentageComplete,
    this.targetMonthsToBudget,
    this.targetUnderFunded,
    this.targetOverallFunded,
    this.targetOverallLeft,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['uuid'] = Variable<String>(uuid);
    map['category_group_id'] = Variable<String>(categoryGroupId);
    map['budget_id'] = Variable<String>(budgetId);
    map['name'] = Variable<String>(name);
    map['is_hidden'] = Variable<bool>(isHidden);
    map['is_deleted'] = Variable<bool>(isDeleted);
    map['order'] = Variable<int>(order);
    map['activity'] = Variable<int>(activity);
    map['budgeted'] = Variable<int>(budgeted);
    map['balance'] = Variable<int>(balance);
    if (!nullToAbsent || targetType != null) {
      map['target_type'] = Variable<String>(
        $DbCategoriesTable.$convertertargetTypen.toSql(targetType),
      );
    }
    if (!nullToAbsent || targetNeedsWholeAmount != null) {
      map['target_needs_whole_amount'] = Variable<bool>(targetNeedsWholeAmount);
    }
    if (!nullToAbsent || targetDay != null) {
      map['target_day'] = Variable<int>(targetDay);
    }
    if (!nullToAbsent || targetCadence != null) {
      map['target_cadence'] = Variable<int>(targetCadence);
    }
    if (!nullToAbsent || targetCadenceFrequency != null) {
      map['target_cadence_frequency'] = Variable<int>(targetCadenceFrequency);
    }
    if (!nullToAbsent || targetCreationMonth != null) {
      map['target_creation_month'] = Variable<String>(targetCreationMonth);
    }
    if (!nullToAbsent || targetBalance != null) {
      map['target_balance'] = Variable<int>(targetBalance);
    }
    if (!nullToAbsent || targetMonth != null) {
      map['target_month'] = Variable<String>(targetMonth);
    }
    if (!nullToAbsent || targetPercentageComplete != null) {
      map['target_percentage_complete'] = Variable<int>(targetPercentageComplete);
    }
    if (!nullToAbsent || targetMonthsToBudget != null) {
      map['target_months_to_budget'] = Variable<int>(targetMonthsToBudget);
    }
    if (!nullToAbsent || targetUnderFunded != null) {
      map['target_under_funded'] = Variable<int>(targetUnderFunded);
    }
    if (!nullToAbsent || targetOverallFunded != null) {
      map['target_overall_funded'] = Variable<int>(targetOverallFunded);
    }
    if (!nullToAbsent || targetOverallLeft != null) {
      map['target_overall_left'] = Variable<int>(targetOverallLeft);
    }
    return map;
  }

  DbCategoriesCompanion toCompanion(bool nullToAbsent) {
    return DbCategoriesCompanion(
      uuid: Value(uuid),
      categoryGroupId: Value(categoryGroupId),
      budgetId: Value(budgetId),
      name: Value(name),
      isHidden: Value(isHidden),
      isDeleted: Value(isDeleted),
      order: Value(order),
      activity: Value(activity),
      budgeted: Value(budgeted),
      balance: Value(balance),
      targetType: targetType == null && nullToAbsent ? const Value.absent() : Value(targetType),
      targetNeedsWholeAmount: targetNeedsWholeAmount == null && nullToAbsent
          ? const Value.absent()
          : Value(targetNeedsWholeAmount),
      targetDay: targetDay == null && nullToAbsent ? const Value.absent() : Value(targetDay),
      targetCadence: targetCadence == null && nullToAbsent
          ? const Value.absent()
          : Value(targetCadence),
      targetCadenceFrequency: targetCadenceFrequency == null && nullToAbsent
          ? const Value.absent()
          : Value(targetCadenceFrequency),
      targetCreationMonth: targetCreationMonth == null && nullToAbsent
          ? const Value.absent()
          : Value(targetCreationMonth),
      targetBalance: targetBalance == null && nullToAbsent
          ? const Value.absent()
          : Value(targetBalance),
      targetMonth: targetMonth == null && nullToAbsent ? const Value.absent() : Value(targetMonth),
      targetPercentageComplete: targetPercentageComplete == null && nullToAbsent
          ? const Value.absent()
          : Value(targetPercentageComplete),
      targetMonthsToBudget: targetMonthsToBudget == null && nullToAbsent
          ? const Value.absent()
          : Value(targetMonthsToBudget),
      targetUnderFunded: targetUnderFunded == null && nullToAbsent
          ? const Value.absent()
          : Value(targetUnderFunded),
      targetOverallFunded: targetOverallFunded == null && nullToAbsent
          ? const Value.absent()
          : Value(targetOverallFunded),
      targetOverallLeft: targetOverallLeft == null && nullToAbsent
          ? const Value.absent()
          : Value(targetOverallLeft),
    );
  }

  factory DbCategory.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DbCategory(
      uuid: serializer.fromJson<String>(json['uuid']),
      categoryGroupId: serializer.fromJson<String>(json['categoryGroupId']),
      budgetId: serializer.fromJson<String>(json['budgetId']),
      name: serializer.fromJson<String>(json['name']),
      isHidden: serializer.fromJson<bool>(json['isHidden']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      order: serializer.fromJson<int>(json['order']),
      activity: serializer.fromJson<int>(json['activity']),
      budgeted: serializer.fromJson<int>(json['budgeted']),
      balance: serializer.fromJson<int>(json['balance']),
      targetType: $DbCategoriesTable.$convertertargetTypen.fromJson(
        serializer.fromJson<String?>(json['targetType']),
      ),
      targetNeedsWholeAmount: serializer.fromJson<bool?>(json['targetNeedsWholeAmount']),
      targetDay: serializer.fromJson<int?>(json['targetDay']),
      targetCadence: serializer.fromJson<int?>(json['targetCadence']),
      targetCadenceFrequency: serializer.fromJson<int?>(json['targetCadenceFrequency']),
      targetCreationMonth: serializer.fromJson<String?>(json['targetCreationMonth']),
      targetBalance: serializer.fromJson<int?>(json['targetBalance']),
      targetMonth: serializer.fromJson<String?>(json['targetMonth']),
      targetPercentageComplete: serializer.fromJson<int?>(json['targetPercentageComplete']),
      targetMonthsToBudget: serializer.fromJson<int?>(json['targetMonthsToBudget']),
      targetUnderFunded: serializer.fromJson<int?>(json['targetUnderFunded']),
      targetOverallFunded: serializer.fromJson<int?>(json['targetOverallFunded']),
      targetOverallLeft: serializer.fromJson<int?>(json['targetOverallLeft']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'uuid': serializer.toJson<String>(uuid),
      'categoryGroupId': serializer.toJson<String>(categoryGroupId),
      'budgetId': serializer.toJson<String>(budgetId),
      'name': serializer.toJson<String>(name),
      'isHidden': serializer.toJson<bool>(isHidden),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'order': serializer.toJson<int>(order),
      'activity': serializer.toJson<int>(activity),
      'budgeted': serializer.toJson<int>(budgeted),
      'balance': serializer.toJson<int>(balance),
      'targetType': serializer.toJson<String?>(
        $DbCategoriesTable.$convertertargetTypen.toJson(targetType),
      ),
      'targetNeedsWholeAmount': serializer.toJson<bool?>(targetNeedsWholeAmount),
      'targetDay': serializer.toJson<int?>(targetDay),
      'targetCadence': serializer.toJson<int?>(targetCadence),
      'targetCadenceFrequency': serializer.toJson<int?>(targetCadenceFrequency),
      'targetCreationMonth': serializer.toJson<String?>(targetCreationMonth),
      'targetBalance': serializer.toJson<int?>(targetBalance),
      'targetMonth': serializer.toJson<String?>(targetMonth),
      'targetPercentageComplete': serializer.toJson<int?>(targetPercentageComplete),
      'targetMonthsToBudget': serializer.toJson<int?>(targetMonthsToBudget),
      'targetUnderFunded': serializer.toJson<int?>(targetUnderFunded),
      'targetOverallFunded': serializer.toJson<int?>(targetOverallFunded),
      'targetOverallLeft': serializer.toJson<int?>(targetOverallLeft),
    };
  }

  DbCategory copyWith({
    String? uuid,
    String? categoryGroupId,
    String? budgetId,
    String? name,
    bool? isHidden,
    bool? isDeleted,
    int? order,
    int? activity,
    int? budgeted,
    int? balance,
    Value<TargetType?> targetType = const Value.absent(),
    Value<bool?> targetNeedsWholeAmount = const Value.absent(),
    Value<int?> targetDay = const Value.absent(),
    Value<int?> targetCadence = const Value.absent(),
    Value<int?> targetCadenceFrequency = const Value.absent(),
    Value<String?> targetCreationMonth = const Value.absent(),
    Value<int?> targetBalance = const Value.absent(),
    Value<String?> targetMonth = const Value.absent(),
    Value<int?> targetPercentageComplete = const Value.absent(),
    Value<int?> targetMonthsToBudget = const Value.absent(),
    Value<int?> targetUnderFunded = const Value.absent(),
    Value<int?> targetOverallFunded = const Value.absent(),
    Value<int?> targetOverallLeft = const Value.absent(),
  }) => DbCategory(
    uuid: uuid ?? this.uuid,
    categoryGroupId: categoryGroupId ?? this.categoryGroupId,
    budgetId: budgetId ?? this.budgetId,
    name: name ?? this.name,
    isHidden: isHidden ?? this.isHidden,
    isDeleted: isDeleted ?? this.isDeleted,
    order: order ?? this.order,
    activity: activity ?? this.activity,
    budgeted: budgeted ?? this.budgeted,
    balance: balance ?? this.balance,
    targetType: targetType.present ? targetType.value : this.targetType,
    targetNeedsWholeAmount: targetNeedsWholeAmount.present
        ? targetNeedsWholeAmount.value
        : this.targetNeedsWholeAmount,
    targetDay: targetDay.present ? targetDay.value : this.targetDay,
    targetCadence: targetCadence.present ? targetCadence.value : this.targetCadence,
    targetCadenceFrequency: targetCadenceFrequency.present
        ? targetCadenceFrequency.value
        : this.targetCadenceFrequency,
    targetCreationMonth: targetCreationMonth.present
        ? targetCreationMonth.value
        : this.targetCreationMonth,
    targetBalance: targetBalance.present ? targetBalance.value : this.targetBalance,
    targetMonth: targetMonth.present ? targetMonth.value : this.targetMonth,
    targetPercentageComplete: targetPercentageComplete.present
        ? targetPercentageComplete.value
        : this.targetPercentageComplete,
    targetMonthsToBudget: targetMonthsToBudget.present
        ? targetMonthsToBudget.value
        : this.targetMonthsToBudget,
    targetUnderFunded: targetUnderFunded.present ? targetUnderFunded.value : this.targetUnderFunded,
    targetOverallFunded: targetOverallFunded.present
        ? targetOverallFunded.value
        : this.targetOverallFunded,
    targetOverallLeft: targetOverallLeft.present ? targetOverallLeft.value : this.targetOverallLeft,
  );
  DbCategory copyWithCompanion(DbCategoriesCompanion data) {
    return DbCategory(
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      categoryGroupId: data.categoryGroupId.present
          ? data.categoryGroupId.value
          : this.categoryGroupId,
      budgetId: data.budgetId.present ? data.budgetId.value : this.budgetId,
      name: data.name.present ? data.name.value : this.name,
      isHidden: data.isHidden.present ? data.isHidden.value : this.isHidden,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      order: data.order.present ? data.order.value : this.order,
      activity: data.activity.present ? data.activity.value : this.activity,
      budgeted: data.budgeted.present ? data.budgeted.value : this.budgeted,
      balance: data.balance.present ? data.balance.value : this.balance,
      targetType: data.targetType.present ? data.targetType.value : this.targetType,
      targetNeedsWholeAmount: data.targetNeedsWholeAmount.present
          ? data.targetNeedsWholeAmount.value
          : this.targetNeedsWholeAmount,
      targetDay: data.targetDay.present ? data.targetDay.value : this.targetDay,
      targetCadence: data.targetCadence.present ? data.targetCadence.value : this.targetCadence,
      targetCadenceFrequency: data.targetCadenceFrequency.present
          ? data.targetCadenceFrequency.value
          : this.targetCadenceFrequency,
      targetCreationMonth: data.targetCreationMonth.present
          ? data.targetCreationMonth.value
          : this.targetCreationMonth,
      targetBalance: data.targetBalance.present ? data.targetBalance.value : this.targetBalance,
      targetMonth: data.targetMonth.present ? data.targetMonth.value : this.targetMonth,
      targetPercentageComplete: data.targetPercentageComplete.present
          ? data.targetPercentageComplete.value
          : this.targetPercentageComplete,
      targetMonthsToBudget: data.targetMonthsToBudget.present
          ? data.targetMonthsToBudget.value
          : this.targetMonthsToBudget,
      targetUnderFunded: data.targetUnderFunded.present
          ? data.targetUnderFunded.value
          : this.targetUnderFunded,
      targetOverallFunded: data.targetOverallFunded.present
          ? data.targetOverallFunded.value
          : this.targetOverallFunded,
      targetOverallLeft: data.targetOverallLeft.present
          ? data.targetOverallLeft.value
          : this.targetOverallLeft,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DbCategory(')
          ..write('uuid: $uuid, ')
          ..write('categoryGroupId: $categoryGroupId, ')
          ..write('budgetId: $budgetId, ')
          ..write('name: $name, ')
          ..write('isHidden: $isHidden, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('order: $order, ')
          ..write('activity: $activity, ')
          ..write('budgeted: $budgeted, ')
          ..write('balance: $balance, ')
          ..write('targetType: $targetType, ')
          ..write('targetNeedsWholeAmount: $targetNeedsWholeAmount, ')
          ..write('targetDay: $targetDay, ')
          ..write('targetCadence: $targetCadence, ')
          ..write('targetCadenceFrequency: $targetCadenceFrequency, ')
          ..write('targetCreationMonth: $targetCreationMonth, ')
          ..write('targetBalance: $targetBalance, ')
          ..write('targetMonth: $targetMonth, ')
          ..write('targetPercentageComplete: $targetPercentageComplete, ')
          ..write('targetMonthsToBudget: $targetMonthsToBudget, ')
          ..write('targetUnderFunded: $targetUnderFunded, ')
          ..write('targetOverallFunded: $targetOverallFunded, ')
          ..write('targetOverallLeft: $targetOverallLeft')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    uuid,
    categoryGroupId,
    budgetId,
    name,
    isHidden,
    isDeleted,
    order,
    activity,
    budgeted,
    balance,
    targetType,
    targetNeedsWholeAmount,
    targetDay,
    targetCadence,
    targetCadenceFrequency,
    targetCreationMonth,
    targetBalance,
    targetMonth,
    targetPercentageComplete,
    targetMonthsToBudget,
    targetUnderFunded,
    targetOverallFunded,
    targetOverallLeft,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DbCategory &&
          other.uuid == this.uuid &&
          other.categoryGroupId == this.categoryGroupId &&
          other.budgetId == this.budgetId &&
          other.name == this.name &&
          other.isHidden == this.isHidden &&
          other.isDeleted == this.isDeleted &&
          other.order == this.order &&
          other.activity == this.activity &&
          other.budgeted == this.budgeted &&
          other.balance == this.balance &&
          other.targetType == this.targetType &&
          other.targetNeedsWholeAmount == this.targetNeedsWholeAmount &&
          other.targetDay == this.targetDay &&
          other.targetCadence == this.targetCadence &&
          other.targetCadenceFrequency == this.targetCadenceFrequency &&
          other.targetCreationMonth == this.targetCreationMonth &&
          other.targetBalance == this.targetBalance &&
          other.targetMonth == this.targetMonth &&
          other.targetPercentageComplete == this.targetPercentageComplete &&
          other.targetMonthsToBudget == this.targetMonthsToBudget &&
          other.targetUnderFunded == this.targetUnderFunded &&
          other.targetOverallFunded == this.targetOverallFunded &&
          other.targetOverallLeft == this.targetOverallLeft);
}

class DbCategoriesCompanion extends UpdateCompanion<DbCategory> {
  final Value<String> uuid;
  final Value<String> categoryGroupId;
  final Value<String> budgetId;
  final Value<String> name;
  final Value<bool> isHidden;
  final Value<bool> isDeleted;
  final Value<int> order;
  final Value<int> activity;
  final Value<int> budgeted;
  final Value<int> balance;
  final Value<TargetType?> targetType;
  final Value<bool?> targetNeedsWholeAmount;
  final Value<int?> targetDay;
  final Value<int?> targetCadence;
  final Value<int?> targetCadenceFrequency;
  final Value<String?> targetCreationMonth;
  final Value<int?> targetBalance;
  final Value<String?> targetMonth;
  final Value<int?> targetPercentageComplete;
  final Value<int?> targetMonthsToBudget;
  final Value<int?> targetUnderFunded;
  final Value<int?> targetOverallFunded;
  final Value<int?> targetOverallLeft;
  final Value<int> rowid;
  const DbCategoriesCompanion({
    this.uuid = const Value.absent(),
    this.categoryGroupId = const Value.absent(),
    this.budgetId = const Value.absent(),
    this.name = const Value.absent(),
    this.isHidden = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.order = const Value.absent(),
    this.activity = const Value.absent(),
    this.budgeted = const Value.absent(),
    this.balance = const Value.absent(),
    this.targetType = const Value.absent(),
    this.targetNeedsWholeAmount = const Value.absent(),
    this.targetDay = const Value.absent(),
    this.targetCadence = const Value.absent(),
    this.targetCadenceFrequency = const Value.absent(),
    this.targetCreationMonth = const Value.absent(),
    this.targetBalance = const Value.absent(),
    this.targetMonth = const Value.absent(),
    this.targetPercentageComplete = const Value.absent(),
    this.targetMonthsToBudget = const Value.absent(),
    this.targetUnderFunded = const Value.absent(),
    this.targetOverallFunded = const Value.absent(),
    this.targetOverallLeft = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DbCategoriesCompanion.insert({
    required String uuid,
    required String categoryGroupId,
    required String budgetId,
    required String name,
    required bool isHidden,
    required bool isDeleted,
    this.order = const Value.absent(),
    this.activity = const Value.absent(),
    this.budgeted = const Value.absent(),
    this.balance = const Value.absent(),
    this.targetType = const Value.absent(),
    this.targetNeedsWholeAmount = const Value.absent(),
    this.targetDay = const Value.absent(),
    this.targetCadence = const Value.absent(),
    this.targetCadenceFrequency = const Value.absent(),
    this.targetCreationMonth = const Value.absent(),
    this.targetBalance = const Value.absent(),
    this.targetMonth = const Value.absent(),
    this.targetPercentageComplete = const Value.absent(),
    this.targetMonthsToBudget = const Value.absent(),
    this.targetUnderFunded = const Value.absent(),
    this.targetOverallFunded = const Value.absent(),
    this.targetOverallLeft = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : uuid = Value(uuid),
       categoryGroupId = Value(categoryGroupId),
       budgetId = Value(budgetId),
       name = Value(name),
       isHidden = Value(isHidden),
       isDeleted = Value(isDeleted);
  static Insertable<DbCategory> custom({
    Expression<String>? uuid,
    Expression<String>? categoryGroupId,
    Expression<String>? budgetId,
    Expression<String>? name,
    Expression<bool>? isHidden,
    Expression<bool>? isDeleted,
    Expression<int>? order,
    Expression<int>? activity,
    Expression<int>? budgeted,
    Expression<int>? balance,
    Expression<String>? targetType,
    Expression<bool>? targetNeedsWholeAmount,
    Expression<int>? targetDay,
    Expression<int>? targetCadence,
    Expression<int>? targetCadenceFrequency,
    Expression<String>? targetCreationMonth,
    Expression<int>? targetBalance,
    Expression<String>? targetMonth,
    Expression<int>? targetPercentageComplete,
    Expression<int>? targetMonthsToBudget,
    Expression<int>? targetUnderFunded,
    Expression<int>? targetOverallFunded,
    Expression<int>? targetOverallLeft,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (uuid != null) 'uuid': uuid,
      if (categoryGroupId != null) 'category_group_id': categoryGroupId,
      if (budgetId != null) 'budget_id': budgetId,
      if (name != null) 'name': name,
      if (isHidden != null) 'is_hidden': isHidden,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (order != null) 'order': order,
      if (activity != null) 'activity': activity,
      if (budgeted != null) 'budgeted': budgeted,
      if (balance != null) 'balance': balance,
      if (targetType != null) 'target_type': targetType,
      if (targetNeedsWholeAmount != null) 'target_needs_whole_amount': targetNeedsWholeAmount,
      if (targetDay != null) 'target_day': targetDay,
      if (targetCadence != null) 'target_cadence': targetCadence,
      if (targetCadenceFrequency != null) 'target_cadence_frequency': targetCadenceFrequency,
      if (targetCreationMonth != null) 'target_creation_month': targetCreationMonth,
      if (targetBalance != null) 'target_balance': targetBalance,
      if (targetMonth != null) 'target_month': targetMonth,
      if (targetPercentageComplete != null) 'target_percentage_complete': targetPercentageComplete,
      if (targetMonthsToBudget != null) 'target_months_to_budget': targetMonthsToBudget,
      if (targetUnderFunded != null) 'target_under_funded': targetUnderFunded,
      if (targetOverallFunded != null) 'target_overall_funded': targetOverallFunded,
      if (targetOverallLeft != null) 'target_overall_left': targetOverallLeft,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DbCategoriesCompanion copyWith({
    Value<String>? uuid,
    Value<String>? categoryGroupId,
    Value<String>? budgetId,
    Value<String>? name,
    Value<bool>? isHidden,
    Value<bool>? isDeleted,
    Value<int>? order,
    Value<int>? activity,
    Value<int>? budgeted,
    Value<int>? balance,
    Value<TargetType?>? targetType,
    Value<bool?>? targetNeedsWholeAmount,
    Value<int?>? targetDay,
    Value<int?>? targetCadence,
    Value<int?>? targetCadenceFrequency,
    Value<String?>? targetCreationMonth,
    Value<int?>? targetBalance,
    Value<String?>? targetMonth,
    Value<int?>? targetPercentageComplete,
    Value<int?>? targetMonthsToBudget,
    Value<int?>? targetUnderFunded,
    Value<int?>? targetOverallFunded,
    Value<int?>? targetOverallLeft,
    Value<int>? rowid,
  }) {
    return DbCategoriesCompanion(
      uuid: uuid ?? this.uuid,
      categoryGroupId: categoryGroupId ?? this.categoryGroupId,
      budgetId: budgetId ?? this.budgetId,
      name: name ?? this.name,
      isHidden: isHidden ?? this.isHidden,
      isDeleted: isDeleted ?? this.isDeleted,
      order: order ?? this.order,
      activity: activity ?? this.activity,
      budgeted: budgeted ?? this.budgeted,
      balance: balance ?? this.balance,
      targetType: targetType ?? this.targetType,
      targetNeedsWholeAmount: targetNeedsWholeAmount ?? this.targetNeedsWholeAmount,
      targetDay: targetDay ?? this.targetDay,
      targetCadence: targetCadence ?? this.targetCadence,
      targetCadenceFrequency: targetCadenceFrequency ?? this.targetCadenceFrequency,
      targetCreationMonth: targetCreationMonth ?? this.targetCreationMonth,
      targetBalance: targetBalance ?? this.targetBalance,
      targetMonth: targetMonth ?? this.targetMonth,
      targetPercentageComplete: targetPercentageComplete ?? this.targetPercentageComplete,
      targetMonthsToBudget: targetMonthsToBudget ?? this.targetMonthsToBudget,
      targetUnderFunded: targetUnderFunded ?? this.targetUnderFunded,
      targetOverallFunded: targetOverallFunded ?? this.targetOverallFunded,
      targetOverallLeft: targetOverallLeft ?? this.targetOverallLeft,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (categoryGroupId.present) {
      map['category_group_id'] = Variable<String>(categoryGroupId.value);
    }
    if (budgetId.present) {
      map['budget_id'] = Variable<String>(budgetId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (isHidden.present) {
      map['is_hidden'] = Variable<bool>(isHidden.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (order.present) {
      map['order'] = Variable<int>(order.value);
    }
    if (activity.present) {
      map['activity'] = Variable<int>(activity.value);
    }
    if (budgeted.present) {
      map['budgeted'] = Variable<int>(budgeted.value);
    }
    if (balance.present) {
      map['balance'] = Variable<int>(balance.value);
    }
    if (targetType.present) {
      map['target_type'] = Variable<String>(
        $DbCategoriesTable.$convertertargetTypen.toSql(targetType.value),
      );
    }
    if (targetNeedsWholeAmount.present) {
      map['target_needs_whole_amount'] = Variable<bool>(targetNeedsWholeAmount.value);
    }
    if (targetDay.present) {
      map['target_day'] = Variable<int>(targetDay.value);
    }
    if (targetCadence.present) {
      map['target_cadence'] = Variable<int>(targetCadence.value);
    }
    if (targetCadenceFrequency.present) {
      map['target_cadence_frequency'] = Variable<int>(targetCadenceFrequency.value);
    }
    if (targetCreationMonth.present) {
      map['target_creation_month'] = Variable<String>(targetCreationMonth.value);
    }
    if (targetBalance.present) {
      map['target_balance'] = Variable<int>(targetBalance.value);
    }
    if (targetMonth.present) {
      map['target_month'] = Variable<String>(targetMonth.value);
    }
    if (targetPercentageComplete.present) {
      map['target_percentage_complete'] = Variable<int>(targetPercentageComplete.value);
    }
    if (targetMonthsToBudget.present) {
      map['target_months_to_budget'] = Variable<int>(targetMonthsToBudget.value);
    }
    if (targetUnderFunded.present) {
      map['target_under_funded'] = Variable<int>(targetUnderFunded.value);
    }
    if (targetOverallFunded.present) {
      map['target_overall_funded'] = Variable<int>(targetOverallFunded.value);
    }
    if (targetOverallLeft.present) {
      map['target_overall_left'] = Variable<int>(targetOverallLeft.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DbCategoriesCompanion(')
          ..write('uuid: $uuid, ')
          ..write('categoryGroupId: $categoryGroupId, ')
          ..write('budgetId: $budgetId, ')
          ..write('name: $name, ')
          ..write('isHidden: $isHidden, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('order: $order, ')
          ..write('activity: $activity, ')
          ..write('budgeted: $budgeted, ')
          ..write('balance: $balance, ')
          ..write('targetType: $targetType, ')
          ..write('targetNeedsWholeAmount: $targetNeedsWholeAmount, ')
          ..write('targetDay: $targetDay, ')
          ..write('targetCadence: $targetCadence, ')
          ..write('targetCadenceFrequency: $targetCadenceFrequency, ')
          ..write('targetCreationMonth: $targetCreationMonth, ')
          ..write('targetBalance: $targetBalance, ')
          ..write('targetMonth: $targetMonth, ')
          ..write('targetPercentageComplete: $targetPercentageComplete, ')
          ..write('targetMonthsToBudget: $targetMonthsToBudget, ')
          ..write('targetUnderFunded: $targetUnderFunded, ')
          ..write('targetOverallFunded: $targetOverallFunded, ')
          ..write('targetOverallLeft: $targetOverallLeft, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DbTransactionsTable extends DbTransactions
    with TableInfo<$DbTransactionsTable, DbTransaction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DbTransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
    'uuid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _budgetIdMeta = const VerificationMeta('budgetId');
  @override
  late final GeneratedColumn<String> budgetId = GeneratedColumn<String>(
    'budget_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta('accountId');
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("is_deleted" IN (0, 1))'),
  );
  static const VerificationMeta _payeeNameMeta = const VerificationMeta('payeeName');
  @override
  late final GeneratedColumn<String> payeeName = GeneratedColumn<String>(
    'payee_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _payeeIdMeta = const VerificationMeta('payeeId');
  @override
  late final GeneratedColumn<String> payeeId = GeneratedColumn<String>(
    'payee_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryNameMeta = const VerificationMeta('categoryName');
  @override
  late final GeneratedColumn<String> categoryName = GeneratedColumn<String>(
    'category_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _memoMeta = const VerificationMeta('memo');
  @override
  late final GeneratedColumn<String> memo = GeneratedColumn<String>(
    'memo',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _transferAccountIdMeta = const VerificationMeta(
    'transferAccountId',
  );
  @override
  late final GeneratedColumn<String> transferAccountId = GeneratedColumn<String>(
    'transfer_account_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _transferTransactionIdMeta = const VerificationMeta(
    'transferTransactionId',
  );
  @override
  late final GeneratedColumn<String> transferTransactionId = GeneratedColumn<String>(
    'transfer_transaction_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _matchedTransactionIdMeta = const VerificationMeta(
    'matchedTransactionId',
  );
  @override
  late final GeneratedColumn<String> matchedTransactionId = GeneratedColumn<String>(
    'matched_transaction_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _importIdMeta = const VerificationMeta('importId');
  @override
  late final GeneratedColumn<String> importId = GeneratedColumn<String>(
    'import_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Flag?, String> flagColor = GeneratedColumn<String>(
    'flag_color',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  ).withConverter<Flag?>($DbTransactionsTable.$converterflagColorn);
  @override
  List<GeneratedColumn> get $columns => [
    uuid,
    budgetId,
    amount,
    date,
    accountId,
    isDeleted,
    payeeName,
    payeeId,
    categoryId,
    categoryName,
    memo,
    transferAccountId,
    transferTransactionId,
    matchedTransactionId,
    importId,
    flagColor,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'db_transactions';
  @override
  VerificationContext validateIntegrity(
    Insertable<DbTransaction> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('uuid')) {
      context.handle(_uuidMeta, uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta));
    } else if (isInserting) {
      context.missing(_uuidMeta);
    }
    if (data.containsKey('budget_id')) {
      context.handle(
        _budgetIdMeta,
        budgetId.isAcceptableOrUnknown(data['budget_id']!, _budgetIdMeta),
      );
    } else if (isInserting) {
      context.missing(_budgetIdMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta, amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('date')) {
      context.handle(_dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    } else if (isInserting) {
      context.missing(_isDeletedMeta);
    }
    if (data.containsKey('payee_name')) {
      context.handle(
        _payeeNameMeta,
        payeeName.isAcceptableOrUnknown(data['payee_name']!, _payeeNameMeta),
      );
    }
    if (data.containsKey('payee_id')) {
      context.handle(_payeeIdMeta, payeeId.isAcceptableOrUnknown(data['payee_id']!, _payeeIdMeta));
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('category_name')) {
      context.handle(
        _categoryNameMeta,
        categoryName.isAcceptableOrUnknown(data['category_name']!, _categoryNameMeta),
      );
    }
    if (data.containsKey('memo')) {
      context.handle(_memoMeta, memo.isAcceptableOrUnknown(data['memo']!, _memoMeta));
    }
    if (data.containsKey('transfer_account_id')) {
      context.handle(
        _transferAccountIdMeta,
        transferAccountId.isAcceptableOrUnknown(
          data['transfer_account_id']!,
          _transferAccountIdMeta,
        ),
      );
    }
    if (data.containsKey('transfer_transaction_id')) {
      context.handle(
        _transferTransactionIdMeta,
        transferTransactionId.isAcceptableOrUnknown(
          data['transfer_transaction_id']!,
          _transferTransactionIdMeta,
        ),
      );
    }
    if (data.containsKey('matched_transaction_id')) {
      context.handle(
        _matchedTransactionIdMeta,
        matchedTransactionId.isAcceptableOrUnknown(
          data['matched_transaction_id']!,
          _matchedTransactionIdMeta,
        ),
      );
    }
    if (data.containsKey('import_id')) {
      context.handle(
        _importIdMeta,
        importId.isAcceptableOrUnknown(data['import_id']!, _importIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {uuid};
  @override
  DbTransaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DbTransaction(
      uuid: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}uuid'])!,
      budgetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}budget_id'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount'],
      )!,
      date: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}date'])!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_id'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
      payeeName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payee_name'],
      ),
      payeeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payee_id'],
      ),
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      ),
      categoryName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_name'],
      ),
      memo: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}memo']),
      transferAccountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}transfer_account_id'],
      ),
      transferTransactionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}transfer_transaction_id'],
      ),
      matchedTransactionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}matched_transaction_id'],
      ),
      importId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}import_id'],
      ),
      flagColor: $DbTransactionsTable.$converterflagColorn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}flag_color'],
        ),
      ),
    );
  }

  @override
  $DbTransactionsTable createAlias(String alias) {
    return $DbTransactionsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<Flag, String, String> $converterflagColor =
      const EnumNameConverter<Flag>(Flag.values);
  static JsonTypeConverter2<Flag?, String?, String?> $converterflagColorn =
      JsonTypeConverter2.asNullable($converterflagColor);
}

class DbTransaction extends DataClass implements Insertable<DbTransaction> {
  final String uuid;
  final String budgetId;
  final int amount;
  final String date;
  final String accountId;
  final bool isDeleted;
  final String? payeeName;
  final String? payeeId;
  final String? categoryId;
  final String? categoryName;
  final String? memo;
  final String? transferAccountId;
  final String? transferTransactionId;
  final String? matchedTransactionId;
  final String? importId;
  final Flag? flagColor;
  const DbTransaction({
    required this.uuid,
    required this.budgetId,
    required this.amount,
    required this.date,
    required this.accountId,
    required this.isDeleted,
    this.payeeName,
    this.payeeId,
    this.categoryId,
    this.categoryName,
    this.memo,
    this.transferAccountId,
    this.transferTransactionId,
    this.matchedTransactionId,
    this.importId,
    this.flagColor,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['uuid'] = Variable<String>(uuid);
    map['budget_id'] = Variable<String>(budgetId);
    map['amount'] = Variable<int>(amount);
    map['date'] = Variable<String>(date);
    map['account_id'] = Variable<String>(accountId);
    map['is_deleted'] = Variable<bool>(isDeleted);
    if (!nullToAbsent || payeeName != null) {
      map['payee_name'] = Variable<String>(payeeName);
    }
    if (!nullToAbsent || payeeId != null) {
      map['payee_id'] = Variable<String>(payeeId);
    }
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<String>(categoryId);
    }
    if (!nullToAbsent || categoryName != null) {
      map['category_name'] = Variable<String>(categoryName);
    }
    if (!nullToAbsent || memo != null) {
      map['memo'] = Variable<String>(memo);
    }
    if (!nullToAbsent || transferAccountId != null) {
      map['transfer_account_id'] = Variable<String>(transferAccountId);
    }
    if (!nullToAbsent || transferTransactionId != null) {
      map['transfer_transaction_id'] = Variable<String>(transferTransactionId);
    }
    if (!nullToAbsent || matchedTransactionId != null) {
      map['matched_transaction_id'] = Variable<String>(matchedTransactionId);
    }
    if (!nullToAbsent || importId != null) {
      map['import_id'] = Variable<String>(importId);
    }
    if (!nullToAbsent || flagColor != null) {
      map['flag_color'] = Variable<String>(
        $DbTransactionsTable.$converterflagColorn.toSql(flagColor),
      );
    }
    return map;
  }

  DbTransactionsCompanion toCompanion(bool nullToAbsent) {
    return DbTransactionsCompanion(
      uuid: Value(uuid),
      budgetId: Value(budgetId),
      amount: Value(amount),
      date: Value(date),
      accountId: Value(accountId),
      isDeleted: Value(isDeleted),
      payeeName: payeeName == null && nullToAbsent ? const Value.absent() : Value(payeeName),
      payeeId: payeeId == null && nullToAbsent ? const Value.absent() : Value(payeeId),
      categoryId: categoryId == null && nullToAbsent ? const Value.absent() : Value(categoryId),
      categoryName: categoryName == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryName),
      memo: memo == null && nullToAbsent ? const Value.absent() : Value(memo),
      transferAccountId: transferAccountId == null && nullToAbsent
          ? const Value.absent()
          : Value(transferAccountId),
      transferTransactionId: transferTransactionId == null && nullToAbsent
          ? const Value.absent()
          : Value(transferTransactionId),
      matchedTransactionId: matchedTransactionId == null && nullToAbsent
          ? const Value.absent()
          : Value(matchedTransactionId),
      importId: importId == null && nullToAbsent ? const Value.absent() : Value(importId),
      flagColor: flagColor == null && nullToAbsent ? const Value.absent() : Value(flagColor),
    );
  }

  factory DbTransaction.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DbTransaction(
      uuid: serializer.fromJson<String>(json['uuid']),
      budgetId: serializer.fromJson<String>(json['budgetId']),
      amount: serializer.fromJson<int>(json['amount']),
      date: serializer.fromJson<String>(json['date']),
      accountId: serializer.fromJson<String>(json['accountId']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      payeeName: serializer.fromJson<String?>(json['payeeName']),
      payeeId: serializer.fromJson<String?>(json['payeeId']),
      categoryId: serializer.fromJson<String?>(json['categoryId']),
      categoryName: serializer.fromJson<String?>(json['categoryName']),
      memo: serializer.fromJson<String?>(json['memo']),
      transferAccountId: serializer.fromJson<String?>(json['transferAccountId']),
      transferTransactionId: serializer.fromJson<String?>(json['transferTransactionId']),
      matchedTransactionId: serializer.fromJson<String?>(json['matchedTransactionId']),
      importId: serializer.fromJson<String?>(json['importId']),
      flagColor: $DbTransactionsTable.$converterflagColorn.fromJson(
        serializer.fromJson<String?>(json['flagColor']),
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'uuid': serializer.toJson<String>(uuid),
      'budgetId': serializer.toJson<String>(budgetId),
      'amount': serializer.toJson<int>(amount),
      'date': serializer.toJson<String>(date),
      'accountId': serializer.toJson<String>(accountId),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'payeeName': serializer.toJson<String?>(payeeName),
      'payeeId': serializer.toJson<String?>(payeeId),
      'categoryId': serializer.toJson<String?>(categoryId),
      'categoryName': serializer.toJson<String?>(categoryName),
      'memo': serializer.toJson<String?>(memo),
      'transferAccountId': serializer.toJson<String?>(transferAccountId),
      'transferTransactionId': serializer.toJson<String?>(transferTransactionId),
      'matchedTransactionId': serializer.toJson<String?>(matchedTransactionId),
      'importId': serializer.toJson<String?>(importId),
      'flagColor': serializer.toJson<String?>(
        $DbTransactionsTable.$converterflagColorn.toJson(flagColor),
      ),
    };
  }

  DbTransaction copyWith({
    String? uuid,
    String? budgetId,
    int? amount,
    String? date,
    String? accountId,
    bool? isDeleted,
    Value<String?> payeeName = const Value.absent(),
    Value<String?> payeeId = const Value.absent(),
    Value<String?> categoryId = const Value.absent(),
    Value<String?> categoryName = const Value.absent(),
    Value<String?> memo = const Value.absent(),
    Value<String?> transferAccountId = const Value.absent(),
    Value<String?> transferTransactionId = const Value.absent(),
    Value<String?> matchedTransactionId = const Value.absent(),
    Value<String?> importId = const Value.absent(),
    Value<Flag?> flagColor = const Value.absent(),
  }) => DbTransaction(
    uuid: uuid ?? this.uuid,
    budgetId: budgetId ?? this.budgetId,
    amount: amount ?? this.amount,
    date: date ?? this.date,
    accountId: accountId ?? this.accountId,
    isDeleted: isDeleted ?? this.isDeleted,
    payeeName: payeeName.present ? payeeName.value : this.payeeName,
    payeeId: payeeId.present ? payeeId.value : this.payeeId,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    categoryName: categoryName.present ? categoryName.value : this.categoryName,
    memo: memo.present ? memo.value : this.memo,
    transferAccountId: transferAccountId.present ? transferAccountId.value : this.transferAccountId,
    transferTransactionId: transferTransactionId.present
        ? transferTransactionId.value
        : this.transferTransactionId,
    matchedTransactionId: matchedTransactionId.present
        ? matchedTransactionId.value
        : this.matchedTransactionId,
    importId: importId.present ? importId.value : this.importId,
    flagColor: flagColor.present ? flagColor.value : this.flagColor,
  );
  DbTransaction copyWithCompanion(DbTransactionsCompanion data) {
    return DbTransaction(
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      budgetId: data.budgetId.present ? data.budgetId.value : this.budgetId,
      amount: data.amount.present ? data.amount.value : this.amount,
      date: data.date.present ? data.date.value : this.date,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      payeeName: data.payeeName.present ? data.payeeName.value : this.payeeName,
      payeeId: data.payeeId.present ? data.payeeId.value : this.payeeId,
      categoryId: data.categoryId.present ? data.categoryId.value : this.categoryId,
      categoryName: data.categoryName.present ? data.categoryName.value : this.categoryName,
      memo: data.memo.present ? data.memo.value : this.memo,
      transferAccountId: data.transferAccountId.present
          ? data.transferAccountId.value
          : this.transferAccountId,
      transferTransactionId: data.transferTransactionId.present
          ? data.transferTransactionId.value
          : this.transferTransactionId,
      matchedTransactionId: data.matchedTransactionId.present
          ? data.matchedTransactionId.value
          : this.matchedTransactionId,
      importId: data.importId.present ? data.importId.value : this.importId,
      flagColor: data.flagColor.present ? data.flagColor.value : this.flagColor,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DbTransaction(')
          ..write('uuid: $uuid, ')
          ..write('budgetId: $budgetId, ')
          ..write('amount: $amount, ')
          ..write('date: $date, ')
          ..write('accountId: $accountId, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('payeeName: $payeeName, ')
          ..write('payeeId: $payeeId, ')
          ..write('categoryId: $categoryId, ')
          ..write('categoryName: $categoryName, ')
          ..write('memo: $memo, ')
          ..write('transferAccountId: $transferAccountId, ')
          ..write('transferTransactionId: $transferTransactionId, ')
          ..write('matchedTransactionId: $matchedTransactionId, ')
          ..write('importId: $importId, ')
          ..write('flagColor: $flagColor')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    uuid,
    budgetId,
    amount,
    date,
    accountId,
    isDeleted,
    payeeName,
    payeeId,
    categoryId,
    categoryName,
    memo,
    transferAccountId,
    transferTransactionId,
    matchedTransactionId,
    importId,
    flagColor,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DbTransaction &&
          other.uuid == this.uuid &&
          other.budgetId == this.budgetId &&
          other.amount == this.amount &&
          other.date == this.date &&
          other.accountId == this.accountId &&
          other.isDeleted == this.isDeleted &&
          other.payeeName == this.payeeName &&
          other.payeeId == this.payeeId &&
          other.categoryId == this.categoryId &&
          other.categoryName == this.categoryName &&
          other.memo == this.memo &&
          other.transferAccountId == this.transferAccountId &&
          other.transferTransactionId == this.transferTransactionId &&
          other.matchedTransactionId == this.matchedTransactionId &&
          other.importId == this.importId &&
          other.flagColor == this.flagColor);
}

class DbTransactionsCompanion extends UpdateCompanion<DbTransaction> {
  final Value<String> uuid;
  final Value<String> budgetId;
  final Value<int> amount;
  final Value<String> date;
  final Value<String> accountId;
  final Value<bool> isDeleted;
  final Value<String?> payeeName;
  final Value<String?> payeeId;
  final Value<String?> categoryId;
  final Value<String?> categoryName;
  final Value<String?> memo;
  final Value<String?> transferAccountId;
  final Value<String?> transferTransactionId;
  final Value<String?> matchedTransactionId;
  final Value<String?> importId;
  final Value<Flag?> flagColor;
  final Value<int> rowid;
  const DbTransactionsCompanion({
    this.uuid = const Value.absent(),
    this.budgetId = const Value.absent(),
    this.amount = const Value.absent(),
    this.date = const Value.absent(),
    this.accountId = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.payeeName = const Value.absent(),
    this.payeeId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.categoryName = const Value.absent(),
    this.memo = const Value.absent(),
    this.transferAccountId = const Value.absent(),
    this.transferTransactionId = const Value.absent(),
    this.matchedTransactionId = const Value.absent(),
    this.importId = const Value.absent(),
    this.flagColor = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DbTransactionsCompanion.insert({
    required String uuid,
    required String budgetId,
    required int amount,
    required String date,
    required String accountId,
    required bool isDeleted,
    this.payeeName = const Value.absent(),
    this.payeeId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.categoryName = const Value.absent(),
    this.memo = const Value.absent(),
    this.transferAccountId = const Value.absent(),
    this.transferTransactionId = const Value.absent(),
    this.matchedTransactionId = const Value.absent(),
    this.importId = const Value.absent(),
    this.flagColor = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : uuid = Value(uuid),
       budgetId = Value(budgetId),
       amount = Value(amount),
       date = Value(date),
       accountId = Value(accountId),
       isDeleted = Value(isDeleted);
  static Insertable<DbTransaction> custom({
    Expression<String>? uuid,
    Expression<String>? budgetId,
    Expression<int>? amount,
    Expression<String>? date,
    Expression<String>? accountId,
    Expression<bool>? isDeleted,
    Expression<String>? payeeName,
    Expression<String>? payeeId,
    Expression<String>? categoryId,
    Expression<String>? categoryName,
    Expression<String>? memo,
    Expression<String>? transferAccountId,
    Expression<String>? transferTransactionId,
    Expression<String>? matchedTransactionId,
    Expression<String>? importId,
    Expression<String>? flagColor,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (uuid != null) 'uuid': uuid,
      if (budgetId != null) 'budget_id': budgetId,
      if (amount != null) 'amount': amount,
      if (date != null) 'date': date,
      if (accountId != null) 'account_id': accountId,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (payeeName != null) 'payee_name': payeeName,
      if (payeeId != null) 'payee_id': payeeId,
      if (categoryId != null) 'category_id': categoryId,
      if (categoryName != null) 'category_name': categoryName,
      if (memo != null) 'memo': memo,
      if (transferAccountId != null) 'transfer_account_id': transferAccountId,
      if (transferTransactionId != null) 'transfer_transaction_id': transferTransactionId,
      if (matchedTransactionId != null) 'matched_transaction_id': matchedTransactionId,
      if (importId != null) 'import_id': importId,
      if (flagColor != null) 'flag_color': flagColor,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DbTransactionsCompanion copyWith({
    Value<String>? uuid,
    Value<String>? budgetId,
    Value<int>? amount,
    Value<String>? date,
    Value<String>? accountId,
    Value<bool>? isDeleted,
    Value<String?>? payeeName,
    Value<String?>? payeeId,
    Value<String?>? categoryId,
    Value<String?>? categoryName,
    Value<String?>? memo,
    Value<String?>? transferAccountId,
    Value<String?>? transferTransactionId,
    Value<String?>? matchedTransactionId,
    Value<String?>? importId,
    Value<Flag?>? flagColor,
    Value<int>? rowid,
  }) {
    return DbTransactionsCompanion(
      uuid: uuid ?? this.uuid,
      budgetId: budgetId ?? this.budgetId,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      accountId: accountId ?? this.accountId,
      isDeleted: isDeleted ?? this.isDeleted,
      payeeName: payeeName ?? this.payeeName,
      payeeId: payeeId ?? this.payeeId,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      memo: memo ?? this.memo,
      transferAccountId: transferAccountId ?? this.transferAccountId,
      transferTransactionId: transferTransactionId ?? this.transferTransactionId,
      matchedTransactionId: matchedTransactionId ?? this.matchedTransactionId,
      importId: importId ?? this.importId,
      flagColor: flagColor ?? this.flagColor,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (budgetId.present) {
      map['budget_id'] = Variable<String>(budgetId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (payeeName.present) {
      map['payee_name'] = Variable<String>(payeeName.value);
    }
    if (payeeId.present) {
      map['payee_id'] = Variable<String>(payeeId.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (categoryName.present) {
      map['category_name'] = Variable<String>(categoryName.value);
    }
    if (memo.present) {
      map['memo'] = Variable<String>(memo.value);
    }
    if (transferAccountId.present) {
      map['transfer_account_id'] = Variable<String>(transferAccountId.value);
    }
    if (transferTransactionId.present) {
      map['transfer_transaction_id'] = Variable<String>(transferTransactionId.value);
    }
    if (matchedTransactionId.present) {
      map['matched_transaction_id'] = Variable<String>(matchedTransactionId.value);
    }
    if (importId.present) {
      map['import_id'] = Variable<String>(importId.value);
    }
    if (flagColor.present) {
      map['flag_color'] = Variable<String>(
        $DbTransactionsTable.$converterflagColorn.toSql(flagColor.value),
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DbTransactionsCompanion(')
          ..write('uuid: $uuid, ')
          ..write('budgetId: $budgetId, ')
          ..write('amount: $amount, ')
          ..write('date: $date, ')
          ..write('accountId: $accountId, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('payeeName: $payeeName, ')
          ..write('payeeId: $payeeId, ')
          ..write('categoryId: $categoryId, ')
          ..write('categoryName: $categoryName, ')
          ..write('memo: $memo, ')
          ..write('transferAccountId: $transferAccountId, ')
          ..write('transferTransactionId: $transferTransactionId, ')
          ..write('matchedTransactionId: $matchedTransactionId, ')
          ..write('importId: $importId, ')
          ..write('flagColor: $flagColor, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DbSubTransactionsTable extends DbSubTransactions
    with TableInfo<$DbSubTransactionsTable, DbSubTransaction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DbSubTransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
    'uuid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _transactionIdMeta = const VerificationMeta('transactionId');
  @override
  late final GeneratedColumn<String> transactionId = GeneratedColumn<String>(
    'transaction_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _budgetIdMeta = const VerificationMeta('budgetId');
  @override
  late final GeneratedColumn<String> budgetId = GeneratedColumn<String>(
    'budget_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("is_deleted" IN (0, 1))'),
  );
  static const VerificationMeta _payeeNameMeta = const VerificationMeta('payeeName');
  @override
  late final GeneratedColumn<String> payeeName = GeneratedColumn<String>(
    'payee_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _payeeIdMeta = const VerificationMeta('payeeId');
  @override
  late final GeneratedColumn<String> payeeId = GeneratedColumn<String>(
    'payee_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryNameMeta = const VerificationMeta('categoryName');
  @override
  late final GeneratedColumn<String> categoryName = GeneratedColumn<String>(
    'category_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _memoMeta = const VerificationMeta('memo');
  @override
  late final GeneratedColumn<String> memo = GeneratedColumn<String>(
    'memo',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _transferAccountIdMeta = const VerificationMeta(
    'transferAccountId',
  );
  @override
  late final GeneratedColumn<String> transferAccountId = GeneratedColumn<String>(
    'transfer_account_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _transferTransactionIdMeta = const VerificationMeta(
    'transferTransactionId',
  );
  @override
  late final GeneratedColumn<String> transferTransactionId = GeneratedColumn<String>(
    'transfer_transaction_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    uuid,
    transactionId,
    budgetId,
    amount,
    isDeleted,
    payeeName,
    payeeId,
    categoryId,
    categoryName,
    memo,
    transferAccountId,
    transferTransactionId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'db_sub_transactions';
  @override
  VerificationContext validateIntegrity(
    Insertable<DbSubTransaction> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('uuid')) {
      context.handle(_uuidMeta, uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta));
    } else if (isInserting) {
      context.missing(_uuidMeta);
    }
    if (data.containsKey('transaction_id')) {
      context.handle(
        _transactionIdMeta,
        transactionId.isAcceptableOrUnknown(data['transaction_id']!, _transactionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_transactionIdMeta);
    }
    if (data.containsKey('budget_id')) {
      context.handle(
        _budgetIdMeta,
        budgetId.isAcceptableOrUnknown(data['budget_id']!, _budgetIdMeta),
      );
    } else if (isInserting) {
      context.missing(_budgetIdMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta, amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    } else if (isInserting) {
      context.missing(_isDeletedMeta);
    }
    if (data.containsKey('payee_name')) {
      context.handle(
        _payeeNameMeta,
        payeeName.isAcceptableOrUnknown(data['payee_name']!, _payeeNameMeta),
      );
    }
    if (data.containsKey('payee_id')) {
      context.handle(_payeeIdMeta, payeeId.isAcceptableOrUnknown(data['payee_id']!, _payeeIdMeta));
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('category_name')) {
      context.handle(
        _categoryNameMeta,
        categoryName.isAcceptableOrUnknown(data['category_name']!, _categoryNameMeta),
      );
    }
    if (data.containsKey('memo')) {
      context.handle(_memoMeta, memo.isAcceptableOrUnknown(data['memo']!, _memoMeta));
    }
    if (data.containsKey('transfer_account_id')) {
      context.handle(
        _transferAccountIdMeta,
        transferAccountId.isAcceptableOrUnknown(
          data['transfer_account_id']!,
          _transferAccountIdMeta,
        ),
      );
    }
    if (data.containsKey('transfer_transaction_id')) {
      context.handle(
        _transferTransactionIdMeta,
        transferTransactionId.isAcceptableOrUnknown(
          data['transfer_transaction_id']!,
          _transferTransactionIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {uuid};
  @override
  DbSubTransaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DbSubTransaction(
      uuid: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}uuid'])!,
      transactionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}transaction_id'],
      )!,
      budgetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}budget_id'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
      payeeName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payee_name'],
      ),
      payeeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payee_id'],
      ),
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      ),
      categoryName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_name'],
      ),
      memo: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}memo']),
      transferAccountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}transfer_account_id'],
      ),
      transferTransactionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}transfer_transaction_id'],
      ),
    );
  }

  @override
  $DbSubTransactionsTable createAlias(String alias) {
    return $DbSubTransactionsTable(attachedDatabase, alias);
  }
}

class DbSubTransaction extends DataClass implements Insertable<DbSubTransaction> {
  final String uuid;
  final String transactionId;
  final String budgetId;
  final int amount;
  final bool isDeleted;
  final String? payeeName;
  final String? payeeId;
  final String? categoryId;
  final String? categoryName;
  final String? memo;
  final String? transferAccountId;
  final String? transferTransactionId;
  const DbSubTransaction({
    required this.uuid,
    required this.transactionId,
    required this.budgetId,
    required this.amount,
    required this.isDeleted,
    this.payeeName,
    this.payeeId,
    this.categoryId,
    this.categoryName,
    this.memo,
    this.transferAccountId,
    this.transferTransactionId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['uuid'] = Variable<String>(uuid);
    map['transaction_id'] = Variable<String>(transactionId);
    map['budget_id'] = Variable<String>(budgetId);
    map['amount'] = Variable<int>(amount);
    map['is_deleted'] = Variable<bool>(isDeleted);
    if (!nullToAbsent || payeeName != null) {
      map['payee_name'] = Variable<String>(payeeName);
    }
    if (!nullToAbsent || payeeId != null) {
      map['payee_id'] = Variable<String>(payeeId);
    }
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<String>(categoryId);
    }
    if (!nullToAbsent || categoryName != null) {
      map['category_name'] = Variable<String>(categoryName);
    }
    if (!nullToAbsent || memo != null) {
      map['memo'] = Variable<String>(memo);
    }
    if (!nullToAbsent || transferAccountId != null) {
      map['transfer_account_id'] = Variable<String>(transferAccountId);
    }
    if (!nullToAbsent || transferTransactionId != null) {
      map['transfer_transaction_id'] = Variable<String>(transferTransactionId);
    }
    return map;
  }

  DbSubTransactionsCompanion toCompanion(bool nullToAbsent) {
    return DbSubTransactionsCompanion(
      uuid: Value(uuid),
      transactionId: Value(transactionId),
      budgetId: Value(budgetId),
      amount: Value(amount),
      isDeleted: Value(isDeleted),
      payeeName: payeeName == null && nullToAbsent ? const Value.absent() : Value(payeeName),
      payeeId: payeeId == null && nullToAbsent ? const Value.absent() : Value(payeeId),
      categoryId: categoryId == null && nullToAbsent ? const Value.absent() : Value(categoryId),
      categoryName: categoryName == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryName),
      memo: memo == null && nullToAbsent ? const Value.absent() : Value(memo),
      transferAccountId: transferAccountId == null && nullToAbsent
          ? const Value.absent()
          : Value(transferAccountId),
      transferTransactionId: transferTransactionId == null && nullToAbsent
          ? const Value.absent()
          : Value(transferTransactionId),
    );
  }

  factory DbSubTransaction.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DbSubTransaction(
      uuid: serializer.fromJson<String>(json['uuid']),
      transactionId: serializer.fromJson<String>(json['transactionId']),
      budgetId: serializer.fromJson<String>(json['budgetId']),
      amount: serializer.fromJson<int>(json['amount']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      payeeName: serializer.fromJson<String?>(json['payeeName']),
      payeeId: serializer.fromJson<String?>(json['payeeId']),
      categoryId: serializer.fromJson<String?>(json['categoryId']),
      categoryName: serializer.fromJson<String?>(json['categoryName']),
      memo: serializer.fromJson<String?>(json['memo']),
      transferAccountId: serializer.fromJson<String?>(json['transferAccountId']),
      transferTransactionId: serializer.fromJson<String?>(json['transferTransactionId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'uuid': serializer.toJson<String>(uuid),
      'transactionId': serializer.toJson<String>(transactionId),
      'budgetId': serializer.toJson<String>(budgetId),
      'amount': serializer.toJson<int>(amount),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'payeeName': serializer.toJson<String?>(payeeName),
      'payeeId': serializer.toJson<String?>(payeeId),
      'categoryId': serializer.toJson<String?>(categoryId),
      'categoryName': serializer.toJson<String?>(categoryName),
      'memo': serializer.toJson<String?>(memo),
      'transferAccountId': serializer.toJson<String?>(transferAccountId),
      'transferTransactionId': serializer.toJson<String?>(transferTransactionId),
    };
  }

  DbSubTransaction copyWith({
    String? uuid,
    String? transactionId,
    String? budgetId,
    int? amount,
    bool? isDeleted,
    Value<String?> payeeName = const Value.absent(),
    Value<String?> payeeId = const Value.absent(),
    Value<String?> categoryId = const Value.absent(),
    Value<String?> categoryName = const Value.absent(),
    Value<String?> memo = const Value.absent(),
    Value<String?> transferAccountId = const Value.absent(),
    Value<String?> transferTransactionId = const Value.absent(),
  }) => DbSubTransaction(
    uuid: uuid ?? this.uuid,
    transactionId: transactionId ?? this.transactionId,
    budgetId: budgetId ?? this.budgetId,
    amount: amount ?? this.amount,
    isDeleted: isDeleted ?? this.isDeleted,
    payeeName: payeeName.present ? payeeName.value : this.payeeName,
    payeeId: payeeId.present ? payeeId.value : this.payeeId,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    categoryName: categoryName.present ? categoryName.value : this.categoryName,
    memo: memo.present ? memo.value : this.memo,
    transferAccountId: transferAccountId.present ? transferAccountId.value : this.transferAccountId,
    transferTransactionId: transferTransactionId.present
        ? transferTransactionId.value
        : this.transferTransactionId,
  );
  DbSubTransaction copyWithCompanion(DbSubTransactionsCompanion data) {
    return DbSubTransaction(
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      transactionId: data.transactionId.present ? data.transactionId.value : this.transactionId,
      budgetId: data.budgetId.present ? data.budgetId.value : this.budgetId,
      amount: data.amount.present ? data.amount.value : this.amount,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      payeeName: data.payeeName.present ? data.payeeName.value : this.payeeName,
      payeeId: data.payeeId.present ? data.payeeId.value : this.payeeId,
      categoryId: data.categoryId.present ? data.categoryId.value : this.categoryId,
      categoryName: data.categoryName.present ? data.categoryName.value : this.categoryName,
      memo: data.memo.present ? data.memo.value : this.memo,
      transferAccountId: data.transferAccountId.present
          ? data.transferAccountId.value
          : this.transferAccountId,
      transferTransactionId: data.transferTransactionId.present
          ? data.transferTransactionId.value
          : this.transferTransactionId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DbSubTransaction(')
          ..write('uuid: $uuid, ')
          ..write('transactionId: $transactionId, ')
          ..write('budgetId: $budgetId, ')
          ..write('amount: $amount, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('payeeName: $payeeName, ')
          ..write('payeeId: $payeeId, ')
          ..write('categoryId: $categoryId, ')
          ..write('categoryName: $categoryName, ')
          ..write('memo: $memo, ')
          ..write('transferAccountId: $transferAccountId, ')
          ..write('transferTransactionId: $transferTransactionId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    uuid,
    transactionId,
    budgetId,
    amount,
    isDeleted,
    payeeName,
    payeeId,
    categoryId,
    categoryName,
    memo,
    transferAccountId,
    transferTransactionId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DbSubTransaction &&
          other.uuid == this.uuid &&
          other.transactionId == this.transactionId &&
          other.budgetId == this.budgetId &&
          other.amount == this.amount &&
          other.isDeleted == this.isDeleted &&
          other.payeeName == this.payeeName &&
          other.payeeId == this.payeeId &&
          other.categoryId == this.categoryId &&
          other.categoryName == this.categoryName &&
          other.memo == this.memo &&
          other.transferAccountId == this.transferAccountId &&
          other.transferTransactionId == this.transferTransactionId);
}

class DbSubTransactionsCompanion extends UpdateCompanion<DbSubTransaction> {
  final Value<String> uuid;
  final Value<String> transactionId;
  final Value<String> budgetId;
  final Value<int> amount;
  final Value<bool> isDeleted;
  final Value<String?> payeeName;
  final Value<String?> payeeId;
  final Value<String?> categoryId;
  final Value<String?> categoryName;
  final Value<String?> memo;
  final Value<String?> transferAccountId;
  final Value<String?> transferTransactionId;
  final Value<int> rowid;
  const DbSubTransactionsCompanion({
    this.uuid = const Value.absent(),
    this.transactionId = const Value.absent(),
    this.budgetId = const Value.absent(),
    this.amount = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.payeeName = const Value.absent(),
    this.payeeId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.categoryName = const Value.absent(),
    this.memo = const Value.absent(),
    this.transferAccountId = const Value.absent(),
    this.transferTransactionId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DbSubTransactionsCompanion.insert({
    required String uuid,
    required String transactionId,
    required String budgetId,
    required int amount,
    required bool isDeleted,
    this.payeeName = const Value.absent(),
    this.payeeId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.categoryName = const Value.absent(),
    this.memo = const Value.absent(),
    this.transferAccountId = const Value.absent(),
    this.transferTransactionId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : uuid = Value(uuid),
       transactionId = Value(transactionId),
       budgetId = Value(budgetId),
       amount = Value(amount),
       isDeleted = Value(isDeleted);
  static Insertable<DbSubTransaction> custom({
    Expression<String>? uuid,
    Expression<String>? transactionId,
    Expression<String>? budgetId,
    Expression<int>? amount,
    Expression<bool>? isDeleted,
    Expression<String>? payeeName,
    Expression<String>? payeeId,
    Expression<String>? categoryId,
    Expression<String>? categoryName,
    Expression<String>? memo,
    Expression<String>? transferAccountId,
    Expression<String>? transferTransactionId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (uuid != null) 'uuid': uuid,
      if (transactionId != null) 'transaction_id': transactionId,
      if (budgetId != null) 'budget_id': budgetId,
      if (amount != null) 'amount': amount,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (payeeName != null) 'payee_name': payeeName,
      if (payeeId != null) 'payee_id': payeeId,
      if (categoryId != null) 'category_id': categoryId,
      if (categoryName != null) 'category_name': categoryName,
      if (memo != null) 'memo': memo,
      if (transferAccountId != null) 'transfer_account_id': transferAccountId,
      if (transferTransactionId != null) 'transfer_transaction_id': transferTransactionId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DbSubTransactionsCompanion copyWith({
    Value<String>? uuid,
    Value<String>? transactionId,
    Value<String>? budgetId,
    Value<int>? amount,
    Value<bool>? isDeleted,
    Value<String?>? payeeName,
    Value<String?>? payeeId,
    Value<String?>? categoryId,
    Value<String?>? categoryName,
    Value<String?>? memo,
    Value<String?>? transferAccountId,
    Value<String?>? transferTransactionId,
    Value<int>? rowid,
  }) {
    return DbSubTransactionsCompanion(
      uuid: uuid ?? this.uuid,
      transactionId: transactionId ?? this.transactionId,
      budgetId: budgetId ?? this.budgetId,
      amount: amount ?? this.amount,
      isDeleted: isDeleted ?? this.isDeleted,
      payeeName: payeeName ?? this.payeeName,
      payeeId: payeeId ?? this.payeeId,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      memo: memo ?? this.memo,
      transferAccountId: transferAccountId ?? this.transferAccountId,
      transferTransactionId: transferTransactionId ?? this.transferTransactionId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (transactionId.present) {
      map['transaction_id'] = Variable<String>(transactionId.value);
    }
    if (budgetId.present) {
      map['budget_id'] = Variable<String>(budgetId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (payeeName.present) {
      map['payee_name'] = Variable<String>(payeeName.value);
    }
    if (payeeId.present) {
      map['payee_id'] = Variable<String>(payeeId.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (categoryName.present) {
      map['category_name'] = Variable<String>(categoryName.value);
    }
    if (memo.present) {
      map['memo'] = Variable<String>(memo.value);
    }
    if (transferAccountId.present) {
      map['transfer_account_id'] = Variable<String>(transferAccountId.value);
    }
    if (transferTransactionId.present) {
      map['transfer_transaction_id'] = Variable<String>(transferTransactionId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DbSubTransactionsCompanion(')
          ..write('uuid: $uuid, ')
          ..write('transactionId: $transactionId, ')
          ..write('budgetId: $budgetId, ')
          ..write('amount: $amount, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('payeeName: $payeeName, ')
          ..write('payeeId: $payeeId, ')
          ..write('categoryId: $categoryId, ')
          ..write('categoryName: $categoryName, ')
          ..write('memo: $memo, ')
          ..write('transferAccountId: $transferAccountId, ')
          ..write('transferTransactionId: $transferTransactionId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DbScheduledTransactionsTable extends DbScheduledTransactions
    with TableInfo<$DbScheduledTransactionsTable, DbScheduledTransaction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DbScheduledTransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
    'uuid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _budgetIdMeta = const VerificationMeta('budgetId');
  @override
  late final GeneratedColumn<String> budgetId = GeneratedColumn<String>(
    'budget_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _frequencyMeta = const VerificationMeta('frequency');
  @override
  late final GeneratedColumn<String> frequency = GeneratedColumn<String>(
    'frequency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateFirstMeta = const VerificationMeta('dateFirst');
  @override
  late final GeneratedColumn<DateTime> dateFirst = GeneratedColumn<DateTime>(
    'date_first',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateNextMeta = const VerificationMeta('dateNext');
  @override
  late final GeneratedColumn<DateTime> dateNext = GeneratedColumn<DateTime>(
    'date_next',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta('accountId');
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountNameMeta = const VerificationMeta('accountName');
  @override
  late final GeneratedColumn<String> accountName = GeneratedColumn<String>(
    'account_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("is_deleted" IN (0, 1))'),
  );
  static const VerificationMeta _payeeNameMeta = const VerificationMeta('payeeName');
  @override
  late final GeneratedColumn<String> payeeName = GeneratedColumn<String>(
    'payee_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _payeeIdMeta = const VerificationMeta('payeeId');
  @override
  late final GeneratedColumn<String> payeeId = GeneratedColumn<String>(
    'payee_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryNameMeta = const VerificationMeta('categoryName');
  @override
  late final GeneratedColumn<String> categoryName = GeneratedColumn<String>(
    'category_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _memoMeta = const VerificationMeta('memo');
  @override
  late final GeneratedColumn<String> memo = GeneratedColumn<String>(
    'memo',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _transferAccountIdMeta = const VerificationMeta(
    'transferAccountId',
  );
  @override
  late final GeneratedColumn<String> transferAccountId = GeneratedColumn<String>(
    'transfer_account_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Flag?, String> flagColor = GeneratedColumn<String>(
    'flag_color',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  ).withConverter<Flag?>($DbScheduledTransactionsTable.$converterflagColorn);
  static const VerificationMeta _flagNameMeta = const VerificationMeta('flagName');
  @override
  late final GeneratedColumn<String> flagName = GeneratedColumn<String>(
    'flag_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    uuid,
    budgetId,
    amount,
    frequency,
    dateFirst,
    dateNext,
    accountId,
    accountName,
    isDeleted,
    payeeName,
    payeeId,
    categoryId,
    categoryName,
    memo,
    transferAccountId,
    flagColor,
    flagName,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'db_scheduled_transactions';
  @override
  VerificationContext validateIntegrity(
    Insertable<DbScheduledTransaction> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('uuid')) {
      context.handle(_uuidMeta, uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta));
    } else if (isInserting) {
      context.missing(_uuidMeta);
    }
    if (data.containsKey('budget_id')) {
      context.handle(
        _budgetIdMeta,
        budgetId.isAcceptableOrUnknown(data['budget_id']!, _budgetIdMeta),
      );
    } else if (isInserting) {
      context.missing(_budgetIdMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta, amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('frequency')) {
      context.handle(
        _frequencyMeta,
        frequency.isAcceptableOrUnknown(data['frequency']!, _frequencyMeta),
      );
    } else if (isInserting) {
      context.missing(_frequencyMeta);
    }
    if (data.containsKey('date_first')) {
      context.handle(
        _dateFirstMeta,
        dateFirst.isAcceptableOrUnknown(data['date_first']!, _dateFirstMeta),
      );
    } else if (isInserting) {
      context.missing(_dateFirstMeta);
    }
    if (data.containsKey('date_next')) {
      context.handle(
        _dateNextMeta,
        dateNext.isAcceptableOrUnknown(data['date_next']!, _dateNextMeta),
      );
    } else if (isInserting) {
      context.missing(_dateNextMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('account_name')) {
      context.handle(
        _accountNameMeta,
        accountName.isAcceptableOrUnknown(data['account_name']!, _accountNameMeta),
      );
    } else if (isInserting) {
      context.missing(_accountNameMeta);
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    } else if (isInserting) {
      context.missing(_isDeletedMeta);
    }
    if (data.containsKey('payee_name')) {
      context.handle(
        _payeeNameMeta,
        payeeName.isAcceptableOrUnknown(data['payee_name']!, _payeeNameMeta),
      );
    }
    if (data.containsKey('payee_id')) {
      context.handle(_payeeIdMeta, payeeId.isAcceptableOrUnknown(data['payee_id']!, _payeeIdMeta));
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('category_name')) {
      context.handle(
        _categoryNameMeta,
        categoryName.isAcceptableOrUnknown(data['category_name']!, _categoryNameMeta),
      );
    }
    if (data.containsKey('memo')) {
      context.handle(_memoMeta, memo.isAcceptableOrUnknown(data['memo']!, _memoMeta));
    }
    if (data.containsKey('transfer_account_id')) {
      context.handle(
        _transferAccountIdMeta,
        transferAccountId.isAcceptableOrUnknown(
          data['transfer_account_id']!,
          _transferAccountIdMeta,
        ),
      );
    }
    if (data.containsKey('flag_name')) {
      context.handle(
        _flagNameMeta,
        flagName.isAcceptableOrUnknown(data['flag_name']!, _flagNameMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {uuid};
  @override
  DbScheduledTransaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DbScheduledTransaction(
      uuid: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}uuid'])!,
      budgetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}budget_id'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount'],
      )!,
      frequency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}frequency'],
      )!,
      dateFirst: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date_first'],
      )!,
      dateNext: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date_next'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_id'],
      )!,
      accountName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_name'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
      payeeName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payee_name'],
      ),
      payeeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payee_id'],
      ),
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      ),
      categoryName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_name'],
      ),
      memo: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}memo']),
      transferAccountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}transfer_account_id'],
      ),
      flagColor: $DbScheduledTransactionsTable.$converterflagColorn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}flag_color'],
        ),
      ),
      flagName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}flag_name'],
      ),
    );
  }

  @override
  $DbScheduledTransactionsTable createAlias(String alias) {
    return $DbScheduledTransactionsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<Flag, String, String> $converterflagColor =
      const EnumNameConverter<Flag>(Flag.values);
  static JsonTypeConverter2<Flag?, String?, String?> $converterflagColorn =
      JsonTypeConverter2.asNullable($converterflagColor);
}

class DbScheduledTransaction extends DataClass implements Insertable<DbScheduledTransaction> {
  final String uuid;
  final String budgetId;
  final int amount;
  final String frequency;
  final DateTime dateFirst;
  final DateTime dateNext;
  final String accountId;
  final String accountName;
  final bool isDeleted;
  final String? payeeName;
  final String? payeeId;
  final String? categoryId;
  final String? categoryName;
  final String? memo;
  final String? transferAccountId;
  final Flag? flagColor;
  final String? flagName;
  const DbScheduledTransaction({
    required this.uuid,
    required this.budgetId,
    required this.amount,
    required this.frequency,
    required this.dateFirst,
    required this.dateNext,
    required this.accountId,
    required this.accountName,
    required this.isDeleted,
    this.payeeName,
    this.payeeId,
    this.categoryId,
    this.categoryName,
    this.memo,
    this.transferAccountId,
    this.flagColor,
    this.flagName,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['uuid'] = Variable<String>(uuid);
    map['budget_id'] = Variable<String>(budgetId);
    map['amount'] = Variable<int>(amount);
    map['frequency'] = Variable<String>(frequency);
    map['date_first'] = Variable<DateTime>(dateFirst);
    map['date_next'] = Variable<DateTime>(dateNext);
    map['account_id'] = Variable<String>(accountId);
    map['account_name'] = Variable<String>(accountName);
    map['is_deleted'] = Variable<bool>(isDeleted);
    if (!nullToAbsent || payeeName != null) {
      map['payee_name'] = Variable<String>(payeeName);
    }
    if (!nullToAbsent || payeeId != null) {
      map['payee_id'] = Variable<String>(payeeId);
    }
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<String>(categoryId);
    }
    if (!nullToAbsent || categoryName != null) {
      map['category_name'] = Variable<String>(categoryName);
    }
    if (!nullToAbsent || memo != null) {
      map['memo'] = Variable<String>(memo);
    }
    if (!nullToAbsent || transferAccountId != null) {
      map['transfer_account_id'] = Variable<String>(transferAccountId);
    }
    if (!nullToAbsent || flagColor != null) {
      map['flag_color'] = Variable<String>(
        $DbScheduledTransactionsTable.$converterflagColorn.toSql(flagColor),
      );
    }
    if (!nullToAbsent || flagName != null) {
      map['flag_name'] = Variable<String>(flagName);
    }
    return map;
  }

  DbScheduledTransactionsCompanion toCompanion(bool nullToAbsent) {
    return DbScheduledTransactionsCompanion(
      uuid: Value(uuid),
      budgetId: Value(budgetId),
      amount: Value(amount),
      frequency: Value(frequency),
      dateFirst: Value(dateFirst),
      dateNext: Value(dateNext),
      accountId: Value(accountId),
      accountName: Value(accountName),
      isDeleted: Value(isDeleted),
      payeeName: payeeName == null && nullToAbsent ? const Value.absent() : Value(payeeName),
      payeeId: payeeId == null && nullToAbsent ? const Value.absent() : Value(payeeId),
      categoryId: categoryId == null && nullToAbsent ? const Value.absent() : Value(categoryId),
      categoryName: categoryName == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryName),
      memo: memo == null && nullToAbsent ? const Value.absent() : Value(memo),
      transferAccountId: transferAccountId == null && nullToAbsent
          ? const Value.absent()
          : Value(transferAccountId),
      flagColor: flagColor == null && nullToAbsent ? const Value.absent() : Value(flagColor),
      flagName: flagName == null && nullToAbsent ? const Value.absent() : Value(flagName),
    );
  }

  factory DbScheduledTransaction.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DbScheduledTransaction(
      uuid: serializer.fromJson<String>(json['uuid']),
      budgetId: serializer.fromJson<String>(json['budgetId']),
      amount: serializer.fromJson<int>(json['amount']),
      frequency: serializer.fromJson<String>(json['frequency']),
      dateFirst: serializer.fromJson<DateTime>(json['dateFirst']),
      dateNext: serializer.fromJson<DateTime>(json['dateNext']),
      accountId: serializer.fromJson<String>(json['accountId']),
      accountName: serializer.fromJson<String>(json['accountName']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      payeeName: serializer.fromJson<String?>(json['payeeName']),
      payeeId: serializer.fromJson<String?>(json['payeeId']),
      categoryId: serializer.fromJson<String?>(json['categoryId']),
      categoryName: serializer.fromJson<String?>(json['categoryName']),
      memo: serializer.fromJson<String?>(json['memo']),
      transferAccountId: serializer.fromJson<String?>(json['transferAccountId']),
      flagColor: $DbScheduledTransactionsTable.$converterflagColorn.fromJson(
        serializer.fromJson<String?>(json['flagColor']),
      ),
      flagName: serializer.fromJson<String?>(json['flagName']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'uuid': serializer.toJson<String>(uuid),
      'budgetId': serializer.toJson<String>(budgetId),
      'amount': serializer.toJson<int>(amount),
      'frequency': serializer.toJson<String>(frequency),
      'dateFirst': serializer.toJson<DateTime>(dateFirst),
      'dateNext': serializer.toJson<DateTime>(dateNext),
      'accountId': serializer.toJson<String>(accountId),
      'accountName': serializer.toJson<String>(accountName),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'payeeName': serializer.toJson<String?>(payeeName),
      'payeeId': serializer.toJson<String?>(payeeId),
      'categoryId': serializer.toJson<String?>(categoryId),
      'categoryName': serializer.toJson<String?>(categoryName),
      'memo': serializer.toJson<String?>(memo),
      'transferAccountId': serializer.toJson<String?>(transferAccountId),
      'flagColor': serializer.toJson<String?>(
        $DbScheduledTransactionsTable.$converterflagColorn.toJson(flagColor),
      ),
      'flagName': serializer.toJson<String?>(flagName),
    };
  }

  DbScheduledTransaction copyWith({
    String? uuid,
    String? budgetId,
    int? amount,
    String? frequency,
    DateTime? dateFirst,
    DateTime? dateNext,
    String? accountId,
    String? accountName,
    bool? isDeleted,
    Value<String?> payeeName = const Value.absent(),
    Value<String?> payeeId = const Value.absent(),
    Value<String?> categoryId = const Value.absent(),
    Value<String?> categoryName = const Value.absent(),
    Value<String?> memo = const Value.absent(),
    Value<String?> transferAccountId = const Value.absent(),
    Value<Flag?> flagColor = const Value.absent(),
    Value<String?> flagName = const Value.absent(),
  }) => DbScheduledTransaction(
    uuid: uuid ?? this.uuid,
    budgetId: budgetId ?? this.budgetId,
    amount: amount ?? this.amount,
    frequency: frequency ?? this.frequency,
    dateFirst: dateFirst ?? this.dateFirst,
    dateNext: dateNext ?? this.dateNext,
    accountId: accountId ?? this.accountId,
    accountName: accountName ?? this.accountName,
    isDeleted: isDeleted ?? this.isDeleted,
    payeeName: payeeName.present ? payeeName.value : this.payeeName,
    payeeId: payeeId.present ? payeeId.value : this.payeeId,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    categoryName: categoryName.present ? categoryName.value : this.categoryName,
    memo: memo.present ? memo.value : this.memo,
    transferAccountId: transferAccountId.present ? transferAccountId.value : this.transferAccountId,
    flagColor: flagColor.present ? flagColor.value : this.flagColor,
    flagName: flagName.present ? flagName.value : this.flagName,
  );
  DbScheduledTransaction copyWithCompanion(DbScheduledTransactionsCompanion data) {
    return DbScheduledTransaction(
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      budgetId: data.budgetId.present ? data.budgetId.value : this.budgetId,
      amount: data.amount.present ? data.amount.value : this.amount,
      frequency: data.frequency.present ? data.frequency.value : this.frequency,
      dateFirst: data.dateFirst.present ? data.dateFirst.value : this.dateFirst,
      dateNext: data.dateNext.present ? data.dateNext.value : this.dateNext,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      accountName: data.accountName.present ? data.accountName.value : this.accountName,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      payeeName: data.payeeName.present ? data.payeeName.value : this.payeeName,
      payeeId: data.payeeId.present ? data.payeeId.value : this.payeeId,
      categoryId: data.categoryId.present ? data.categoryId.value : this.categoryId,
      categoryName: data.categoryName.present ? data.categoryName.value : this.categoryName,
      memo: data.memo.present ? data.memo.value : this.memo,
      transferAccountId: data.transferAccountId.present
          ? data.transferAccountId.value
          : this.transferAccountId,
      flagColor: data.flagColor.present ? data.flagColor.value : this.flagColor,
      flagName: data.flagName.present ? data.flagName.value : this.flagName,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DbScheduledTransaction(')
          ..write('uuid: $uuid, ')
          ..write('budgetId: $budgetId, ')
          ..write('amount: $amount, ')
          ..write('frequency: $frequency, ')
          ..write('dateFirst: $dateFirst, ')
          ..write('dateNext: $dateNext, ')
          ..write('accountId: $accountId, ')
          ..write('accountName: $accountName, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('payeeName: $payeeName, ')
          ..write('payeeId: $payeeId, ')
          ..write('categoryId: $categoryId, ')
          ..write('categoryName: $categoryName, ')
          ..write('memo: $memo, ')
          ..write('transferAccountId: $transferAccountId, ')
          ..write('flagColor: $flagColor, ')
          ..write('flagName: $flagName')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    uuid,
    budgetId,
    amount,
    frequency,
    dateFirst,
    dateNext,
    accountId,
    accountName,
    isDeleted,
    payeeName,
    payeeId,
    categoryId,
    categoryName,
    memo,
    transferAccountId,
    flagColor,
    flagName,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DbScheduledTransaction &&
          other.uuid == this.uuid &&
          other.budgetId == this.budgetId &&
          other.amount == this.amount &&
          other.frequency == this.frequency &&
          other.dateFirst == this.dateFirst &&
          other.dateNext == this.dateNext &&
          other.accountId == this.accountId &&
          other.accountName == this.accountName &&
          other.isDeleted == this.isDeleted &&
          other.payeeName == this.payeeName &&
          other.payeeId == this.payeeId &&
          other.categoryId == this.categoryId &&
          other.categoryName == this.categoryName &&
          other.memo == this.memo &&
          other.transferAccountId == this.transferAccountId &&
          other.flagColor == this.flagColor &&
          other.flagName == this.flagName);
}

class DbScheduledTransactionsCompanion extends UpdateCompanion<DbScheduledTransaction> {
  final Value<String> uuid;
  final Value<String> budgetId;
  final Value<int> amount;
  final Value<String> frequency;
  final Value<DateTime> dateFirst;
  final Value<DateTime> dateNext;
  final Value<String> accountId;
  final Value<String> accountName;
  final Value<bool> isDeleted;
  final Value<String?> payeeName;
  final Value<String?> payeeId;
  final Value<String?> categoryId;
  final Value<String?> categoryName;
  final Value<String?> memo;
  final Value<String?> transferAccountId;
  final Value<Flag?> flagColor;
  final Value<String?> flagName;
  final Value<int> rowid;
  const DbScheduledTransactionsCompanion({
    this.uuid = const Value.absent(),
    this.budgetId = const Value.absent(),
    this.amount = const Value.absent(),
    this.frequency = const Value.absent(),
    this.dateFirst = const Value.absent(),
    this.dateNext = const Value.absent(),
    this.accountId = const Value.absent(),
    this.accountName = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.payeeName = const Value.absent(),
    this.payeeId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.categoryName = const Value.absent(),
    this.memo = const Value.absent(),
    this.transferAccountId = const Value.absent(),
    this.flagColor = const Value.absent(),
    this.flagName = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DbScheduledTransactionsCompanion.insert({
    required String uuid,
    required String budgetId,
    required int amount,
    required String frequency,
    required DateTime dateFirst,
    required DateTime dateNext,
    required String accountId,
    required String accountName,
    required bool isDeleted,
    this.payeeName = const Value.absent(),
    this.payeeId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.categoryName = const Value.absent(),
    this.memo = const Value.absent(),
    this.transferAccountId = const Value.absent(),
    this.flagColor = const Value.absent(),
    this.flagName = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : uuid = Value(uuid),
       budgetId = Value(budgetId),
       amount = Value(amount),
       frequency = Value(frequency),
       dateFirst = Value(dateFirst),
       dateNext = Value(dateNext),
       accountId = Value(accountId),
       accountName = Value(accountName),
       isDeleted = Value(isDeleted);
  static Insertable<DbScheduledTransaction> custom({
    Expression<String>? uuid,
    Expression<String>? budgetId,
    Expression<int>? amount,
    Expression<String>? frequency,
    Expression<DateTime>? dateFirst,
    Expression<DateTime>? dateNext,
    Expression<String>? accountId,
    Expression<String>? accountName,
    Expression<bool>? isDeleted,
    Expression<String>? payeeName,
    Expression<String>? payeeId,
    Expression<String>? categoryId,
    Expression<String>? categoryName,
    Expression<String>? memo,
    Expression<String>? transferAccountId,
    Expression<String>? flagColor,
    Expression<String>? flagName,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (uuid != null) 'uuid': uuid,
      if (budgetId != null) 'budget_id': budgetId,
      if (amount != null) 'amount': amount,
      if (frequency != null) 'frequency': frequency,
      if (dateFirst != null) 'date_first': dateFirst,
      if (dateNext != null) 'date_next': dateNext,
      if (accountId != null) 'account_id': accountId,
      if (accountName != null) 'account_name': accountName,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (payeeName != null) 'payee_name': payeeName,
      if (payeeId != null) 'payee_id': payeeId,
      if (categoryId != null) 'category_id': categoryId,
      if (categoryName != null) 'category_name': categoryName,
      if (memo != null) 'memo': memo,
      if (transferAccountId != null) 'transfer_account_id': transferAccountId,
      if (flagColor != null) 'flag_color': flagColor,
      if (flagName != null) 'flag_name': flagName,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DbScheduledTransactionsCompanion copyWith({
    Value<String>? uuid,
    Value<String>? budgetId,
    Value<int>? amount,
    Value<String>? frequency,
    Value<DateTime>? dateFirst,
    Value<DateTime>? dateNext,
    Value<String>? accountId,
    Value<String>? accountName,
    Value<bool>? isDeleted,
    Value<String?>? payeeName,
    Value<String?>? payeeId,
    Value<String?>? categoryId,
    Value<String?>? categoryName,
    Value<String?>? memo,
    Value<String?>? transferAccountId,
    Value<Flag?>? flagColor,
    Value<String?>? flagName,
    Value<int>? rowid,
  }) {
    return DbScheduledTransactionsCompanion(
      uuid: uuid ?? this.uuid,
      budgetId: budgetId ?? this.budgetId,
      amount: amount ?? this.amount,
      frequency: frequency ?? this.frequency,
      dateFirst: dateFirst ?? this.dateFirst,
      dateNext: dateNext ?? this.dateNext,
      accountId: accountId ?? this.accountId,
      accountName: accountName ?? this.accountName,
      isDeleted: isDeleted ?? this.isDeleted,
      payeeName: payeeName ?? this.payeeName,
      payeeId: payeeId ?? this.payeeId,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      memo: memo ?? this.memo,
      transferAccountId: transferAccountId ?? this.transferAccountId,
      flagColor: flagColor ?? this.flagColor,
      flagName: flagName ?? this.flagName,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (budgetId.present) {
      map['budget_id'] = Variable<String>(budgetId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (frequency.present) {
      map['frequency'] = Variable<String>(frequency.value);
    }
    if (dateFirst.present) {
      map['date_first'] = Variable<DateTime>(dateFirst.value);
    }
    if (dateNext.present) {
      map['date_next'] = Variable<DateTime>(dateNext.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (accountName.present) {
      map['account_name'] = Variable<String>(accountName.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (payeeName.present) {
      map['payee_name'] = Variable<String>(payeeName.value);
    }
    if (payeeId.present) {
      map['payee_id'] = Variable<String>(payeeId.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (categoryName.present) {
      map['category_name'] = Variable<String>(categoryName.value);
    }
    if (memo.present) {
      map['memo'] = Variable<String>(memo.value);
    }
    if (transferAccountId.present) {
      map['transfer_account_id'] = Variable<String>(transferAccountId.value);
    }
    if (flagColor.present) {
      map['flag_color'] = Variable<String>(
        $DbScheduledTransactionsTable.$converterflagColorn.toSql(flagColor.value),
      );
    }
    if (flagName.present) {
      map['flag_name'] = Variable<String>(flagName.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DbScheduledTransactionsCompanion(')
          ..write('uuid: $uuid, ')
          ..write('budgetId: $budgetId, ')
          ..write('amount: $amount, ')
          ..write('frequency: $frequency, ')
          ..write('dateFirst: $dateFirst, ')
          ..write('dateNext: $dateNext, ')
          ..write('accountId: $accountId, ')
          ..write('accountName: $accountName, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('payeeName: $payeeName, ')
          ..write('payeeId: $payeeId, ')
          ..write('categoryId: $categoryId, ')
          ..write('categoryName: $categoryName, ')
          ..write('memo: $memo, ')
          ..write('transferAccountId: $transferAccountId, ')
          ..write('flagColor: $flagColor, ')
          ..write('flagName: $flagName, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DbScheduledSubTransactionsTable extends DbScheduledSubTransactions
    with TableInfo<$DbScheduledSubTransactionsTable, DbScheduledSubTransaction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DbScheduledSubTransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
    'uuid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scheduledTransactionIdMeta = const VerificationMeta(
    'scheduledTransactionId',
  );
  @override
  late final GeneratedColumn<String> scheduledTransactionId = GeneratedColumn<String>(
    'scheduled_transaction_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _budgetIdMeta = const VerificationMeta('budgetId');
  @override
  late final GeneratedColumn<String> budgetId = GeneratedColumn<String>(
    'budget_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("is_deleted" IN (0, 1))'),
  );
  static const VerificationMeta _payeeIdMeta = const VerificationMeta('payeeId');
  @override
  late final GeneratedColumn<String> payeeId = GeneratedColumn<String>(
    'payee_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _memoMeta = const VerificationMeta('memo');
  @override
  late final GeneratedColumn<String> memo = GeneratedColumn<String>(
    'memo',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _transferAccountIdMeta = const VerificationMeta(
    'transferAccountId',
  );
  @override
  late final GeneratedColumn<String> transferAccountId = GeneratedColumn<String>(
    'transfer_account_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    uuid,
    scheduledTransactionId,
    budgetId,
    amount,
    isDeleted,
    payeeId,
    categoryId,
    memo,
    transferAccountId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'db_scheduled_sub_transactions';
  @override
  VerificationContext validateIntegrity(
    Insertable<DbScheduledSubTransaction> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('uuid')) {
      context.handle(_uuidMeta, uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta));
    } else if (isInserting) {
      context.missing(_uuidMeta);
    }
    if (data.containsKey('scheduled_transaction_id')) {
      context.handle(
        _scheduledTransactionIdMeta,
        scheduledTransactionId.isAcceptableOrUnknown(
          data['scheduled_transaction_id']!,
          _scheduledTransactionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_scheduledTransactionIdMeta);
    }
    if (data.containsKey('budget_id')) {
      context.handle(
        _budgetIdMeta,
        budgetId.isAcceptableOrUnknown(data['budget_id']!, _budgetIdMeta),
      );
    } else if (isInserting) {
      context.missing(_budgetIdMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta, amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    } else if (isInserting) {
      context.missing(_isDeletedMeta);
    }
    if (data.containsKey('payee_id')) {
      context.handle(_payeeIdMeta, payeeId.isAcceptableOrUnknown(data['payee_id']!, _payeeIdMeta));
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('memo')) {
      context.handle(_memoMeta, memo.isAcceptableOrUnknown(data['memo']!, _memoMeta));
    }
    if (data.containsKey('transfer_account_id')) {
      context.handle(
        _transferAccountIdMeta,
        transferAccountId.isAcceptableOrUnknown(
          data['transfer_account_id']!,
          _transferAccountIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {uuid};
  @override
  DbScheduledSubTransaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DbScheduledSubTransaction(
      uuid: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}uuid'])!,
      scheduledTransactionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}scheduled_transaction_id'],
      )!,
      budgetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}budget_id'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
      payeeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payee_id'],
      ),
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      ),
      memo: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}memo']),
      transferAccountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}transfer_account_id'],
      ),
    );
  }

  @override
  $DbScheduledSubTransactionsTable createAlias(String alias) {
    return $DbScheduledSubTransactionsTable(attachedDatabase, alias);
  }
}

class DbScheduledSubTransaction extends DataClass implements Insertable<DbScheduledSubTransaction> {
  final String uuid;
  final String scheduledTransactionId;
  final String budgetId;
  final int amount;
  final bool isDeleted;
  final String? payeeId;
  final String? categoryId;
  final String? memo;
  final String? transferAccountId;
  const DbScheduledSubTransaction({
    required this.uuid,
    required this.scheduledTransactionId,
    required this.budgetId,
    required this.amount,
    required this.isDeleted,
    this.payeeId,
    this.categoryId,
    this.memo,
    this.transferAccountId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['uuid'] = Variable<String>(uuid);
    map['scheduled_transaction_id'] = Variable<String>(scheduledTransactionId);
    map['budget_id'] = Variable<String>(budgetId);
    map['amount'] = Variable<int>(amount);
    map['is_deleted'] = Variable<bool>(isDeleted);
    if (!nullToAbsent || payeeId != null) {
      map['payee_id'] = Variable<String>(payeeId);
    }
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<String>(categoryId);
    }
    if (!nullToAbsent || memo != null) {
      map['memo'] = Variable<String>(memo);
    }
    if (!nullToAbsent || transferAccountId != null) {
      map['transfer_account_id'] = Variable<String>(transferAccountId);
    }
    return map;
  }

  DbScheduledSubTransactionsCompanion toCompanion(bool nullToAbsent) {
    return DbScheduledSubTransactionsCompanion(
      uuid: Value(uuid),
      scheduledTransactionId: Value(scheduledTransactionId),
      budgetId: Value(budgetId),
      amount: Value(amount),
      isDeleted: Value(isDeleted),
      payeeId: payeeId == null && nullToAbsent ? const Value.absent() : Value(payeeId),
      categoryId: categoryId == null && nullToAbsent ? const Value.absent() : Value(categoryId),
      memo: memo == null && nullToAbsent ? const Value.absent() : Value(memo),
      transferAccountId: transferAccountId == null && nullToAbsent
          ? const Value.absent()
          : Value(transferAccountId),
    );
  }

  factory DbScheduledSubTransaction.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DbScheduledSubTransaction(
      uuid: serializer.fromJson<String>(json['uuid']),
      scheduledTransactionId: serializer.fromJson<String>(json['scheduledTransactionId']),
      budgetId: serializer.fromJson<String>(json['budgetId']),
      amount: serializer.fromJson<int>(json['amount']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      payeeId: serializer.fromJson<String?>(json['payeeId']),
      categoryId: serializer.fromJson<String?>(json['categoryId']),
      memo: serializer.fromJson<String?>(json['memo']),
      transferAccountId: serializer.fromJson<String?>(json['transferAccountId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'uuid': serializer.toJson<String>(uuid),
      'scheduledTransactionId': serializer.toJson<String>(scheduledTransactionId),
      'budgetId': serializer.toJson<String>(budgetId),
      'amount': serializer.toJson<int>(amount),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'payeeId': serializer.toJson<String?>(payeeId),
      'categoryId': serializer.toJson<String?>(categoryId),
      'memo': serializer.toJson<String?>(memo),
      'transferAccountId': serializer.toJson<String?>(transferAccountId),
    };
  }

  DbScheduledSubTransaction copyWith({
    String? uuid,
    String? scheduledTransactionId,
    String? budgetId,
    int? amount,
    bool? isDeleted,
    Value<String?> payeeId = const Value.absent(),
    Value<String?> categoryId = const Value.absent(),
    Value<String?> memo = const Value.absent(),
    Value<String?> transferAccountId = const Value.absent(),
  }) => DbScheduledSubTransaction(
    uuid: uuid ?? this.uuid,
    scheduledTransactionId: scheduledTransactionId ?? this.scheduledTransactionId,
    budgetId: budgetId ?? this.budgetId,
    amount: amount ?? this.amount,
    isDeleted: isDeleted ?? this.isDeleted,
    payeeId: payeeId.present ? payeeId.value : this.payeeId,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    memo: memo.present ? memo.value : this.memo,
    transferAccountId: transferAccountId.present ? transferAccountId.value : this.transferAccountId,
  );
  DbScheduledSubTransaction copyWithCompanion(DbScheduledSubTransactionsCompanion data) {
    return DbScheduledSubTransaction(
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      scheduledTransactionId: data.scheduledTransactionId.present
          ? data.scheduledTransactionId.value
          : this.scheduledTransactionId,
      budgetId: data.budgetId.present ? data.budgetId.value : this.budgetId,
      amount: data.amount.present ? data.amount.value : this.amount,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      payeeId: data.payeeId.present ? data.payeeId.value : this.payeeId,
      categoryId: data.categoryId.present ? data.categoryId.value : this.categoryId,
      memo: data.memo.present ? data.memo.value : this.memo,
      transferAccountId: data.transferAccountId.present
          ? data.transferAccountId.value
          : this.transferAccountId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DbScheduledSubTransaction(')
          ..write('uuid: $uuid, ')
          ..write('scheduledTransactionId: $scheduledTransactionId, ')
          ..write('budgetId: $budgetId, ')
          ..write('amount: $amount, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('payeeId: $payeeId, ')
          ..write('categoryId: $categoryId, ')
          ..write('memo: $memo, ')
          ..write('transferAccountId: $transferAccountId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    uuid,
    scheduledTransactionId,
    budgetId,
    amount,
    isDeleted,
    payeeId,
    categoryId,
    memo,
    transferAccountId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DbScheduledSubTransaction &&
          other.uuid == this.uuid &&
          other.scheduledTransactionId == this.scheduledTransactionId &&
          other.budgetId == this.budgetId &&
          other.amount == this.amount &&
          other.isDeleted == this.isDeleted &&
          other.payeeId == this.payeeId &&
          other.categoryId == this.categoryId &&
          other.memo == this.memo &&
          other.transferAccountId == this.transferAccountId);
}

class DbScheduledSubTransactionsCompanion extends UpdateCompanion<DbScheduledSubTransaction> {
  final Value<String> uuid;
  final Value<String> scheduledTransactionId;
  final Value<String> budgetId;
  final Value<int> amount;
  final Value<bool> isDeleted;
  final Value<String?> payeeId;
  final Value<String?> categoryId;
  final Value<String?> memo;
  final Value<String?> transferAccountId;
  final Value<int> rowid;
  const DbScheduledSubTransactionsCompanion({
    this.uuid = const Value.absent(),
    this.scheduledTransactionId = const Value.absent(),
    this.budgetId = const Value.absent(),
    this.amount = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.payeeId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.memo = const Value.absent(),
    this.transferAccountId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DbScheduledSubTransactionsCompanion.insert({
    required String uuid,
    required String scheduledTransactionId,
    required String budgetId,
    required int amount,
    required bool isDeleted,
    this.payeeId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.memo = const Value.absent(),
    this.transferAccountId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : uuid = Value(uuid),
       scheduledTransactionId = Value(scheduledTransactionId),
       budgetId = Value(budgetId),
       amount = Value(amount),
       isDeleted = Value(isDeleted);
  static Insertable<DbScheduledSubTransaction> custom({
    Expression<String>? uuid,
    Expression<String>? scheduledTransactionId,
    Expression<String>? budgetId,
    Expression<int>? amount,
    Expression<bool>? isDeleted,
    Expression<String>? payeeId,
    Expression<String>? categoryId,
    Expression<String>? memo,
    Expression<String>? transferAccountId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (uuid != null) 'uuid': uuid,
      if (scheduledTransactionId != null) 'scheduled_transaction_id': scheduledTransactionId,
      if (budgetId != null) 'budget_id': budgetId,
      if (amount != null) 'amount': amount,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (payeeId != null) 'payee_id': payeeId,
      if (categoryId != null) 'category_id': categoryId,
      if (memo != null) 'memo': memo,
      if (transferAccountId != null) 'transfer_account_id': transferAccountId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DbScheduledSubTransactionsCompanion copyWith({
    Value<String>? uuid,
    Value<String>? scheduledTransactionId,
    Value<String>? budgetId,
    Value<int>? amount,
    Value<bool>? isDeleted,
    Value<String?>? payeeId,
    Value<String?>? categoryId,
    Value<String?>? memo,
    Value<String?>? transferAccountId,
    Value<int>? rowid,
  }) {
    return DbScheduledSubTransactionsCompanion(
      uuid: uuid ?? this.uuid,
      scheduledTransactionId: scheduledTransactionId ?? this.scheduledTransactionId,
      budgetId: budgetId ?? this.budgetId,
      amount: amount ?? this.amount,
      isDeleted: isDeleted ?? this.isDeleted,
      payeeId: payeeId ?? this.payeeId,
      categoryId: categoryId ?? this.categoryId,
      memo: memo ?? this.memo,
      transferAccountId: transferAccountId ?? this.transferAccountId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (scheduledTransactionId.present) {
      map['scheduled_transaction_id'] = Variable<String>(scheduledTransactionId.value);
    }
    if (budgetId.present) {
      map['budget_id'] = Variable<String>(budgetId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (payeeId.present) {
      map['payee_id'] = Variable<String>(payeeId.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (memo.present) {
      map['memo'] = Variable<String>(memo.value);
    }
    if (transferAccountId.present) {
      map['transfer_account_id'] = Variable<String>(transferAccountId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DbScheduledSubTransactionsCompanion(')
          ..write('uuid: $uuid, ')
          ..write('scheduledTransactionId: $scheduledTransactionId, ')
          ..write('budgetId: $budgetId, ')
          ..write('amount: $amount, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('payeeId: $payeeId, ')
          ..write('categoryId: $categoryId, ')
          ..write('memo: $memo, ')
          ..write('transferAccountId: $transferAccountId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DbMonthsTable extends DbMonths with TableInfo<$DbMonthsTable, DbMonth> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DbMonthsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _budgetIdMeta = const VerificationMeta('budgetId');
  @override
  late final GeneratedColumn<String> budgetId = GeneratedColumn<String>(
    'budget_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _monthMeta = const VerificationMeta('month');
  @override
  late final GeneratedColumn<String> month = GeneratedColumn<String>(
    'month',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _incomeMeta = const VerificationMeta('income');
  @override
  late final GeneratedColumn<int> income = GeneratedColumn<int>(
    'income',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _budgetedMeta = const VerificationMeta('budgeted');
  @override
  late final GeneratedColumn<int> budgeted = GeneratedColumn<int>(
    'budgeted',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _activityMeta = const VerificationMeta('activity');
  @override
  late final GeneratedColumn<int> activity = GeneratedColumn<int>(
    'activity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _toBeBudgetedMeta = const VerificationMeta('toBeBudgeted');
  @override
  late final GeneratedColumn<int> toBeBudgeted = GeneratedColumn<int>(
    'to_be_budgeted',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ageOfMoneyMeta = const VerificationMeta('ageOfMoney');
  @override
  late final GeneratedColumn<int> ageOfMoney = GeneratedColumn<int>(
    'age_of_money',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta('deleted');
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("deleted" IN (0, 1))'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    budgetId,
    month,
    note,
    income,
    budgeted,
    activity,
    toBeBudgeted,
    ageOfMoney,
    deleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'db_months';
  @override
  VerificationContext validateIntegrity(Insertable<DbMonth> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('budget_id')) {
      context.handle(
        _budgetIdMeta,
        budgetId.isAcceptableOrUnknown(data['budget_id']!, _budgetIdMeta),
      );
    } else if (isInserting) {
      context.missing(_budgetIdMeta);
    }
    if (data.containsKey('month')) {
      context.handle(_monthMeta, month.isAcceptableOrUnknown(data['month']!, _monthMeta));
    } else if (isInserting) {
      context.missing(_monthMeta);
    }
    if (data.containsKey('note')) {
      context.handle(_noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    if (data.containsKey('income')) {
      context.handle(_incomeMeta, income.isAcceptableOrUnknown(data['income']!, _incomeMeta));
    } else if (isInserting) {
      context.missing(_incomeMeta);
    }
    if (data.containsKey('budgeted')) {
      context.handle(
        _budgetedMeta,
        budgeted.isAcceptableOrUnknown(data['budgeted']!, _budgetedMeta),
      );
    } else if (isInserting) {
      context.missing(_budgetedMeta);
    }
    if (data.containsKey('activity')) {
      context.handle(
        _activityMeta,
        activity.isAcceptableOrUnknown(data['activity']!, _activityMeta),
      );
    } else if (isInserting) {
      context.missing(_activityMeta);
    }
    if (data.containsKey('to_be_budgeted')) {
      context.handle(
        _toBeBudgetedMeta,
        toBeBudgeted.isAcceptableOrUnknown(data['to_be_budgeted']!, _toBeBudgetedMeta),
      );
    } else if (isInserting) {
      context.missing(_toBeBudgetedMeta);
    }
    if (data.containsKey('age_of_money')) {
      context.handle(
        _ageOfMoneyMeta,
        ageOfMoney.isAcceptableOrUnknown(data['age_of_money']!, _ageOfMoneyMeta),
      );
    }
    if (data.containsKey('deleted')) {
      context.handle(_deletedMeta, deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta));
    } else if (isInserting) {
      context.missing(_deletedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {budgetId, month};
  @override
  DbMonth map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DbMonth(
      budgetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}budget_id'],
      )!,
      month: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}month'],
      )!,
      note: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}note']),
      income: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}income'],
      )!,
      budgeted: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}budgeted'],
      )!,
      activity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}activity'],
      )!,
      toBeBudgeted: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}to_be_budgeted'],
      )!,
      ageOfMoney: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}age_of_money'],
      ),
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
    );
  }

  @override
  $DbMonthsTable createAlias(String alias) {
    return $DbMonthsTable(attachedDatabase, alias);
  }
}

class DbMonth extends DataClass implements Insertable<DbMonth> {
  final String budgetId;
  final String month;
  final String? note;
  final int income;
  final int budgeted;
  final int activity;
  final int toBeBudgeted;
  final int? ageOfMoney;
  final bool deleted;
  const DbMonth({
    required this.budgetId,
    required this.month,
    this.note,
    required this.income,
    required this.budgeted,
    required this.activity,
    required this.toBeBudgeted,
    this.ageOfMoney,
    required this.deleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['budget_id'] = Variable<String>(budgetId);
    map['month'] = Variable<String>(month);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['income'] = Variable<int>(income);
    map['budgeted'] = Variable<int>(budgeted);
    map['activity'] = Variable<int>(activity);
    map['to_be_budgeted'] = Variable<int>(toBeBudgeted);
    if (!nullToAbsent || ageOfMoney != null) {
      map['age_of_money'] = Variable<int>(ageOfMoney);
    }
    map['deleted'] = Variable<bool>(deleted);
    return map;
  }

  DbMonthsCompanion toCompanion(bool nullToAbsent) {
    return DbMonthsCompanion(
      budgetId: Value(budgetId),
      month: Value(month),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      income: Value(income),
      budgeted: Value(budgeted),
      activity: Value(activity),
      toBeBudgeted: Value(toBeBudgeted),
      ageOfMoney: ageOfMoney == null && nullToAbsent ? const Value.absent() : Value(ageOfMoney),
      deleted: Value(deleted),
    );
  }

  factory DbMonth.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DbMonth(
      budgetId: serializer.fromJson<String>(json['budgetId']),
      month: serializer.fromJson<String>(json['month']),
      note: serializer.fromJson<String?>(json['note']),
      income: serializer.fromJson<int>(json['income']),
      budgeted: serializer.fromJson<int>(json['budgeted']),
      activity: serializer.fromJson<int>(json['activity']),
      toBeBudgeted: serializer.fromJson<int>(json['toBeBudgeted']),
      ageOfMoney: serializer.fromJson<int?>(json['ageOfMoney']),
      deleted: serializer.fromJson<bool>(json['deleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'budgetId': serializer.toJson<String>(budgetId),
      'month': serializer.toJson<String>(month),
      'note': serializer.toJson<String?>(note),
      'income': serializer.toJson<int>(income),
      'budgeted': serializer.toJson<int>(budgeted),
      'activity': serializer.toJson<int>(activity),
      'toBeBudgeted': serializer.toJson<int>(toBeBudgeted),
      'ageOfMoney': serializer.toJson<int?>(ageOfMoney),
      'deleted': serializer.toJson<bool>(deleted),
    };
  }

  DbMonth copyWith({
    String? budgetId,
    String? month,
    Value<String?> note = const Value.absent(),
    int? income,
    int? budgeted,
    int? activity,
    int? toBeBudgeted,
    Value<int?> ageOfMoney = const Value.absent(),
    bool? deleted,
  }) => DbMonth(
    budgetId: budgetId ?? this.budgetId,
    month: month ?? this.month,
    note: note.present ? note.value : this.note,
    income: income ?? this.income,
    budgeted: budgeted ?? this.budgeted,
    activity: activity ?? this.activity,
    toBeBudgeted: toBeBudgeted ?? this.toBeBudgeted,
    ageOfMoney: ageOfMoney.present ? ageOfMoney.value : this.ageOfMoney,
    deleted: deleted ?? this.deleted,
  );
  DbMonth copyWithCompanion(DbMonthsCompanion data) {
    return DbMonth(
      budgetId: data.budgetId.present ? data.budgetId.value : this.budgetId,
      month: data.month.present ? data.month.value : this.month,
      note: data.note.present ? data.note.value : this.note,
      income: data.income.present ? data.income.value : this.income,
      budgeted: data.budgeted.present ? data.budgeted.value : this.budgeted,
      activity: data.activity.present ? data.activity.value : this.activity,
      toBeBudgeted: data.toBeBudgeted.present ? data.toBeBudgeted.value : this.toBeBudgeted,
      ageOfMoney: data.ageOfMoney.present ? data.ageOfMoney.value : this.ageOfMoney,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DbMonth(')
          ..write('budgetId: $budgetId, ')
          ..write('month: $month, ')
          ..write('note: $note, ')
          ..write('income: $income, ')
          ..write('budgeted: $budgeted, ')
          ..write('activity: $activity, ')
          ..write('toBeBudgeted: $toBeBudgeted, ')
          ..write('ageOfMoney: $ageOfMoney, ')
          ..write('deleted: $deleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    budgetId,
    month,
    note,
    income,
    budgeted,
    activity,
    toBeBudgeted,
    ageOfMoney,
    deleted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DbMonth &&
          other.budgetId == this.budgetId &&
          other.month == this.month &&
          other.note == this.note &&
          other.income == this.income &&
          other.budgeted == this.budgeted &&
          other.activity == this.activity &&
          other.toBeBudgeted == this.toBeBudgeted &&
          other.ageOfMoney == this.ageOfMoney &&
          other.deleted == this.deleted);
}

class DbMonthsCompanion extends UpdateCompanion<DbMonth> {
  final Value<String> budgetId;
  final Value<String> month;
  final Value<String?> note;
  final Value<int> income;
  final Value<int> budgeted;
  final Value<int> activity;
  final Value<int> toBeBudgeted;
  final Value<int?> ageOfMoney;
  final Value<bool> deleted;
  final Value<int> rowid;
  const DbMonthsCompanion({
    this.budgetId = const Value.absent(),
    this.month = const Value.absent(),
    this.note = const Value.absent(),
    this.income = const Value.absent(),
    this.budgeted = const Value.absent(),
    this.activity = const Value.absent(),
    this.toBeBudgeted = const Value.absent(),
    this.ageOfMoney = const Value.absent(),
    this.deleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DbMonthsCompanion.insert({
    required String budgetId,
    required String month,
    this.note = const Value.absent(),
    required int income,
    required int budgeted,
    required int activity,
    required int toBeBudgeted,
    this.ageOfMoney = const Value.absent(),
    required bool deleted,
    this.rowid = const Value.absent(),
  }) : budgetId = Value(budgetId),
       month = Value(month),
       income = Value(income),
       budgeted = Value(budgeted),
       activity = Value(activity),
       toBeBudgeted = Value(toBeBudgeted),
       deleted = Value(deleted);
  static Insertable<DbMonth> custom({
    Expression<String>? budgetId,
    Expression<String>? month,
    Expression<String>? note,
    Expression<int>? income,
    Expression<int>? budgeted,
    Expression<int>? activity,
    Expression<int>? toBeBudgeted,
    Expression<int>? ageOfMoney,
    Expression<bool>? deleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (budgetId != null) 'budget_id': budgetId,
      if (month != null) 'month': month,
      if (note != null) 'note': note,
      if (income != null) 'income': income,
      if (budgeted != null) 'budgeted': budgeted,
      if (activity != null) 'activity': activity,
      if (toBeBudgeted != null) 'to_be_budgeted': toBeBudgeted,
      if (ageOfMoney != null) 'age_of_money': ageOfMoney,
      if (deleted != null) 'deleted': deleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DbMonthsCompanion copyWith({
    Value<String>? budgetId,
    Value<String>? month,
    Value<String?>? note,
    Value<int>? income,
    Value<int>? budgeted,
    Value<int>? activity,
    Value<int>? toBeBudgeted,
    Value<int?>? ageOfMoney,
    Value<bool>? deleted,
    Value<int>? rowid,
  }) {
    return DbMonthsCompanion(
      budgetId: budgetId ?? this.budgetId,
      month: month ?? this.month,
      note: note ?? this.note,
      income: income ?? this.income,
      budgeted: budgeted ?? this.budgeted,
      activity: activity ?? this.activity,
      toBeBudgeted: toBeBudgeted ?? this.toBeBudgeted,
      ageOfMoney: ageOfMoney ?? this.ageOfMoney,
      deleted: deleted ?? this.deleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (budgetId.present) {
      map['budget_id'] = Variable<String>(budgetId.value);
    }
    if (month.present) {
      map['month'] = Variable<String>(month.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (income.present) {
      map['income'] = Variable<int>(income.value);
    }
    if (budgeted.present) {
      map['budgeted'] = Variable<int>(budgeted.value);
    }
    if (activity.present) {
      map['activity'] = Variable<int>(activity.value);
    }
    if (toBeBudgeted.present) {
      map['to_be_budgeted'] = Variable<int>(toBeBudgeted.value);
    }
    if (ageOfMoney.present) {
      map['age_of_money'] = Variable<int>(ageOfMoney.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DbMonthsCompanion(')
          ..write('budgetId: $budgetId, ')
          ..write('month: $month, ')
          ..write('note: $note, ')
          ..write('income: $income, ')
          ..write('budgeted: $budgeted, ')
          ..write('activity: $activity, ')
          ..write('toBeBudgeted: $toBeBudgeted, ')
          ..write('ageOfMoney: $ageOfMoney, ')
          ..write('deleted: $deleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DbAccountKnowledgesTable extends DbAccountKnowledges
    with TableInfo<$DbAccountKnowledgesTable, DbAccountKnowledge> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DbAccountKnowledgesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _budgetIdMeta = const VerificationMeta('budgetId');
  @override
  late final GeneratedColumn<String> budgetId = GeneratedColumn<String>(
    'budget_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _knowledgeMeta = const VerificationMeta('knowledge');
  @override
  late final GeneratedColumn<int> knowledge = GeneratedColumn<int>(
    'knowledge',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [budgetId, knowledge];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'db_account_knowledges';
  @override
  VerificationContext validateIntegrity(
    Insertable<DbAccountKnowledge> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('budget_id')) {
      context.handle(
        _budgetIdMeta,
        budgetId.isAcceptableOrUnknown(data['budget_id']!, _budgetIdMeta),
      );
    } else if (isInserting) {
      context.missing(_budgetIdMeta);
    }
    if (data.containsKey('knowledge')) {
      context.handle(
        _knowledgeMeta,
        knowledge.isAcceptableOrUnknown(data['knowledge']!, _knowledgeMeta),
      );
    } else if (isInserting) {
      context.missing(_knowledgeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {budgetId};
  @override
  DbAccountKnowledge map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DbAccountKnowledge(
      budgetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}budget_id'],
      )!,
      knowledge: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}knowledge'],
      )!,
    );
  }

  @override
  $DbAccountKnowledgesTable createAlias(String alias) {
    return $DbAccountKnowledgesTable(attachedDatabase, alias);
  }
}

class DbAccountKnowledge extends DataClass implements Insertable<DbAccountKnowledge> {
  final String budgetId;
  final int knowledge;
  const DbAccountKnowledge({required this.budgetId, required this.knowledge});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['budget_id'] = Variable<String>(budgetId);
    map['knowledge'] = Variable<int>(knowledge);
    return map;
  }

  DbAccountKnowledgesCompanion toCompanion(bool nullToAbsent) {
    return DbAccountKnowledgesCompanion(budgetId: Value(budgetId), knowledge: Value(knowledge));
  }

  factory DbAccountKnowledge.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DbAccountKnowledge(
      budgetId: serializer.fromJson<String>(json['budgetId']),
      knowledge: serializer.fromJson<int>(json['knowledge']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'budgetId': serializer.toJson<String>(budgetId),
      'knowledge': serializer.toJson<int>(knowledge),
    };
  }

  DbAccountKnowledge copyWith({String? budgetId, int? knowledge}) => DbAccountKnowledge(
    budgetId: budgetId ?? this.budgetId,
    knowledge: knowledge ?? this.knowledge,
  );
  DbAccountKnowledge copyWithCompanion(DbAccountKnowledgesCompanion data) {
    return DbAccountKnowledge(
      budgetId: data.budgetId.present ? data.budgetId.value : this.budgetId,
      knowledge: data.knowledge.present ? data.knowledge.value : this.knowledge,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DbAccountKnowledge(')
          ..write('budgetId: $budgetId, ')
          ..write('knowledge: $knowledge')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(budgetId, knowledge);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DbAccountKnowledge &&
          other.budgetId == this.budgetId &&
          other.knowledge == this.knowledge);
}

class DbAccountKnowledgesCompanion extends UpdateCompanion<DbAccountKnowledge> {
  final Value<String> budgetId;
  final Value<int> knowledge;
  final Value<int> rowid;
  const DbAccountKnowledgesCompanion({
    this.budgetId = const Value.absent(),
    this.knowledge = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DbAccountKnowledgesCompanion.insert({
    required String budgetId,
    required int knowledge,
    this.rowid = const Value.absent(),
  }) : budgetId = Value(budgetId),
       knowledge = Value(knowledge);
  static Insertable<DbAccountKnowledge> custom({
    Expression<String>? budgetId,
    Expression<int>? knowledge,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (budgetId != null) 'budget_id': budgetId,
      if (knowledge != null) 'knowledge': knowledge,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DbAccountKnowledgesCompanion copyWith({
    Value<String>? budgetId,
    Value<int>? knowledge,
    Value<int>? rowid,
  }) {
    return DbAccountKnowledgesCompanion(
      budgetId: budgetId ?? this.budgetId,
      knowledge: knowledge ?? this.knowledge,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (budgetId.present) {
      map['budget_id'] = Variable<String>(budgetId.value);
    }
    if (knowledge.present) {
      map['knowledge'] = Variable<int>(knowledge.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DbAccountKnowledgesCompanion(')
          ..write('budgetId: $budgetId, ')
          ..write('knowledge: $knowledge, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DbCategoryKnowledgesTable extends DbCategoryKnowledges
    with TableInfo<$DbCategoryKnowledgesTable, DbCategoryKnowledge> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DbCategoryKnowledgesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _budgetIdMeta = const VerificationMeta('budgetId');
  @override
  late final GeneratedColumn<String> budgetId = GeneratedColumn<String>(
    'budget_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _knowledgeMeta = const VerificationMeta('knowledge');
  @override
  late final GeneratedColumn<int> knowledge = GeneratedColumn<int>(
    'knowledge',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _monthMeta = const VerificationMeta('month');
  @override
  late final GeneratedColumn<String> month = GeneratedColumn<String>(
    'month',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [budgetId, knowledge, month];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'db_category_knowledges';
  @override
  VerificationContext validateIntegrity(
    Insertable<DbCategoryKnowledge> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('budget_id')) {
      context.handle(
        _budgetIdMeta,
        budgetId.isAcceptableOrUnknown(data['budget_id']!, _budgetIdMeta),
      );
    } else if (isInserting) {
      context.missing(_budgetIdMeta);
    }
    if (data.containsKey('knowledge')) {
      context.handle(
        _knowledgeMeta,
        knowledge.isAcceptableOrUnknown(data['knowledge']!, _knowledgeMeta),
      );
    } else if (isInserting) {
      context.missing(_knowledgeMeta);
    }
    if (data.containsKey('month')) {
      context.handle(_monthMeta, month.isAcceptableOrUnknown(data['month']!, _monthMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {budgetId};
  @override
  DbCategoryKnowledge map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DbCategoryKnowledge(
      budgetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}budget_id'],
      )!,
      knowledge: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}knowledge'],
      )!,
      month: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}month'],
      ),
    );
  }

  @override
  $DbCategoryKnowledgesTable createAlias(String alias) {
    return $DbCategoryKnowledgesTable(attachedDatabase, alias);
  }
}

class DbCategoryKnowledge extends DataClass implements Insertable<DbCategoryKnowledge> {
  final String budgetId;
  final int knowledge;
  final String? month;
  const DbCategoryKnowledge({required this.budgetId, required this.knowledge, this.month});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['budget_id'] = Variable<String>(budgetId);
    map['knowledge'] = Variable<int>(knowledge);
    if (!nullToAbsent || month != null) {
      map['month'] = Variable<String>(month);
    }
    return map;
  }

  DbCategoryKnowledgesCompanion toCompanion(bool nullToAbsent) {
    return DbCategoryKnowledgesCompanion(
      budgetId: Value(budgetId),
      knowledge: Value(knowledge),
      month: month == null && nullToAbsent ? const Value.absent() : Value(month),
    );
  }

  factory DbCategoryKnowledge.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DbCategoryKnowledge(
      budgetId: serializer.fromJson<String>(json['budgetId']),
      knowledge: serializer.fromJson<int>(json['knowledge']),
      month: serializer.fromJson<String?>(json['month']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'budgetId': serializer.toJson<String>(budgetId),
      'knowledge': serializer.toJson<int>(knowledge),
      'month': serializer.toJson<String?>(month),
    };
  }

  DbCategoryKnowledge copyWith({
    String? budgetId,
    int? knowledge,
    Value<String?> month = const Value.absent(),
  }) => DbCategoryKnowledge(
    budgetId: budgetId ?? this.budgetId,
    knowledge: knowledge ?? this.knowledge,
    month: month.present ? month.value : this.month,
  );
  DbCategoryKnowledge copyWithCompanion(DbCategoryKnowledgesCompanion data) {
    return DbCategoryKnowledge(
      budgetId: data.budgetId.present ? data.budgetId.value : this.budgetId,
      knowledge: data.knowledge.present ? data.knowledge.value : this.knowledge,
      month: data.month.present ? data.month.value : this.month,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DbCategoryKnowledge(')
          ..write('budgetId: $budgetId, ')
          ..write('knowledge: $knowledge, ')
          ..write('month: $month')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(budgetId, knowledge, month);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DbCategoryKnowledge &&
          other.budgetId == this.budgetId &&
          other.knowledge == this.knowledge &&
          other.month == this.month);
}

class DbCategoryKnowledgesCompanion extends UpdateCompanion<DbCategoryKnowledge> {
  final Value<String> budgetId;
  final Value<int> knowledge;
  final Value<String?> month;
  final Value<int> rowid;
  const DbCategoryKnowledgesCompanion({
    this.budgetId = const Value.absent(),
    this.knowledge = const Value.absent(),
    this.month = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DbCategoryKnowledgesCompanion.insert({
    required String budgetId,
    required int knowledge,
    this.month = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : budgetId = Value(budgetId),
       knowledge = Value(knowledge);
  static Insertable<DbCategoryKnowledge> custom({
    Expression<String>? budgetId,
    Expression<int>? knowledge,
    Expression<String>? month,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (budgetId != null) 'budget_id': budgetId,
      if (knowledge != null) 'knowledge': knowledge,
      if (month != null) 'month': month,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DbCategoryKnowledgesCompanion copyWith({
    Value<String>? budgetId,
    Value<int>? knowledge,
    Value<String?>? month,
    Value<int>? rowid,
  }) {
    return DbCategoryKnowledgesCompanion(
      budgetId: budgetId ?? this.budgetId,
      knowledge: knowledge ?? this.knowledge,
      month: month ?? this.month,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (budgetId.present) {
      map['budget_id'] = Variable<String>(budgetId.value);
    }
    if (knowledge.present) {
      map['knowledge'] = Variable<int>(knowledge.value);
    }
    if (month.present) {
      map['month'] = Variable<String>(month.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DbCategoryKnowledgesCompanion(')
          ..write('budgetId: $budgetId, ')
          ..write('knowledge: $knowledge, ')
          ..write('month: $month, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DbPayeeKnowledgesTable extends DbPayeeKnowledges
    with TableInfo<$DbPayeeKnowledgesTable, DbPayeeKnowledge> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DbPayeeKnowledgesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _budgetIdMeta = const VerificationMeta('budgetId');
  @override
  late final GeneratedColumn<String> budgetId = GeneratedColumn<String>(
    'budget_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _knowledgeMeta = const VerificationMeta('knowledge');
  @override
  late final GeneratedColumn<int> knowledge = GeneratedColumn<int>(
    'knowledge',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [budgetId, knowledge];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'db_payee_knowledges';
  @override
  VerificationContext validateIntegrity(
    Insertable<DbPayeeKnowledge> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('budget_id')) {
      context.handle(
        _budgetIdMeta,
        budgetId.isAcceptableOrUnknown(data['budget_id']!, _budgetIdMeta),
      );
    } else if (isInserting) {
      context.missing(_budgetIdMeta);
    }
    if (data.containsKey('knowledge')) {
      context.handle(
        _knowledgeMeta,
        knowledge.isAcceptableOrUnknown(data['knowledge']!, _knowledgeMeta),
      );
    } else if (isInserting) {
      context.missing(_knowledgeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {budgetId};
  @override
  DbPayeeKnowledge map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DbPayeeKnowledge(
      budgetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}budget_id'],
      )!,
      knowledge: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}knowledge'],
      )!,
    );
  }

  @override
  $DbPayeeKnowledgesTable createAlias(String alias) {
    return $DbPayeeKnowledgesTable(attachedDatabase, alias);
  }
}

class DbPayeeKnowledge extends DataClass implements Insertable<DbPayeeKnowledge> {
  final String budgetId;
  final int knowledge;
  const DbPayeeKnowledge({required this.budgetId, required this.knowledge});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['budget_id'] = Variable<String>(budgetId);
    map['knowledge'] = Variable<int>(knowledge);
    return map;
  }

  DbPayeeKnowledgesCompanion toCompanion(bool nullToAbsent) {
    return DbPayeeKnowledgesCompanion(budgetId: Value(budgetId), knowledge: Value(knowledge));
  }

  factory DbPayeeKnowledge.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DbPayeeKnowledge(
      budgetId: serializer.fromJson<String>(json['budgetId']),
      knowledge: serializer.fromJson<int>(json['knowledge']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'budgetId': serializer.toJson<String>(budgetId),
      'knowledge': serializer.toJson<int>(knowledge),
    };
  }

  DbPayeeKnowledge copyWith({String? budgetId, int? knowledge}) =>
      DbPayeeKnowledge(budgetId: budgetId ?? this.budgetId, knowledge: knowledge ?? this.knowledge);
  DbPayeeKnowledge copyWithCompanion(DbPayeeKnowledgesCompanion data) {
    return DbPayeeKnowledge(
      budgetId: data.budgetId.present ? data.budgetId.value : this.budgetId,
      knowledge: data.knowledge.present ? data.knowledge.value : this.knowledge,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DbPayeeKnowledge(')
          ..write('budgetId: $budgetId, ')
          ..write('knowledge: $knowledge')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(budgetId, knowledge);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DbPayeeKnowledge &&
          other.budgetId == this.budgetId &&
          other.knowledge == this.knowledge);
}

class DbPayeeKnowledgesCompanion extends UpdateCompanion<DbPayeeKnowledge> {
  final Value<String> budgetId;
  final Value<int> knowledge;
  final Value<int> rowid;
  const DbPayeeKnowledgesCompanion({
    this.budgetId = const Value.absent(),
    this.knowledge = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DbPayeeKnowledgesCompanion.insert({
    required String budgetId,
    required int knowledge,
    this.rowid = const Value.absent(),
  }) : budgetId = Value(budgetId),
       knowledge = Value(knowledge);
  static Insertable<DbPayeeKnowledge> custom({
    Expression<String>? budgetId,
    Expression<int>? knowledge,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (budgetId != null) 'budget_id': budgetId,
      if (knowledge != null) 'knowledge': knowledge,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DbPayeeKnowledgesCompanion copyWith({
    Value<String>? budgetId,
    Value<int>? knowledge,
    Value<int>? rowid,
  }) {
    return DbPayeeKnowledgesCompanion(
      budgetId: budgetId ?? this.budgetId,
      knowledge: knowledge ?? this.knowledge,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (budgetId.present) {
      map['budget_id'] = Variable<String>(budgetId.value);
    }
    if (knowledge.present) {
      map['knowledge'] = Variable<int>(knowledge.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DbPayeeKnowledgesCompanion(')
          ..write('budgetId: $budgetId, ')
          ..write('knowledge: $knowledge, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DbTransactionKnowledgesTable extends DbTransactionKnowledges
    with TableInfo<$DbTransactionKnowledgesTable, DbTransactionKnowledge> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DbTransactionKnowledgesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _budgetIdMeta = const VerificationMeta('budgetId');
  @override
  late final GeneratedColumn<String> budgetId = GeneratedColumn<String>(
    'budget_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _knowledgeMeta = const VerificationMeta('knowledge');
  @override
  late final GeneratedColumn<int> knowledge = GeneratedColumn<int>(
    'knowledge',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [budgetId, knowledge];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'db_transaction_knowledges';
  @override
  VerificationContext validateIntegrity(
    Insertable<DbTransactionKnowledge> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('budget_id')) {
      context.handle(
        _budgetIdMeta,
        budgetId.isAcceptableOrUnknown(data['budget_id']!, _budgetIdMeta),
      );
    } else if (isInserting) {
      context.missing(_budgetIdMeta);
    }
    if (data.containsKey('knowledge')) {
      context.handle(
        _knowledgeMeta,
        knowledge.isAcceptableOrUnknown(data['knowledge']!, _knowledgeMeta),
      );
    } else if (isInserting) {
      context.missing(_knowledgeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {budgetId};
  @override
  DbTransactionKnowledge map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DbTransactionKnowledge(
      budgetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}budget_id'],
      )!,
      knowledge: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}knowledge'],
      )!,
    );
  }

  @override
  $DbTransactionKnowledgesTable createAlias(String alias) {
    return $DbTransactionKnowledgesTable(attachedDatabase, alias);
  }
}

class DbTransactionKnowledge extends DataClass implements Insertable<DbTransactionKnowledge> {
  final String budgetId;
  final int knowledge;
  const DbTransactionKnowledge({required this.budgetId, required this.knowledge});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['budget_id'] = Variable<String>(budgetId);
    map['knowledge'] = Variable<int>(knowledge);
    return map;
  }

  DbTransactionKnowledgesCompanion toCompanion(bool nullToAbsent) {
    return DbTransactionKnowledgesCompanion(budgetId: Value(budgetId), knowledge: Value(knowledge));
  }

  factory DbTransactionKnowledge.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DbTransactionKnowledge(
      budgetId: serializer.fromJson<String>(json['budgetId']),
      knowledge: serializer.fromJson<int>(json['knowledge']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'budgetId': serializer.toJson<String>(budgetId),
      'knowledge': serializer.toJson<int>(knowledge),
    };
  }

  DbTransactionKnowledge copyWith({String? budgetId, int? knowledge}) => DbTransactionKnowledge(
    budgetId: budgetId ?? this.budgetId,
    knowledge: knowledge ?? this.knowledge,
  );
  DbTransactionKnowledge copyWithCompanion(DbTransactionKnowledgesCompanion data) {
    return DbTransactionKnowledge(
      budgetId: data.budgetId.present ? data.budgetId.value : this.budgetId,
      knowledge: data.knowledge.present ? data.knowledge.value : this.knowledge,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DbTransactionKnowledge(')
          ..write('budgetId: $budgetId, ')
          ..write('knowledge: $knowledge')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(budgetId, knowledge);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DbTransactionKnowledge &&
          other.budgetId == this.budgetId &&
          other.knowledge == this.knowledge);
}

class DbTransactionKnowledgesCompanion extends UpdateCompanion<DbTransactionKnowledge> {
  final Value<String> budgetId;
  final Value<int> knowledge;
  final Value<int> rowid;
  const DbTransactionKnowledgesCompanion({
    this.budgetId = const Value.absent(),
    this.knowledge = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DbTransactionKnowledgesCompanion.insert({
    required String budgetId,
    required int knowledge,
    this.rowid = const Value.absent(),
  }) : budgetId = Value(budgetId),
       knowledge = Value(knowledge);
  static Insertable<DbTransactionKnowledge> custom({
    Expression<String>? budgetId,
    Expression<int>? knowledge,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (budgetId != null) 'budget_id': budgetId,
      if (knowledge != null) 'knowledge': knowledge,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DbTransactionKnowledgesCompanion copyWith({
    Value<String>? budgetId,
    Value<int>? knowledge,
    Value<int>? rowid,
  }) {
    return DbTransactionKnowledgesCompanion(
      budgetId: budgetId ?? this.budgetId,
      knowledge: knowledge ?? this.knowledge,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (budgetId.present) {
      map['budget_id'] = Variable<String>(budgetId.value);
    }
    if (knowledge.present) {
      map['knowledge'] = Variable<int>(knowledge.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DbTransactionKnowledgesCompanion(')
          ..write('budgetId: $budgetId, ')
          ..write('knowledge: $knowledge, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DbScheduledTransactionKnowledgesTable extends DbScheduledTransactionKnowledges
    with TableInfo<$DbScheduledTransactionKnowledgesTable, DbScheduledTransactionKnowledge> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DbScheduledTransactionKnowledgesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _budgetIdMeta = const VerificationMeta('budgetId');
  @override
  late final GeneratedColumn<String> budgetId = GeneratedColumn<String>(
    'budget_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _knowledgeMeta = const VerificationMeta('knowledge');
  @override
  late final GeneratedColumn<int> knowledge = GeneratedColumn<int>(
    'knowledge',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [budgetId, knowledge];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'db_scheduled_transaction_knowledges';
  @override
  VerificationContext validateIntegrity(
    Insertable<DbScheduledTransactionKnowledge> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('budget_id')) {
      context.handle(
        _budgetIdMeta,
        budgetId.isAcceptableOrUnknown(data['budget_id']!, _budgetIdMeta),
      );
    } else if (isInserting) {
      context.missing(_budgetIdMeta);
    }
    if (data.containsKey('knowledge')) {
      context.handle(
        _knowledgeMeta,
        knowledge.isAcceptableOrUnknown(data['knowledge']!, _knowledgeMeta),
      );
    } else if (isInserting) {
      context.missing(_knowledgeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {budgetId};
  @override
  DbScheduledTransactionKnowledge map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DbScheduledTransactionKnowledge(
      budgetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}budget_id'],
      )!,
      knowledge: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}knowledge'],
      )!,
    );
  }

  @override
  $DbScheduledTransactionKnowledgesTable createAlias(String alias) {
    return $DbScheduledTransactionKnowledgesTable(attachedDatabase, alias);
  }
}

class DbScheduledTransactionKnowledge extends DataClass
    implements Insertable<DbScheduledTransactionKnowledge> {
  final String budgetId;
  final int knowledge;
  const DbScheduledTransactionKnowledge({required this.budgetId, required this.knowledge});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['budget_id'] = Variable<String>(budgetId);
    map['knowledge'] = Variable<int>(knowledge);
    return map;
  }

  DbScheduledTransactionKnowledgesCompanion toCompanion(bool nullToAbsent) {
    return DbScheduledTransactionKnowledgesCompanion(
      budgetId: Value(budgetId),
      knowledge: Value(knowledge),
    );
  }

  factory DbScheduledTransactionKnowledge.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DbScheduledTransactionKnowledge(
      budgetId: serializer.fromJson<String>(json['budgetId']),
      knowledge: serializer.fromJson<int>(json['knowledge']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'budgetId': serializer.toJson<String>(budgetId),
      'knowledge': serializer.toJson<int>(knowledge),
    };
  }

  DbScheduledTransactionKnowledge copyWith({String? budgetId, int? knowledge}) =>
      DbScheduledTransactionKnowledge(
        budgetId: budgetId ?? this.budgetId,
        knowledge: knowledge ?? this.knowledge,
      );
  DbScheduledTransactionKnowledge copyWithCompanion(
    DbScheduledTransactionKnowledgesCompanion data,
  ) {
    return DbScheduledTransactionKnowledge(
      budgetId: data.budgetId.present ? data.budgetId.value : this.budgetId,
      knowledge: data.knowledge.present ? data.knowledge.value : this.knowledge,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DbScheduledTransactionKnowledge(')
          ..write('budgetId: $budgetId, ')
          ..write('knowledge: $knowledge')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(budgetId, knowledge);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DbScheduledTransactionKnowledge &&
          other.budgetId == this.budgetId &&
          other.knowledge == this.knowledge);
}

class DbScheduledTransactionKnowledgesCompanion
    extends UpdateCompanion<DbScheduledTransactionKnowledge> {
  final Value<String> budgetId;
  final Value<int> knowledge;
  final Value<int> rowid;
  const DbScheduledTransactionKnowledgesCompanion({
    this.budgetId = const Value.absent(),
    this.knowledge = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DbScheduledTransactionKnowledgesCompanion.insert({
    required String budgetId,
    required int knowledge,
    this.rowid = const Value.absent(),
  }) : budgetId = Value(budgetId),
       knowledge = Value(knowledge);
  static Insertable<DbScheduledTransactionKnowledge> custom({
    Expression<String>? budgetId,
    Expression<int>? knowledge,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (budgetId != null) 'budget_id': budgetId,
      if (knowledge != null) 'knowledge': knowledge,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DbScheduledTransactionKnowledgesCompanion copyWith({
    Value<String>? budgetId,
    Value<int>? knowledge,
    Value<int>? rowid,
  }) {
    return DbScheduledTransactionKnowledgesCompanion(
      budgetId: budgetId ?? this.budgetId,
      knowledge: knowledge ?? this.knowledge,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (budgetId.present) {
      map['budget_id'] = Variable<String>(budgetId.value);
    }
    if (knowledge.present) {
      map['knowledge'] = Variable<int>(knowledge.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DbScheduledTransactionKnowledgesCompanion(')
          ..write('budgetId: $budgetId, ')
          ..write('knowledge: $knowledge, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DbMonthKnowledgesTable extends DbMonthKnowledges
    with TableInfo<$DbMonthKnowledgesTable, DbMonthKnowledge> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DbMonthKnowledgesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _budgetIdMeta = const VerificationMeta('budgetId');
  @override
  late final GeneratedColumn<String> budgetId = GeneratedColumn<String>(
    'budget_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _knowledgeMeta = const VerificationMeta('knowledge');
  @override
  late final GeneratedColumn<int> knowledge = GeneratedColumn<int>(
    'knowledge',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _monthMeta = const VerificationMeta('month');
  @override
  late final GeneratedColumn<String> month = GeneratedColumn<String>(
    'month',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [budgetId, knowledge, month];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'db_month_knowledges';
  @override
  VerificationContext validateIntegrity(
    Insertable<DbMonthKnowledge> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('budget_id')) {
      context.handle(
        _budgetIdMeta,
        budgetId.isAcceptableOrUnknown(data['budget_id']!, _budgetIdMeta),
      );
    } else if (isInserting) {
      context.missing(_budgetIdMeta);
    }
    if (data.containsKey('knowledge')) {
      context.handle(
        _knowledgeMeta,
        knowledge.isAcceptableOrUnknown(data['knowledge']!, _knowledgeMeta),
      );
    } else if (isInserting) {
      context.missing(_knowledgeMeta);
    }
    if (data.containsKey('month')) {
      context.handle(_monthMeta, month.isAcceptableOrUnknown(data['month']!, _monthMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {budgetId};
  @override
  DbMonthKnowledge map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DbMonthKnowledge(
      budgetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}budget_id'],
      )!,
      knowledge: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}knowledge'],
      )!,
      month: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}month'],
      ),
    );
  }

  @override
  $DbMonthKnowledgesTable createAlias(String alias) {
    return $DbMonthKnowledgesTable(attachedDatabase, alias);
  }
}

class DbMonthKnowledge extends DataClass implements Insertable<DbMonthKnowledge> {
  final String budgetId;
  final int knowledge;
  final String? month;
  const DbMonthKnowledge({required this.budgetId, required this.knowledge, this.month});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['budget_id'] = Variable<String>(budgetId);
    map['knowledge'] = Variable<int>(knowledge);
    if (!nullToAbsent || month != null) {
      map['month'] = Variable<String>(month);
    }
    return map;
  }

  DbMonthKnowledgesCompanion toCompanion(bool nullToAbsent) {
    return DbMonthKnowledgesCompanion(
      budgetId: Value(budgetId),
      knowledge: Value(knowledge),
      month: month == null && nullToAbsent ? const Value.absent() : Value(month),
    );
  }

  factory DbMonthKnowledge.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DbMonthKnowledge(
      budgetId: serializer.fromJson<String>(json['budgetId']),
      knowledge: serializer.fromJson<int>(json['knowledge']),
      month: serializer.fromJson<String?>(json['month']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'budgetId': serializer.toJson<String>(budgetId),
      'knowledge': serializer.toJson<int>(knowledge),
      'month': serializer.toJson<String?>(month),
    };
  }

  DbMonthKnowledge copyWith({
    String? budgetId,
    int? knowledge,
    Value<String?> month = const Value.absent(),
  }) => DbMonthKnowledge(
    budgetId: budgetId ?? this.budgetId,
    knowledge: knowledge ?? this.knowledge,
    month: month.present ? month.value : this.month,
  );
  DbMonthKnowledge copyWithCompanion(DbMonthKnowledgesCompanion data) {
    return DbMonthKnowledge(
      budgetId: data.budgetId.present ? data.budgetId.value : this.budgetId,
      knowledge: data.knowledge.present ? data.knowledge.value : this.knowledge,
      month: data.month.present ? data.month.value : this.month,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DbMonthKnowledge(')
          ..write('budgetId: $budgetId, ')
          ..write('knowledge: $knowledge, ')
          ..write('month: $month')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(budgetId, knowledge, month);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DbMonthKnowledge &&
          other.budgetId == this.budgetId &&
          other.knowledge == this.knowledge &&
          other.month == this.month);
}

class DbMonthKnowledgesCompanion extends UpdateCompanion<DbMonthKnowledge> {
  final Value<String> budgetId;
  final Value<int> knowledge;
  final Value<String?> month;
  final Value<int> rowid;
  const DbMonthKnowledgesCompanion({
    this.budgetId = const Value.absent(),
    this.knowledge = const Value.absent(),
    this.month = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DbMonthKnowledgesCompanion.insert({
    required String budgetId,
    required int knowledge,
    this.month = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : budgetId = Value(budgetId),
       knowledge = Value(knowledge);
  static Insertable<DbMonthKnowledge> custom({
    Expression<String>? budgetId,
    Expression<int>? knowledge,
    Expression<String>? month,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (budgetId != null) 'budget_id': budgetId,
      if (knowledge != null) 'knowledge': knowledge,
      if (month != null) 'month': month,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DbMonthKnowledgesCompanion copyWith({
    Value<String>? budgetId,
    Value<int>? knowledge,
    Value<String?>? month,
    Value<int>? rowid,
  }) {
    return DbMonthKnowledgesCompanion(
      budgetId: budgetId ?? this.budgetId,
      knowledge: knowledge ?? this.knowledge,
      month: month ?? this.month,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (budgetId.present) {
      map['budget_id'] = Variable<String>(budgetId.value);
    }
    if (knowledge.present) {
      map['knowledge'] = Variable<int>(knowledge.value);
    }
    if (month.present) {
      map['month'] = Variable<String>(month.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DbMonthKnowledgesCompanion(')
          ..write('budgetId: $budgetId, ')
          ..write('knowledge: $knowledge, ')
          ..write('month: $month, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DbCategoryViewsTable extends DbCategoryViews
    with TableInfo<$DbCategoryViewsTable, DbCategoryView> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DbCategoryViewsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _budgetIdMeta = const VerificationMeta('budgetId');
  @override
  late final GeneratedColumn<String> budgetId = GeneratedColumn<String>(
    'budget_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("is_deleted" IN (0, 1))'),
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, budgetId, isDeleted];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'db_category_views';
  @override
  VerificationContext validateIntegrity(
    Insertable<DbCategoryView> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(_nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('budget_id')) {
      context.handle(
        _budgetIdMeta,
        budgetId.isAcceptableOrUnknown(data['budget_id']!, _budgetIdMeta),
      );
    } else if (isInserting) {
      context.missing(_budgetIdMeta);
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    } else if (isInserting) {
      context.missing(_isDeletedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DbCategoryView map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DbCategoryView(
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      budgetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}budget_id'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
    );
  }

  @override
  $DbCategoryViewsTable createAlias(String alias) {
    return $DbCategoryViewsTable(attachedDatabase, alias);
  }
}

class DbCategoryView extends DataClass implements Insertable<DbCategoryView> {
  final int id;
  final String name;
  final String budgetId;
  final bool isDeleted;
  const DbCategoryView({
    required this.id,
    required this.name,
    required this.budgetId,
    required this.isDeleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['budget_id'] = Variable<String>(budgetId);
    map['is_deleted'] = Variable<bool>(isDeleted);
    return map;
  }

  DbCategoryViewsCompanion toCompanion(bool nullToAbsent) {
    return DbCategoryViewsCompanion(
      id: Value(id),
      name: Value(name),
      budgetId: Value(budgetId),
      isDeleted: Value(isDeleted),
    );
  }

  factory DbCategoryView.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DbCategoryView(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      budgetId: serializer.fromJson<String>(json['budgetId']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'budgetId': serializer.toJson<String>(budgetId),
      'isDeleted': serializer.toJson<bool>(isDeleted),
    };
  }

  DbCategoryView copyWith({int? id, String? name, String? budgetId, bool? isDeleted}) =>
      DbCategoryView(
        id: id ?? this.id,
        name: name ?? this.name,
        budgetId: budgetId ?? this.budgetId,
        isDeleted: isDeleted ?? this.isDeleted,
      );
  DbCategoryView copyWithCompanion(DbCategoryViewsCompanion data) {
    return DbCategoryView(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      budgetId: data.budgetId.present ? data.budgetId.value : this.budgetId,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DbCategoryView(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('budgetId: $budgetId, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, budgetId, isDeleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DbCategoryView &&
          other.id == this.id &&
          other.name == this.name &&
          other.budgetId == this.budgetId &&
          other.isDeleted == this.isDeleted);
}

class DbCategoryViewsCompanion extends UpdateCompanion<DbCategoryView> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> budgetId;
  final Value<bool> isDeleted;
  const DbCategoryViewsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.budgetId = const Value.absent(),
    this.isDeleted = const Value.absent(),
  });
  DbCategoryViewsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String budgetId,
    required bool isDeleted,
  }) : name = Value(name),
       budgetId = Value(budgetId),
       isDeleted = Value(isDeleted);
  static Insertable<DbCategoryView> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? budgetId,
    Expression<bool>? isDeleted,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (budgetId != null) 'budget_id': budgetId,
      if (isDeleted != null) 'is_deleted': isDeleted,
    });
  }

  DbCategoryViewsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? budgetId,
    Value<bool>? isDeleted,
  }) {
    return DbCategoryViewsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      budgetId: budgetId ?? this.budgetId,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (budgetId.present) {
      map['budget_id'] = Variable<String>(budgetId.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DbCategoryViewsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('budgetId: $budgetId, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }
}

class $DbCategoryViewCategoriesTable extends DbCategoryViewCategories
    with TableInfo<$DbCategoryViewCategoriesTable, DbCategoryViewCategory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DbCategoryViewCategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'),
  );
  static const VerificationMeta _categoryViewIdMeta = const VerificationMeta('categoryViewId');
  @override
  late final GeneratedColumn<int> categoryViewId = GeneratedColumn<int>(
    'category_view_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, categoryViewId, categoryId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'db_category_view_categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<DbCategoryViewCategory> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('category_view_id')) {
      context.handle(
        _categoryViewIdMeta,
        categoryViewId.isAcceptableOrUnknown(data['category_view_id']!, _categoryViewIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryViewIdMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DbCategoryViewCategory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DbCategoryViewCategory(
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      categoryViewId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_view_id'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      )!,
    );
  }

  @override
  $DbCategoryViewCategoriesTable createAlias(String alias) {
    return $DbCategoryViewCategoriesTable(attachedDatabase, alias);
  }
}

class DbCategoryViewCategory extends DataClass implements Insertable<DbCategoryViewCategory> {
  final int id;
  final int categoryViewId;
  final String categoryId;
  const DbCategoryViewCategory({
    required this.id,
    required this.categoryViewId,
    required this.categoryId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['category_view_id'] = Variable<int>(categoryViewId);
    map['category_id'] = Variable<String>(categoryId);
    return map;
  }

  DbCategoryViewCategoriesCompanion toCompanion(bool nullToAbsent) {
    return DbCategoryViewCategoriesCompanion(
      id: Value(id),
      categoryViewId: Value(categoryViewId),
      categoryId: Value(categoryId),
    );
  }

  factory DbCategoryViewCategory.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DbCategoryViewCategory(
      id: serializer.fromJson<int>(json['id']),
      categoryViewId: serializer.fromJson<int>(json['categoryViewId']),
      categoryId: serializer.fromJson<String>(json['categoryId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'categoryViewId': serializer.toJson<int>(categoryViewId),
      'categoryId': serializer.toJson<String>(categoryId),
    };
  }

  DbCategoryViewCategory copyWith({int? id, int? categoryViewId, String? categoryId}) =>
      DbCategoryViewCategory(
        id: id ?? this.id,
        categoryViewId: categoryViewId ?? this.categoryViewId,
        categoryId: categoryId ?? this.categoryId,
      );
  DbCategoryViewCategory copyWithCompanion(DbCategoryViewCategoriesCompanion data) {
    return DbCategoryViewCategory(
      id: data.id.present ? data.id.value : this.id,
      categoryViewId: data.categoryViewId.present ? data.categoryViewId.value : this.categoryViewId,
      categoryId: data.categoryId.present ? data.categoryId.value : this.categoryId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DbCategoryViewCategory(')
          ..write('id: $id, ')
          ..write('categoryViewId: $categoryViewId, ')
          ..write('categoryId: $categoryId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, categoryViewId, categoryId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DbCategoryViewCategory &&
          other.id == this.id &&
          other.categoryViewId == this.categoryViewId &&
          other.categoryId == this.categoryId);
}

class DbCategoryViewCategoriesCompanion extends UpdateCompanion<DbCategoryViewCategory> {
  final Value<int> id;
  final Value<int> categoryViewId;
  final Value<String> categoryId;
  const DbCategoryViewCategoriesCompanion({
    this.id = const Value.absent(),
    this.categoryViewId = const Value.absent(),
    this.categoryId = const Value.absent(),
  });
  DbCategoryViewCategoriesCompanion.insert({
    this.id = const Value.absent(),
    required int categoryViewId,
    required String categoryId,
  }) : categoryViewId = Value(categoryViewId),
       categoryId = Value(categoryId);
  static Insertable<DbCategoryViewCategory> custom({
    Expression<int>? id,
    Expression<int>? categoryViewId,
    Expression<String>? categoryId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (categoryViewId != null) 'category_view_id': categoryViewId,
      if (categoryId != null) 'category_id': categoryId,
    });
  }

  DbCategoryViewCategoriesCompanion copyWith({
    Value<int>? id,
    Value<int>? categoryViewId,
    Value<String>? categoryId,
  }) {
    return DbCategoryViewCategoriesCompanion(
      id: id ?? this.id,
      categoryViewId: categoryViewId ?? this.categoryViewId,
      categoryId: categoryId ?? this.categoryId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (categoryViewId.present) {
      map['category_view_id'] = Variable<int>(categoryViewId.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DbCategoryViewCategoriesCompanion(')
          ..write('id: $id, ')
          ..write('categoryViewId: $categoryViewId, ')
          ..write('categoryId: $categoryId')
          ..write(')'))
        .toString();
  }
}

class $DbCategoryViewCategoryGroupsTable extends DbCategoryViewCategoryGroups
    with TableInfo<$DbCategoryViewCategoryGroupsTable, DbCategoryViewCategoryGroup> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DbCategoryViewCategoryGroupsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'),
  );
  static const VerificationMeta _categoryViewIdMeta = const VerificationMeta('categoryViewId');
  @override
  late final GeneratedColumn<int> categoryViewId = GeneratedColumn<int>(
    'category_view_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryGroupIdMeta = const VerificationMeta('categoryGroupId');
  @override
  late final GeneratedColumn<String> categoryGroupId = GeneratedColumn<String>(
    'category_group_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, categoryViewId, categoryGroupId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'db_category_view_category_groups';
  @override
  VerificationContext validateIntegrity(
    Insertable<DbCategoryViewCategoryGroup> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('category_view_id')) {
      context.handle(
        _categoryViewIdMeta,
        categoryViewId.isAcceptableOrUnknown(data['category_view_id']!, _categoryViewIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryViewIdMeta);
    }
    if (data.containsKey('category_group_id')) {
      context.handle(
        _categoryGroupIdMeta,
        categoryGroupId.isAcceptableOrUnknown(data['category_group_id']!, _categoryGroupIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryGroupIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DbCategoryViewCategoryGroup map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DbCategoryViewCategoryGroup(
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      categoryViewId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_view_id'],
      )!,
      categoryGroupId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_group_id'],
      )!,
    );
  }

  @override
  $DbCategoryViewCategoryGroupsTable createAlias(String alias) {
    return $DbCategoryViewCategoryGroupsTable(attachedDatabase, alias);
  }
}

class DbCategoryViewCategoryGroup extends DataClass
    implements Insertable<DbCategoryViewCategoryGroup> {
  final int id;
  final int categoryViewId;
  final String categoryGroupId;
  const DbCategoryViewCategoryGroup({
    required this.id,
    required this.categoryViewId,
    required this.categoryGroupId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['category_view_id'] = Variable<int>(categoryViewId);
    map['category_group_id'] = Variable<String>(categoryGroupId);
    return map;
  }

  DbCategoryViewCategoryGroupsCompanion toCompanion(bool nullToAbsent) {
    return DbCategoryViewCategoryGroupsCompanion(
      id: Value(id),
      categoryViewId: Value(categoryViewId),
      categoryGroupId: Value(categoryGroupId),
    );
  }

  factory DbCategoryViewCategoryGroup.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DbCategoryViewCategoryGroup(
      id: serializer.fromJson<int>(json['id']),
      categoryViewId: serializer.fromJson<int>(json['categoryViewId']),
      categoryGroupId: serializer.fromJson<String>(json['categoryGroupId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'categoryViewId': serializer.toJson<int>(categoryViewId),
      'categoryGroupId': serializer.toJson<String>(categoryGroupId),
    };
  }

  DbCategoryViewCategoryGroup copyWith({int? id, int? categoryViewId, String? categoryGroupId}) =>
      DbCategoryViewCategoryGroup(
        id: id ?? this.id,
        categoryViewId: categoryViewId ?? this.categoryViewId,
        categoryGroupId: categoryGroupId ?? this.categoryGroupId,
      );
  DbCategoryViewCategoryGroup copyWithCompanion(DbCategoryViewCategoryGroupsCompanion data) {
    return DbCategoryViewCategoryGroup(
      id: data.id.present ? data.id.value : this.id,
      categoryViewId: data.categoryViewId.present ? data.categoryViewId.value : this.categoryViewId,
      categoryGroupId: data.categoryGroupId.present
          ? data.categoryGroupId.value
          : this.categoryGroupId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DbCategoryViewCategoryGroup(')
          ..write('id: $id, ')
          ..write('categoryViewId: $categoryViewId, ')
          ..write('categoryGroupId: $categoryGroupId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, categoryViewId, categoryGroupId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DbCategoryViewCategoryGroup &&
          other.id == this.id &&
          other.categoryViewId == this.categoryViewId &&
          other.categoryGroupId == this.categoryGroupId);
}

class DbCategoryViewCategoryGroupsCompanion extends UpdateCompanion<DbCategoryViewCategoryGroup> {
  final Value<int> id;
  final Value<int> categoryViewId;
  final Value<String> categoryGroupId;
  const DbCategoryViewCategoryGroupsCompanion({
    this.id = const Value.absent(),
    this.categoryViewId = const Value.absent(),
    this.categoryGroupId = const Value.absent(),
  });
  DbCategoryViewCategoryGroupsCompanion.insert({
    this.id = const Value.absent(),
    required int categoryViewId,
    required String categoryGroupId,
  }) : categoryViewId = Value(categoryViewId),
       categoryGroupId = Value(categoryGroupId);
  static Insertable<DbCategoryViewCategoryGroup> custom({
    Expression<int>? id,
    Expression<int>? categoryViewId,
    Expression<String>? categoryGroupId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (categoryViewId != null) 'category_view_id': categoryViewId,
      if (categoryGroupId != null) 'category_group_id': categoryGroupId,
    });
  }

  DbCategoryViewCategoryGroupsCompanion copyWith({
    Value<int>? id,
    Value<int>? categoryViewId,
    Value<String>? categoryGroupId,
  }) {
    return DbCategoryViewCategoryGroupsCompanion(
      id: id ?? this.id,
      categoryViewId: categoryViewId ?? this.categoryViewId,
      categoryGroupId: categoryGroupId ?? this.categoryGroupId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (categoryViewId.present) {
      map['category_view_id'] = Variable<int>(categoryViewId.value);
    }
    if (categoryGroupId.present) {
      map['category_group_id'] = Variable<String>(categoryGroupId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DbCategoryViewCategoryGroupsCompanion(')
          ..write('id: $id, ')
          ..write('categoryViewId: $categoryViewId, ')
          ..write('categoryGroupId: $categoryGroupId')
          ..write(')'))
        .toString();
  }
}

class $DbLegacySpendTrackersTable extends DbLegacySpendTrackers
    with TableInfo<$DbLegacySpendTrackersTable, DbLegacySpendTracker> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DbLegacySpendTrackersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nickNameMeta = const VerificationMeta('nickName');
  @override
  late final GeneratedColumn<String> nickName = GeneratedColumn<String>(
    'nick_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceIdMeta = const VerificationMeta('sourceId');
  @override
  late final GeneratedColumn<String> sourceId = GeneratedColumn<String>(
    'source_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _budgetIdMeta = const VerificationMeta('budgetId');
  @override
  late final GeneratedColumn<String> budgetId = GeneratedColumn<String>(
    'budget_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("is_deleted" IN (0, 1))'),
  );
  @override
  late final GeneratedColumnWithTypeConverter<SpendTrackerType, String> type =
      GeneratedColumn<String>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<SpendTrackerType>($DbLegacySpendTrackersTable.$convertertype);
  @override
  List<GeneratedColumn> get $columns => [id, name, nickName, sourceId, budgetId, isDeleted, type];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'db_legacy_spend_trackers';
  @override
  VerificationContext validateIntegrity(
    Insertable<DbLegacySpendTracker> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(_nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('nick_name')) {
      context.handle(
        _nickNameMeta,
        nickName.isAcceptableOrUnknown(data['nick_name']!, _nickNameMeta),
      );
    }
    if (data.containsKey('source_id')) {
      context.handle(
        _sourceIdMeta,
        sourceId.isAcceptableOrUnknown(data['source_id']!, _sourceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceIdMeta);
    }
    if (data.containsKey('budget_id')) {
      context.handle(
        _budgetIdMeta,
        budgetId.isAcceptableOrUnknown(data['budget_id']!, _budgetIdMeta),
      );
    } else if (isInserting) {
      context.missing(_budgetIdMeta);
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    } else if (isInserting) {
      context.missing(_isDeletedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DbLegacySpendTracker map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DbLegacySpendTracker(
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      nickName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nick_name'],
      ),
      sourceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_id'],
      )!,
      budgetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}budget_id'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
      type: $DbLegacySpendTrackersTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      ),
    );
  }

  @override
  $DbLegacySpendTrackersTable createAlias(String alias) {
    return $DbLegacySpendTrackersTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SpendTrackerType, String, String> $convertertype =
      const EnumNameConverter<SpendTrackerType>(SpendTrackerType.values);
}

class DbLegacySpendTracker extends DataClass implements Insertable<DbLegacySpendTracker> {
  final int id;
  final String name;
  final String? nickName;
  final String sourceId;
  final String budgetId;
  final bool isDeleted;
  final SpendTrackerType type;
  const DbLegacySpendTracker({
    required this.id,
    required this.name,
    this.nickName,
    required this.sourceId,
    required this.budgetId,
    required this.isDeleted,
    required this.type,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || nickName != null) {
      map['nick_name'] = Variable<String>(nickName);
    }
    map['source_id'] = Variable<String>(sourceId);
    map['budget_id'] = Variable<String>(budgetId);
    map['is_deleted'] = Variable<bool>(isDeleted);
    {
      map['type'] = Variable<String>($DbLegacySpendTrackersTable.$convertertype.toSql(type));
    }
    return map;
  }

  DbLegacySpendTrackersCompanion toCompanion(bool nullToAbsent) {
    return DbLegacySpendTrackersCompanion(
      id: Value(id),
      name: Value(name),
      nickName: nickName == null && nullToAbsent ? const Value.absent() : Value(nickName),
      sourceId: Value(sourceId),
      budgetId: Value(budgetId),
      isDeleted: Value(isDeleted),
      type: Value(type),
    );
  }

  factory DbLegacySpendTracker.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DbLegacySpendTracker(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      nickName: serializer.fromJson<String?>(json['nickName']),
      sourceId: serializer.fromJson<String>(json['sourceId']),
      budgetId: serializer.fromJson<String>(json['budgetId']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      type: $DbLegacySpendTrackersTable.$convertertype.fromJson(
        serializer.fromJson<String>(json['type']),
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'nickName': serializer.toJson<String?>(nickName),
      'sourceId': serializer.toJson<String>(sourceId),
      'budgetId': serializer.toJson<String>(budgetId),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'type': serializer.toJson<String>($DbLegacySpendTrackersTable.$convertertype.toJson(type)),
    };
  }

  DbLegacySpendTracker copyWith({
    int? id,
    String? name,
    Value<String?> nickName = const Value.absent(),
    String? sourceId,
    String? budgetId,
    bool? isDeleted,
    SpendTrackerType? type,
  }) => DbLegacySpendTracker(
    id: id ?? this.id,
    name: name ?? this.name,
    nickName: nickName.present ? nickName.value : this.nickName,
    sourceId: sourceId ?? this.sourceId,
    budgetId: budgetId ?? this.budgetId,
    isDeleted: isDeleted ?? this.isDeleted,
    type: type ?? this.type,
  );
  DbLegacySpendTracker copyWithCompanion(DbLegacySpendTrackersCompanion data) {
    return DbLegacySpendTracker(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      nickName: data.nickName.present ? data.nickName.value : this.nickName,
      sourceId: data.sourceId.present ? data.sourceId.value : this.sourceId,
      budgetId: data.budgetId.present ? data.budgetId.value : this.budgetId,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      type: data.type.present ? data.type.value : this.type,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DbLegacySpendTracker(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('nickName: $nickName, ')
          ..write('sourceId: $sourceId, ')
          ..write('budgetId: $budgetId, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('type: $type')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, nickName, sourceId, budgetId, isDeleted, type);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DbLegacySpendTracker &&
          other.id == this.id &&
          other.name == this.name &&
          other.nickName == this.nickName &&
          other.sourceId == this.sourceId &&
          other.budgetId == this.budgetId &&
          other.isDeleted == this.isDeleted &&
          other.type == this.type);
}

class DbLegacySpendTrackersCompanion extends UpdateCompanion<DbLegacySpendTracker> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> nickName;
  final Value<String> sourceId;
  final Value<String> budgetId;
  final Value<bool> isDeleted;
  final Value<SpendTrackerType> type;
  const DbLegacySpendTrackersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.nickName = const Value.absent(),
    this.sourceId = const Value.absent(),
    this.budgetId = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.type = const Value.absent(),
  });
  DbLegacySpendTrackersCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.nickName = const Value.absent(),
    required String sourceId,
    required String budgetId,
    required bool isDeleted,
    required SpendTrackerType type,
  }) : name = Value(name),
       sourceId = Value(sourceId),
       budgetId = Value(budgetId),
       isDeleted = Value(isDeleted),
       type = Value(type);
  static Insertable<DbLegacySpendTracker> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? nickName,
    Expression<String>? sourceId,
    Expression<String>? budgetId,
    Expression<bool>? isDeleted,
    Expression<String>? type,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (nickName != null) 'nick_name': nickName,
      if (sourceId != null) 'source_id': sourceId,
      if (budgetId != null) 'budget_id': budgetId,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (type != null) 'type': type,
    });
  }

  DbLegacySpendTrackersCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? nickName,
    Value<String>? sourceId,
    Value<String>? budgetId,
    Value<bool>? isDeleted,
    Value<SpendTrackerType>? type,
  }) {
    return DbLegacySpendTrackersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      nickName: nickName ?? this.nickName,
      sourceId: sourceId ?? this.sourceId,
      budgetId: budgetId ?? this.budgetId,
      isDeleted: isDeleted ?? this.isDeleted,
      type: type ?? this.type,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (nickName.present) {
      map['nick_name'] = Variable<String>(nickName.value);
    }
    if (sourceId.present) {
      map['source_id'] = Variable<String>(sourceId.value);
    }
    if (budgetId.present) {
      map['budget_id'] = Variable<String>(budgetId.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (type.present) {
      map['type'] = Variable<String>($DbLegacySpendTrackersTable.$convertertype.toSql(type.value));
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DbLegacySpendTrackersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('nickName: $nickName, ')
          ..write('sourceId: $sourceId, ')
          ..write('budgetId: $budgetId, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('type: $type')
          ..write(')'))
        .toString();
  }
}

class $DbQuerySpendTrackersTable extends DbQuerySpendTrackers
    with TableInfo<$DbQuerySpendTrackersTable, DbQuerySpendTracker> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DbQuerySpendTrackersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nickNameMeta = const VerificationMeta('nickName');
  @override
  late final GeneratedColumn<String> nickName = GeneratedColumn<String>(
    'nick_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _conditionIdMeta = const VerificationMeta('conditionId');
  @override
  late final GeneratedColumn<int> conditionId = GeneratedColumn<int>(
    'condition_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _budgetIdMeta = const VerificationMeta('budgetId');
  @override
  late final GeneratedColumn<String> budgetId = GeneratedColumn<String>(
    'budget_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("is_deleted" IN (0, 1))'),
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, nickName, conditionId, budgetId, isDeleted];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'db_query_spend_trackers';
  @override
  VerificationContext validateIntegrity(
    Insertable<DbQuerySpendTracker> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(_nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('nick_name')) {
      context.handle(
        _nickNameMeta,
        nickName.isAcceptableOrUnknown(data['nick_name']!, _nickNameMeta),
      );
    }
    if (data.containsKey('condition_id')) {
      context.handle(
        _conditionIdMeta,
        conditionId.isAcceptableOrUnknown(data['condition_id']!, _conditionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_conditionIdMeta);
    }
    if (data.containsKey('budget_id')) {
      context.handle(
        _budgetIdMeta,
        budgetId.isAcceptableOrUnknown(data['budget_id']!, _budgetIdMeta),
      );
    } else if (isInserting) {
      context.missing(_budgetIdMeta);
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    } else if (isInserting) {
      context.missing(_isDeletedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DbQuerySpendTracker map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DbQuerySpendTracker(
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      nickName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nick_name'],
      ),
      conditionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}condition_id'],
      )!,
      budgetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}budget_id'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
    );
  }

  @override
  $DbQuerySpendTrackersTable createAlias(String alias) {
    return $DbQuerySpendTrackersTable(attachedDatabase, alias);
  }
}

class DbQuerySpendTracker extends DataClass implements Insertable<DbQuerySpendTracker> {
  final int id;
  final String name;
  final String? nickName;
  final int conditionId;
  final String budgetId;
  final bool isDeleted;
  const DbQuerySpendTracker({
    required this.id,
    required this.name,
    this.nickName,
    required this.conditionId,
    required this.budgetId,
    required this.isDeleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || nickName != null) {
      map['nick_name'] = Variable<String>(nickName);
    }
    map['condition_id'] = Variable<int>(conditionId);
    map['budget_id'] = Variable<String>(budgetId);
    map['is_deleted'] = Variable<bool>(isDeleted);
    return map;
  }

  DbQuerySpendTrackersCompanion toCompanion(bool nullToAbsent) {
    return DbQuerySpendTrackersCompanion(
      id: Value(id),
      name: Value(name),
      nickName: nickName == null && nullToAbsent ? const Value.absent() : Value(nickName),
      conditionId: Value(conditionId),
      budgetId: Value(budgetId),
      isDeleted: Value(isDeleted),
    );
  }

  factory DbQuerySpendTracker.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DbQuerySpendTracker(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      nickName: serializer.fromJson<String?>(json['nickName']),
      conditionId: serializer.fromJson<int>(json['conditionId']),
      budgetId: serializer.fromJson<String>(json['budgetId']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'nickName': serializer.toJson<String?>(nickName),
      'conditionId': serializer.toJson<int>(conditionId),
      'budgetId': serializer.toJson<String>(budgetId),
      'isDeleted': serializer.toJson<bool>(isDeleted),
    };
  }

  DbQuerySpendTracker copyWith({
    int? id,
    String? name,
    Value<String?> nickName = const Value.absent(),
    int? conditionId,
    String? budgetId,
    bool? isDeleted,
  }) => DbQuerySpendTracker(
    id: id ?? this.id,
    name: name ?? this.name,
    nickName: nickName.present ? nickName.value : this.nickName,
    conditionId: conditionId ?? this.conditionId,
    budgetId: budgetId ?? this.budgetId,
    isDeleted: isDeleted ?? this.isDeleted,
  );
  DbQuerySpendTracker copyWithCompanion(DbQuerySpendTrackersCompanion data) {
    return DbQuerySpendTracker(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      nickName: data.nickName.present ? data.nickName.value : this.nickName,
      conditionId: data.conditionId.present ? data.conditionId.value : this.conditionId,
      budgetId: data.budgetId.present ? data.budgetId.value : this.budgetId,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DbQuerySpendTracker(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('nickName: $nickName, ')
          ..write('conditionId: $conditionId, ')
          ..write('budgetId: $budgetId, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, nickName, conditionId, budgetId, isDeleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DbQuerySpendTracker &&
          other.id == this.id &&
          other.name == this.name &&
          other.nickName == this.nickName &&
          other.conditionId == this.conditionId &&
          other.budgetId == this.budgetId &&
          other.isDeleted == this.isDeleted);
}

class DbQuerySpendTrackersCompanion extends UpdateCompanion<DbQuerySpendTracker> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> nickName;
  final Value<int> conditionId;
  final Value<String> budgetId;
  final Value<bool> isDeleted;
  const DbQuerySpendTrackersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.nickName = const Value.absent(),
    this.conditionId = const Value.absent(),
    this.budgetId = const Value.absent(),
    this.isDeleted = const Value.absent(),
  });
  DbQuerySpendTrackersCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.nickName = const Value.absent(),
    required int conditionId,
    required String budgetId,
    required bool isDeleted,
  }) : name = Value(name),
       conditionId = Value(conditionId),
       budgetId = Value(budgetId),
       isDeleted = Value(isDeleted);
  static Insertable<DbQuerySpendTracker> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? nickName,
    Expression<int>? conditionId,
    Expression<String>? budgetId,
    Expression<bool>? isDeleted,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (nickName != null) 'nick_name': nickName,
      if (conditionId != null) 'condition_id': conditionId,
      if (budgetId != null) 'budget_id': budgetId,
      if (isDeleted != null) 'is_deleted': isDeleted,
    });
  }

  DbQuerySpendTrackersCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? nickName,
    Value<int>? conditionId,
    Value<String>? budgetId,
    Value<bool>? isDeleted,
  }) {
    return DbQuerySpendTrackersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      nickName: nickName ?? this.nickName,
      conditionId: conditionId ?? this.conditionId,
      budgetId: budgetId ?? this.budgetId,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (nickName.present) {
      map['nick_name'] = Variable<String>(nickName.value);
    }
    if (conditionId.present) {
      map['condition_id'] = Variable<int>(conditionId.value);
    }
    if (budgetId.present) {
      map['budget_id'] = Variable<String>(budgetId.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DbQuerySpendTrackersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('nickName: $nickName, ')
          ..write('conditionId: $conditionId, ')
          ..write('budgetId: $budgetId, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }
}

class $DbSpendTrackerConditionsTable extends DbSpendTrackerConditions
    with TableInfo<$DbSpendTrackerConditionsTable, DbSpendTrackerCondition> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DbSpendTrackerConditionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'),
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _parentIdMeta = const VerificationMeta('parentId');
  @override
  late final GeneratedColumn<int> parentId = GeneratedColumn<int>(
    'parent_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, type, parentId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'db_spend_tracker_conditions';
  @override
  VerificationContext validateIntegrity(
    Insertable<DbSpendTrackerCondition> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('type')) {
      context.handle(_typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('parent_id')) {
      context.handle(
        _parentIdMeta,
        parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DbSpendTrackerCondition map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DbSpendTrackerCondition(
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      type: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      parentId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}parent_id'],
      ),
    );
  }

  @override
  $DbSpendTrackerConditionsTable createAlias(String alias) {
    return $DbSpendTrackerConditionsTable(attachedDatabase, alias);
  }
}

class DbSpendTrackerCondition extends DataClass implements Insertable<DbSpendTrackerCondition> {
  final int id;
  final String type;
  final int? parentId;
  const DbSpendTrackerCondition({required this.id, required this.type, this.parentId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<int>(parentId);
    }
    return map;
  }

  DbSpendTrackerConditionsCompanion toCompanion(bool nullToAbsent) {
    return DbSpendTrackerConditionsCompanion(
      id: Value(id),
      type: Value(type),
      parentId: parentId == null && nullToAbsent ? const Value.absent() : Value(parentId),
    );
  }

  factory DbSpendTrackerCondition.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DbSpendTrackerCondition(
      id: serializer.fromJson<int>(json['id']),
      type: serializer.fromJson<String>(json['type']),
      parentId: serializer.fromJson<int?>(json['parentId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'type': serializer.toJson<String>(type),
      'parentId': serializer.toJson<int?>(parentId),
    };
  }

  DbSpendTrackerCondition copyWith({
    int? id,
    String? type,
    Value<int?> parentId = const Value.absent(),
  }) => DbSpendTrackerCondition(
    id: id ?? this.id,
    type: type ?? this.type,
    parentId: parentId.present ? parentId.value : this.parentId,
  );
  DbSpendTrackerCondition copyWithCompanion(DbSpendTrackerConditionsCompanion data) {
    return DbSpendTrackerCondition(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DbSpendTrackerCondition(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('parentId: $parentId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, type, parentId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DbSpendTrackerCondition &&
          other.id == this.id &&
          other.type == this.type &&
          other.parentId == this.parentId);
}

class DbSpendTrackerConditionsCompanion extends UpdateCompanion<DbSpendTrackerCondition> {
  final Value<int> id;
  final Value<String> type;
  final Value<int?> parentId;
  const DbSpendTrackerConditionsCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.parentId = const Value.absent(),
  });
  DbSpendTrackerConditionsCompanion.insert({
    this.id = const Value.absent(),
    required String type,
    this.parentId = const Value.absent(),
  }) : type = Value(type);
  static Insertable<DbSpendTrackerCondition> custom({
    Expression<int>? id,
    Expression<String>? type,
    Expression<int>? parentId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (parentId != null) 'parent_id': parentId,
    });
  }

  DbSpendTrackerConditionsCompanion copyWith({
    Value<int>? id,
    Value<String>? type,
    Value<int?>? parentId,
  }) {
    return DbSpendTrackerConditionsCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      parentId: parentId ?? this.parentId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (parentId.present) {
      map['parent_id'] = Variable<int>(parentId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DbSpendTrackerConditionsCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('parentId: $parentId')
          ..write(')'))
        .toString();
  }
}

class $DbSpendTrackerTestsTable extends DbSpendTrackerTests
    with TableInfo<$DbSpendTrackerTestsTable, DbSpendTrackerTest> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DbSpendTrackerTestsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'),
  );
  static const VerificationMeta _conditionIdMeta = const VerificationMeta('conditionId');
  @override
  late final GeneratedColumn<int> conditionId = GeneratedColumn<int>(
    'condition_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _testTypeMeta = const VerificationMeta('testType');
  @override
  late final GeneratedColumn<String> testType = GeneratedColumn<String>(
    'test_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _testValueMeta = const VerificationMeta('testValue');
  @override
  late final GeneratedColumn<String> testValue = GeneratedColumn<String>(
    'test_value',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, conditionId, testType, testValue];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'db_spend_tracker_tests';
  @override
  VerificationContext validateIntegrity(
    Insertable<DbSpendTrackerTest> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('condition_id')) {
      context.handle(
        _conditionIdMeta,
        conditionId.isAcceptableOrUnknown(data['condition_id']!, _conditionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_conditionIdMeta);
    }
    if (data.containsKey('test_type')) {
      context.handle(
        _testTypeMeta,
        testType.isAcceptableOrUnknown(data['test_type']!, _testTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_testTypeMeta);
    }
    if (data.containsKey('test_value')) {
      context.handle(
        _testValueMeta,
        testValue.isAcceptableOrUnknown(data['test_value']!, _testValueMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DbSpendTrackerTest map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DbSpendTrackerTest(
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      conditionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}condition_id'],
      )!,
      testType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}test_type'],
      )!,
      testValue: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}test_value'],
      ),
    );
  }

  @override
  $DbSpendTrackerTestsTable createAlias(String alias) {
    return $DbSpendTrackerTestsTable(attachedDatabase, alias);
  }
}

class DbSpendTrackerTest extends DataClass implements Insertable<DbSpendTrackerTest> {
  final int id;
  final int conditionId;
  final String testType;
  final String? testValue;
  const DbSpendTrackerTest({
    required this.id,
    required this.conditionId,
    required this.testType,
    this.testValue,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['condition_id'] = Variable<int>(conditionId);
    map['test_type'] = Variable<String>(testType);
    if (!nullToAbsent || testValue != null) {
      map['test_value'] = Variable<String>(testValue);
    }
    return map;
  }

  DbSpendTrackerTestsCompanion toCompanion(bool nullToAbsent) {
    return DbSpendTrackerTestsCompanion(
      id: Value(id),
      conditionId: Value(conditionId),
      testType: Value(testType),
      testValue: testValue == null && nullToAbsent ? const Value.absent() : Value(testValue),
    );
  }

  factory DbSpendTrackerTest.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DbSpendTrackerTest(
      id: serializer.fromJson<int>(json['id']),
      conditionId: serializer.fromJson<int>(json['conditionId']),
      testType: serializer.fromJson<String>(json['testType']),
      testValue: serializer.fromJson<String?>(json['testValue']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'conditionId': serializer.toJson<int>(conditionId),
      'testType': serializer.toJson<String>(testType),
      'testValue': serializer.toJson<String?>(testValue),
    };
  }

  DbSpendTrackerTest copyWith({
    int? id,
    int? conditionId,
    String? testType,
    Value<String?> testValue = const Value.absent(),
  }) => DbSpendTrackerTest(
    id: id ?? this.id,
    conditionId: conditionId ?? this.conditionId,
    testType: testType ?? this.testType,
    testValue: testValue.present ? testValue.value : this.testValue,
  );
  DbSpendTrackerTest copyWithCompanion(DbSpendTrackerTestsCompanion data) {
    return DbSpendTrackerTest(
      id: data.id.present ? data.id.value : this.id,
      conditionId: data.conditionId.present ? data.conditionId.value : this.conditionId,
      testType: data.testType.present ? data.testType.value : this.testType,
      testValue: data.testValue.present ? data.testValue.value : this.testValue,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DbSpendTrackerTest(')
          ..write('id: $id, ')
          ..write('conditionId: $conditionId, ')
          ..write('testType: $testType, ')
          ..write('testValue: $testValue')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, conditionId, testType, testValue);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DbSpendTrackerTest &&
          other.id == this.id &&
          other.conditionId == this.conditionId &&
          other.testType == this.testType &&
          other.testValue == this.testValue);
}

class DbSpendTrackerTestsCompanion extends UpdateCompanion<DbSpendTrackerTest> {
  final Value<int> id;
  final Value<int> conditionId;
  final Value<String> testType;
  final Value<String?> testValue;
  const DbSpendTrackerTestsCompanion({
    this.id = const Value.absent(),
    this.conditionId = const Value.absent(),
    this.testType = const Value.absent(),
    this.testValue = const Value.absent(),
  });
  DbSpendTrackerTestsCompanion.insert({
    this.id = const Value.absent(),
    required int conditionId,
    required String testType,
    this.testValue = const Value.absent(),
  }) : conditionId = Value(conditionId),
       testType = Value(testType);
  static Insertable<DbSpendTrackerTest> custom({
    Expression<int>? id,
    Expression<int>? conditionId,
    Expression<String>? testType,
    Expression<String>? testValue,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (conditionId != null) 'condition_id': conditionId,
      if (testType != null) 'test_type': testType,
      if (testValue != null) 'test_value': testValue,
    });
  }

  DbSpendTrackerTestsCompanion copyWith({
    Value<int>? id,
    Value<int>? conditionId,
    Value<String>? testType,
    Value<String?>? testValue,
  }) {
    return DbSpendTrackerTestsCompanion(
      id: id ?? this.id,
      conditionId: conditionId ?? this.conditionId,
      testType: testType ?? this.testType,
      testValue: testValue ?? this.testValue,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (conditionId.present) {
      map['condition_id'] = Variable<int>(conditionId.value);
    }
    if (testType.present) {
      map['test_type'] = Variable<String>(testType.value);
    }
    if (testValue.present) {
      map['test_value'] = Variable<String>(testValue.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DbSpendTrackerTestsCompanion(')
          ..write('id: $id, ')
          ..write('conditionId: $conditionId, ')
          ..write('testType: $testType, ')
          ..write('testValue: $testValue')
          ..write(')'))
        .toString();
  }
}

class $DbFrugalMonthsTable extends DbFrugalMonths
    with TableInfo<$DbFrugalMonthsTable, DbFrugalMonth> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DbFrugalMonthsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'),
  );
  static const VerificationMeta _budgetIdMeta = const VerificationMeta('budgetId');
  @override
  late final GeneratedColumn<String> budgetId = GeneratedColumn<String>(
    'budget_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _monthMeta = const VerificationMeta('month');
  @override
  late final GeneratedColumn<String> month = GeneratedColumn<String>(
    'month',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetAmountMeta = const VerificationMeta('targetAmount');
  @override
  late final GeneratedColumn<int> targetAmount = GeneratedColumn<int>(
    'target_amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("is_deleted" IN (0, 1))'),
  );
  @override
  List<GeneratedColumn> get $columns => [id, budgetId, month, targetAmount, isDeleted];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'db_frugal_months';
  @override
  VerificationContext validateIntegrity(
    Insertable<DbFrugalMonth> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('budget_id')) {
      context.handle(
        _budgetIdMeta,
        budgetId.isAcceptableOrUnknown(data['budget_id']!, _budgetIdMeta),
      );
    } else if (isInserting) {
      context.missing(_budgetIdMeta);
    }
    if (data.containsKey('month')) {
      context.handle(_monthMeta, month.isAcceptableOrUnknown(data['month']!, _monthMeta));
    } else if (isInserting) {
      context.missing(_monthMeta);
    }
    if (data.containsKey('target_amount')) {
      context.handle(
        _targetAmountMeta,
        targetAmount.isAcceptableOrUnknown(data['target_amount']!, _targetAmountMeta),
      );
    } else if (isInserting) {
      context.missing(_targetAmountMeta);
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    } else if (isInserting) {
      context.missing(_isDeletedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DbFrugalMonth map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DbFrugalMonth(
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      budgetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}budget_id'],
      )!,
      month: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}month'],
      )!,
      targetAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_amount'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
    );
  }

  @override
  $DbFrugalMonthsTable createAlias(String alias) {
    return $DbFrugalMonthsTable(attachedDatabase, alias);
  }
}

class DbFrugalMonth extends DataClass implements Insertable<DbFrugalMonth> {
  final int id;
  final String budgetId;
  final String month;
  final int targetAmount;
  final bool isDeleted;
  const DbFrugalMonth({
    required this.id,
    required this.budgetId,
    required this.month,
    required this.targetAmount,
    required this.isDeleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['budget_id'] = Variable<String>(budgetId);
    map['month'] = Variable<String>(month);
    map['target_amount'] = Variable<int>(targetAmount);
    map['is_deleted'] = Variable<bool>(isDeleted);
    return map;
  }

  DbFrugalMonthsCompanion toCompanion(bool nullToAbsent) {
    return DbFrugalMonthsCompanion(
      id: Value(id),
      budgetId: Value(budgetId),
      month: Value(month),
      targetAmount: Value(targetAmount),
      isDeleted: Value(isDeleted),
    );
  }

  factory DbFrugalMonth.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DbFrugalMonth(
      id: serializer.fromJson<int>(json['id']),
      budgetId: serializer.fromJson<String>(json['budgetId']),
      month: serializer.fromJson<String>(json['month']),
      targetAmount: serializer.fromJson<int>(json['targetAmount']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'budgetId': serializer.toJson<String>(budgetId),
      'month': serializer.toJson<String>(month),
      'targetAmount': serializer.toJson<int>(targetAmount),
      'isDeleted': serializer.toJson<bool>(isDeleted),
    };
  }

  DbFrugalMonth copyWith({
    int? id,
    String? budgetId,
    String? month,
    int? targetAmount,
    bool? isDeleted,
  }) => DbFrugalMonth(
    id: id ?? this.id,
    budgetId: budgetId ?? this.budgetId,
    month: month ?? this.month,
    targetAmount: targetAmount ?? this.targetAmount,
    isDeleted: isDeleted ?? this.isDeleted,
  );
  DbFrugalMonth copyWithCompanion(DbFrugalMonthsCompanion data) {
    return DbFrugalMonth(
      id: data.id.present ? data.id.value : this.id,
      budgetId: data.budgetId.present ? data.budgetId.value : this.budgetId,
      month: data.month.present ? data.month.value : this.month,
      targetAmount: data.targetAmount.present ? data.targetAmount.value : this.targetAmount,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DbFrugalMonth(')
          ..write('id: $id, ')
          ..write('budgetId: $budgetId, ')
          ..write('month: $month, ')
          ..write('targetAmount: $targetAmount, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, budgetId, month, targetAmount, isDeleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DbFrugalMonth &&
          other.id == this.id &&
          other.budgetId == this.budgetId &&
          other.month == this.month &&
          other.targetAmount == this.targetAmount &&
          other.isDeleted == this.isDeleted);
}

class DbFrugalMonthsCompanion extends UpdateCompanion<DbFrugalMonth> {
  final Value<int> id;
  final Value<String> budgetId;
  final Value<String> month;
  final Value<int> targetAmount;
  final Value<bool> isDeleted;
  const DbFrugalMonthsCompanion({
    this.id = const Value.absent(),
    this.budgetId = const Value.absent(),
    this.month = const Value.absent(),
    this.targetAmount = const Value.absent(),
    this.isDeleted = const Value.absent(),
  });
  DbFrugalMonthsCompanion.insert({
    this.id = const Value.absent(),
    required String budgetId,
    required String month,
    required int targetAmount,
    required bool isDeleted,
  }) : budgetId = Value(budgetId),
       month = Value(month),
       targetAmount = Value(targetAmount),
       isDeleted = Value(isDeleted);
  static Insertable<DbFrugalMonth> custom({
    Expression<int>? id,
    Expression<String>? budgetId,
    Expression<String>? month,
    Expression<int>? targetAmount,
    Expression<bool>? isDeleted,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (budgetId != null) 'budget_id': budgetId,
      if (month != null) 'month': month,
      if (targetAmount != null) 'target_amount': targetAmount,
      if (isDeleted != null) 'is_deleted': isDeleted,
    });
  }

  DbFrugalMonthsCompanion copyWith({
    Value<int>? id,
    Value<String>? budgetId,
    Value<String>? month,
    Value<int>? targetAmount,
    Value<bool>? isDeleted,
  }) {
    return DbFrugalMonthsCompanion(
      id: id ?? this.id,
      budgetId: budgetId ?? this.budgetId,
      month: month ?? this.month,
      targetAmount: targetAmount ?? this.targetAmount,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (budgetId.present) {
      map['budget_id'] = Variable<String>(budgetId.value);
    }
    if (month.present) {
      map['month'] = Variable<String>(month.value);
    }
    if (targetAmount.present) {
      map['target_amount'] = Variable<int>(targetAmount.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DbFrugalMonthsCompanion(')
          ..write('id: $id, ')
          ..write('budgetId: $budgetId, ')
          ..write('month: $month, ')
          ..write('targetAmount: $targetAmount, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }
}

class $DbFrugalMonthCategoriesTable extends DbFrugalMonthCategories
    with TableInfo<$DbFrugalMonthCategoriesTable, DbFrugalMonthCategory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DbFrugalMonthCategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'),
  );
  static const VerificationMeta _frugalMonthIdMeta = const VerificationMeta('frugalMonthId');
  @override
  late final GeneratedColumn<int> frugalMonthId = GeneratedColumn<int>(
    'frugal_month_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, frugalMonthId, categoryId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'db_frugal_month_categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<DbFrugalMonthCategory> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('frugal_month_id')) {
      context.handle(
        _frugalMonthIdMeta,
        frugalMonthId.isAcceptableOrUnknown(data['frugal_month_id']!, _frugalMonthIdMeta),
      );
    } else if (isInserting) {
      context.missing(_frugalMonthIdMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DbFrugalMonthCategory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DbFrugalMonthCategory(
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      frugalMonthId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}frugal_month_id'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      )!,
    );
  }

  @override
  $DbFrugalMonthCategoriesTable createAlias(String alias) {
    return $DbFrugalMonthCategoriesTable(attachedDatabase, alias);
  }
}

class DbFrugalMonthCategory extends DataClass implements Insertable<DbFrugalMonthCategory> {
  final int id;
  final int frugalMonthId;
  final String categoryId;
  const DbFrugalMonthCategory({
    required this.id,
    required this.frugalMonthId,
    required this.categoryId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['frugal_month_id'] = Variable<int>(frugalMonthId);
    map['category_id'] = Variable<String>(categoryId);
    return map;
  }

  DbFrugalMonthCategoriesCompanion toCompanion(bool nullToAbsent) {
    return DbFrugalMonthCategoriesCompanion(
      id: Value(id),
      frugalMonthId: Value(frugalMonthId),
      categoryId: Value(categoryId),
    );
  }

  factory DbFrugalMonthCategory.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DbFrugalMonthCategory(
      id: serializer.fromJson<int>(json['id']),
      frugalMonthId: serializer.fromJson<int>(json['frugalMonthId']),
      categoryId: serializer.fromJson<String>(json['categoryId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'frugalMonthId': serializer.toJson<int>(frugalMonthId),
      'categoryId': serializer.toJson<String>(categoryId),
    };
  }

  DbFrugalMonthCategory copyWith({int? id, int? frugalMonthId, String? categoryId}) =>
      DbFrugalMonthCategory(
        id: id ?? this.id,
        frugalMonthId: frugalMonthId ?? this.frugalMonthId,
        categoryId: categoryId ?? this.categoryId,
      );
  DbFrugalMonthCategory copyWithCompanion(DbFrugalMonthCategoriesCompanion data) {
    return DbFrugalMonthCategory(
      id: data.id.present ? data.id.value : this.id,
      frugalMonthId: data.frugalMonthId.present ? data.frugalMonthId.value : this.frugalMonthId,
      categoryId: data.categoryId.present ? data.categoryId.value : this.categoryId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DbFrugalMonthCategory(')
          ..write('id: $id, ')
          ..write('frugalMonthId: $frugalMonthId, ')
          ..write('categoryId: $categoryId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, frugalMonthId, categoryId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DbFrugalMonthCategory &&
          other.id == this.id &&
          other.frugalMonthId == this.frugalMonthId &&
          other.categoryId == this.categoryId);
}

class DbFrugalMonthCategoriesCompanion extends UpdateCompanion<DbFrugalMonthCategory> {
  final Value<int> id;
  final Value<int> frugalMonthId;
  final Value<String> categoryId;
  const DbFrugalMonthCategoriesCompanion({
    this.id = const Value.absent(),
    this.frugalMonthId = const Value.absent(),
    this.categoryId = const Value.absent(),
  });
  DbFrugalMonthCategoriesCompanion.insert({
    this.id = const Value.absent(),
    required int frugalMonthId,
    required String categoryId,
  }) : frugalMonthId = Value(frugalMonthId),
       categoryId = Value(categoryId);
  static Insertable<DbFrugalMonthCategory> custom({
    Expression<int>? id,
    Expression<int>? frugalMonthId,
    Expression<String>? categoryId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (frugalMonthId != null) 'frugal_month_id': frugalMonthId,
      if (categoryId != null) 'category_id': categoryId,
    });
  }

  DbFrugalMonthCategoriesCompanion copyWith({
    Value<int>? id,
    Value<int>? frugalMonthId,
    Value<String>? categoryId,
  }) {
    return DbFrugalMonthCategoriesCompanion(
      id: id ?? this.id,
      frugalMonthId: frugalMonthId ?? this.frugalMonthId,
      categoryId: categoryId ?? this.categoryId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (frugalMonthId.present) {
      map['frugal_month_id'] = Variable<int>(frugalMonthId.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DbFrugalMonthCategoriesCompanion(')
          ..write('id: $id, ')
          ..write('frugalMonthId: $frugalMonthId, ')
          ..write('categoryId: $categoryId')
          ..write(')'))
        .toString();
  }
}

class $DbFrugalMonthAccountsTable extends DbFrugalMonthAccounts
    with TableInfo<$DbFrugalMonthAccountsTable, DbFrugalMonthAccount> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DbFrugalMonthAccountsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'),
  );
  static const VerificationMeta _frugalMonthIdMeta = const VerificationMeta('frugalMonthId');
  @override
  late final GeneratedColumn<int> frugalMonthId = GeneratedColumn<int>(
    'frugal_month_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta('accountId');
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, frugalMonthId, accountId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'db_frugal_month_accounts';
  @override
  VerificationContext validateIntegrity(
    Insertable<DbFrugalMonthAccount> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('frugal_month_id')) {
      context.handle(
        _frugalMonthIdMeta,
        frugalMonthId.isAcceptableOrUnknown(data['frugal_month_id']!, _frugalMonthIdMeta),
      );
    } else if (isInserting) {
      context.missing(_frugalMonthIdMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DbFrugalMonthAccount map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DbFrugalMonthAccount(
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      frugalMonthId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}frugal_month_id'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_id'],
      )!,
    );
  }

  @override
  $DbFrugalMonthAccountsTable createAlias(String alias) {
    return $DbFrugalMonthAccountsTable(attachedDatabase, alias);
  }
}

class DbFrugalMonthAccount extends DataClass implements Insertable<DbFrugalMonthAccount> {
  final int id;
  final int frugalMonthId;
  final String accountId;
  const DbFrugalMonthAccount({
    required this.id,
    required this.frugalMonthId,
    required this.accountId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['frugal_month_id'] = Variable<int>(frugalMonthId);
    map['account_id'] = Variable<String>(accountId);
    return map;
  }

  DbFrugalMonthAccountsCompanion toCompanion(bool nullToAbsent) {
    return DbFrugalMonthAccountsCompanion(
      id: Value(id),
      frugalMonthId: Value(frugalMonthId),
      accountId: Value(accountId),
    );
  }

  factory DbFrugalMonthAccount.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DbFrugalMonthAccount(
      id: serializer.fromJson<int>(json['id']),
      frugalMonthId: serializer.fromJson<int>(json['frugalMonthId']),
      accountId: serializer.fromJson<String>(json['accountId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'frugalMonthId': serializer.toJson<int>(frugalMonthId),
      'accountId': serializer.toJson<String>(accountId),
    };
  }

  DbFrugalMonthAccount copyWith({int? id, int? frugalMonthId, String? accountId}) =>
      DbFrugalMonthAccount(
        id: id ?? this.id,
        frugalMonthId: frugalMonthId ?? this.frugalMonthId,
        accountId: accountId ?? this.accountId,
      );
  DbFrugalMonthAccount copyWithCompanion(DbFrugalMonthAccountsCompanion data) {
    return DbFrugalMonthAccount(
      id: data.id.present ? data.id.value : this.id,
      frugalMonthId: data.frugalMonthId.present ? data.frugalMonthId.value : this.frugalMonthId,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DbFrugalMonthAccount(')
          ..write('id: $id, ')
          ..write('frugalMonthId: $frugalMonthId, ')
          ..write('accountId: $accountId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, frugalMonthId, accountId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DbFrugalMonthAccount &&
          other.id == this.id &&
          other.frugalMonthId == this.frugalMonthId &&
          other.accountId == this.accountId);
}

class DbFrugalMonthAccountsCompanion extends UpdateCompanion<DbFrugalMonthAccount> {
  final Value<int> id;
  final Value<int> frugalMonthId;
  final Value<String> accountId;
  const DbFrugalMonthAccountsCompanion({
    this.id = const Value.absent(),
    this.frugalMonthId = const Value.absent(),
    this.accountId = const Value.absent(),
  });
  DbFrugalMonthAccountsCompanion.insert({
    this.id = const Value.absent(),
    required int frugalMonthId,
    required String accountId,
  }) : frugalMonthId = Value(frugalMonthId),
       accountId = Value(accountId);
  static Insertable<DbFrugalMonthAccount> custom({
    Expression<int>? id,
    Expression<int>? frugalMonthId,
    Expression<String>? accountId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (frugalMonthId != null) 'frugal_month_id': frugalMonthId,
      if (accountId != null) 'account_id': accountId,
    });
  }

  DbFrugalMonthAccountsCompanion copyWith({
    Value<int>? id,
    Value<int>? frugalMonthId,
    Value<String>? accountId,
  }) {
    return DbFrugalMonthAccountsCompanion(
      id: id ?? this.id,
      frugalMonthId: frugalMonthId ?? this.frugalMonthId,
      accountId: accountId ?? this.accountId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (frugalMonthId.present) {
      map['frugal_month_id'] = Variable<int>(frugalMonthId.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DbFrugalMonthAccountsCompanion(')
          ..write('id: $id, ')
          ..write('frugalMonthId: $frugalMonthId, ')
          ..write('accountId: $accountId')
          ..write(')'))
        .toString();
  }
}

class $DbGoalsTable extends DbGoals with TableInfo<$DbGoalsTable, DbGoal> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DbGoalsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'),
  );
  static const VerificationMeta _budgetIdMeta = const VerificationMeta('budgetId');
  @override
  late final GeneratedColumn<String> budgetId = GeneratedColumn<String>(
    'budget_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdDateMeta = const VerificationMeta('createdDate');
  @override
  late final GeneratedColumn<DateTime> createdDate = GeneratedColumn<DateTime>(
    'created_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<GoalType, String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<GoalType>($DbGoalsTable.$convertertype);
  @override
  List<GeneratedColumn> get $columns => [id, budgetId, name, createdDate, type];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'db_goals';
  @override
  VerificationContext validateIntegrity(Insertable<DbGoal> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('budget_id')) {
      context.handle(
        _budgetIdMeta,
        budgetId.isAcceptableOrUnknown(data['budget_id']!, _budgetIdMeta),
      );
    } else if (isInserting) {
      context.missing(_budgetIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(_nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('created_date')) {
      context.handle(
        _createdDateMeta,
        createdDate.isAcceptableOrUnknown(data['created_date']!, _createdDateMeta),
      );
    } else if (isInserting) {
      context.missing(_createdDateMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DbGoal map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DbGoal(
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      budgetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}budget_id'],
      )!,
      name: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      createdDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_date'],
      )!,
      type: $DbGoalsTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      ),
    );
  }

  @override
  $DbGoalsTable createAlias(String alias) {
    return $DbGoalsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<GoalType, String, String> $convertertype =
      const EnumNameConverter<GoalType>(GoalType.values);
}

class DbGoal extends DataClass implements Insertable<DbGoal> {
  final int id;
  final String budgetId;
  final String name;
  final DateTime createdDate;
  final GoalType type;
  const DbGoal({
    required this.id,
    required this.budgetId,
    required this.name,
    required this.createdDate,
    required this.type,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['budget_id'] = Variable<String>(budgetId);
    map['name'] = Variable<String>(name);
    map['created_date'] = Variable<DateTime>(createdDate);
    {
      map['type'] = Variable<String>($DbGoalsTable.$convertertype.toSql(type));
    }
    return map;
  }

  DbGoalsCompanion toCompanion(bool nullToAbsent) {
    return DbGoalsCompanion(
      id: Value(id),
      budgetId: Value(budgetId),
      name: Value(name),
      createdDate: Value(createdDate),
      type: Value(type),
    );
  }

  factory DbGoal.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DbGoal(
      id: serializer.fromJson<int>(json['id']),
      budgetId: serializer.fromJson<String>(json['budgetId']),
      name: serializer.fromJson<String>(json['name']),
      createdDate: serializer.fromJson<DateTime>(json['createdDate']),
      type: $DbGoalsTable.$convertertype.fromJson(serializer.fromJson<String>(json['type'])),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'budgetId': serializer.toJson<String>(budgetId),
      'name': serializer.toJson<String>(name),
      'createdDate': serializer.toJson<DateTime>(createdDate),
      'type': serializer.toJson<String>($DbGoalsTable.$convertertype.toJson(type)),
    };
  }

  DbGoal copyWith({
    int? id,
    String? budgetId,
    String? name,
    DateTime? createdDate,
    GoalType? type,
  }) => DbGoal(
    id: id ?? this.id,
    budgetId: budgetId ?? this.budgetId,
    name: name ?? this.name,
    createdDate: createdDate ?? this.createdDate,
    type: type ?? this.type,
  );
  DbGoal copyWithCompanion(DbGoalsCompanion data) {
    return DbGoal(
      id: data.id.present ? data.id.value : this.id,
      budgetId: data.budgetId.present ? data.budgetId.value : this.budgetId,
      name: data.name.present ? data.name.value : this.name,
      createdDate: data.createdDate.present ? data.createdDate.value : this.createdDate,
      type: data.type.present ? data.type.value : this.type,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DbGoal(')
          ..write('id: $id, ')
          ..write('budgetId: $budgetId, ')
          ..write('name: $name, ')
          ..write('createdDate: $createdDate, ')
          ..write('type: $type')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, budgetId, name, createdDate, type);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DbGoal &&
          other.id == this.id &&
          other.budgetId == this.budgetId &&
          other.name == this.name &&
          other.createdDate == this.createdDate &&
          other.type == this.type);
}

class DbGoalsCompanion extends UpdateCompanion<DbGoal> {
  final Value<int> id;
  final Value<String> budgetId;
  final Value<String> name;
  final Value<DateTime> createdDate;
  final Value<GoalType> type;
  const DbGoalsCompanion({
    this.id = const Value.absent(),
    this.budgetId = const Value.absent(),
    this.name = const Value.absent(),
    this.createdDate = const Value.absent(),
    this.type = const Value.absent(),
  });
  DbGoalsCompanion.insert({
    this.id = const Value.absent(),
    required String budgetId,
    required String name,
    required DateTime createdDate,
    required GoalType type,
  }) : budgetId = Value(budgetId),
       name = Value(name),
       createdDate = Value(createdDate),
       type = Value(type);
  static Insertable<DbGoal> custom({
    Expression<int>? id,
    Expression<String>? budgetId,
    Expression<String>? name,
    Expression<DateTime>? createdDate,
    Expression<String>? type,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (budgetId != null) 'budget_id': budgetId,
      if (name != null) 'name': name,
      if (createdDate != null) 'created_date': createdDate,
      if (type != null) 'type': type,
    });
  }

  DbGoalsCompanion copyWith({
    Value<int>? id,
    Value<String>? budgetId,
    Value<String>? name,
    Value<DateTime>? createdDate,
    Value<GoalType>? type,
  }) {
    return DbGoalsCompanion(
      id: id ?? this.id,
      budgetId: budgetId ?? this.budgetId,
      name: name ?? this.name,
      createdDate: createdDate ?? this.createdDate,
      type: type ?? this.type,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (budgetId.present) {
      map['budget_id'] = Variable<String>(budgetId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (createdDate.present) {
      map['created_date'] = Variable<DateTime>(createdDate.value);
    }
    if (type.present) {
      map['type'] = Variable<String>($DbGoalsTable.$convertertype.toSql(type.value));
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DbGoalsCompanion(')
          ..write('id: $id, ')
          ..write('budgetId: $budgetId, ')
          ..write('name: $name, ')
          ..write('createdDate: $createdDate, ')
          ..write('type: $type')
          ..write(')'))
        .toString();
  }
}

class $DbDebtPayoffGoalsMetadataTable extends DbDebtPayoffGoalsMetadata
    with TableInfo<$DbDebtPayoffGoalsMetadataTable, DbDebtPayoffGoalsMetadataData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DbDebtPayoffGoalsMetadataTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'),
  );
  static const VerificationMeta _goalIdMeta = const VerificationMeta('goalId');
  @override
  late final GeneratedColumn<int> goalId = GeneratedColumn<int>(
    'goal_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetDateMeta = const VerificationMeta('targetDate');
  @override
  late final GeneratedColumn<DateTime> targetDate = GeneratedColumn<DateTime>(
    'target_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, goalId, targetDate];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'db_debt_payoff_goals_metadata';
  @override
  VerificationContext validateIntegrity(
    Insertable<DbDebtPayoffGoalsMetadataData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('goal_id')) {
      context.handle(_goalIdMeta, goalId.isAcceptableOrUnknown(data['goal_id']!, _goalIdMeta));
    } else if (isInserting) {
      context.missing(_goalIdMeta);
    }
    if (data.containsKey('target_date')) {
      context.handle(
        _targetDateMeta,
        targetDate.isAcceptableOrUnknown(data['target_date']!, _targetDateMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DbDebtPayoffGoalsMetadataData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DbDebtPayoffGoalsMetadataData(
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      goalId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}goal_id'],
      )!,
      targetDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}target_date'],
      ),
    );
  }

  @override
  $DbDebtPayoffGoalsMetadataTable createAlias(String alias) {
    return $DbDebtPayoffGoalsMetadataTable(attachedDatabase, alias);
  }
}

class DbDebtPayoffGoalsMetadataData extends DataClass
    implements Insertable<DbDebtPayoffGoalsMetadataData> {
  final int id;
  final int goalId;
  final DateTime? targetDate;
  const DbDebtPayoffGoalsMetadataData({required this.id, required this.goalId, this.targetDate});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['goal_id'] = Variable<int>(goalId);
    if (!nullToAbsent || targetDate != null) {
      map['target_date'] = Variable<DateTime>(targetDate);
    }
    return map;
  }

  DbDebtPayoffGoalsMetadataCompanion toCompanion(bool nullToAbsent) {
    return DbDebtPayoffGoalsMetadataCompanion(
      id: Value(id),
      goalId: Value(goalId),
      targetDate: targetDate == null && nullToAbsent ? const Value.absent() : Value(targetDate),
    );
  }

  factory DbDebtPayoffGoalsMetadataData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DbDebtPayoffGoalsMetadataData(
      id: serializer.fromJson<int>(json['id']),
      goalId: serializer.fromJson<int>(json['goalId']),
      targetDate: serializer.fromJson<DateTime?>(json['targetDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'goalId': serializer.toJson<int>(goalId),
      'targetDate': serializer.toJson<DateTime?>(targetDate),
    };
  }

  DbDebtPayoffGoalsMetadataData copyWith({
    int? id,
    int? goalId,
    Value<DateTime?> targetDate = const Value.absent(),
  }) => DbDebtPayoffGoalsMetadataData(
    id: id ?? this.id,
    goalId: goalId ?? this.goalId,
    targetDate: targetDate.present ? targetDate.value : this.targetDate,
  );
  DbDebtPayoffGoalsMetadataData copyWithCompanion(DbDebtPayoffGoalsMetadataCompanion data) {
    return DbDebtPayoffGoalsMetadataData(
      id: data.id.present ? data.id.value : this.id,
      goalId: data.goalId.present ? data.goalId.value : this.goalId,
      targetDate: data.targetDate.present ? data.targetDate.value : this.targetDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DbDebtPayoffGoalsMetadataData(')
          ..write('id: $id, ')
          ..write('goalId: $goalId, ')
          ..write('targetDate: $targetDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, goalId, targetDate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DbDebtPayoffGoalsMetadataData &&
          other.id == this.id &&
          other.goalId == this.goalId &&
          other.targetDate == this.targetDate);
}

class DbDebtPayoffGoalsMetadataCompanion extends UpdateCompanion<DbDebtPayoffGoalsMetadataData> {
  final Value<int> id;
  final Value<int> goalId;
  final Value<DateTime?> targetDate;
  const DbDebtPayoffGoalsMetadataCompanion({
    this.id = const Value.absent(),
    this.goalId = const Value.absent(),
    this.targetDate = const Value.absent(),
  });
  DbDebtPayoffGoalsMetadataCompanion.insert({
    this.id = const Value.absent(),
    required int goalId,
    this.targetDate = const Value.absent(),
  }) : goalId = Value(goalId);
  static Insertable<DbDebtPayoffGoalsMetadataData> custom({
    Expression<int>? id,
    Expression<int>? goalId,
    Expression<DateTime>? targetDate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (goalId != null) 'goal_id': goalId,
      if (targetDate != null) 'target_date': targetDate,
    });
  }

  DbDebtPayoffGoalsMetadataCompanion copyWith({
    Value<int>? id,
    Value<int>? goalId,
    Value<DateTime?>? targetDate,
  }) {
    return DbDebtPayoffGoalsMetadataCompanion(
      id: id ?? this.id,
      goalId: goalId ?? this.goalId,
      targetDate: targetDate ?? this.targetDate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (goalId.present) {
      map['goal_id'] = Variable<int>(goalId.value);
    }
    if (targetDate.present) {
      map['target_date'] = Variable<DateTime>(targetDate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DbDebtPayoffGoalsMetadataCompanion(')
          ..write('id: $id, ')
          ..write('goalId: $goalId, ')
          ..write('targetDate: $targetDate')
          ..write(')'))
        .toString();
  }
}

class $DbDebtPayoffGoalsAccountsTable extends DbDebtPayoffGoalsAccounts
    with TableInfo<$DbDebtPayoffGoalsAccountsTable, DbDebtPayoffGoalsAccount> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DbDebtPayoffGoalsAccountsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _goalIdMeta = const VerificationMeta('goalId');
  @override
  late final GeneratedColumn<int> goalId = GeneratedColumn<int>(
    'goal_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta('accountId');
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _originalBalanceMeta = const VerificationMeta('originalBalance');
  @override
  late final GeneratedColumn<int> originalBalance = GeneratedColumn<int>(
    'original_balance',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [goalId, accountId, originalBalance];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'db_debt_payoff_goals_accounts';
  @override
  VerificationContext validateIntegrity(
    Insertable<DbDebtPayoffGoalsAccount> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('goal_id')) {
      context.handle(_goalIdMeta, goalId.isAcceptableOrUnknown(data['goal_id']!, _goalIdMeta));
    } else if (isInserting) {
      context.missing(_goalIdMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('original_balance')) {
      context.handle(
        _originalBalanceMeta,
        originalBalance.isAcceptableOrUnknown(data['original_balance']!, _originalBalanceMeta),
      );
    } else if (isInserting) {
      context.missing(_originalBalanceMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {goalId, accountId};
  @override
  DbDebtPayoffGoalsAccount map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DbDebtPayoffGoalsAccount(
      goalId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}goal_id'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_id'],
      )!,
      originalBalance: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}original_balance'],
      )!,
    );
  }

  @override
  $DbDebtPayoffGoalsAccountsTable createAlias(String alias) {
    return $DbDebtPayoffGoalsAccountsTable(attachedDatabase, alias);
  }
}

class DbDebtPayoffGoalsAccount extends DataClass implements Insertable<DbDebtPayoffGoalsAccount> {
  final int goalId;
  final String accountId;
  final int originalBalance;
  const DbDebtPayoffGoalsAccount({
    required this.goalId,
    required this.accountId,
    required this.originalBalance,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['goal_id'] = Variable<int>(goalId);
    map['account_id'] = Variable<String>(accountId);
    map['original_balance'] = Variable<int>(originalBalance);
    return map;
  }

  DbDebtPayoffGoalsAccountsCompanion toCompanion(bool nullToAbsent) {
    return DbDebtPayoffGoalsAccountsCompanion(
      goalId: Value(goalId),
      accountId: Value(accountId),
      originalBalance: Value(originalBalance),
    );
  }

  factory DbDebtPayoffGoalsAccount.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DbDebtPayoffGoalsAccount(
      goalId: serializer.fromJson<int>(json['goalId']),
      accountId: serializer.fromJson<String>(json['accountId']),
      originalBalance: serializer.fromJson<int>(json['originalBalance']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'goalId': serializer.toJson<int>(goalId),
      'accountId': serializer.toJson<String>(accountId),
      'originalBalance': serializer.toJson<int>(originalBalance),
    };
  }

  DbDebtPayoffGoalsAccount copyWith({int? goalId, String? accountId, int? originalBalance}) =>
      DbDebtPayoffGoalsAccount(
        goalId: goalId ?? this.goalId,
        accountId: accountId ?? this.accountId,
        originalBalance: originalBalance ?? this.originalBalance,
      );
  DbDebtPayoffGoalsAccount copyWithCompanion(DbDebtPayoffGoalsAccountsCompanion data) {
    return DbDebtPayoffGoalsAccount(
      goalId: data.goalId.present ? data.goalId.value : this.goalId,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      originalBalance: data.originalBalance.present
          ? data.originalBalance.value
          : this.originalBalance,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DbDebtPayoffGoalsAccount(')
          ..write('goalId: $goalId, ')
          ..write('accountId: $accountId, ')
          ..write('originalBalance: $originalBalance')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(goalId, accountId, originalBalance);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DbDebtPayoffGoalsAccount &&
          other.goalId == this.goalId &&
          other.accountId == this.accountId &&
          other.originalBalance == this.originalBalance);
}

class DbDebtPayoffGoalsAccountsCompanion extends UpdateCompanion<DbDebtPayoffGoalsAccount> {
  final Value<int> goalId;
  final Value<String> accountId;
  final Value<int> originalBalance;
  final Value<int> rowid;
  const DbDebtPayoffGoalsAccountsCompanion({
    this.goalId = const Value.absent(),
    this.accountId = const Value.absent(),
    this.originalBalance = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DbDebtPayoffGoalsAccountsCompanion.insert({
    required int goalId,
    required String accountId,
    required int originalBalance,
    this.rowid = const Value.absent(),
  }) : goalId = Value(goalId),
       accountId = Value(accountId),
       originalBalance = Value(originalBalance);
  static Insertable<DbDebtPayoffGoalsAccount> custom({
    Expression<int>? goalId,
    Expression<String>? accountId,
    Expression<int>? originalBalance,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (goalId != null) 'goal_id': goalId,
      if (accountId != null) 'account_id': accountId,
      if (originalBalance != null) 'original_balance': originalBalance,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DbDebtPayoffGoalsAccountsCompanion copyWith({
    Value<int>? goalId,
    Value<String>? accountId,
    Value<int>? originalBalance,
    Value<int>? rowid,
  }) {
    return DbDebtPayoffGoalsAccountsCompanion(
      goalId: goalId ?? this.goalId,
      accountId: accountId ?? this.accountId,
      originalBalance: originalBalance ?? this.originalBalance,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (goalId.present) {
      map['goal_id'] = Variable<int>(goalId.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (originalBalance.present) {
      map['original_balance'] = Variable<int>(originalBalance.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DbDebtPayoffGoalsAccountsCompanion(')
          ..write('goalId: $goalId, ')
          ..write('accountId: $accountId, ')
          ..write('originalBalance: $originalBalance, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$LocalDatabase extends GeneratedDatabase {
  _$LocalDatabase(QueryExecutor e) : super(e);
  $LocalDatabaseManager get managers => $LocalDatabaseManager(this);
  late final $DbBudgetsTable dbBudgets = $DbBudgetsTable(this);
  late final $DbCurrencyFormatsTable dbCurrencyFormats = $DbCurrencyFormatsTable(this);
  late final $DbAccountsTable dbAccounts = $DbAccountsTable(this);
  late final $DbAccountInterestRatesTable dbAccountInterestRates = $DbAccountInterestRatesTable(
    this,
  );
  late final $DbAccountMinimumPaymentsTable dbAccountMinimumPayments =
      $DbAccountMinimumPaymentsTable(this);
  late final $DbAccountEscrowAmountsTable dbAccountEscrowAmounts = $DbAccountEscrowAmountsTable(
    this,
  );
  late final $DbPayeesTable dbPayees = $DbPayeesTable(this);
  late final $DbCategoryGroupsTable dbCategoryGroups = $DbCategoryGroupsTable(this);
  late final $DbCategoriesTable dbCategories = $DbCategoriesTable(this);
  late final $DbTransactionsTable dbTransactions = $DbTransactionsTable(this);
  late final $DbSubTransactionsTable dbSubTransactions = $DbSubTransactionsTable(this);
  late final $DbScheduledTransactionsTable dbScheduledTransactions = $DbScheduledTransactionsTable(
    this,
  );
  late final $DbScheduledSubTransactionsTable dbScheduledSubTransactions =
      $DbScheduledSubTransactionsTable(this);
  late final $DbMonthsTable dbMonths = $DbMonthsTable(this);
  late final $DbAccountKnowledgesTable dbAccountKnowledges = $DbAccountKnowledgesTable(this);
  late final $DbCategoryKnowledgesTable dbCategoryKnowledges = $DbCategoryKnowledgesTable(this);
  late final $DbPayeeKnowledgesTable dbPayeeKnowledges = $DbPayeeKnowledgesTable(this);
  late final $DbTransactionKnowledgesTable dbTransactionKnowledges = $DbTransactionKnowledgesTable(
    this,
  );
  late final $DbScheduledTransactionKnowledgesTable dbScheduledTransactionKnowledges =
      $DbScheduledTransactionKnowledgesTable(this);
  late final $DbMonthKnowledgesTable dbMonthKnowledges = $DbMonthKnowledgesTable(this);
  late final $DbCategoryViewsTable dbCategoryViews = $DbCategoryViewsTable(this);
  late final $DbCategoryViewCategoriesTable dbCategoryViewCategories =
      $DbCategoryViewCategoriesTable(this);
  late final $DbCategoryViewCategoryGroupsTable dbCategoryViewCategoryGroups =
      $DbCategoryViewCategoryGroupsTable(this);
  late final $DbLegacySpendTrackersTable dbLegacySpendTrackers = $DbLegacySpendTrackersTable(this);
  late final $DbQuerySpendTrackersTable dbQuerySpendTrackers = $DbQuerySpendTrackersTable(this);
  late final $DbSpendTrackerConditionsTable dbSpendTrackerConditions =
      $DbSpendTrackerConditionsTable(this);
  late final $DbSpendTrackerTestsTable dbSpendTrackerTests = $DbSpendTrackerTestsTable(this);
  late final $DbFrugalMonthsTable dbFrugalMonths = $DbFrugalMonthsTable(this);
  late final $DbFrugalMonthCategoriesTable dbFrugalMonthCategories = $DbFrugalMonthCategoriesTable(
    this,
  );
  late final $DbFrugalMonthAccountsTable dbFrugalMonthAccounts = $DbFrugalMonthAccountsTable(this);
  late final $DbGoalsTable dbGoals = $DbGoalsTable(this);
  late final $DbDebtPayoffGoalsMetadataTable dbDebtPayoffGoalsMetadata =
      $DbDebtPayoffGoalsMetadataTable(this);
  late final $DbDebtPayoffGoalsAccountsTable dbDebtPayoffGoalsAccounts =
      $DbDebtPayoffGoalsAccountsTable(this);
  late final Index idxTxn = Index(
    'idx_txn',
    'CREATE INDEX idx_txn ON db_transactions (budget_id, is_deleted)',
  );
  late final Index idxTxnBudgetDeletedDate = Index(
    'idx_txn_budget_deleted_date',
    'CREATE INDEX idx_txn_budget_deleted_date ON db_transactions (budget_id, is_deleted, date)',
  );
  late final Index idxSubTxn = Index(
    'idx_sub_txn',
    'CREATE INDEX idx_sub_txn ON db_sub_transactions (budget_id, transaction_id, is_deleted)',
  );
  late final Index idxSubTxnJoin = Index(
    'idx_sub_txn_join',
    'CREATE INDEX idx_sub_txn_join ON db_sub_transactions (transaction_id, is_deleted)',
  );
  late final Index idxScheduledTxn = Index(
    'idx_scheduled_txn',
    'CREATE INDEX idx_scheduled_txn ON db_scheduled_transactions (budget_id, is_deleted)',
  );
  late final Index idxScheduledSubTxn = Index(
    'idx_scheduled_sub_txn',
    'CREATE INDEX idx_scheduled_sub_txn ON db_scheduled_sub_transactions (budget_id, scheduled_transaction_id, is_deleted)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    dbBudgets,
    dbCurrencyFormats,
    dbAccounts,
    dbAccountInterestRates,
    dbAccountMinimumPayments,
    dbAccountEscrowAmounts,
    dbPayees,
    dbCategoryGroups,
    dbCategories,
    dbTransactions,
    dbSubTransactions,
    dbScheduledTransactions,
    dbScheduledSubTransactions,
    dbMonths,
    dbAccountKnowledges,
    dbCategoryKnowledges,
    dbPayeeKnowledges,
    dbTransactionKnowledges,
    dbScheduledTransactionKnowledges,
    dbMonthKnowledges,
    dbCategoryViews,
    dbCategoryViewCategories,
    dbCategoryViewCategoryGroups,
    dbLegacySpendTrackers,
    dbQuerySpendTrackers,
    dbSpendTrackerConditions,
    dbSpendTrackerTests,
    dbFrugalMonths,
    dbFrugalMonthCategories,
    dbFrugalMonthAccounts,
    dbGoals,
    dbDebtPayoffGoalsMetadata,
    dbDebtPayoffGoalsAccounts,
    idxTxn,
    idxTxnBudgetDeletedDate,
    idxSubTxn,
    idxSubTxnJoin,
    idxScheduledTxn,
    idxScheduledSubTxn,
  ];
}

typedef $$DbBudgetsTableCreateCompanionBuilder =
    DbBudgetsCompanion Function({
      required String uuid,
      required String name,
      Value<String?> firstMonth,
      Value<String?> lastMonth,
      Value<String?> lastModifiedOn,
      Value<int> rowid,
    });
typedef $$DbBudgetsTableUpdateCompanionBuilder =
    DbBudgetsCompanion Function({
      Value<String> uuid,
      Value<String> name,
      Value<String?> firstMonth,
      Value<String?> lastMonth,
      Value<String?> lastModifiedOn,
      Value<int> rowid,
    });

class $$DbBudgetsTableFilterComposer extends Composer<_$LocalDatabase, $DbBudgetsTable> {
  $$DbBudgetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get firstMonth =>
      $composableBuilder(column: $table.firstMonth, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastMonth =>
      $composableBuilder(column: $table.lastMonth, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastModifiedOn =>
      $composableBuilder(column: $table.lastModifiedOn, builder: (column) => ColumnFilters(column));
}

class $$DbBudgetsTableOrderingComposer extends Composer<_$LocalDatabase, $DbBudgetsTable> {
  $$DbBudgetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get firstMonth =>
      $composableBuilder(column: $table.firstMonth, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastMonth =>
      $composableBuilder(column: $table.lastMonth, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastModifiedOn => $composableBuilder(
    column: $table.lastModifiedOn,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DbBudgetsTableAnnotationComposer extends Composer<_$LocalDatabase, $DbBudgetsTable> {
  $$DbBudgetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get firstMonth =>
      $composableBuilder(column: $table.firstMonth, builder: (column) => column);

  GeneratedColumn<String> get lastMonth =>
      $composableBuilder(column: $table.lastMonth, builder: (column) => column);

  GeneratedColumn<String> get lastModifiedOn =>
      $composableBuilder(column: $table.lastModifiedOn, builder: (column) => column);
}

class $$DbBudgetsTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $DbBudgetsTable,
          DbBudget,
          $$DbBudgetsTableFilterComposer,
          $$DbBudgetsTableOrderingComposer,
          $$DbBudgetsTableAnnotationComposer,
          $$DbBudgetsTableCreateCompanionBuilder,
          $$DbBudgetsTableUpdateCompanionBuilder,
          (DbBudget, BaseReferences<_$LocalDatabase, $DbBudgetsTable, DbBudget>),
          DbBudget,
          PrefetchHooks Function()
        > {
  $$DbBudgetsTableTableManager(_$LocalDatabase db, $DbBudgetsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$DbBudgetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$DbBudgetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DbBudgetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> uuid = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> firstMonth = const Value.absent(),
                Value<String?> lastMonth = const Value.absent(),
                Value<String?> lastModifiedOn = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DbBudgetsCompanion(
                uuid: uuid,
                name: name,
                firstMonth: firstMonth,
                lastMonth: lastMonth,
                lastModifiedOn: lastModifiedOn,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String uuid,
                required String name,
                Value<String?> firstMonth = const Value.absent(),
                Value<String?> lastMonth = const Value.absent(),
                Value<String?> lastModifiedOn = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DbBudgetsCompanion.insert(
                uuid: uuid,
                name: name,
                firstMonth: firstMonth,
                lastMonth: lastMonth,
                lastModifiedOn: lastModifiedOn,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) =>
              p0.map((e) => (e.readTable(table), BaseReferences(db, table, e))).toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DbBudgetsTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $DbBudgetsTable,
      DbBudget,
      $$DbBudgetsTableFilterComposer,
      $$DbBudgetsTableOrderingComposer,
      $$DbBudgetsTableAnnotationComposer,
      $$DbBudgetsTableCreateCompanionBuilder,
      $$DbBudgetsTableUpdateCompanionBuilder,
      (DbBudget, BaseReferences<_$LocalDatabase, $DbBudgetsTable, DbBudget>),
      DbBudget,
      PrefetchHooks Function()
    >;
typedef $$DbCurrencyFormatsTableCreateCompanionBuilder =
    DbCurrencyFormatsCompanion Function({
      required String budgetId,
      required String isoCode,
      required int decimalDigits,
      required String decimalSeparator,
      required bool isSymbolFirst,
      required String groupSeparator,
      required String currencySymbol,
      required bool shouldDisplaySymbol,
      required String exampleFormat,
      Value<int> rowid,
    });
typedef $$DbCurrencyFormatsTableUpdateCompanionBuilder =
    DbCurrencyFormatsCompanion Function({
      Value<String> budgetId,
      Value<String> isoCode,
      Value<int> decimalDigits,
      Value<String> decimalSeparator,
      Value<bool> isSymbolFirst,
      Value<String> groupSeparator,
      Value<String> currencySymbol,
      Value<bool> shouldDisplaySymbol,
      Value<String> exampleFormat,
      Value<int> rowid,
    });

class $$DbCurrencyFormatsTableFilterComposer
    extends Composer<_$LocalDatabase, $DbCurrencyFormatsTable> {
  $$DbCurrencyFormatsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get budgetId =>
      $composableBuilder(column: $table.budgetId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get isoCode =>
      $composableBuilder(column: $table.isoCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get decimalDigits =>
      $composableBuilder(column: $table.decimalDigits, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get decimalSeparator => $composableBuilder(
    column: $table.decimalSeparator,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSymbolFirst =>
      $composableBuilder(column: $table.isSymbolFirst, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get groupSeparator =>
      $composableBuilder(column: $table.groupSeparator, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get currencySymbol =>
      $composableBuilder(column: $table.currencySymbol, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get shouldDisplaySymbol => $composableBuilder(
    column: $table.shouldDisplaySymbol,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exampleFormat =>
      $composableBuilder(column: $table.exampleFormat, builder: (column) => ColumnFilters(column));
}

class $$DbCurrencyFormatsTableOrderingComposer
    extends Composer<_$LocalDatabase, $DbCurrencyFormatsTable> {
  $$DbCurrencyFormatsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get budgetId =>
      $composableBuilder(column: $table.budgetId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get isoCode =>
      $composableBuilder(column: $table.isoCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get decimalDigits => $composableBuilder(
    column: $table.decimalDigits,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get decimalSeparator => $composableBuilder(
    column: $table.decimalSeparator,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSymbolFirst => $composableBuilder(
    column: $table.isSymbolFirst,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get groupSeparator => $composableBuilder(
    column: $table.groupSeparator,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currencySymbol => $composableBuilder(
    column: $table.currencySymbol,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get shouldDisplaySymbol => $composableBuilder(
    column: $table.shouldDisplaySymbol,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exampleFormat => $composableBuilder(
    column: $table.exampleFormat,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DbCurrencyFormatsTableAnnotationComposer
    extends Composer<_$LocalDatabase, $DbCurrencyFormatsTable> {
  $$DbCurrencyFormatsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get budgetId =>
      $composableBuilder(column: $table.budgetId, builder: (column) => column);

  GeneratedColumn<String> get isoCode =>
      $composableBuilder(column: $table.isoCode, builder: (column) => column);

  GeneratedColumn<int> get decimalDigits =>
      $composableBuilder(column: $table.decimalDigits, builder: (column) => column);

  GeneratedColumn<String> get decimalSeparator =>
      $composableBuilder(column: $table.decimalSeparator, builder: (column) => column);

  GeneratedColumn<bool> get isSymbolFirst =>
      $composableBuilder(column: $table.isSymbolFirst, builder: (column) => column);

  GeneratedColumn<String> get groupSeparator =>
      $composableBuilder(column: $table.groupSeparator, builder: (column) => column);

  GeneratedColumn<String> get currencySymbol =>
      $composableBuilder(column: $table.currencySymbol, builder: (column) => column);

  GeneratedColumn<bool> get shouldDisplaySymbol =>
      $composableBuilder(column: $table.shouldDisplaySymbol, builder: (column) => column);

  GeneratedColumn<String> get exampleFormat =>
      $composableBuilder(column: $table.exampleFormat, builder: (column) => column);
}

class $$DbCurrencyFormatsTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $DbCurrencyFormatsTable,
          DbCurrencyFormat,
          $$DbCurrencyFormatsTableFilterComposer,
          $$DbCurrencyFormatsTableOrderingComposer,
          $$DbCurrencyFormatsTableAnnotationComposer,
          $$DbCurrencyFormatsTableCreateCompanionBuilder,
          $$DbCurrencyFormatsTableUpdateCompanionBuilder,
          (
            DbCurrencyFormat,
            BaseReferences<_$LocalDatabase, $DbCurrencyFormatsTable, DbCurrencyFormat>,
          ),
          DbCurrencyFormat,
          PrefetchHooks Function()
        > {
  $$DbCurrencyFormatsTableTableManager(_$LocalDatabase db, $DbCurrencyFormatsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DbCurrencyFormatsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DbCurrencyFormatsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DbCurrencyFormatsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> budgetId = const Value.absent(),
                Value<String> isoCode = const Value.absent(),
                Value<int> decimalDigits = const Value.absent(),
                Value<String> decimalSeparator = const Value.absent(),
                Value<bool> isSymbolFirst = const Value.absent(),
                Value<String> groupSeparator = const Value.absent(),
                Value<String> currencySymbol = const Value.absent(),
                Value<bool> shouldDisplaySymbol = const Value.absent(),
                Value<String> exampleFormat = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DbCurrencyFormatsCompanion(
                budgetId: budgetId,
                isoCode: isoCode,
                decimalDigits: decimalDigits,
                decimalSeparator: decimalSeparator,
                isSymbolFirst: isSymbolFirst,
                groupSeparator: groupSeparator,
                currencySymbol: currencySymbol,
                shouldDisplaySymbol: shouldDisplaySymbol,
                exampleFormat: exampleFormat,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String budgetId,
                required String isoCode,
                required int decimalDigits,
                required String decimalSeparator,
                required bool isSymbolFirst,
                required String groupSeparator,
                required String currencySymbol,
                required bool shouldDisplaySymbol,
                required String exampleFormat,
                Value<int> rowid = const Value.absent(),
              }) => DbCurrencyFormatsCompanion.insert(
                budgetId: budgetId,
                isoCode: isoCode,
                decimalDigits: decimalDigits,
                decimalSeparator: decimalSeparator,
                isSymbolFirst: isSymbolFirst,
                groupSeparator: groupSeparator,
                currencySymbol: currencySymbol,
                shouldDisplaySymbol: shouldDisplaySymbol,
                exampleFormat: exampleFormat,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) =>
              p0.map((e) => (e.readTable(table), BaseReferences(db, table, e))).toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DbCurrencyFormatsTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $DbCurrencyFormatsTable,
      DbCurrencyFormat,
      $$DbCurrencyFormatsTableFilterComposer,
      $$DbCurrencyFormatsTableOrderingComposer,
      $$DbCurrencyFormatsTableAnnotationComposer,
      $$DbCurrencyFormatsTableCreateCompanionBuilder,
      $$DbCurrencyFormatsTableUpdateCompanionBuilder,
      (
        DbCurrencyFormat,
        BaseReferences<_$LocalDatabase, $DbCurrencyFormatsTable, DbCurrencyFormat>,
      ),
      DbCurrencyFormat,
      PrefetchHooks Function()
    >;
typedef $$DbAccountsTableCreateCompanionBuilder =
    DbAccountsCompanion Function({
      required String uuid,
      required String budgetId,
      required int balance,
      required String name,
      required AccountType type,
      required bool isOnBudget,
      required bool isClosed,
      required bool isDeleted,
      Value<int> rowid,
    });
typedef $$DbAccountsTableUpdateCompanionBuilder =
    DbAccountsCompanion Function({
      Value<String> uuid,
      Value<String> budgetId,
      Value<int> balance,
      Value<String> name,
      Value<AccountType> type,
      Value<bool> isOnBudget,
      Value<bool> isClosed,
      Value<bool> isDeleted,
      Value<int> rowid,
    });

class $$DbAccountsTableFilterComposer extends Composer<_$LocalDatabase, $DbAccountsTable> {
  $$DbAccountsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get budgetId =>
      $composableBuilder(column: $table.budgetId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get balance =>
      $composableBuilder(column: $table.balance, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<AccountType, AccountType, String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<bool> get isOnBudget =>
      $composableBuilder(column: $table.isOnBudget, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isClosed =>
      $composableBuilder(column: $table.isClosed, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => ColumnFilters(column));
}

class $$DbAccountsTableOrderingComposer extends Composer<_$LocalDatabase, $DbAccountsTable> {
  $$DbAccountsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get budgetId =>
      $composableBuilder(column: $table.budgetId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get balance =>
      $composableBuilder(column: $table.balance, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isOnBudget =>
      $composableBuilder(column: $table.isOnBudget, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isClosed =>
      $composableBuilder(column: $table.isClosed, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => ColumnOrderings(column));
}

class $$DbAccountsTableAnnotationComposer extends Composer<_$LocalDatabase, $DbAccountsTable> {
  $$DbAccountsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<String> get budgetId =>
      $composableBuilder(column: $table.budgetId, builder: (column) => column);

  GeneratedColumn<int> get balance =>
      $composableBuilder(column: $table.balance, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumnWithTypeConverter<AccountType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<bool> get isOnBudget =>
      $composableBuilder(column: $table.isOnBudget, builder: (column) => column);

  GeneratedColumn<bool> get isClosed =>
      $composableBuilder(column: $table.isClosed, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);
}

class $$DbAccountsTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $DbAccountsTable,
          DbAccount,
          $$DbAccountsTableFilterComposer,
          $$DbAccountsTableOrderingComposer,
          $$DbAccountsTableAnnotationComposer,
          $$DbAccountsTableCreateCompanionBuilder,
          $$DbAccountsTableUpdateCompanionBuilder,
          (DbAccount, BaseReferences<_$LocalDatabase, $DbAccountsTable, DbAccount>),
          DbAccount,
          PrefetchHooks Function()
        > {
  $$DbAccountsTableTableManager(_$LocalDatabase db, $DbAccountsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$DbAccountsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$DbAccountsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DbAccountsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> uuid = const Value.absent(),
                Value<String> budgetId = const Value.absent(),
                Value<int> balance = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<AccountType> type = const Value.absent(),
                Value<bool> isOnBudget = const Value.absent(),
                Value<bool> isClosed = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DbAccountsCompanion(
                uuid: uuid,
                budgetId: budgetId,
                balance: balance,
                name: name,
                type: type,
                isOnBudget: isOnBudget,
                isClosed: isClosed,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String uuid,
                required String budgetId,
                required int balance,
                required String name,
                required AccountType type,
                required bool isOnBudget,
                required bool isClosed,
                required bool isDeleted,
                Value<int> rowid = const Value.absent(),
              }) => DbAccountsCompanion.insert(
                uuid: uuid,
                budgetId: budgetId,
                balance: balance,
                name: name,
                type: type,
                isOnBudget: isOnBudget,
                isClosed: isClosed,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) =>
              p0.map((e) => (e.readTable(table), BaseReferences(db, table, e))).toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DbAccountsTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $DbAccountsTable,
      DbAccount,
      $$DbAccountsTableFilterComposer,
      $$DbAccountsTableOrderingComposer,
      $$DbAccountsTableAnnotationComposer,
      $$DbAccountsTableCreateCompanionBuilder,
      $$DbAccountsTableUpdateCompanionBuilder,
      (DbAccount, BaseReferences<_$LocalDatabase, $DbAccountsTable, DbAccount>),
      DbAccount,
      PrefetchHooks Function()
    >;
typedef $$DbAccountInterestRatesTableCreateCompanionBuilder =
    DbAccountInterestRatesCompanion Function({
      required String budgetId,
      required String accountId,
      required String month,
      required int interestRate,
      Value<int> rowid,
    });
typedef $$DbAccountInterestRatesTableUpdateCompanionBuilder =
    DbAccountInterestRatesCompanion Function({
      Value<String> budgetId,
      Value<String> accountId,
      Value<String> month,
      Value<int> interestRate,
      Value<int> rowid,
    });

class $$DbAccountInterestRatesTableFilterComposer
    extends Composer<_$LocalDatabase, $DbAccountInterestRatesTable> {
  $$DbAccountInterestRatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get budgetId =>
      $composableBuilder(column: $table.budgetId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get month =>
      $composableBuilder(column: $table.month, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get interestRate =>
      $composableBuilder(column: $table.interestRate, builder: (column) => ColumnFilters(column));
}

class $$DbAccountInterestRatesTableOrderingComposer
    extends Composer<_$LocalDatabase, $DbAccountInterestRatesTable> {
  $$DbAccountInterestRatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get budgetId =>
      $composableBuilder(column: $table.budgetId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get month =>
      $composableBuilder(column: $table.month, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get interestRate =>
      $composableBuilder(column: $table.interestRate, builder: (column) => ColumnOrderings(column));
}

class $$DbAccountInterestRatesTableAnnotationComposer
    extends Composer<_$LocalDatabase, $DbAccountInterestRatesTable> {
  $$DbAccountInterestRatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get budgetId =>
      $composableBuilder(column: $table.budgetId, builder: (column) => column);

  GeneratedColumn<String> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<String> get month =>
      $composableBuilder(column: $table.month, builder: (column) => column);

  GeneratedColumn<int> get interestRate =>
      $composableBuilder(column: $table.interestRate, builder: (column) => column);
}

class $$DbAccountInterestRatesTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $DbAccountInterestRatesTable,
          DbAccountInterestRate,
          $$DbAccountInterestRatesTableFilterComposer,
          $$DbAccountInterestRatesTableOrderingComposer,
          $$DbAccountInterestRatesTableAnnotationComposer,
          $$DbAccountInterestRatesTableCreateCompanionBuilder,
          $$DbAccountInterestRatesTableUpdateCompanionBuilder,
          (
            DbAccountInterestRate,
            BaseReferences<_$LocalDatabase, $DbAccountInterestRatesTable, DbAccountInterestRate>,
          ),
          DbAccountInterestRate,
          PrefetchHooks Function()
        > {
  $$DbAccountInterestRatesTableTableManager(_$LocalDatabase db, $DbAccountInterestRatesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DbAccountInterestRatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DbAccountInterestRatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DbAccountInterestRatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> budgetId = const Value.absent(),
                Value<String> accountId = const Value.absent(),
                Value<String> month = const Value.absent(),
                Value<int> interestRate = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DbAccountInterestRatesCompanion(
                budgetId: budgetId,
                accountId: accountId,
                month: month,
                interestRate: interestRate,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String budgetId,
                required String accountId,
                required String month,
                required int interestRate,
                Value<int> rowid = const Value.absent(),
              }) => DbAccountInterestRatesCompanion.insert(
                budgetId: budgetId,
                accountId: accountId,
                month: month,
                interestRate: interestRate,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) =>
              p0.map((e) => (e.readTable(table), BaseReferences(db, table, e))).toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DbAccountInterestRatesTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $DbAccountInterestRatesTable,
      DbAccountInterestRate,
      $$DbAccountInterestRatesTableFilterComposer,
      $$DbAccountInterestRatesTableOrderingComposer,
      $$DbAccountInterestRatesTableAnnotationComposer,
      $$DbAccountInterestRatesTableCreateCompanionBuilder,
      $$DbAccountInterestRatesTableUpdateCompanionBuilder,
      (
        DbAccountInterestRate,
        BaseReferences<_$LocalDatabase, $DbAccountInterestRatesTable, DbAccountInterestRate>,
      ),
      DbAccountInterestRate,
      PrefetchHooks Function()
    >;
typedef $$DbAccountMinimumPaymentsTableCreateCompanionBuilder =
    DbAccountMinimumPaymentsCompanion Function({
      required String budgetId,
      required String accountId,
      required String month,
      required int mininumPayment,
      Value<int> rowid,
    });
typedef $$DbAccountMinimumPaymentsTableUpdateCompanionBuilder =
    DbAccountMinimumPaymentsCompanion Function({
      Value<String> budgetId,
      Value<String> accountId,
      Value<String> month,
      Value<int> mininumPayment,
      Value<int> rowid,
    });

class $$DbAccountMinimumPaymentsTableFilterComposer
    extends Composer<_$LocalDatabase, $DbAccountMinimumPaymentsTable> {
  $$DbAccountMinimumPaymentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get budgetId =>
      $composableBuilder(column: $table.budgetId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get month =>
      $composableBuilder(column: $table.month, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get mininumPayment =>
      $composableBuilder(column: $table.mininumPayment, builder: (column) => ColumnFilters(column));
}

class $$DbAccountMinimumPaymentsTableOrderingComposer
    extends Composer<_$LocalDatabase, $DbAccountMinimumPaymentsTable> {
  $$DbAccountMinimumPaymentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get budgetId =>
      $composableBuilder(column: $table.budgetId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get month =>
      $composableBuilder(column: $table.month, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get mininumPayment => $composableBuilder(
    column: $table.mininumPayment,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DbAccountMinimumPaymentsTableAnnotationComposer
    extends Composer<_$LocalDatabase, $DbAccountMinimumPaymentsTable> {
  $$DbAccountMinimumPaymentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get budgetId =>
      $composableBuilder(column: $table.budgetId, builder: (column) => column);

  GeneratedColumn<String> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<String> get month =>
      $composableBuilder(column: $table.month, builder: (column) => column);

  GeneratedColumn<int> get mininumPayment =>
      $composableBuilder(column: $table.mininumPayment, builder: (column) => column);
}

class $$DbAccountMinimumPaymentsTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $DbAccountMinimumPaymentsTable,
          DbAccountMinimumPayment,
          $$DbAccountMinimumPaymentsTableFilterComposer,
          $$DbAccountMinimumPaymentsTableOrderingComposer,
          $$DbAccountMinimumPaymentsTableAnnotationComposer,
          $$DbAccountMinimumPaymentsTableCreateCompanionBuilder,
          $$DbAccountMinimumPaymentsTableUpdateCompanionBuilder,
          (
            DbAccountMinimumPayment,
            BaseReferences<
              _$LocalDatabase,
              $DbAccountMinimumPaymentsTable,
              DbAccountMinimumPayment
            >,
          ),
          DbAccountMinimumPayment,
          PrefetchHooks Function()
        > {
  $$DbAccountMinimumPaymentsTableTableManager(
    _$LocalDatabase db,
    $DbAccountMinimumPaymentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DbAccountMinimumPaymentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DbAccountMinimumPaymentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DbAccountMinimumPaymentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> budgetId = const Value.absent(),
                Value<String> accountId = const Value.absent(),
                Value<String> month = const Value.absent(),
                Value<int> mininumPayment = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DbAccountMinimumPaymentsCompanion(
                budgetId: budgetId,
                accountId: accountId,
                month: month,
                mininumPayment: mininumPayment,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String budgetId,
                required String accountId,
                required String month,
                required int mininumPayment,
                Value<int> rowid = const Value.absent(),
              }) => DbAccountMinimumPaymentsCompanion.insert(
                budgetId: budgetId,
                accountId: accountId,
                month: month,
                mininumPayment: mininumPayment,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) =>
              p0.map((e) => (e.readTable(table), BaseReferences(db, table, e))).toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DbAccountMinimumPaymentsTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $DbAccountMinimumPaymentsTable,
      DbAccountMinimumPayment,
      $$DbAccountMinimumPaymentsTableFilterComposer,
      $$DbAccountMinimumPaymentsTableOrderingComposer,
      $$DbAccountMinimumPaymentsTableAnnotationComposer,
      $$DbAccountMinimumPaymentsTableCreateCompanionBuilder,
      $$DbAccountMinimumPaymentsTableUpdateCompanionBuilder,
      (
        DbAccountMinimumPayment,
        BaseReferences<_$LocalDatabase, $DbAccountMinimumPaymentsTable, DbAccountMinimumPayment>,
      ),
      DbAccountMinimumPayment,
      PrefetchHooks Function()
    >;
typedef $$DbAccountEscrowAmountsTableCreateCompanionBuilder =
    DbAccountEscrowAmountsCompanion Function({
      required String budgetId,
      required String accountId,
      required String month,
      required int escrowPayment,
      Value<int> rowid,
    });
typedef $$DbAccountEscrowAmountsTableUpdateCompanionBuilder =
    DbAccountEscrowAmountsCompanion Function({
      Value<String> budgetId,
      Value<String> accountId,
      Value<String> month,
      Value<int> escrowPayment,
      Value<int> rowid,
    });

class $$DbAccountEscrowAmountsTableFilterComposer
    extends Composer<_$LocalDatabase, $DbAccountEscrowAmountsTable> {
  $$DbAccountEscrowAmountsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get budgetId =>
      $composableBuilder(column: $table.budgetId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get month =>
      $composableBuilder(column: $table.month, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get escrowPayment =>
      $composableBuilder(column: $table.escrowPayment, builder: (column) => ColumnFilters(column));
}

class $$DbAccountEscrowAmountsTableOrderingComposer
    extends Composer<_$LocalDatabase, $DbAccountEscrowAmountsTable> {
  $$DbAccountEscrowAmountsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get budgetId =>
      $composableBuilder(column: $table.budgetId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get month =>
      $composableBuilder(column: $table.month, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get escrowPayment => $composableBuilder(
    column: $table.escrowPayment,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DbAccountEscrowAmountsTableAnnotationComposer
    extends Composer<_$LocalDatabase, $DbAccountEscrowAmountsTable> {
  $$DbAccountEscrowAmountsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get budgetId =>
      $composableBuilder(column: $table.budgetId, builder: (column) => column);

  GeneratedColumn<String> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<String> get month =>
      $composableBuilder(column: $table.month, builder: (column) => column);

  GeneratedColumn<int> get escrowPayment =>
      $composableBuilder(column: $table.escrowPayment, builder: (column) => column);
}

class $$DbAccountEscrowAmountsTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $DbAccountEscrowAmountsTable,
          DbAccountEscrowAmount,
          $$DbAccountEscrowAmountsTableFilterComposer,
          $$DbAccountEscrowAmountsTableOrderingComposer,
          $$DbAccountEscrowAmountsTableAnnotationComposer,
          $$DbAccountEscrowAmountsTableCreateCompanionBuilder,
          $$DbAccountEscrowAmountsTableUpdateCompanionBuilder,
          (
            DbAccountEscrowAmount,
            BaseReferences<_$LocalDatabase, $DbAccountEscrowAmountsTable, DbAccountEscrowAmount>,
          ),
          DbAccountEscrowAmount,
          PrefetchHooks Function()
        > {
  $$DbAccountEscrowAmountsTableTableManager(_$LocalDatabase db, $DbAccountEscrowAmountsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DbAccountEscrowAmountsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DbAccountEscrowAmountsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DbAccountEscrowAmountsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> budgetId = const Value.absent(),
                Value<String> accountId = const Value.absent(),
                Value<String> month = const Value.absent(),
                Value<int> escrowPayment = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DbAccountEscrowAmountsCompanion(
                budgetId: budgetId,
                accountId: accountId,
                month: month,
                escrowPayment: escrowPayment,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String budgetId,
                required String accountId,
                required String month,
                required int escrowPayment,
                Value<int> rowid = const Value.absent(),
              }) => DbAccountEscrowAmountsCompanion.insert(
                budgetId: budgetId,
                accountId: accountId,
                month: month,
                escrowPayment: escrowPayment,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) =>
              p0.map((e) => (e.readTable(table), BaseReferences(db, table, e))).toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DbAccountEscrowAmountsTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $DbAccountEscrowAmountsTable,
      DbAccountEscrowAmount,
      $$DbAccountEscrowAmountsTableFilterComposer,
      $$DbAccountEscrowAmountsTableOrderingComposer,
      $$DbAccountEscrowAmountsTableAnnotationComposer,
      $$DbAccountEscrowAmountsTableCreateCompanionBuilder,
      $$DbAccountEscrowAmountsTableUpdateCompanionBuilder,
      (
        DbAccountEscrowAmount,
        BaseReferences<_$LocalDatabase, $DbAccountEscrowAmountsTable, DbAccountEscrowAmount>,
      ),
      DbAccountEscrowAmount,
      PrefetchHooks Function()
    >;
typedef $$DbPayeesTableCreateCompanionBuilder =
    DbPayeesCompanion Function({
      required String uuid,
      required String budgetId,
      required String name,
      required bool deleted,
      Value<int> rowid,
    });
typedef $$DbPayeesTableUpdateCompanionBuilder =
    DbPayeesCompanion Function({
      Value<String> uuid,
      Value<String> budgetId,
      Value<String> name,
      Value<bool> deleted,
      Value<int> rowid,
    });

class $$DbPayeesTableFilterComposer extends Composer<_$LocalDatabase, $DbPayeesTable> {
  $$DbPayeesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get budgetId =>
      $composableBuilder(column: $table.budgetId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => ColumnFilters(column));
}

class $$DbPayeesTableOrderingComposer extends Composer<_$LocalDatabase, $DbPayeesTable> {
  $$DbPayeesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get budgetId =>
      $composableBuilder(column: $table.budgetId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => ColumnOrderings(column));
}

class $$DbPayeesTableAnnotationComposer extends Composer<_$LocalDatabase, $DbPayeesTable> {
  $$DbPayeesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<String> get budgetId =>
      $composableBuilder(column: $table.budgetId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);
}

class $$DbPayeesTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $DbPayeesTable,
          DbPayee,
          $$DbPayeesTableFilterComposer,
          $$DbPayeesTableOrderingComposer,
          $$DbPayeesTableAnnotationComposer,
          $$DbPayeesTableCreateCompanionBuilder,
          $$DbPayeesTableUpdateCompanionBuilder,
          (DbPayee, BaseReferences<_$LocalDatabase, $DbPayeesTable, DbPayee>),
          DbPayee,
          PrefetchHooks Function()
        > {
  $$DbPayeesTableTableManager(_$LocalDatabase db, $DbPayeesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$DbPayeesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$DbPayeesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DbPayeesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> uuid = const Value.absent(),
                Value<String> budgetId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DbPayeesCompanion(
                uuid: uuid,
                budgetId: budgetId,
                name: name,
                deleted: deleted,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String uuid,
                required String budgetId,
                required String name,
                required bool deleted,
                Value<int> rowid = const Value.absent(),
              }) => DbPayeesCompanion.insert(
                uuid: uuid,
                budgetId: budgetId,
                name: name,
                deleted: deleted,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) =>
              p0.map((e) => (e.readTable(table), BaseReferences(db, table, e))).toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DbPayeesTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $DbPayeesTable,
      DbPayee,
      $$DbPayeesTableFilterComposer,
      $$DbPayeesTableOrderingComposer,
      $$DbPayeesTableAnnotationComposer,
      $$DbPayeesTableCreateCompanionBuilder,
      $$DbPayeesTableUpdateCompanionBuilder,
      (DbPayee, BaseReferences<_$LocalDatabase, $DbPayeesTable, DbPayee>),
      DbPayee,
      PrefetchHooks Function()
    >;
typedef $$DbCategoryGroupsTableCreateCompanionBuilder =
    DbCategoryGroupsCompanion Function({
      required String uuid,
      required String budgetId,
      required String name,
      required bool isHidden,
      required bool isDeleted,
      Value<int> order,
      Value<int> rowid,
    });
typedef $$DbCategoryGroupsTableUpdateCompanionBuilder =
    DbCategoryGroupsCompanion Function({
      Value<String> uuid,
      Value<String> budgetId,
      Value<String> name,
      Value<bool> isHidden,
      Value<bool> isDeleted,
      Value<int> order,
      Value<int> rowid,
    });

class $$DbCategoryGroupsTableFilterComposer
    extends Composer<_$LocalDatabase, $DbCategoryGroupsTable> {
  $$DbCategoryGroupsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get budgetId =>
      $composableBuilder(column: $table.budgetId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isHidden =>
      $composableBuilder(column: $table.isHidden, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get order =>
      $composableBuilder(column: $table.order, builder: (column) => ColumnFilters(column));
}

class $$DbCategoryGroupsTableOrderingComposer
    extends Composer<_$LocalDatabase, $DbCategoryGroupsTable> {
  $$DbCategoryGroupsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get budgetId =>
      $composableBuilder(column: $table.budgetId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isHidden =>
      $composableBuilder(column: $table.isHidden, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get order =>
      $composableBuilder(column: $table.order, builder: (column) => ColumnOrderings(column));
}

class $$DbCategoryGroupsTableAnnotationComposer
    extends Composer<_$LocalDatabase, $DbCategoryGroupsTable> {
  $$DbCategoryGroupsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<String> get budgetId =>
      $composableBuilder(column: $table.budgetId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<bool> get isHidden =>
      $composableBuilder(column: $table.isHidden, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<int> get order =>
      $composableBuilder(column: $table.order, builder: (column) => column);
}

class $$DbCategoryGroupsTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $DbCategoryGroupsTable,
          DbCategoryGroup,
          $$DbCategoryGroupsTableFilterComposer,
          $$DbCategoryGroupsTableOrderingComposer,
          $$DbCategoryGroupsTableAnnotationComposer,
          $$DbCategoryGroupsTableCreateCompanionBuilder,
          $$DbCategoryGroupsTableUpdateCompanionBuilder,
          (
            DbCategoryGroup,
            BaseReferences<_$LocalDatabase, $DbCategoryGroupsTable, DbCategoryGroup>,
          ),
          DbCategoryGroup,
          PrefetchHooks Function()
        > {
  $$DbCategoryGroupsTableTableManager(_$LocalDatabase db, $DbCategoryGroupsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DbCategoryGroupsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DbCategoryGroupsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DbCategoryGroupsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> uuid = const Value.absent(),
                Value<String> budgetId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<bool> isHidden = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<int> order = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DbCategoryGroupsCompanion(
                uuid: uuid,
                budgetId: budgetId,
                name: name,
                isHidden: isHidden,
                isDeleted: isDeleted,
                order: order,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String uuid,
                required String budgetId,
                required String name,
                required bool isHidden,
                required bool isDeleted,
                Value<int> order = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DbCategoryGroupsCompanion.insert(
                uuid: uuid,
                budgetId: budgetId,
                name: name,
                isHidden: isHidden,
                isDeleted: isDeleted,
                order: order,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) =>
              p0.map((e) => (e.readTable(table), BaseReferences(db, table, e))).toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DbCategoryGroupsTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $DbCategoryGroupsTable,
      DbCategoryGroup,
      $$DbCategoryGroupsTableFilterComposer,
      $$DbCategoryGroupsTableOrderingComposer,
      $$DbCategoryGroupsTableAnnotationComposer,
      $$DbCategoryGroupsTableCreateCompanionBuilder,
      $$DbCategoryGroupsTableUpdateCompanionBuilder,
      (DbCategoryGroup, BaseReferences<_$LocalDatabase, $DbCategoryGroupsTable, DbCategoryGroup>),
      DbCategoryGroup,
      PrefetchHooks Function()
    >;
typedef $$DbCategoriesTableCreateCompanionBuilder =
    DbCategoriesCompanion Function({
      required String uuid,
      required String categoryGroupId,
      required String budgetId,
      required String name,
      required bool isHidden,
      required bool isDeleted,
      Value<int> order,
      Value<int> activity,
      Value<int> budgeted,
      Value<int> balance,
      Value<TargetType?> targetType,
      Value<bool?> targetNeedsWholeAmount,
      Value<int?> targetDay,
      Value<int?> targetCadence,
      Value<int?> targetCadenceFrequency,
      Value<String?> targetCreationMonth,
      Value<int?> targetBalance,
      Value<String?> targetMonth,
      Value<int?> targetPercentageComplete,
      Value<int?> targetMonthsToBudget,
      Value<int?> targetUnderFunded,
      Value<int?> targetOverallFunded,
      Value<int?> targetOverallLeft,
      Value<int> rowid,
    });
typedef $$DbCategoriesTableUpdateCompanionBuilder =
    DbCategoriesCompanion Function({
      Value<String> uuid,
      Value<String> categoryGroupId,
      Value<String> budgetId,
      Value<String> name,
      Value<bool> isHidden,
      Value<bool> isDeleted,
      Value<int> order,
      Value<int> activity,
      Value<int> budgeted,
      Value<int> balance,
      Value<TargetType?> targetType,
      Value<bool?> targetNeedsWholeAmount,
      Value<int?> targetDay,
      Value<int?> targetCadence,
      Value<int?> targetCadenceFrequency,
      Value<String?> targetCreationMonth,
      Value<int?> targetBalance,
      Value<String?> targetMonth,
      Value<int?> targetPercentageComplete,
      Value<int?> targetMonthsToBudget,
      Value<int?> targetUnderFunded,
      Value<int?> targetOverallFunded,
      Value<int?> targetOverallLeft,
      Value<int> rowid,
    });

class $$DbCategoriesTableFilterComposer extends Composer<_$LocalDatabase, $DbCategoriesTable> {
  $$DbCategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get categoryGroupId => $composableBuilder(
    column: $table.categoryGroupId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get budgetId =>
      $composableBuilder(column: $table.budgetId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isHidden =>
      $composableBuilder(column: $table.isHidden, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get order =>
      $composableBuilder(column: $table.order, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get activity =>
      $composableBuilder(column: $table.activity, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get budgeted =>
      $composableBuilder(column: $table.budgeted, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get balance =>
      $composableBuilder(column: $table.balance, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<TargetType?, TargetType, String> get targetType =>
      $composableBuilder(
        column: $table.targetType,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<bool> get targetNeedsWholeAmount => $composableBuilder(
    column: $table.targetNeedsWholeAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetDay =>
      $composableBuilder(column: $table.targetDay, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get targetCadence =>
      $composableBuilder(column: $table.targetCadence, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get targetCadenceFrequency => $composableBuilder(
    column: $table.targetCadenceFrequency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get targetCreationMonth => $composableBuilder(
    column: $table.targetCreationMonth,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetBalance =>
      $composableBuilder(column: $table.targetBalance, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get targetMonth =>
      $composableBuilder(column: $table.targetMonth, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get targetPercentageComplete => $composableBuilder(
    column: $table.targetPercentageComplete,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetMonthsToBudget => $composableBuilder(
    column: $table.targetMonthsToBudget,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetUnderFunded => $composableBuilder(
    column: $table.targetUnderFunded,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetOverallFunded => $composableBuilder(
    column: $table.targetOverallFunded,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetOverallLeft => $composableBuilder(
    column: $table.targetOverallLeft,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DbCategoriesTableOrderingComposer extends Composer<_$LocalDatabase, $DbCategoriesTable> {
  $$DbCategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get categoryGroupId => $composableBuilder(
    column: $table.categoryGroupId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get budgetId =>
      $composableBuilder(column: $table.budgetId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isHidden =>
      $composableBuilder(column: $table.isHidden, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get order =>
      $composableBuilder(column: $table.order, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get activity =>
      $composableBuilder(column: $table.activity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get budgeted =>
      $composableBuilder(column: $table.budgeted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get balance =>
      $composableBuilder(column: $table.balance, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get targetType =>
      $composableBuilder(column: $table.targetType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get targetNeedsWholeAmount => $composableBuilder(
    column: $table.targetNeedsWholeAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetDay =>
      $composableBuilder(column: $table.targetDay, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get targetCadence => $composableBuilder(
    column: $table.targetCadence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetCadenceFrequency => $composableBuilder(
    column: $table.targetCadenceFrequency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetCreationMonth => $composableBuilder(
    column: $table.targetCreationMonth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetBalance => $composableBuilder(
    column: $table.targetBalance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetMonth =>
      $composableBuilder(column: $table.targetMonth, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get targetPercentageComplete => $composableBuilder(
    column: $table.targetPercentageComplete,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetMonthsToBudget => $composableBuilder(
    column: $table.targetMonthsToBudget,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetUnderFunded => $composableBuilder(
    column: $table.targetUnderFunded,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetOverallFunded => $composableBuilder(
    column: $table.targetOverallFunded,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetOverallLeft => $composableBuilder(
    column: $table.targetOverallLeft,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DbCategoriesTableAnnotationComposer extends Composer<_$LocalDatabase, $DbCategoriesTable> {
  $$DbCategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<String> get categoryGroupId =>
      $composableBuilder(column: $table.categoryGroupId, builder: (column) => column);

  GeneratedColumn<String> get budgetId =>
      $composableBuilder(column: $table.budgetId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<bool> get isHidden =>
      $composableBuilder(column: $table.isHidden, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<int> get order =>
      $composableBuilder(column: $table.order, builder: (column) => column);

  GeneratedColumn<int> get activity =>
      $composableBuilder(column: $table.activity, builder: (column) => column);

  GeneratedColumn<int> get budgeted =>
      $composableBuilder(column: $table.budgeted, builder: (column) => column);

  GeneratedColumn<int> get balance =>
      $composableBuilder(column: $table.balance, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TargetType?, String> get targetType =>
      $composableBuilder(column: $table.targetType, builder: (column) => column);

  GeneratedColumn<bool> get targetNeedsWholeAmount =>
      $composableBuilder(column: $table.targetNeedsWholeAmount, builder: (column) => column);

  GeneratedColumn<int> get targetDay =>
      $composableBuilder(column: $table.targetDay, builder: (column) => column);

  GeneratedColumn<int> get targetCadence =>
      $composableBuilder(column: $table.targetCadence, builder: (column) => column);

  GeneratedColumn<int> get targetCadenceFrequency =>
      $composableBuilder(column: $table.targetCadenceFrequency, builder: (column) => column);

  GeneratedColumn<String> get targetCreationMonth =>
      $composableBuilder(column: $table.targetCreationMonth, builder: (column) => column);

  GeneratedColumn<int> get targetBalance =>
      $composableBuilder(column: $table.targetBalance, builder: (column) => column);

  GeneratedColumn<String> get targetMonth =>
      $composableBuilder(column: $table.targetMonth, builder: (column) => column);

  GeneratedColumn<int> get targetPercentageComplete =>
      $composableBuilder(column: $table.targetPercentageComplete, builder: (column) => column);

  GeneratedColumn<int> get targetMonthsToBudget =>
      $composableBuilder(column: $table.targetMonthsToBudget, builder: (column) => column);

  GeneratedColumn<int> get targetUnderFunded =>
      $composableBuilder(column: $table.targetUnderFunded, builder: (column) => column);

  GeneratedColumn<int> get targetOverallFunded =>
      $composableBuilder(column: $table.targetOverallFunded, builder: (column) => column);

  GeneratedColumn<int> get targetOverallLeft =>
      $composableBuilder(column: $table.targetOverallLeft, builder: (column) => column);
}

class $$DbCategoriesTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $DbCategoriesTable,
          DbCategory,
          $$DbCategoriesTableFilterComposer,
          $$DbCategoriesTableOrderingComposer,
          $$DbCategoriesTableAnnotationComposer,
          $$DbCategoriesTableCreateCompanionBuilder,
          $$DbCategoriesTableUpdateCompanionBuilder,
          (DbCategory, BaseReferences<_$LocalDatabase, $DbCategoriesTable, DbCategory>),
          DbCategory,
          PrefetchHooks Function()
        > {
  $$DbCategoriesTableTableManager(_$LocalDatabase db, $DbCategoriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$DbCategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$DbCategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DbCategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> uuid = const Value.absent(),
                Value<String> categoryGroupId = const Value.absent(),
                Value<String> budgetId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<bool> isHidden = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<int> order = const Value.absent(),
                Value<int> activity = const Value.absent(),
                Value<int> budgeted = const Value.absent(),
                Value<int> balance = const Value.absent(),
                Value<TargetType?> targetType = const Value.absent(),
                Value<bool?> targetNeedsWholeAmount = const Value.absent(),
                Value<int?> targetDay = const Value.absent(),
                Value<int?> targetCadence = const Value.absent(),
                Value<int?> targetCadenceFrequency = const Value.absent(),
                Value<String?> targetCreationMonth = const Value.absent(),
                Value<int?> targetBalance = const Value.absent(),
                Value<String?> targetMonth = const Value.absent(),
                Value<int?> targetPercentageComplete = const Value.absent(),
                Value<int?> targetMonthsToBudget = const Value.absent(),
                Value<int?> targetUnderFunded = const Value.absent(),
                Value<int?> targetOverallFunded = const Value.absent(),
                Value<int?> targetOverallLeft = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DbCategoriesCompanion(
                uuid: uuid,
                categoryGroupId: categoryGroupId,
                budgetId: budgetId,
                name: name,
                isHidden: isHidden,
                isDeleted: isDeleted,
                order: order,
                activity: activity,
                budgeted: budgeted,
                balance: balance,
                targetType: targetType,
                targetNeedsWholeAmount: targetNeedsWholeAmount,
                targetDay: targetDay,
                targetCadence: targetCadence,
                targetCadenceFrequency: targetCadenceFrequency,
                targetCreationMonth: targetCreationMonth,
                targetBalance: targetBalance,
                targetMonth: targetMonth,
                targetPercentageComplete: targetPercentageComplete,
                targetMonthsToBudget: targetMonthsToBudget,
                targetUnderFunded: targetUnderFunded,
                targetOverallFunded: targetOverallFunded,
                targetOverallLeft: targetOverallLeft,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String uuid,
                required String categoryGroupId,
                required String budgetId,
                required String name,
                required bool isHidden,
                required bool isDeleted,
                Value<int> order = const Value.absent(),
                Value<int> activity = const Value.absent(),
                Value<int> budgeted = const Value.absent(),
                Value<int> balance = const Value.absent(),
                Value<TargetType?> targetType = const Value.absent(),
                Value<bool?> targetNeedsWholeAmount = const Value.absent(),
                Value<int?> targetDay = const Value.absent(),
                Value<int?> targetCadence = const Value.absent(),
                Value<int?> targetCadenceFrequency = const Value.absent(),
                Value<String?> targetCreationMonth = const Value.absent(),
                Value<int?> targetBalance = const Value.absent(),
                Value<String?> targetMonth = const Value.absent(),
                Value<int?> targetPercentageComplete = const Value.absent(),
                Value<int?> targetMonthsToBudget = const Value.absent(),
                Value<int?> targetUnderFunded = const Value.absent(),
                Value<int?> targetOverallFunded = const Value.absent(),
                Value<int?> targetOverallLeft = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DbCategoriesCompanion.insert(
                uuid: uuid,
                categoryGroupId: categoryGroupId,
                budgetId: budgetId,
                name: name,
                isHidden: isHidden,
                isDeleted: isDeleted,
                order: order,
                activity: activity,
                budgeted: budgeted,
                balance: balance,
                targetType: targetType,
                targetNeedsWholeAmount: targetNeedsWholeAmount,
                targetDay: targetDay,
                targetCadence: targetCadence,
                targetCadenceFrequency: targetCadenceFrequency,
                targetCreationMonth: targetCreationMonth,
                targetBalance: targetBalance,
                targetMonth: targetMonth,
                targetPercentageComplete: targetPercentageComplete,
                targetMonthsToBudget: targetMonthsToBudget,
                targetUnderFunded: targetUnderFunded,
                targetOverallFunded: targetOverallFunded,
                targetOverallLeft: targetOverallLeft,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) =>
              p0.map((e) => (e.readTable(table), BaseReferences(db, table, e))).toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DbCategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $DbCategoriesTable,
      DbCategory,
      $$DbCategoriesTableFilterComposer,
      $$DbCategoriesTableOrderingComposer,
      $$DbCategoriesTableAnnotationComposer,
      $$DbCategoriesTableCreateCompanionBuilder,
      $$DbCategoriesTableUpdateCompanionBuilder,
      (DbCategory, BaseReferences<_$LocalDatabase, $DbCategoriesTable, DbCategory>),
      DbCategory,
      PrefetchHooks Function()
    >;
typedef $$DbTransactionsTableCreateCompanionBuilder =
    DbTransactionsCompanion Function({
      required String uuid,
      required String budgetId,
      required int amount,
      required String date,
      required String accountId,
      required bool isDeleted,
      Value<String?> payeeName,
      Value<String?> payeeId,
      Value<String?> categoryId,
      Value<String?> categoryName,
      Value<String?> memo,
      Value<String?> transferAccountId,
      Value<String?> transferTransactionId,
      Value<String?> matchedTransactionId,
      Value<String?> importId,
      Value<Flag?> flagColor,
      Value<int> rowid,
    });
typedef $$DbTransactionsTableUpdateCompanionBuilder =
    DbTransactionsCompanion Function({
      Value<String> uuid,
      Value<String> budgetId,
      Value<int> amount,
      Value<String> date,
      Value<String> accountId,
      Value<bool> isDeleted,
      Value<String?> payeeName,
      Value<String?> payeeId,
      Value<String?> categoryId,
      Value<String?> categoryName,
      Value<String?> memo,
      Value<String?> transferAccountId,
      Value<String?> transferTransactionId,
      Value<String?> matchedTransactionId,
      Value<String?> importId,
      Value<Flag?> flagColor,
      Value<int> rowid,
    });

class $$DbTransactionsTableFilterComposer extends Composer<_$LocalDatabase, $DbTransactionsTable> {
  $$DbTransactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get budgetId =>
      $composableBuilder(column: $table.budgetId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get payeeName =>
      $composableBuilder(column: $table.payeeName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get payeeId =>
      $composableBuilder(column: $table.payeeId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get categoryId =>
      $composableBuilder(column: $table.categoryId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get categoryName =>
      $composableBuilder(column: $table.categoryName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get memo =>
      $composableBuilder(column: $table.memo, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get transferAccountId => $composableBuilder(
    column: $table.transferAccountId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get transferTransactionId => $composableBuilder(
    column: $table.transferTransactionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get matchedTransactionId => $composableBuilder(
    column: $table.matchedTransactionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get importId =>
      $composableBuilder(column: $table.importId, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<Flag?, Flag, String> get flagColor => $composableBuilder(
    column: $table.flagColor,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );
}

class $$DbTransactionsTableOrderingComposer
    extends Composer<_$LocalDatabase, $DbTransactionsTable> {
  $$DbTransactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get budgetId =>
      $composableBuilder(column: $table.budgetId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get payeeName =>
      $composableBuilder(column: $table.payeeName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get payeeId =>
      $composableBuilder(column: $table.payeeId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get categoryId =>
      $composableBuilder(column: $table.categoryId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get categoryName =>
      $composableBuilder(column: $table.categoryName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get memo =>
      $composableBuilder(column: $table.memo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get transferAccountId => $composableBuilder(
    column: $table.transferAccountId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get transferTransactionId => $composableBuilder(
    column: $table.transferTransactionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get matchedTransactionId => $composableBuilder(
    column: $table.matchedTransactionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get importId =>
      $composableBuilder(column: $table.importId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get flagColor =>
      $composableBuilder(column: $table.flagColor, builder: (column) => ColumnOrderings(column));
}

class $$DbTransactionsTableAnnotationComposer
    extends Composer<_$LocalDatabase, $DbTransactionsTable> {
  $$DbTransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<String> get budgetId =>
      $composableBuilder(column: $table.budgetId, builder: (column) => column);

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<String> get payeeName =>
      $composableBuilder(column: $table.payeeName, builder: (column) => column);

  GeneratedColumn<String> get payeeId =>
      $composableBuilder(column: $table.payeeId, builder: (column) => column);

  GeneratedColumn<String> get categoryId =>
      $composableBuilder(column: $table.categoryId, builder: (column) => column);

  GeneratedColumn<String> get categoryName =>
      $composableBuilder(column: $table.categoryName, builder: (column) => column);

  GeneratedColumn<String> get memo =>
      $composableBuilder(column: $table.memo, builder: (column) => column);

  GeneratedColumn<String> get transferAccountId =>
      $composableBuilder(column: $table.transferAccountId, builder: (column) => column);

  GeneratedColumn<String> get transferTransactionId =>
      $composableBuilder(column: $table.transferTransactionId, builder: (column) => column);

  GeneratedColumn<String> get matchedTransactionId =>
      $composableBuilder(column: $table.matchedTransactionId, builder: (column) => column);

  GeneratedColumn<String> get importId =>
      $composableBuilder(column: $table.importId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Flag?, String> get flagColor =>
      $composableBuilder(column: $table.flagColor, builder: (column) => column);
}

class $$DbTransactionsTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $DbTransactionsTable,
          DbTransaction,
          $$DbTransactionsTableFilterComposer,
          $$DbTransactionsTableOrderingComposer,
          $$DbTransactionsTableAnnotationComposer,
          $$DbTransactionsTableCreateCompanionBuilder,
          $$DbTransactionsTableUpdateCompanionBuilder,
          (DbTransaction, BaseReferences<_$LocalDatabase, $DbTransactionsTable, DbTransaction>),
          DbTransaction,
          PrefetchHooks Function()
        > {
  $$DbTransactionsTableTableManager(_$LocalDatabase db, $DbTransactionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DbTransactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DbTransactionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DbTransactionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> uuid = const Value.absent(),
                Value<String> budgetId = const Value.absent(),
                Value<int> amount = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<String> accountId = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<String?> payeeName = const Value.absent(),
                Value<String?> payeeId = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                Value<String?> categoryName = const Value.absent(),
                Value<String?> memo = const Value.absent(),
                Value<String?> transferAccountId = const Value.absent(),
                Value<String?> transferTransactionId = const Value.absent(),
                Value<String?> matchedTransactionId = const Value.absent(),
                Value<String?> importId = const Value.absent(),
                Value<Flag?> flagColor = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DbTransactionsCompanion(
                uuid: uuid,
                budgetId: budgetId,
                amount: amount,
                date: date,
                accountId: accountId,
                isDeleted: isDeleted,
                payeeName: payeeName,
                payeeId: payeeId,
                categoryId: categoryId,
                categoryName: categoryName,
                memo: memo,
                transferAccountId: transferAccountId,
                transferTransactionId: transferTransactionId,
                matchedTransactionId: matchedTransactionId,
                importId: importId,
                flagColor: flagColor,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String uuid,
                required String budgetId,
                required int amount,
                required String date,
                required String accountId,
                required bool isDeleted,
                Value<String?> payeeName = const Value.absent(),
                Value<String?> payeeId = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                Value<String?> categoryName = const Value.absent(),
                Value<String?> memo = const Value.absent(),
                Value<String?> transferAccountId = const Value.absent(),
                Value<String?> transferTransactionId = const Value.absent(),
                Value<String?> matchedTransactionId = const Value.absent(),
                Value<String?> importId = const Value.absent(),
                Value<Flag?> flagColor = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DbTransactionsCompanion.insert(
                uuid: uuid,
                budgetId: budgetId,
                amount: amount,
                date: date,
                accountId: accountId,
                isDeleted: isDeleted,
                payeeName: payeeName,
                payeeId: payeeId,
                categoryId: categoryId,
                categoryName: categoryName,
                memo: memo,
                transferAccountId: transferAccountId,
                transferTransactionId: transferTransactionId,
                matchedTransactionId: matchedTransactionId,
                importId: importId,
                flagColor: flagColor,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) =>
              p0.map((e) => (e.readTable(table), BaseReferences(db, table, e))).toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DbTransactionsTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $DbTransactionsTable,
      DbTransaction,
      $$DbTransactionsTableFilterComposer,
      $$DbTransactionsTableOrderingComposer,
      $$DbTransactionsTableAnnotationComposer,
      $$DbTransactionsTableCreateCompanionBuilder,
      $$DbTransactionsTableUpdateCompanionBuilder,
      (DbTransaction, BaseReferences<_$LocalDatabase, $DbTransactionsTable, DbTransaction>),
      DbTransaction,
      PrefetchHooks Function()
    >;
typedef $$DbSubTransactionsTableCreateCompanionBuilder =
    DbSubTransactionsCompanion Function({
      required String uuid,
      required String transactionId,
      required String budgetId,
      required int amount,
      required bool isDeleted,
      Value<String?> payeeName,
      Value<String?> payeeId,
      Value<String?> categoryId,
      Value<String?> categoryName,
      Value<String?> memo,
      Value<String?> transferAccountId,
      Value<String?> transferTransactionId,
      Value<int> rowid,
    });
typedef $$DbSubTransactionsTableUpdateCompanionBuilder =
    DbSubTransactionsCompanion Function({
      Value<String> uuid,
      Value<String> transactionId,
      Value<String> budgetId,
      Value<int> amount,
      Value<bool> isDeleted,
      Value<String?> payeeName,
      Value<String?> payeeId,
      Value<String?> categoryId,
      Value<String?> categoryName,
      Value<String?> memo,
      Value<String?> transferAccountId,
      Value<String?> transferTransactionId,
      Value<int> rowid,
    });

class $$DbSubTransactionsTableFilterComposer
    extends Composer<_$LocalDatabase, $DbSubTransactionsTable> {
  $$DbSubTransactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get transactionId =>
      $composableBuilder(column: $table.transactionId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get budgetId =>
      $composableBuilder(column: $table.budgetId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get payeeName =>
      $composableBuilder(column: $table.payeeName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get payeeId =>
      $composableBuilder(column: $table.payeeId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get categoryId =>
      $composableBuilder(column: $table.categoryId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get categoryName =>
      $composableBuilder(column: $table.categoryName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get memo =>
      $composableBuilder(column: $table.memo, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get transferAccountId => $composableBuilder(
    column: $table.transferAccountId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get transferTransactionId => $composableBuilder(
    column: $table.transferTransactionId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DbSubTransactionsTableOrderingComposer
    extends Composer<_$LocalDatabase, $DbSubTransactionsTable> {
  $$DbSubTransactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get transactionId => $composableBuilder(
    column: $table.transactionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get budgetId =>
      $composableBuilder(column: $table.budgetId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get payeeName =>
      $composableBuilder(column: $table.payeeName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get payeeId =>
      $composableBuilder(column: $table.payeeId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get categoryId =>
      $composableBuilder(column: $table.categoryId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get categoryName =>
      $composableBuilder(column: $table.categoryName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get memo =>
      $composableBuilder(column: $table.memo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get transferAccountId => $composableBuilder(
    column: $table.transferAccountId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get transferTransactionId => $composableBuilder(
    column: $table.transferTransactionId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DbSubTransactionsTableAnnotationComposer
    extends Composer<_$LocalDatabase, $DbSubTransactionsTable> {
  $$DbSubTransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<String> get transactionId =>
      $composableBuilder(column: $table.transactionId, builder: (column) => column);

  GeneratedColumn<String> get budgetId =>
      $composableBuilder(column: $table.budgetId, builder: (column) => column);

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<String> get payeeName =>
      $composableBuilder(column: $table.payeeName, builder: (column) => column);

  GeneratedColumn<String> get payeeId =>
      $composableBuilder(column: $table.payeeId, builder: (column) => column);

  GeneratedColumn<String> get categoryId =>
      $composableBuilder(column: $table.categoryId, builder: (column) => column);

  GeneratedColumn<String> get categoryName =>
      $composableBuilder(column: $table.categoryName, builder: (column) => column);

  GeneratedColumn<String> get memo =>
      $composableBuilder(column: $table.memo, builder: (column) => column);

  GeneratedColumn<String> get transferAccountId =>
      $composableBuilder(column: $table.transferAccountId, builder: (column) => column);

  GeneratedColumn<String> get transferTransactionId =>
      $composableBuilder(column: $table.transferTransactionId, builder: (column) => column);
}

class $$DbSubTransactionsTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $DbSubTransactionsTable,
          DbSubTransaction,
          $$DbSubTransactionsTableFilterComposer,
          $$DbSubTransactionsTableOrderingComposer,
          $$DbSubTransactionsTableAnnotationComposer,
          $$DbSubTransactionsTableCreateCompanionBuilder,
          $$DbSubTransactionsTableUpdateCompanionBuilder,
          (
            DbSubTransaction,
            BaseReferences<_$LocalDatabase, $DbSubTransactionsTable, DbSubTransaction>,
          ),
          DbSubTransaction,
          PrefetchHooks Function()
        > {
  $$DbSubTransactionsTableTableManager(_$LocalDatabase db, $DbSubTransactionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DbSubTransactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DbSubTransactionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DbSubTransactionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> uuid = const Value.absent(),
                Value<String> transactionId = const Value.absent(),
                Value<String> budgetId = const Value.absent(),
                Value<int> amount = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<String?> payeeName = const Value.absent(),
                Value<String?> payeeId = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                Value<String?> categoryName = const Value.absent(),
                Value<String?> memo = const Value.absent(),
                Value<String?> transferAccountId = const Value.absent(),
                Value<String?> transferTransactionId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DbSubTransactionsCompanion(
                uuid: uuid,
                transactionId: transactionId,
                budgetId: budgetId,
                amount: amount,
                isDeleted: isDeleted,
                payeeName: payeeName,
                payeeId: payeeId,
                categoryId: categoryId,
                categoryName: categoryName,
                memo: memo,
                transferAccountId: transferAccountId,
                transferTransactionId: transferTransactionId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String uuid,
                required String transactionId,
                required String budgetId,
                required int amount,
                required bool isDeleted,
                Value<String?> payeeName = const Value.absent(),
                Value<String?> payeeId = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                Value<String?> categoryName = const Value.absent(),
                Value<String?> memo = const Value.absent(),
                Value<String?> transferAccountId = const Value.absent(),
                Value<String?> transferTransactionId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DbSubTransactionsCompanion.insert(
                uuid: uuid,
                transactionId: transactionId,
                budgetId: budgetId,
                amount: amount,
                isDeleted: isDeleted,
                payeeName: payeeName,
                payeeId: payeeId,
                categoryId: categoryId,
                categoryName: categoryName,
                memo: memo,
                transferAccountId: transferAccountId,
                transferTransactionId: transferTransactionId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) =>
              p0.map((e) => (e.readTable(table), BaseReferences(db, table, e))).toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DbSubTransactionsTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $DbSubTransactionsTable,
      DbSubTransaction,
      $$DbSubTransactionsTableFilterComposer,
      $$DbSubTransactionsTableOrderingComposer,
      $$DbSubTransactionsTableAnnotationComposer,
      $$DbSubTransactionsTableCreateCompanionBuilder,
      $$DbSubTransactionsTableUpdateCompanionBuilder,
      (
        DbSubTransaction,
        BaseReferences<_$LocalDatabase, $DbSubTransactionsTable, DbSubTransaction>,
      ),
      DbSubTransaction,
      PrefetchHooks Function()
    >;
typedef $$DbScheduledTransactionsTableCreateCompanionBuilder =
    DbScheduledTransactionsCompanion Function({
      required String uuid,
      required String budgetId,
      required int amount,
      required String frequency,
      required DateTime dateFirst,
      required DateTime dateNext,
      required String accountId,
      required String accountName,
      required bool isDeleted,
      Value<String?> payeeName,
      Value<String?> payeeId,
      Value<String?> categoryId,
      Value<String?> categoryName,
      Value<String?> memo,
      Value<String?> transferAccountId,
      Value<Flag?> flagColor,
      Value<String?> flagName,
      Value<int> rowid,
    });
typedef $$DbScheduledTransactionsTableUpdateCompanionBuilder =
    DbScheduledTransactionsCompanion Function({
      Value<String> uuid,
      Value<String> budgetId,
      Value<int> amount,
      Value<String> frequency,
      Value<DateTime> dateFirst,
      Value<DateTime> dateNext,
      Value<String> accountId,
      Value<String> accountName,
      Value<bool> isDeleted,
      Value<String?> payeeName,
      Value<String?> payeeId,
      Value<String?> categoryId,
      Value<String?> categoryName,
      Value<String?> memo,
      Value<String?> transferAccountId,
      Value<Flag?> flagColor,
      Value<String?> flagName,
      Value<int> rowid,
    });

class $$DbScheduledTransactionsTableFilterComposer
    extends Composer<_$LocalDatabase, $DbScheduledTransactionsTable> {
  $$DbScheduledTransactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get budgetId =>
      $composableBuilder(column: $table.budgetId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get frequency =>
      $composableBuilder(column: $table.frequency, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dateFirst =>
      $composableBuilder(column: $table.dateFirst, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dateNext =>
      $composableBuilder(column: $table.dateNext, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get accountName =>
      $composableBuilder(column: $table.accountName, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get payeeName =>
      $composableBuilder(column: $table.payeeName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get payeeId =>
      $composableBuilder(column: $table.payeeId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get categoryId =>
      $composableBuilder(column: $table.categoryId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get categoryName =>
      $composableBuilder(column: $table.categoryName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get memo =>
      $composableBuilder(column: $table.memo, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get transferAccountId => $composableBuilder(
    column: $table.transferAccountId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Flag?, Flag, String> get flagColor => $composableBuilder(
    column: $table.flagColor,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get flagName =>
      $composableBuilder(column: $table.flagName, builder: (column) => ColumnFilters(column));
}

class $$DbScheduledTransactionsTableOrderingComposer
    extends Composer<_$LocalDatabase, $DbScheduledTransactionsTable> {
  $$DbScheduledTransactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get budgetId =>
      $composableBuilder(column: $table.budgetId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get frequency =>
      $composableBuilder(column: $table.frequency, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dateFirst =>
      $composableBuilder(column: $table.dateFirst, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dateNext =>
      $composableBuilder(column: $table.dateNext, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get accountName =>
      $composableBuilder(column: $table.accountName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get payeeName =>
      $composableBuilder(column: $table.payeeName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get payeeId =>
      $composableBuilder(column: $table.payeeId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get categoryId =>
      $composableBuilder(column: $table.categoryId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get categoryName =>
      $composableBuilder(column: $table.categoryName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get memo =>
      $composableBuilder(column: $table.memo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get transferAccountId => $composableBuilder(
    column: $table.transferAccountId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get flagColor =>
      $composableBuilder(column: $table.flagColor, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get flagName =>
      $composableBuilder(column: $table.flagName, builder: (column) => ColumnOrderings(column));
}

class $$DbScheduledTransactionsTableAnnotationComposer
    extends Composer<_$LocalDatabase, $DbScheduledTransactionsTable> {
  $$DbScheduledTransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<String> get budgetId =>
      $composableBuilder(column: $table.budgetId, builder: (column) => column);

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get frequency =>
      $composableBuilder(column: $table.frequency, builder: (column) => column);

  GeneratedColumn<DateTime> get dateFirst =>
      $composableBuilder(column: $table.dateFirst, builder: (column) => column);

  GeneratedColumn<DateTime> get dateNext =>
      $composableBuilder(column: $table.dateNext, builder: (column) => column);

  GeneratedColumn<String> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<String> get accountName =>
      $composableBuilder(column: $table.accountName, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<String> get payeeName =>
      $composableBuilder(column: $table.payeeName, builder: (column) => column);

  GeneratedColumn<String> get payeeId =>
      $composableBuilder(column: $table.payeeId, builder: (column) => column);

  GeneratedColumn<String> get categoryId =>
      $composableBuilder(column: $table.categoryId, builder: (column) => column);

  GeneratedColumn<String> get categoryName =>
      $composableBuilder(column: $table.categoryName, builder: (column) => column);

  GeneratedColumn<String> get memo =>
      $composableBuilder(column: $table.memo, builder: (column) => column);

  GeneratedColumn<String> get transferAccountId =>
      $composableBuilder(column: $table.transferAccountId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Flag?, String> get flagColor =>
      $composableBuilder(column: $table.flagColor, builder: (column) => column);

  GeneratedColumn<String> get flagName =>
      $composableBuilder(column: $table.flagName, builder: (column) => column);
}

class $$DbScheduledTransactionsTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $DbScheduledTransactionsTable,
          DbScheduledTransaction,
          $$DbScheduledTransactionsTableFilterComposer,
          $$DbScheduledTransactionsTableOrderingComposer,
          $$DbScheduledTransactionsTableAnnotationComposer,
          $$DbScheduledTransactionsTableCreateCompanionBuilder,
          $$DbScheduledTransactionsTableUpdateCompanionBuilder,
          (
            DbScheduledTransaction,
            BaseReferences<_$LocalDatabase, $DbScheduledTransactionsTable, DbScheduledTransaction>,
          ),
          DbScheduledTransaction,
          PrefetchHooks Function()
        > {
  $$DbScheduledTransactionsTableTableManager(
    _$LocalDatabase db,
    $DbScheduledTransactionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DbScheduledTransactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DbScheduledTransactionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DbScheduledTransactionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> uuid = const Value.absent(),
                Value<String> budgetId = const Value.absent(),
                Value<int> amount = const Value.absent(),
                Value<String> frequency = const Value.absent(),
                Value<DateTime> dateFirst = const Value.absent(),
                Value<DateTime> dateNext = const Value.absent(),
                Value<String> accountId = const Value.absent(),
                Value<String> accountName = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<String?> payeeName = const Value.absent(),
                Value<String?> payeeId = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                Value<String?> categoryName = const Value.absent(),
                Value<String?> memo = const Value.absent(),
                Value<String?> transferAccountId = const Value.absent(),
                Value<Flag?> flagColor = const Value.absent(),
                Value<String?> flagName = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DbScheduledTransactionsCompanion(
                uuid: uuid,
                budgetId: budgetId,
                amount: amount,
                frequency: frequency,
                dateFirst: dateFirst,
                dateNext: dateNext,
                accountId: accountId,
                accountName: accountName,
                isDeleted: isDeleted,
                payeeName: payeeName,
                payeeId: payeeId,
                categoryId: categoryId,
                categoryName: categoryName,
                memo: memo,
                transferAccountId: transferAccountId,
                flagColor: flagColor,
                flagName: flagName,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String uuid,
                required String budgetId,
                required int amount,
                required String frequency,
                required DateTime dateFirst,
                required DateTime dateNext,
                required String accountId,
                required String accountName,
                required bool isDeleted,
                Value<String?> payeeName = const Value.absent(),
                Value<String?> payeeId = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                Value<String?> categoryName = const Value.absent(),
                Value<String?> memo = const Value.absent(),
                Value<String?> transferAccountId = const Value.absent(),
                Value<Flag?> flagColor = const Value.absent(),
                Value<String?> flagName = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DbScheduledTransactionsCompanion.insert(
                uuid: uuid,
                budgetId: budgetId,
                amount: amount,
                frequency: frequency,
                dateFirst: dateFirst,
                dateNext: dateNext,
                accountId: accountId,
                accountName: accountName,
                isDeleted: isDeleted,
                payeeName: payeeName,
                payeeId: payeeId,
                categoryId: categoryId,
                categoryName: categoryName,
                memo: memo,
                transferAccountId: transferAccountId,
                flagColor: flagColor,
                flagName: flagName,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) =>
              p0.map((e) => (e.readTable(table), BaseReferences(db, table, e))).toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DbScheduledTransactionsTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $DbScheduledTransactionsTable,
      DbScheduledTransaction,
      $$DbScheduledTransactionsTableFilterComposer,
      $$DbScheduledTransactionsTableOrderingComposer,
      $$DbScheduledTransactionsTableAnnotationComposer,
      $$DbScheduledTransactionsTableCreateCompanionBuilder,
      $$DbScheduledTransactionsTableUpdateCompanionBuilder,
      (
        DbScheduledTransaction,
        BaseReferences<_$LocalDatabase, $DbScheduledTransactionsTable, DbScheduledTransaction>,
      ),
      DbScheduledTransaction,
      PrefetchHooks Function()
    >;
typedef $$DbScheduledSubTransactionsTableCreateCompanionBuilder =
    DbScheduledSubTransactionsCompanion Function({
      required String uuid,
      required String scheduledTransactionId,
      required String budgetId,
      required int amount,
      required bool isDeleted,
      Value<String?> payeeId,
      Value<String?> categoryId,
      Value<String?> memo,
      Value<String?> transferAccountId,
      Value<int> rowid,
    });
typedef $$DbScheduledSubTransactionsTableUpdateCompanionBuilder =
    DbScheduledSubTransactionsCompanion Function({
      Value<String> uuid,
      Value<String> scheduledTransactionId,
      Value<String> budgetId,
      Value<int> amount,
      Value<bool> isDeleted,
      Value<String?> payeeId,
      Value<String?> categoryId,
      Value<String?> memo,
      Value<String?> transferAccountId,
      Value<int> rowid,
    });

class $$DbScheduledSubTransactionsTableFilterComposer
    extends Composer<_$LocalDatabase, $DbScheduledSubTransactionsTable> {
  $$DbScheduledSubTransactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get scheduledTransactionId => $composableBuilder(
    column: $table.scheduledTransactionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get budgetId =>
      $composableBuilder(column: $table.budgetId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get payeeId =>
      $composableBuilder(column: $table.payeeId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get categoryId =>
      $composableBuilder(column: $table.categoryId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get memo =>
      $composableBuilder(column: $table.memo, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get transferAccountId => $composableBuilder(
    column: $table.transferAccountId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DbScheduledSubTransactionsTableOrderingComposer
    extends Composer<_$LocalDatabase, $DbScheduledSubTransactionsTable> {
  $$DbScheduledSubTransactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get scheduledTransactionId => $composableBuilder(
    column: $table.scheduledTransactionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get budgetId =>
      $composableBuilder(column: $table.budgetId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get payeeId =>
      $composableBuilder(column: $table.payeeId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get categoryId =>
      $composableBuilder(column: $table.categoryId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get memo =>
      $composableBuilder(column: $table.memo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get transferAccountId => $composableBuilder(
    column: $table.transferAccountId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DbScheduledSubTransactionsTableAnnotationComposer
    extends Composer<_$LocalDatabase, $DbScheduledSubTransactionsTable> {
  $$DbScheduledSubTransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<String> get scheduledTransactionId =>
      $composableBuilder(column: $table.scheduledTransactionId, builder: (column) => column);

  GeneratedColumn<String> get budgetId =>
      $composableBuilder(column: $table.budgetId, builder: (column) => column);

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<String> get payeeId =>
      $composableBuilder(column: $table.payeeId, builder: (column) => column);

  GeneratedColumn<String> get categoryId =>
      $composableBuilder(column: $table.categoryId, builder: (column) => column);

  GeneratedColumn<String> get memo =>
      $composableBuilder(column: $table.memo, builder: (column) => column);

  GeneratedColumn<String> get transferAccountId =>
      $composableBuilder(column: $table.transferAccountId, builder: (column) => column);
}

class $$DbScheduledSubTransactionsTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $DbScheduledSubTransactionsTable,
          DbScheduledSubTransaction,
          $$DbScheduledSubTransactionsTableFilterComposer,
          $$DbScheduledSubTransactionsTableOrderingComposer,
          $$DbScheduledSubTransactionsTableAnnotationComposer,
          $$DbScheduledSubTransactionsTableCreateCompanionBuilder,
          $$DbScheduledSubTransactionsTableUpdateCompanionBuilder,
          (
            DbScheduledSubTransaction,
            BaseReferences<
              _$LocalDatabase,
              $DbScheduledSubTransactionsTable,
              DbScheduledSubTransaction
            >,
          ),
          DbScheduledSubTransaction,
          PrefetchHooks Function()
        > {
  $$DbScheduledSubTransactionsTableTableManager(
    _$LocalDatabase db,
    $DbScheduledSubTransactionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DbScheduledSubTransactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DbScheduledSubTransactionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DbScheduledSubTransactionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> uuid = const Value.absent(),
                Value<String> scheduledTransactionId = const Value.absent(),
                Value<String> budgetId = const Value.absent(),
                Value<int> amount = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<String?> payeeId = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                Value<String?> memo = const Value.absent(),
                Value<String?> transferAccountId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DbScheduledSubTransactionsCompanion(
                uuid: uuid,
                scheduledTransactionId: scheduledTransactionId,
                budgetId: budgetId,
                amount: amount,
                isDeleted: isDeleted,
                payeeId: payeeId,
                categoryId: categoryId,
                memo: memo,
                transferAccountId: transferAccountId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String uuid,
                required String scheduledTransactionId,
                required String budgetId,
                required int amount,
                required bool isDeleted,
                Value<String?> payeeId = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                Value<String?> memo = const Value.absent(),
                Value<String?> transferAccountId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DbScheduledSubTransactionsCompanion.insert(
                uuid: uuid,
                scheduledTransactionId: scheduledTransactionId,
                budgetId: budgetId,
                amount: amount,
                isDeleted: isDeleted,
                payeeId: payeeId,
                categoryId: categoryId,
                memo: memo,
                transferAccountId: transferAccountId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) =>
              p0.map((e) => (e.readTable(table), BaseReferences(db, table, e))).toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DbScheduledSubTransactionsTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $DbScheduledSubTransactionsTable,
      DbScheduledSubTransaction,
      $$DbScheduledSubTransactionsTableFilterComposer,
      $$DbScheduledSubTransactionsTableOrderingComposer,
      $$DbScheduledSubTransactionsTableAnnotationComposer,
      $$DbScheduledSubTransactionsTableCreateCompanionBuilder,
      $$DbScheduledSubTransactionsTableUpdateCompanionBuilder,
      (
        DbScheduledSubTransaction,
        BaseReferences<
          _$LocalDatabase,
          $DbScheduledSubTransactionsTable,
          DbScheduledSubTransaction
        >,
      ),
      DbScheduledSubTransaction,
      PrefetchHooks Function()
    >;
typedef $$DbMonthsTableCreateCompanionBuilder =
    DbMonthsCompanion Function({
      required String budgetId,
      required String month,
      Value<String?> note,
      required int income,
      required int budgeted,
      required int activity,
      required int toBeBudgeted,
      Value<int?> ageOfMoney,
      required bool deleted,
      Value<int> rowid,
    });
typedef $$DbMonthsTableUpdateCompanionBuilder =
    DbMonthsCompanion Function({
      Value<String> budgetId,
      Value<String> month,
      Value<String?> note,
      Value<int> income,
      Value<int> budgeted,
      Value<int> activity,
      Value<int> toBeBudgeted,
      Value<int?> ageOfMoney,
      Value<bool> deleted,
      Value<int> rowid,
    });

class $$DbMonthsTableFilterComposer extends Composer<_$LocalDatabase, $DbMonthsTable> {
  $$DbMonthsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get budgetId =>
      $composableBuilder(column: $table.budgetId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get month =>
      $composableBuilder(column: $table.month, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get income =>
      $composableBuilder(column: $table.income, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get budgeted =>
      $composableBuilder(column: $table.budgeted, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get activity =>
      $composableBuilder(column: $table.activity, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get toBeBudgeted =>
      $composableBuilder(column: $table.toBeBudgeted, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get ageOfMoney =>
      $composableBuilder(column: $table.ageOfMoney, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => ColumnFilters(column));
}

class $$DbMonthsTableOrderingComposer extends Composer<_$LocalDatabase, $DbMonthsTable> {
  $$DbMonthsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get budgetId =>
      $composableBuilder(column: $table.budgetId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get month =>
      $composableBuilder(column: $table.month, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get income =>
      $composableBuilder(column: $table.income, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get budgeted =>
      $composableBuilder(column: $table.budgeted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get activity =>
      $composableBuilder(column: $table.activity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get toBeBudgeted =>
      $composableBuilder(column: $table.toBeBudgeted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get ageOfMoney =>
      $composableBuilder(column: $table.ageOfMoney, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => ColumnOrderings(column));
}

class $$DbMonthsTableAnnotationComposer extends Composer<_$LocalDatabase, $DbMonthsTable> {
  $$DbMonthsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get budgetId =>
      $composableBuilder(column: $table.budgetId, builder: (column) => column);

  GeneratedColumn<String> get month =>
      $composableBuilder(column: $table.month, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<int> get income =>
      $composableBuilder(column: $table.income, builder: (column) => column);

  GeneratedColumn<int> get budgeted =>
      $composableBuilder(column: $table.budgeted, builder: (column) => column);

  GeneratedColumn<int> get activity =>
      $composableBuilder(column: $table.activity, builder: (column) => column);

  GeneratedColumn<int> get toBeBudgeted =>
      $composableBuilder(column: $table.toBeBudgeted, builder: (column) => column);

  GeneratedColumn<int> get ageOfMoney =>
      $composableBuilder(column: $table.ageOfMoney, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);
}

class $$DbMonthsTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $DbMonthsTable,
          DbMonth,
          $$DbMonthsTableFilterComposer,
          $$DbMonthsTableOrderingComposer,
          $$DbMonthsTableAnnotationComposer,
          $$DbMonthsTableCreateCompanionBuilder,
          $$DbMonthsTableUpdateCompanionBuilder,
          (DbMonth, BaseReferences<_$LocalDatabase, $DbMonthsTable, DbMonth>),
          DbMonth,
          PrefetchHooks Function()
        > {
  $$DbMonthsTableTableManager(_$LocalDatabase db, $DbMonthsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$DbMonthsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$DbMonthsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DbMonthsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> budgetId = const Value.absent(),
                Value<String> month = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> income = const Value.absent(),
                Value<int> budgeted = const Value.absent(),
                Value<int> activity = const Value.absent(),
                Value<int> toBeBudgeted = const Value.absent(),
                Value<int?> ageOfMoney = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DbMonthsCompanion(
                budgetId: budgetId,
                month: month,
                note: note,
                income: income,
                budgeted: budgeted,
                activity: activity,
                toBeBudgeted: toBeBudgeted,
                ageOfMoney: ageOfMoney,
                deleted: deleted,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String budgetId,
                required String month,
                Value<String?> note = const Value.absent(),
                required int income,
                required int budgeted,
                required int activity,
                required int toBeBudgeted,
                Value<int?> ageOfMoney = const Value.absent(),
                required bool deleted,
                Value<int> rowid = const Value.absent(),
              }) => DbMonthsCompanion.insert(
                budgetId: budgetId,
                month: month,
                note: note,
                income: income,
                budgeted: budgeted,
                activity: activity,
                toBeBudgeted: toBeBudgeted,
                ageOfMoney: ageOfMoney,
                deleted: deleted,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) =>
              p0.map((e) => (e.readTable(table), BaseReferences(db, table, e))).toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DbMonthsTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $DbMonthsTable,
      DbMonth,
      $$DbMonthsTableFilterComposer,
      $$DbMonthsTableOrderingComposer,
      $$DbMonthsTableAnnotationComposer,
      $$DbMonthsTableCreateCompanionBuilder,
      $$DbMonthsTableUpdateCompanionBuilder,
      (DbMonth, BaseReferences<_$LocalDatabase, $DbMonthsTable, DbMonth>),
      DbMonth,
      PrefetchHooks Function()
    >;
typedef $$DbAccountKnowledgesTableCreateCompanionBuilder =
    DbAccountKnowledgesCompanion Function({
      required String budgetId,
      required int knowledge,
      Value<int> rowid,
    });
typedef $$DbAccountKnowledgesTableUpdateCompanionBuilder =
    DbAccountKnowledgesCompanion Function({
      Value<String> budgetId,
      Value<int> knowledge,
      Value<int> rowid,
    });

class $$DbAccountKnowledgesTableFilterComposer
    extends Composer<_$LocalDatabase, $DbAccountKnowledgesTable> {
  $$DbAccountKnowledgesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get budgetId =>
      $composableBuilder(column: $table.budgetId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get knowledge =>
      $composableBuilder(column: $table.knowledge, builder: (column) => ColumnFilters(column));
}

class $$DbAccountKnowledgesTableOrderingComposer
    extends Composer<_$LocalDatabase, $DbAccountKnowledgesTable> {
  $$DbAccountKnowledgesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get budgetId =>
      $composableBuilder(column: $table.budgetId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get knowledge =>
      $composableBuilder(column: $table.knowledge, builder: (column) => ColumnOrderings(column));
}

class $$DbAccountKnowledgesTableAnnotationComposer
    extends Composer<_$LocalDatabase, $DbAccountKnowledgesTable> {
  $$DbAccountKnowledgesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get budgetId =>
      $composableBuilder(column: $table.budgetId, builder: (column) => column);

  GeneratedColumn<int> get knowledge =>
      $composableBuilder(column: $table.knowledge, builder: (column) => column);
}

class $$DbAccountKnowledgesTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $DbAccountKnowledgesTable,
          DbAccountKnowledge,
          $$DbAccountKnowledgesTableFilterComposer,
          $$DbAccountKnowledgesTableOrderingComposer,
          $$DbAccountKnowledgesTableAnnotationComposer,
          $$DbAccountKnowledgesTableCreateCompanionBuilder,
          $$DbAccountKnowledgesTableUpdateCompanionBuilder,
          (
            DbAccountKnowledge,
            BaseReferences<_$LocalDatabase, $DbAccountKnowledgesTable, DbAccountKnowledge>,
          ),
          DbAccountKnowledge,
          PrefetchHooks Function()
        > {
  $$DbAccountKnowledgesTableTableManager(_$LocalDatabase db, $DbAccountKnowledgesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DbAccountKnowledgesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DbAccountKnowledgesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DbAccountKnowledgesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> budgetId = const Value.absent(),
                Value<int> knowledge = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DbAccountKnowledgesCompanion(
                budgetId: budgetId,
                knowledge: knowledge,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String budgetId,
                required int knowledge,
                Value<int> rowid = const Value.absent(),
              }) => DbAccountKnowledgesCompanion.insert(
                budgetId: budgetId,
                knowledge: knowledge,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) =>
              p0.map((e) => (e.readTable(table), BaseReferences(db, table, e))).toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DbAccountKnowledgesTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $DbAccountKnowledgesTable,
      DbAccountKnowledge,
      $$DbAccountKnowledgesTableFilterComposer,
      $$DbAccountKnowledgesTableOrderingComposer,
      $$DbAccountKnowledgesTableAnnotationComposer,
      $$DbAccountKnowledgesTableCreateCompanionBuilder,
      $$DbAccountKnowledgesTableUpdateCompanionBuilder,
      (
        DbAccountKnowledge,
        BaseReferences<_$LocalDatabase, $DbAccountKnowledgesTable, DbAccountKnowledge>,
      ),
      DbAccountKnowledge,
      PrefetchHooks Function()
    >;
typedef $$DbCategoryKnowledgesTableCreateCompanionBuilder =
    DbCategoryKnowledgesCompanion Function({
      required String budgetId,
      required int knowledge,
      Value<String?> month,
      Value<int> rowid,
    });
typedef $$DbCategoryKnowledgesTableUpdateCompanionBuilder =
    DbCategoryKnowledgesCompanion Function({
      Value<String> budgetId,
      Value<int> knowledge,
      Value<String?> month,
      Value<int> rowid,
    });

class $$DbCategoryKnowledgesTableFilterComposer
    extends Composer<_$LocalDatabase, $DbCategoryKnowledgesTable> {
  $$DbCategoryKnowledgesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get budgetId =>
      $composableBuilder(column: $table.budgetId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get knowledge =>
      $composableBuilder(column: $table.knowledge, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get month =>
      $composableBuilder(column: $table.month, builder: (column) => ColumnFilters(column));
}

class $$DbCategoryKnowledgesTableOrderingComposer
    extends Composer<_$LocalDatabase, $DbCategoryKnowledgesTable> {
  $$DbCategoryKnowledgesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get budgetId =>
      $composableBuilder(column: $table.budgetId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get knowledge =>
      $composableBuilder(column: $table.knowledge, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get month =>
      $composableBuilder(column: $table.month, builder: (column) => ColumnOrderings(column));
}

class $$DbCategoryKnowledgesTableAnnotationComposer
    extends Composer<_$LocalDatabase, $DbCategoryKnowledgesTable> {
  $$DbCategoryKnowledgesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get budgetId =>
      $composableBuilder(column: $table.budgetId, builder: (column) => column);

  GeneratedColumn<int> get knowledge =>
      $composableBuilder(column: $table.knowledge, builder: (column) => column);

  GeneratedColumn<String> get month =>
      $composableBuilder(column: $table.month, builder: (column) => column);
}

class $$DbCategoryKnowledgesTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $DbCategoryKnowledgesTable,
          DbCategoryKnowledge,
          $$DbCategoryKnowledgesTableFilterComposer,
          $$DbCategoryKnowledgesTableOrderingComposer,
          $$DbCategoryKnowledgesTableAnnotationComposer,
          $$DbCategoryKnowledgesTableCreateCompanionBuilder,
          $$DbCategoryKnowledgesTableUpdateCompanionBuilder,
          (
            DbCategoryKnowledge,
            BaseReferences<_$LocalDatabase, $DbCategoryKnowledgesTable, DbCategoryKnowledge>,
          ),
          DbCategoryKnowledge,
          PrefetchHooks Function()
        > {
  $$DbCategoryKnowledgesTableTableManager(_$LocalDatabase db, $DbCategoryKnowledgesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DbCategoryKnowledgesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DbCategoryKnowledgesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DbCategoryKnowledgesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> budgetId = const Value.absent(),
                Value<int> knowledge = const Value.absent(),
                Value<String?> month = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DbCategoryKnowledgesCompanion(
                budgetId: budgetId,
                knowledge: knowledge,
                month: month,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String budgetId,
                required int knowledge,
                Value<String?> month = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DbCategoryKnowledgesCompanion.insert(
                budgetId: budgetId,
                knowledge: knowledge,
                month: month,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) =>
              p0.map((e) => (e.readTable(table), BaseReferences(db, table, e))).toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DbCategoryKnowledgesTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $DbCategoryKnowledgesTable,
      DbCategoryKnowledge,
      $$DbCategoryKnowledgesTableFilterComposer,
      $$DbCategoryKnowledgesTableOrderingComposer,
      $$DbCategoryKnowledgesTableAnnotationComposer,
      $$DbCategoryKnowledgesTableCreateCompanionBuilder,
      $$DbCategoryKnowledgesTableUpdateCompanionBuilder,
      (
        DbCategoryKnowledge,
        BaseReferences<_$LocalDatabase, $DbCategoryKnowledgesTable, DbCategoryKnowledge>,
      ),
      DbCategoryKnowledge,
      PrefetchHooks Function()
    >;
typedef $$DbPayeeKnowledgesTableCreateCompanionBuilder =
    DbPayeeKnowledgesCompanion Function({
      required String budgetId,
      required int knowledge,
      Value<int> rowid,
    });
typedef $$DbPayeeKnowledgesTableUpdateCompanionBuilder =
    DbPayeeKnowledgesCompanion Function({
      Value<String> budgetId,
      Value<int> knowledge,
      Value<int> rowid,
    });

class $$DbPayeeKnowledgesTableFilterComposer
    extends Composer<_$LocalDatabase, $DbPayeeKnowledgesTable> {
  $$DbPayeeKnowledgesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get budgetId =>
      $composableBuilder(column: $table.budgetId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get knowledge =>
      $composableBuilder(column: $table.knowledge, builder: (column) => ColumnFilters(column));
}

class $$DbPayeeKnowledgesTableOrderingComposer
    extends Composer<_$LocalDatabase, $DbPayeeKnowledgesTable> {
  $$DbPayeeKnowledgesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get budgetId =>
      $composableBuilder(column: $table.budgetId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get knowledge =>
      $composableBuilder(column: $table.knowledge, builder: (column) => ColumnOrderings(column));
}

class $$DbPayeeKnowledgesTableAnnotationComposer
    extends Composer<_$LocalDatabase, $DbPayeeKnowledgesTable> {
  $$DbPayeeKnowledgesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get budgetId =>
      $composableBuilder(column: $table.budgetId, builder: (column) => column);

  GeneratedColumn<int> get knowledge =>
      $composableBuilder(column: $table.knowledge, builder: (column) => column);
}

class $$DbPayeeKnowledgesTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $DbPayeeKnowledgesTable,
          DbPayeeKnowledge,
          $$DbPayeeKnowledgesTableFilterComposer,
          $$DbPayeeKnowledgesTableOrderingComposer,
          $$DbPayeeKnowledgesTableAnnotationComposer,
          $$DbPayeeKnowledgesTableCreateCompanionBuilder,
          $$DbPayeeKnowledgesTableUpdateCompanionBuilder,
          (
            DbPayeeKnowledge,
            BaseReferences<_$LocalDatabase, $DbPayeeKnowledgesTable, DbPayeeKnowledge>,
          ),
          DbPayeeKnowledge,
          PrefetchHooks Function()
        > {
  $$DbPayeeKnowledgesTableTableManager(_$LocalDatabase db, $DbPayeeKnowledgesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DbPayeeKnowledgesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DbPayeeKnowledgesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DbPayeeKnowledgesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> budgetId = const Value.absent(),
                Value<int> knowledge = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DbPayeeKnowledgesCompanion(
                budgetId: budgetId,
                knowledge: knowledge,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String budgetId,
                required int knowledge,
                Value<int> rowid = const Value.absent(),
              }) => DbPayeeKnowledgesCompanion.insert(
                budgetId: budgetId,
                knowledge: knowledge,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) =>
              p0.map((e) => (e.readTable(table), BaseReferences(db, table, e))).toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DbPayeeKnowledgesTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $DbPayeeKnowledgesTable,
      DbPayeeKnowledge,
      $$DbPayeeKnowledgesTableFilterComposer,
      $$DbPayeeKnowledgesTableOrderingComposer,
      $$DbPayeeKnowledgesTableAnnotationComposer,
      $$DbPayeeKnowledgesTableCreateCompanionBuilder,
      $$DbPayeeKnowledgesTableUpdateCompanionBuilder,
      (
        DbPayeeKnowledge,
        BaseReferences<_$LocalDatabase, $DbPayeeKnowledgesTable, DbPayeeKnowledge>,
      ),
      DbPayeeKnowledge,
      PrefetchHooks Function()
    >;
typedef $$DbTransactionKnowledgesTableCreateCompanionBuilder =
    DbTransactionKnowledgesCompanion Function({
      required String budgetId,
      required int knowledge,
      Value<int> rowid,
    });
typedef $$DbTransactionKnowledgesTableUpdateCompanionBuilder =
    DbTransactionKnowledgesCompanion Function({
      Value<String> budgetId,
      Value<int> knowledge,
      Value<int> rowid,
    });

class $$DbTransactionKnowledgesTableFilterComposer
    extends Composer<_$LocalDatabase, $DbTransactionKnowledgesTable> {
  $$DbTransactionKnowledgesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get budgetId =>
      $composableBuilder(column: $table.budgetId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get knowledge =>
      $composableBuilder(column: $table.knowledge, builder: (column) => ColumnFilters(column));
}

class $$DbTransactionKnowledgesTableOrderingComposer
    extends Composer<_$LocalDatabase, $DbTransactionKnowledgesTable> {
  $$DbTransactionKnowledgesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get budgetId =>
      $composableBuilder(column: $table.budgetId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get knowledge =>
      $composableBuilder(column: $table.knowledge, builder: (column) => ColumnOrderings(column));
}

class $$DbTransactionKnowledgesTableAnnotationComposer
    extends Composer<_$LocalDatabase, $DbTransactionKnowledgesTable> {
  $$DbTransactionKnowledgesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get budgetId =>
      $composableBuilder(column: $table.budgetId, builder: (column) => column);

  GeneratedColumn<int> get knowledge =>
      $composableBuilder(column: $table.knowledge, builder: (column) => column);
}

class $$DbTransactionKnowledgesTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $DbTransactionKnowledgesTable,
          DbTransactionKnowledge,
          $$DbTransactionKnowledgesTableFilterComposer,
          $$DbTransactionKnowledgesTableOrderingComposer,
          $$DbTransactionKnowledgesTableAnnotationComposer,
          $$DbTransactionKnowledgesTableCreateCompanionBuilder,
          $$DbTransactionKnowledgesTableUpdateCompanionBuilder,
          (
            DbTransactionKnowledge,
            BaseReferences<_$LocalDatabase, $DbTransactionKnowledgesTable, DbTransactionKnowledge>,
          ),
          DbTransactionKnowledge,
          PrefetchHooks Function()
        > {
  $$DbTransactionKnowledgesTableTableManager(
    _$LocalDatabase db,
    $DbTransactionKnowledgesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DbTransactionKnowledgesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DbTransactionKnowledgesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DbTransactionKnowledgesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> budgetId = const Value.absent(),
                Value<int> knowledge = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DbTransactionKnowledgesCompanion(
                budgetId: budgetId,
                knowledge: knowledge,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String budgetId,
                required int knowledge,
                Value<int> rowid = const Value.absent(),
              }) => DbTransactionKnowledgesCompanion.insert(
                budgetId: budgetId,
                knowledge: knowledge,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) =>
              p0.map((e) => (e.readTable(table), BaseReferences(db, table, e))).toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DbTransactionKnowledgesTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $DbTransactionKnowledgesTable,
      DbTransactionKnowledge,
      $$DbTransactionKnowledgesTableFilterComposer,
      $$DbTransactionKnowledgesTableOrderingComposer,
      $$DbTransactionKnowledgesTableAnnotationComposer,
      $$DbTransactionKnowledgesTableCreateCompanionBuilder,
      $$DbTransactionKnowledgesTableUpdateCompanionBuilder,
      (
        DbTransactionKnowledge,
        BaseReferences<_$LocalDatabase, $DbTransactionKnowledgesTable, DbTransactionKnowledge>,
      ),
      DbTransactionKnowledge,
      PrefetchHooks Function()
    >;
typedef $$DbScheduledTransactionKnowledgesTableCreateCompanionBuilder =
    DbScheduledTransactionKnowledgesCompanion Function({
      required String budgetId,
      required int knowledge,
      Value<int> rowid,
    });
typedef $$DbScheduledTransactionKnowledgesTableUpdateCompanionBuilder =
    DbScheduledTransactionKnowledgesCompanion Function({
      Value<String> budgetId,
      Value<int> knowledge,
      Value<int> rowid,
    });

class $$DbScheduledTransactionKnowledgesTableFilterComposer
    extends Composer<_$LocalDatabase, $DbScheduledTransactionKnowledgesTable> {
  $$DbScheduledTransactionKnowledgesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get budgetId =>
      $composableBuilder(column: $table.budgetId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get knowledge =>
      $composableBuilder(column: $table.knowledge, builder: (column) => ColumnFilters(column));
}

class $$DbScheduledTransactionKnowledgesTableOrderingComposer
    extends Composer<_$LocalDatabase, $DbScheduledTransactionKnowledgesTable> {
  $$DbScheduledTransactionKnowledgesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get budgetId =>
      $composableBuilder(column: $table.budgetId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get knowledge =>
      $composableBuilder(column: $table.knowledge, builder: (column) => ColumnOrderings(column));
}

class $$DbScheduledTransactionKnowledgesTableAnnotationComposer
    extends Composer<_$LocalDatabase, $DbScheduledTransactionKnowledgesTable> {
  $$DbScheduledTransactionKnowledgesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get budgetId =>
      $composableBuilder(column: $table.budgetId, builder: (column) => column);

  GeneratedColumn<int> get knowledge =>
      $composableBuilder(column: $table.knowledge, builder: (column) => column);
}

class $$DbScheduledTransactionKnowledgesTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $DbScheduledTransactionKnowledgesTable,
          DbScheduledTransactionKnowledge,
          $$DbScheduledTransactionKnowledgesTableFilterComposer,
          $$DbScheduledTransactionKnowledgesTableOrderingComposer,
          $$DbScheduledTransactionKnowledgesTableAnnotationComposer,
          $$DbScheduledTransactionKnowledgesTableCreateCompanionBuilder,
          $$DbScheduledTransactionKnowledgesTableUpdateCompanionBuilder,
          (
            DbScheduledTransactionKnowledge,
            BaseReferences<
              _$LocalDatabase,
              $DbScheduledTransactionKnowledgesTable,
              DbScheduledTransactionKnowledge
            >,
          ),
          DbScheduledTransactionKnowledge,
          PrefetchHooks Function()
        > {
  $$DbScheduledTransactionKnowledgesTableTableManager(
    _$LocalDatabase db,
    $DbScheduledTransactionKnowledgesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DbScheduledTransactionKnowledgesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DbScheduledTransactionKnowledgesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DbScheduledTransactionKnowledgesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> budgetId = const Value.absent(),
                Value<int> knowledge = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DbScheduledTransactionKnowledgesCompanion(
                budgetId: budgetId,
                knowledge: knowledge,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String budgetId,
                required int knowledge,
                Value<int> rowid = const Value.absent(),
              }) => DbScheduledTransactionKnowledgesCompanion.insert(
                budgetId: budgetId,
                knowledge: knowledge,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) =>
              p0.map((e) => (e.readTable(table), BaseReferences(db, table, e))).toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DbScheduledTransactionKnowledgesTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $DbScheduledTransactionKnowledgesTable,
      DbScheduledTransactionKnowledge,
      $$DbScheduledTransactionKnowledgesTableFilterComposer,
      $$DbScheduledTransactionKnowledgesTableOrderingComposer,
      $$DbScheduledTransactionKnowledgesTableAnnotationComposer,
      $$DbScheduledTransactionKnowledgesTableCreateCompanionBuilder,
      $$DbScheduledTransactionKnowledgesTableUpdateCompanionBuilder,
      (
        DbScheduledTransactionKnowledge,
        BaseReferences<
          _$LocalDatabase,
          $DbScheduledTransactionKnowledgesTable,
          DbScheduledTransactionKnowledge
        >,
      ),
      DbScheduledTransactionKnowledge,
      PrefetchHooks Function()
    >;
typedef $$DbMonthKnowledgesTableCreateCompanionBuilder =
    DbMonthKnowledgesCompanion Function({
      required String budgetId,
      required int knowledge,
      Value<String?> month,
      Value<int> rowid,
    });
typedef $$DbMonthKnowledgesTableUpdateCompanionBuilder =
    DbMonthKnowledgesCompanion Function({
      Value<String> budgetId,
      Value<int> knowledge,
      Value<String?> month,
      Value<int> rowid,
    });

class $$DbMonthKnowledgesTableFilterComposer
    extends Composer<_$LocalDatabase, $DbMonthKnowledgesTable> {
  $$DbMonthKnowledgesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get budgetId =>
      $composableBuilder(column: $table.budgetId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get knowledge =>
      $composableBuilder(column: $table.knowledge, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get month =>
      $composableBuilder(column: $table.month, builder: (column) => ColumnFilters(column));
}

class $$DbMonthKnowledgesTableOrderingComposer
    extends Composer<_$LocalDatabase, $DbMonthKnowledgesTable> {
  $$DbMonthKnowledgesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get budgetId =>
      $composableBuilder(column: $table.budgetId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get knowledge =>
      $composableBuilder(column: $table.knowledge, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get month =>
      $composableBuilder(column: $table.month, builder: (column) => ColumnOrderings(column));
}

class $$DbMonthKnowledgesTableAnnotationComposer
    extends Composer<_$LocalDatabase, $DbMonthKnowledgesTable> {
  $$DbMonthKnowledgesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get budgetId =>
      $composableBuilder(column: $table.budgetId, builder: (column) => column);

  GeneratedColumn<int> get knowledge =>
      $composableBuilder(column: $table.knowledge, builder: (column) => column);

  GeneratedColumn<String> get month =>
      $composableBuilder(column: $table.month, builder: (column) => column);
}

class $$DbMonthKnowledgesTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $DbMonthKnowledgesTable,
          DbMonthKnowledge,
          $$DbMonthKnowledgesTableFilterComposer,
          $$DbMonthKnowledgesTableOrderingComposer,
          $$DbMonthKnowledgesTableAnnotationComposer,
          $$DbMonthKnowledgesTableCreateCompanionBuilder,
          $$DbMonthKnowledgesTableUpdateCompanionBuilder,
          (
            DbMonthKnowledge,
            BaseReferences<_$LocalDatabase, $DbMonthKnowledgesTable, DbMonthKnowledge>,
          ),
          DbMonthKnowledge,
          PrefetchHooks Function()
        > {
  $$DbMonthKnowledgesTableTableManager(_$LocalDatabase db, $DbMonthKnowledgesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DbMonthKnowledgesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DbMonthKnowledgesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DbMonthKnowledgesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> budgetId = const Value.absent(),
                Value<int> knowledge = const Value.absent(),
                Value<String?> month = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DbMonthKnowledgesCompanion(
                budgetId: budgetId,
                knowledge: knowledge,
                month: month,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String budgetId,
                required int knowledge,
                Value<String?> month = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DbMonthKnowledgesCompanion.insert(
                budgetId: budgetId,
                knowledge: knowledge,
                month: month,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) =>
              p0.map((e) => (e.readTable(table), BaseReferences(db, table, e))).toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DbMonthKnowledgesTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $DbMonthKnowledgesTable,
      DbMonthKnowledge,
      $$DbMonthKnowledgesTableFilterComposer,
      $$DbMonthKnowledgesTableOrderingComposer,
      $$DbMonthKnowledgesTableAnnotationComposer,
      $$DbMonthKnowledgesTableCreateCompanionBuilder,
      $$DbMonthKnowledgesTableUpdateCompanionBuilder,
      (
        DbMonthKnowledge,
        BaseReferences<_$LocalDatabase, $DbMonthKnowledgesTable, DbMonthKnowledge>,
      ),
      DbMonthKnowledge,
      PrefetchHooks Function()
    >;
typedef $$DbCategoryViewsTableCreateCompanionBuilder =
    DbCategoryViewsCompanion Function({
      Value<int> id,
      required String name,
      required String budgetId,
      required bool isDeleted,
    });
typedef $$DbCategoryViewsTableUpdateCompanionBuilder =
    DbCategoryViewsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> budgetId,
      Value<bool> isDeleted,
    });

class $$DbCategoryViewsTableFilterComposer
    extends Composer<_$LocalDatabase, $DbCategoryViewsTable> {
  $$DbCategoryViewsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get budgetId =>
      $composableBuilder(column: $table.budgetId, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => ColumnFilters(column));
}

class $$DbCategoryViewsTableOrderingComposer
    extends Composer<_$LocalDatabase, $DbCategoryViewsTable> {
  $$DbCategoryViewsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get budgetId =>
      $composableBuilder(column: $table.budgetId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => ColumnOrderings(column));
}

class $$DbCategoryViewsTableAnnotationComposer
    extends Composer<_$LocalDatabase, $DbCategoryViewsTable> {
  $$DbCategoryViewsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get budgetId =>
      $composableBuilder(column: $table.budgetId, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);
}

class $$DbCategoryViewsTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $DbCategoryViewsTable,
          DbCategoryView,
          $$DbCategoryViewsTableFilterComposer,
          $$DbCategoryViewsTableOrderingComposer,
          $$DbCategoryViewsTableAnnotationComposer,
          $$DbCategoryViewsTableCreateCompanionBuilder,
          $$DbCategoryViewsTableUpdateCompanionBuilder,
          (DbCategoryView, BaseReferences<_$LocalDatabase, $DbCategoryViewsTable, DbCategoryView>),
          DbCategoryView,
          PrefetchHooks Function()
        > {
  $$DbCategoryViewsTableTableManager(_$LocalDatabase db, $DbCategoryViewsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DbCategoryViewsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DbCategoryViewsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DbCategoryViewsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> budgetId = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
              }) => DbCategoryViewsCompanion(
                id: id,
                name: name,
                budgetId: budgetId,
                isDeleted: isDeleted,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String budgetId,
                required bool isDeleted,
              }) => DbCategoryViewsCompanion.insert(
                id: id,
                name: name,
                budgetId: budgetId,
                isDeleted: isDeleted,
              ),
          withReferenceMapper: (p0) =>
              p0.map((e) => (e.readTable(table), BaseReferences(db, table, e))).toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DbCategoryViewsTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $DbCategoryViewsTable,
      DbCategoryView,
      $$DbCategoryViewsTableFilterComposer,
      $$DbCategoryViewsTableOrderingComposer,
      $$DbCategoryViewsTableAnnotationComposer,
      $$DbCategoryViewsTableCreateCompanionBuilder,
      $$DbCategoryViewsTableUpdateCompanionBuilder,
      (DbCategoryView, BaseReferences<_$LocalDatabase, $DbCategoryViewsTable, DbCategoryView>),
      DbCategoryView,
      PrefetchHooks Function()
    >;
typedef $$DbCategoryViewCategoriesTableCreateCompanionBuilder =
    DbCategoryViewCategoriesCompanion Function({
      Value<int> id,
      required int categoryViewId,
      required String categoryId,
    });
typedef $$DbCategoryViewCategoriesTableUpdateCompanionBuilder =
    DbCategoryViewCategoriesCompanion Function({
      Value<int> id,
      Value<int> categoryViewId,
      Value<String> categoryId,
    });

class $$DbCategoryViewCategoriesTableFilterComposer
    extends Composer<_$LocalDatabase, $DbCategoryViewCategoriesTable> {
  $$DbCategoryViewCategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get categoryViewId =>
      $composableBuilder(column: $table.categoryViewId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get categoryId =>
      $composableBuilder(column: $table.categoryId, builder: (column) => ColumnFilters(column));
}

class $$DbCategoryViewCategoriesTableOrderingComposer
    extends Composer<_$LocalDatabase, $DbCategoryViewCategoriesTable> {
  $$DbCategoryViewCategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get categoryViewId => $composableBuilder(
    column: $table.categoryViewId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoryId =>
      $composableBuilder(column: $table.categoryId, builder: (column) => ColumnOrderings(column));
}

class $$DbCategoryViewCategoriesTableAnnotationComposer
    extends Composer<_$LocalDatabase, $DbCategoryViewCategoriesTable> {
  $$DbCategoryViewCategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get categoryViewId =>
      $composableBuilder(column: $table.categoryViewId, builder: (column) => column);

  GeneratedColumn<String> get categoryId =>
      $composableBuilder(column: $table.categoryId, builder: (column) => column);
}

class $$DbCategoryViewCategoriesTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $DbCategoryViewCategoriesTable,
          DbCategoryViewCategory,
          $$DbCategoryViewCategoriesTableFilterComposer,
          $$DbCategoryViewCategoriesTableOrderingComposer,
          $$DbCategoryViewCategoriesTableAnnotationComposer,
          $$DbCategoryViewCategoriesTableCreateCompanionBuilder,
          $$DbCategoryViewCategoriesTableUpdateCompanionBuilder,
          (
            DbCategoryViewCategory,
            BaseReferences<_$LocalDatabase, $DbCategoryViewCategoriesTable, DbCategoryViewCategory>,
          ),
          DbCategoryViewCategory,
          PrefetchHooks Function()
        > {
  $$DbCategoryViewCategoriesTableTableManager(
    _$LocalDatabase db,
    $DbCategoryViewCategoriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DbCategoryViewCategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DbCategoryViewCategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DbCategoryViewCategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> categoryViewId = const Value.absent(),
                Value<String> categoryId = const Value.absent(),
              }) => DbCategoryViewCategoriesCompanion(
                id: id,
                categoryViewId: categoryViewId,
                categoryId: categoryId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int categoryViewId,
                required String categoryId,
              }) => DbCategoryViewCategoriesCompanion.insert(
                id: id,
                categoryViewId: categoryViewId,
                categoryId: categoryId,
              ),
          withReferenceMapper: (p0) =>
              p0.map((e) => (e.readTable(table), BaseReferences(db, table, e))).toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DbCategoryViewCategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $DbCategoryViewCategoriesTable,
      DbCategoryViewCategory,
      $$DbCategoryViewCategoriesTableFilterComposer,
      $$DbCategoryViewCategoriesTableOrderingComposer,
      $$DbCategoryViewCategoriesTableAnnotationComposer,
      $$DbCategoryViewCategoriesTableCreateCompanionBuilder,
      $$DbCategoryViewCategoriesTableUpdateCompanionBuilder,
      (
        DbCategoryViewCategory,
        BaseReferences<_$LocalDatabase, $DbCategoryViewCategoriesTable, DbCategoryViewCategory>,
      ),
      DbCategoryViewCategory,
      PrefetchHooks Function()
    >;
typedef $$DbCategoryViewCategoryGroupsTableCreateCompanionBuilder =
    DbCategoryViewCategoryGroupsCompanion Function({
      Value<int> id,
      required int categoryViewId,
      required String categoryGroupId,
    });
typedef $$DbCategoryViewCategoryGroupsTableUpdateCompanionBuilder =
    DbCategoryViewCategoryGroupsCompanion Function({
      Value<int> id,
      Value<int> categoryViewId,
      Value<String> categoryGroupId,
    });

class $$DbCategoryViewCategoryGroupsTableFilterComposer
    extends Composer<_$LocalDatabase, $DbCategoryViewCategoryGroupsTable> {
  $$DbCategoryViewCategoryGroupsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get categoryViewId =>
      $composableBuilder(column: $table.categoryViewId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get categoryGroupId => $composableBuilder(
    column: $table.categoryGroupId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DbCategoryViewCategoryGroupsTableOrderingComposer
    extends Composer<_$LocalDatabase, $DbCategoryViewCategoryGroupsTable> {
  $$DbCategoryViewCategoryGroupsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get categoryViewId => $composableBuilder(
    column: $table.categoryViewId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoryGroupId => $composableBuilder(
    column: $table.categoryGroupId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DbCategoryViewCategoryGroupsTableAnnotationComposer
    extends Composer<_$LocalDatabase, $DbCategoryViewCategoryGroupsTable> {
  $$DbCategoryViewCategoryGroupsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get categoryViewId =>
      $composableBuilder(column: $table.categoryViewId, builder: (column) => column);

  GeneratedColumn<String> get categoryGroupId =>
      $composableBuilder(column: $table.categoryGroupId, builder: (column) => column);
}

class $$DbCategoryViewCategoryGroupsTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $DbCategoryViewCategoryGroupsTable,
          DbCategoryViewCategoryGroup,
          $$DbCategoryViewCategoryGroupsTableFilterComposer,
          $$DbCategoryViewCategoryGroupsTableOrderingComposer,
          $$DbCategoryViewCategoryGroupsTableAnnotationComposer,
          $$DbCategoryViewCategoryGroupsTableCreateCompanionBuilder,
          $$DbCategoryViewCategoryGroupsTableUpdateCompanionBuilder,
          (
            DbCategoryViewCategoryGroup,
            BaseReferences<
              _$LocalDatabase,
              $DbCategoryViewCategoryGroupsTable,
              DbCategoryViewCategoryGroup
            >,
          ),
          DbCategoryViewCategoryGroup,
          PrefetchHooks Function()
        > {
  $$DbCategoryViewCategoryGroupsTableTableManager(
    _$LocalDatabase db,
    $DbCategoryViewCategoryGroupsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DbCategoryViewCategoryGroupsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DbCategoryViewCategoryGroupsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DbCategoryViewCategoryGroupsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> categoryViewId = const Value.absent(),
                Value<String> categoryGroupId = const Value.absent(),
              }) => DbCategoryViewCategoryGroupsCompanion(
                id: id,
                categoryViewId: categoryViewId,
                categoryGroupId: categoryGroupId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int categoryViewId,
                required String categoryGroupId,
              }) => DbCategoryViewCategoryGroupsCompanion.insert(
                id: id,
                categoryViewId: categoryViewId,
                categoryGroupId: categoryGroupId,
              ),
          withReferenceMapper: (p0) =>
              p0.map((e) => (e.readTable(table), BaseReferences(db, table, e))).toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DbCategoryViewCategoryGroupsTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $DbCategoryViewCategoryGroupsTable,
      DbCategoryViewCategoryGroup,
      $$DbCategoryViewCategoryGroupsTableFilterComposer,
      $$DbCategoryViewCategoryGroupsTableOrderingComposer,
      $$DbCategoryViewCategoryGroupsTableAnnotationComposer,
      $$DbCategoryViewCategoryGroupsTableCreateCompanionBuilder,
      $$DbCategoryViewCategoryGroupsTableUpdateCompanionBuilder,
      (
        DbCategoryViewCategoryGroup,
        BaseReferences<
          _$LocalDatabase,
          $DbCategoryViewCategoryGroupsTable,
          DbCategoryViewCategoryGroup
        >,
      ),
      DbCategoryViewCategoryGroup,
      PrefetchHooks Function()
    >;
typedef $$DbLegacySpendTrackersTableCreateCompanionBuilder =
    DbLegacySpendTrackersCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> nickName,
      required String sourceId,
      required String budgetId,
      required bool isDeleted,
      required SpendTrackerType type,
    });
typedef $$DbLegacySpendTrackersTableUpdateCompanionBuilder =
    DbLegacySpendTrackersCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> nickName,
      Value<String> sourceId,
      Value<String> budgetId,
      Value<bool> isDeleted,
      Value<SpendTrackerType> type,
    });

class $$DbLegacySpendTrackersTableFilterComposer
    extends Composer<_$LocalDatabase, $DbLegacySpendTrackersTable> {
  $$DbLegacySpendTrackersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nickName =>
      $composableBuilder(column: $table.nickName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sourceId =>
      $composableBuilder(column: $table.sourceId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get budgetId =>
      $composableBuilder(column: $table.budgetId, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<SpendTrackerType, SpendTrackerType, String> get type =>
      $composableBuilder(
        column: $table.type,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );
}

class $$DbLegacySpendTrackersTableOrderingComposer
    extends Composer<_$LocalDatabase, $DbLegacySpendTrackersTable> {
  $$DbLegacySpendTrackersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nickName =>
      $composableBuilder(column: $table.nickName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sourceId =>
      $composableBuilder(column: $table.sourceId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get budgetId =>
      $composableBuilder(column: $table.budgetId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => ColumnOrderings(column));
}

class $$DbLegacySpendTrackersTableAnnotationComposer
    extends Composer<_$LocalDatabase, $DbLegacySpendTrackersTable> {
  $$DbLegacySpendTrackersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get nickName =>
      $composableBuilder(column: $table.nickName, builder: (column) => column);

  GeneratedColumn<String> get sourceId =>
      $composableBuilder(column: $table.sourceId, builder: (column) => column);

  GeneratedColumn<String> get budgetId =>
      $composableBuilder(column: $table.budgetId, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SpendTrackerType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);
}

class $$DbLegacySpendTrackersTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $DbLegacySpendTrackersTable,
          DbLegacySpendTracker,
          $$DbLegacySpendTrackersTableFilterComposer,
          $$DbLegacySpendTrackersTableOrderingComposer,
          $$DbLegacySpendTrackersTableAnnotationComposer,
          $$DbLegacySpendTrackersTableCreateCompanionBuilder,
          $$DbLegacySpendTrackersTableUpdateCompanionBuilder,
          (
            DbLegacySpendTracker,
            BaseReferences<_$LocalDatabase, $DbLegacySpendTrackersTable, DbLegacySpendTracker>,
          ),
          DbLegacySpendTracker,
          PrefetchHooks Function()
        > {
  $$DbLegacySpendTrackersTableTableManager(_$LocalDatabase db, $DbLegacySpendTrackersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DbLegacySpendTrackersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DbLegacySpendTrackersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DbLegacySpendTrackersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> nickName = const Value.absent(),
                Value<String> sourceId = const Value.absent(),
                Value<String> budgetId = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<SpendTrackerType> type = const Value.absent(),
              }) => DbLegacySpendTrackersCompanion(
                id: id,
                name: name,
                nickName: nickName,
                sourceId: sourceId,
                budgetId: budgetId,
                isDeleted: isDeleted,
                type: type,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> nickName = const Value.absent(),
                required String sourceId,
                required String budgetId,
                required bool isDeleted,
                required SpendTrackerType type,
              }) => DbLegacySpendTrackersCompanion.insert(
                id: id,
                name: name,
                nickName: nickName,
                sourceId: sourceId,
                budgetId: budgetId,
                isDeleted: isDeleted,
                type: type,
              ),
          withReferenceMapper: (p0) =>
              p0.map((e) => (e.readTable(table), BaseReferences(db, table, e))).toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DbLegacySpendTrackersTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $DbLegacySpendTrackersTable,
      DbLegacySpendTracker,
      $$DbLegacySpendTrackersTableFilterComposer,
      $$DbLegacySpendTrackersTableOrderingComposer,
      $$DbLegacySpendTrackersTableAnnotationComposer,
      $$DbLegacySpendTrackersTableCreateCompanionBuilder,
      $$DbLegacySpendTrackersTableUpdateCompanionBuilder,
      (
        DbLegacySpendTracker,
        BaseReferences<_$LocalDatabase, $DbLegacySpendTrackersTable, DbLegacySpendTracker>,
      ),
      DbLegacySpendTracker,
      PrefetchHooks Function()
    >;
typedef $$DbQuerySpendTrackersTableCreateCompanionBuilder =
    DbQuerySpendTrackersCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> nickName,
      required int conditionId,
      required String budgetId,
      required bool isDeleted,
    });
typedef $$DbQuerySpendTrackersTableUpdateCompanionBuilder =
    DbQuerySpendTrackersCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> nickName,
      Value<int> conditionId,
      Value<String> budgetId,
      Value<bool> isDeleted,
    });

class $$DbQuerySpendTrackersTableFilterComposer
    extends Composer<_$LocalDatabase, $DbQuerySpendTrackersTable> {
  $$DbQuerySpendTrackersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nickName =>
      $composableBuilder(column: $table.nickName, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get conditionId =>
      $composableBuilder(column: $table.conditionId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get budgetId =>
      $composableBuilder(column: $table.budgetId, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => ColumnFilters(column));
}

class $$DbQuerySpendTrackersTableOrderingComposer
    extends Composer<_$LocalDatabase, $DbQuerySpendTrackersTable> {
  $$DbQuerySpendTrackersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nickName =>
      $composableBuilder(column: $table.nickName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get conditionId =>
      $composableBuilder(column: $table.conditionId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get budgetId =>
      $composableBuilder(column: $table.budgetId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => ColumnOrderings(column));
}

class $$DbQuerySpendTrackersTableAnnotationComposer
    extends Composer<_$LocalDatabase, $DbQuerySpendTrackersTable> {
  $$DbQuerySpendTrackersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get nickName =>
      $composableBuilder(column: $table.nickName, builder: (column) => column);

  GeneratedColumn<int> get conditionId =>
      $composableBuilder(column: $table.conditionId, builder: (column) => column);

  GeneratedColumn<String> get budgetId =>
      $composableBuilder(column: $table.budgetId, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);
}

class $$DbQuerySpendTrackersTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $DbQuerySpendTrackersTable,
          DbQuerySpendTracker,
          $$DbQuerySpendTrackersTableFilterComposer,
          $$DbQuerySpendTrackersTableOrderingComposer,
          $$DbQuerySpendTrackersTableAnnotationComposer,
          $$DbQuerySpendTrackersTableCreateCompanionBuilder,
          $$DbQuerySpendTrackersTableUpdateCompanionBuilder,
          (
            DbQuerySpendTracker,
            BaseReferences<_$LocalDatabase, $DbQuerySpendTrackersTable, DbQuerySpendTracker>,
          ),
          DbQuerySpendTracker,
          PrefetchHooks Function()
        > {
  $$DbQuerySpendTrackersTableTableManager(_$LocalDatabase db, $DbQuerySpendTrackersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DbQuerySpendTrackersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DbQuerySpendTrackersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DbQuerySpendTrackersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> nickName = const Value.absent(),
                Value<int> conditionId = const Value.absent(),
                Value<String> budgetId = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
              }) => DbQuerySpendTrackersCompanion(
                id: id,
                name: name,
                nickName: nickName,
                conditionId: conditionId,
                budgetId: budgetId,
                isDeleted: isDeleted,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> nickName = const Value.absent(),
                required int conditionId,
                required String budgetId,
                required bool isDeleted,
              }) => DbQuerySpendTrackersCompanion.insert(
                id: id,
                name: name,
                nickName: nickName,
                conditionId: conditionId,
                budgetId: budgetId,
                isDeleted: isDeleted,
              ),
          withReferenceMapper: (p0) =>
              p0.map((e) => (e.readTable(table), BaseReferences(db, table, e))).toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DbQuerySpendTrackersTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $DbQuerySpendTrackersTable,
      DbQuerySpendTracker,
      $$DbQuerySpendTrackersTableFilterComposer,
      $$DbQuerySpendTrackersTableOrderingComposer,
      $$DbQuerySpendTrackersTableAnnotationComposer,
      $$DbQuerySpendTrackersTableCreateCompanionBuilder,
      $$DbQuerySpendTrackersTableUpdateCompanionBuilder,
      (
        DbQuerySpendTracker,
        BaseReferences<_$LocalDatabase, $DbQuerySpendTrackersTable, DbQuerySpendTracker>,
      ),
      DbQuerySpendTracker,
      PrefetchHooks Function()
    >;
typedef $$DbSpendTrackerConditionsTableCreateCompanionBuilder =
    DbSpendTrackerConditionsCompanion Function({
      Value<int> id,
      required String type,
      Value<int?> parentId,
    });
typedef $$DbSpendTrackerConditionsTableUpdateCompanionBuilder =
    DbSpendTrackerConditionsCompanion Function({
      Value<int> id,
      Value<String> type,
      Value<int?> parentId,
    });

class $$DbSpendTrackerConditionsTableFilterComposer
    extends Composer<_$LocalDatabase, $DbSpendTrackerConditionsTable> {
  $$DbSpendTrackerConditionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get parentId =>
      $composableBuilder(column: $table.parentId, builder: (column) => ColumnFilters(column));
}

class $$DbSpendTrackerConditionsTableOrderingComposer
    extends Composer<_$LocalDatabase, $DbSpendTrackerConditionsTable> {
  $$DbSpendTrackerConditionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get parentId =>
      $composableBuilder(column: $table.parentId, builder: (column) => ColumnOrderings(column));
}

class $$DbSpendTrackerConditionsTableAnnotationComposer
    extends Composer<_$LocalDatabase, $DbSpendTrackerConditionsTable> {
  $$DbSpendTrackerConditionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get parentId =>
      $composableBuilder(column: $table.parentId, builder: (column) => column);
}

class $$DbSpendTrackerConditionsTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $DbSpendTrackerConditionsTable,
          DbSpendTrackerCondition,
          $$DbSpendTrackerConditionsTableFilterComposer,
          $$DbSpendTrackerConditionsTableOrderingComposer,
          $$DbSpendTrackerConditionsTableAnnotationComposer,
          $$DbSpendTrackerConditionsTableCreateCompanionBuilder,
          $$DbSpendTrackerConditionsTableUpdateCompanionBuilder,
          (
            DbSpendTrackerCondition,
            BaseReferences<
              _$LocalDatabase,
              $DbSpendTrackerConditionsTable,
              DbSpendTrackerCondition
            >,
          ),
          DbSpendTrackerCondition,
          PrefetchHooks Function()
        > {
  $$DbSpendTrackerConditionsTableTableManager(
    _$LocalDatabase db,
    $DbSpendTrackerConditionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DbSpendTrackerConditionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DbSpendTrackerConditionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DbSpendTrackerConditionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<int?> parentId = const Value.absent(),
              }) => DbSpendTrackerConditionsCompanion(id: id, type: type, parentId: parentId),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String type,
                Value<int?> parentId = const Value.absent(),
              }) =>
                  DbSpendTrackerConditionsCompanion.insert(id: id, type: type, parentId: parentId),
          withReferenceMapper: (p0) =>
              p0.map((e) => (e.readTable(table), BaseReferences(db, table, e))).toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DbSpendTrackerConditionsTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $DbSpendTrackerConditionsTable,
      DbSpendTrackerCondition,
      $$DbSpendTrackerConditionsTableFilterComposer,
      $$DbSpendTrackerConditionsTableOrderingComposer,
      $$DbSpendTrackerConditionsTableAnnotationComposer,
      $$DbSpendTrackerConditionsTableCreateCompanionBuilder,
      $$DbSpendTrackerConditionsTableUpdateCompanionBuilder,
      (
        DbSpendTrackerCondition,
        BaseReferences<_$LocalDatabase, $DbSpendTrackerConditionsTable, DbSpendTrackerCondition>,
      ),
      DbSpendTrackerCondition,
      PrefetchHooks Function()
    >;
typedef $$DbSpendTrackerTestsTableCreateCompanionBuilder =
    DbSpendTrackerTestsCompanion Function({
      Value<int> id,
      required int conditionId,
      required String testType,
      Value<String?> testValue,
    });
typedef $$DbSpendTrackerTestsTableUpdateCompanionBuilder =
    DbSpendTrackerTestsCompanion Function({
      Value<int> id,
      Value<int> conditionId,
      Value<String> testType,
      Value<String?> testValue,
    });

class $$DbSpendTrackerTestsTableFilterComposer
    extends Composer<_$LocalDatabase, $DbSpendTrackerTestsTable> {
  $$DbSpendTrackerTestsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get conditionId =>
      $composableBuilder(column: $table.conditionId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get testType =>
      $composableBuilder(column: $table.testType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get testValue =>
      $composableBuilder(column: $table.testValue, builder: (column) => ColumnFilters(column));
}

class $$DbSpendTrackerTestsTableOrderingComposer
    extends Composer<_$LocalDatabase, $DbSpendTrackerTestsTable> {
  $$DbSpendTrackerTestsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get conditionId =>
      $composableBuilder(column: $table.conditionId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get testType =>
      $composableBuilder(column: $table.testType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get testValue =>
      $composableBuilder(column: $table.testValue, builder: (column) => ColumnOrderings(column));
}

class $$DbSpendTrackerTestsTableAnnotationComposer
    extends Composer<_$LocalDatabase, $DbSpendTrackerTestsTable> {
  $$DbSpendTrackerTestsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get conditionId =>
      $composableBuilder(column: $table.conditionId, builder: (column) => column);

  GeneratedColumn<String> get testType =>
      $composableBuilder(column: $table.testType, builder: (column) => column);

  GeneratedColumn<String> get testValue =>
      $composableBuilder(column: $table.testValue, builder: (column) => column);
}

class $$DbSpendTrackerTestsTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $DbSpendTrackerTestsTable,
          DbSpendTrackerTest,
          $$DbSpendTrackerTestsTableFilterComposer,
          $$DbSpendTrackerTestsTableOrderingComposer,
          $$DbSpendTrackerTestsTableAnnotationComposer,
          $$DbSpendTrackerTestsTableCreateCompanionBuilder,
          $$DbSpendTrackerTestsTableUpdateCompanionBuilder,
          (
            DbSpendTrackerTest,
            BaseReferences<_$LocalDatabase, $DbSpendTrackerTestsTable, DbSpendTrackerTest>,
          ),
          DbSpendTrackerTest,
          PrefetchHooks Function()
        > {
  $$DbSpendTrackerTestsTableTableManager(_$LocalDatabase db, $DbSpendTrackerTestsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DbSpendTrackerTestsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DbSpendTrackerTestsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DbSpendTrackerTestsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> conditionId = const Value.absent(),
                Value<String> testType = const Value.absent(),
                Value<String?> testValue = const Value.absent(),
              }) => DbSpendTrackerTestsCompanion(
                id: id,
                conditionId: conditionId,
                testType: testType,
                testValue: testValue,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int conditionId,
                required String testType,
                Value<String?> testValue = const Value.absent(),
              }) => DbSpendTrackerTestsCompanion.insert(
                id: id,
                conditionId: conditionId,
                testType: testType,
                testValue: testValue,
              ),
          withReferenceMapper: (p0) =>
              p0.map((e) => (e.readTable(table), BaseReferences(db, table, e))).toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DbSpendTrackerTestsTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $DbSpendTrackerTestsTable,
      DbSpendTrackerTest,
      $$DbSpendTrackerTestsTableFilterComposer,
      $$DbSpendTrackerTestsTableOrderingComposer,
      $$DbSpendTrackerTestsTableAnnotationComposer,
      $$DbSpendTrackerTestsTableCreateCompanionBuilder,
      $$DbSpendTrackerTestsTableUpdateCompanionBuilder,
      (
        DbSpendTrackerTest,
        BaseReferences<_$LocalDatabase, $DbSpendTrackerTestsTable, DbSpendTrackerTest>,
      ),
      DbSpendTrackerTest,
      PrefetchHooks Function()
    >;
typedef $$DbFrugalMonthsTableCreateCompanionBuilder =
    DbFrugalMonthsCompanion Function({
      Value<int> id,
      required String budgetId,
      required String month,
      required int targetAmount,
      required bool isDeleted,
    });
typedef $$DbFrugalMonthsTableUpdateCompanionBuilder =
    DbFrugalMonthsCompanion Function({
      Value<int> id,
      Value<String> budgetId,
      Value<String> month,
      Value<int> targetAmount,
      Value<bool> isDeleted,
    });

class $$DbFrugalMonthsTableFilterComposer extends Composer<_$LocalDatabase, $DbFrugalMonthsTable> {
  $$DbFrugalMonthsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get budgetId =>
      $composableBuilder(column: $table.budgetId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get month =>
      $composableBuilder(column: $table.month, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get targetAmount =>
      $composableBuilder(column: $table.targetAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => ColumnFilters(column));
}

class $$DbFrugalMonthsTableOrderingComposer
    extends Composer<_$LocalDatabase, $DbFrugalMonthsTable> {
  $$DbFrugalMonthsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get budgetId =>
      $composableBuilder(column: $table.budgetId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get month =>
      $composableBuilder(column: $table.month, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get targetAmount =>
      $composableBuilder(column: $table.targetAmount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => ColumnOrderings(column));
}

class $$DbFrugalMonthsTableAnnotationComposer
    extends Composer<_$LocalDatabase, $DbFrugalMonthsTable> {
  $$DbFrugalMonthsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get budgetId =>
      $composableBuilder(column: $table.budgetId, builder: (column) => column);

  GeneratedColumn<String> get month =>
      $composableBuilder(column: $table.month, builder: (column) => column);

  GeneratedColumn<int> get targetAmount =>
      $composableBuilder(column: $table.targetAmount, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);
}

class $$DbFrugalMonthsTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $DbFrugalMonthsTable,
          DbFrugalMonth,
          $$DbFrugalMonthsTableFilterComposer,
          $$DbFrugalMonthsTableOrderingComposer,
          $$DbFrugalMonthsTableAnnotationComposer,
          $$DbFrugalMonthsTableCreateCompanionBuilder,
          $$DbFrugalMonthsTableUpdateCompanionBuilder,
          (DbFrugalMonth, BaseReferences<_$LocalDatabase, $DbFrugalMonthsTable, DbFrugalMonth>),
          DbFrugalMonth,
          PrefetchHooks Function()
        > {
  $$DbFrugalMonthsTableTableManager(_$LocalDatabase db, $DbFrugalMonthsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DbFrugalMonthsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DbFrugalMonthsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DbFrugalMonthsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> budgetId = const Value.absent(),
                Value<String> month = const Value.absent(),
                Value<int> targetAmount = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
              }) => DbFrugalMonthsCompanion(
                id: id,
                budgetId: budgetId,
                month: month,
                targetAmount: targetAmount,
                isDeleted: isDeleted,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String budgetId,
                required String month,
                required int targetAmount,
                required bool isDeleted,
              }) => DbFrugalMonthsCompanion.insert(
                id: id,
                budgetId: budgetId,
                month: month,
                targetAmount: targetAmount,
                isDeleted: isDeleted,
              ),
          withReferenceMapper: (p0) =>
              p0.map((e) => (e.readTable(table), BaseReferences(db, table, e))).toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DbFrugalMonthsTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $DbFrugalMonthsTable,
      DbFrugalMonth,
      $$DbFrugalMonthsTableFilterComposer,
      $$DbFrugalMonthsTableOrderingComposer,
      $$DbFrugalMonthsTableAnnotationComposer,
      $$DbFrugalMonthsTableCreateCompanionBuilder,
      $$DbFrugalMonthsTableUpdateCompanionBuilder,
      (DbFrugalMonth, BaseReferences<_$LocalDatabase, $DbFrugalMonthsTable, DbFrugalMonth>),
      DbFrugalMonth,
      PrefetchHooks Function()
    >;
typedef $$DbFrugalMonthCategoriesTableCreateCompanionBuilder =
    DbFrugalMonthCategoriesCompanion Function({
      Value<int> id,
      required int frugalMonthId,
      required String categoryId,
    });
typedef $$DbFrugalMonthCategoriesTableUpdateCompanionBuilder =
    DbFrugalMonthCategoriesCompanion Function({
      Value<int> id,
      Value<int> frugalMonthId,
      Value<String> categoryId,
    });

class $$DbFrugalMonthCategoriesTableFilterComposer
    extends Composer<_$LocalDatabase, $DbFrugalMonthCategoriesTable> {
  $$DbFrugalMonthCategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get frugalMonthId =>
      $composableBuilder(column: $table.frugalMonthId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get categoryId =>
      $composableBuilder(column: $table.categoryId, builder: (column) => ColumnFilters(column));
}

class $$DbFrugalMonthCategoriesTableOrderingComposer
    extends Composer<_$LocalDatabase, $DbFrugalMonthCategoriesTable> {
  $$DbFrugalMonthCategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get frugalMonthId => $composableBuilder(
    column: $table.frugalMonthId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoryId =>
      $composableBuilder(column: $table.categoryId, builder: (column) => ColumnOrderings(column));
}

class $$DbFrugalMonthCategoriesTableAnnotationComposer
    extends Composer<_$LocalDatabase, $DbFrugalMonthCategoriesTable> {
  $$DbFrugalMonthCategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get frugalMonthId =>
      $composableBuilder(column: $table.frugalMonthId, builder: (column) => column);

  GeneratedColumn<String> get categoryId =>
      $composableBuilder(column: $table.categoryId, builder: (column) => column);
}

class $$DbFrugalMonthCategoriesTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $DbFrugalMonthCategoriesTable,
          DbFrugalMonthCategory,
          $$DbFrugalMonthCategoriesTableFilterComposer,
          $$DbFrugalMonthCategoriesTableOrderingComposer,
          $$DbFrugalMonthCategoriesTableAnnotationComposer,
          $$DbFrugalMonthCategoriesTableCreateCompanionBuilder,
          $$DbFrugalMonthCategoriesTableUpdateCompanionBuilder,
          (
            DbFrugalMonthCategory,
            BaseReferences<_$LocalDatabase, $DbFrugalMonthCategoriesTable, DbFrugalMonthCategory>,
          ),
          DbFrugalMonthCategory,
          PrefetchHooks Function()
        > {
  $$DbFrugalMonthCategoriesTableTableManager(
    _$LocalDatabase db,
    $DbFrugalMonthCategoriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DbFrugalMonthCategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DbFrugalMonthCategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DbFrugalMonthCategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> frugalMonthId = const Value.absent(),
                Value<String> categoryId = const Value.absent(),
              }) => DbFrugalMonthCategoriesCompanion(
                id: id,
                frugalMonthId: frugalMonthId,
                categoryId: categoryId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int frugalMonthId,
                required String categoryId,
              }) => DbFrugalMonthCategoriesCompanion.insert(
                id: id,
                frugalMonthId: frugalMonthId,
                categoryId: categoryId,
              ),
          withReferenceMapper: (p0) =>
              p0.map((e) => (e.readTable(table), BaseReferences(db, table, e))).toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DbFrugalMonthCategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $DbFrugalMonthCategoriesTable,
      DbFrugalMonthCategory,
      $$DbFrugalMonthCategoriesTableFilterComposer,
      $$DbFrugalMonthCategoriesTableOrderingComposer,
      $$DbFrugalMonthCategoriesTableAnnotationComposer,
      $$DbFrugalMonthCategoriesTableCreateCompanionBuilder,
      $$DbFrugalMonthCategoriesTableUpdateCompanionBuilder,
      (
        DbFrugalMonthCategory,
        BaseReferences<_$LocalDatabase, $DbFrugalMonthCategoriesTable, DbFrugalMonthCategory>,
      ),
      DbFrugalMonthCategory,
      PrefetchHooks Function()
    >;
typedef $$DbFrugalMonthAccountsTableCreateCompanionBuilder =
    DbFrugalMonthAccountsCompanion Function({
      Value<int> id,
      required int frugalMonthId,
      required String accountId,
    });
typedef $$DbFrugalMonthAccountsTableUpdateCompanionBuilder =
    DbFrugalMonthAccountsCompanion Function({
      Value<int> id,
      Value<int> frugalMonthId,
      Value<String> accountId,
    });

class $$DbFrugalMonthAccountsTableFilterComposer
    extends Composer<_$LocalDatabase, $DbFrugalMonthAccountsTable> {
  $$DbFrugalMonthAccountsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get frugalMonthId =>
      $composableBuilder(column: $table.frugalMonthId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => ColumnFilters(column));
}

class $$DbFrugalMonthAccountsTableOrderingComposer
    extends Composer<_$LocalDatabase, $DbFrugalMonthAccountsTable> {
  $$DbFrugalMonthAccountsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get frugalMonthId => $composableBuilder(
    column: $table.frugalMonthId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => ColumnOrderings(column));
}

class $$DbFrugalMonthAccountsTableAnnotationComposer
    extends Composer<_$LocalDatabase, $DbFrugalMonthAccountsTable> {
  $$DbFrugalMonthAccountsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get frugalMonthId =>
      $composableBuilder(column: $table.frugalMonthId, builder: (column) => column);

  GeneratedColumn<String> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);
}

class $$DbFrugalMonthAccountsTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $DbFrugalMonthAccountsTable,
          DbFrugalMonthAccount,
          $$DbFrugalMonthAccountsTableFilterComposer,
          $$DbFrugalMonthAccountsTableOrderingComposer,
          $$DbFrugalMonthAccountsTableAnnotationComposer,
          $$DbFrugalMonthAccountsTableCreateCompanionBuilder,
          $$DbFrugalMonthAccountsTableUpdateCompanionBuilder,
          (
            DbFrugalMonthAccount,
            BaseReferences<_$LocalDatabase, $DbFrugalMonthAccountsTable, DbFrugalMonthAccount>,
          ),
          DbFrugalMonthAccount,
          PrefetchHooks Function()
        > {
  $$DbFrugalMonthAccountsTableTableManager(_$LocalDatabase db, $DbFrugalMonthAccountsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DbFrugalMonthAccountsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DbFrugalMonthAccountsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DbFrugalMonthAccountsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> frugalMonthId = const Value.absent(),
                Value<String> accountId = const Value.absent(),
              }) => DbFrugalMonthAccountsCompanion(
                id: id,
                frugalMonthId: frugalMonthId,
                accountId: accountId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int frugalMonthId,
                required String accountId,
              }) => DbFrugalMonthAccountsCompanion.insert(
                id: id,
                frugalMonthId: frugalMonthId,
                accountId: accountId,
              ),
          withReferenceMapper: (p0) =>
              p0.map((e) => (e.readTable(table), BaseReferences(db, table, e))).toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DbFrugalMonthAccountsTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $DbFrugalMonthAccountsTable,
      DbFrugalMonthAccount,
      $$DbFrugalMonthAccountsTableFilterComposer,
      $$DbFrugalMonthAccountsTableOrderingComposer,
      $$DbFrugalMonthAccountsTableAnnotationComposer,
      $$DbFrugalMonthAccountsTableCreateCompanionBuilder,
      $$DbFrugalMonthAccountsTableUpdateCompanionBuilder,
      (
        DbFrugalMonthAccount,
        BaseReferences<_$LocalDatabase, $DbFrugalMonthAccountsTable, DbFrugalMonthAccount>,
      ),
      DbFrugalMonthAccount,
      PrefetchHooks Function()
    >;
typedef $$DbGoalsTableCreateCompanionBuilder =
    DbGoalsCompanion Function({
      Value<int> id,
      required String budgetId,
      required String name,
      required DateTime createdDate,
      required GoalType type,
    });
typedef $$DbGoalsTableUpdateCompanionBuilder =
    DbGoalsCompanion Function({
      Value<int> id,
      Value<String> budgetId,
      Value<String> name,
      Value<DateTime> createdDate,
      Value<GoalType> type,
    });

class $$DbGoalsTableFilterComposer extends Composer<_$LocalDatabase, $DbGoalsTable> {
  $$DbGoalsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get budgetId =>
      $composableBuilder(column: $table.budgetId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdDate =>
      $composableBuilder(column: $table.createdDate, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<GoalType, GoalType, String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );
}

class $$DbGoalsTableOrderingComposer extends Composer<_$LocalDatabase, $DbGoalsTable> {
  $$DbGoalsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get budgetId =>
      $composableBuilder(column: $table.budgetId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdDate =>
      $composableBuilder(column: $table.createdDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => ColumnOrderings(column));
}

class $$DbGoalsTableAnnotationComposer extends Composer<_$LocalDatabase, $DbGoalsTable> {
  $$DbGoalsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get budgetId =>
      $composableBuilder(column: $table.budgetId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get createdDate =>
      $composableBuilder(column: $table.createdDate, builder: (column) => column);

  GeneratedColumnWithTypeConverter<GoalType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);
}

class $$DbGoalsTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $DbGoalsTable,
          DbGoal,
          $$DbGoalsTableFilterComposer,
          $$DbGoalsTableOrderingComposer,
          $$DbGoalsTableAnnotationComposer,
          $$DbGoalsTableCreateCompanionBuilder,
          $$DbGoalsTableUpdateCompanionBuilder,
          (DbGoal, BaseReferences<_$LocalDatabase, $DbGoalsTable, DbGoal>),
          DbGoal,
          PrefetchHooks Function()
        > {
  $$DbGoalsTableTableManager(_$LocalDatabase db, $DbGoalsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$DbGoalsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$DbGoalsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DbGoalsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> budgetId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<DateTime> createdDate = const Value.absent(),
                Value<GoalType> type = const Value.absent(),
              }) => DbGoalsCompanion(
                id: id,
                budgetId: budgetId,
                name: name,
                createdDate: createdDate,
                type: type,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String budgetId,
                required String name,
                required DateTime createdDate,
                required GoalType type,
              }) => DbGoalsCompanion.insert(
                id: id,
                budgetId: budgetId,
                name: name,
                createdDate: createdDate,
                type: type,
              ),
          withReferenceMapper: (p0) =>
              p0.map((e) => (e.readTable(table), BaseReferences(db, table, e))).toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DbGoalsTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $DbGoalsTable,
      DbGoal,
      $$DbGoalsTableFilterComposer,
      $$DbGoalsTableOrderingComposer,
      $$DbGoalsTableAnnotationComposer,
      $$DbGoalsTableCreateCompanionBuilder,
      $$DbGoalsTableUpdateCompanionBuilder,
      (DbGoal, BaseReferences<_$LocalDatabase, $DbGoalsTable, DbGoal>),
      DbGoal,
      PrefetchHooks Function()
    >;
typedef $$DbDebtPayoffGoalsMetadataTableCreateCompanionBuilder =
    DbDebtPayoffGoalsMetadataCompanion Function({
      Value<int> id,
      required int goalId,
      Value<DateTime?> targetDate,
    });
typedef $$DbDebtPayoffGoalsMetadataTableUpdateCompanionBuilder =
    DbDebtPayoffGoalsMetadataCompanion Function({
      Value<int> id,
      Value<int> goalId,
      Value<DateTime?> targetDate,
    });

class $$DbDebtPayoffGoalsMetadataTableFilterComposer
    extends Composer<_$LocalDatabase, $DbDebtPayoffGoalsMetadataTable> {
  $$DbDebtPayoffGoalsMetadataTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get goalId =>
      $composableBuilder(column: $table.goalId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get targetDate =>
      $composableBuilder(column: $table.targetDate, builder: (column) => ColumnFilters(column));
}

class $$DbDebtPayoffGoalsMetadataTableOrderingComposer
    extends Composer<_$LocalDatabase, $DbDebtPayoffGoalsMetadataTable> {
  $$DbDebtPayoffGoalsMetadataTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get goalId =>
      $composableBuilder(column: $table.goalId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get targetDate =>
      $composableBuilder(column: $table.targetDate, builder: (column) => ColumnOrderings(column));
}

class $$DbDebtPayoffGoalsMetadataTableAnnotationComposer
    extends Composer<_$LocalDatabase, $DbDebtPayoffGoalsMetadataTable> {
  $$DbDebtPayoffGoalsMetadataTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get goalId =>
      $composableBuilder(column: $table.goalId, builder: (column) => column);

  GeneratedColumn<DateTime> get targetDate =>
      $composableBuilder(column: $table.targetDate, builder: (column) => column);
}

class $$DbDebtPayoffGoalsMetadataTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $DbDebtPayoffGoalsMetadataTable,
          DbDebtPayoffGoalsMetadataData,
          $$DbDebtPayoffGoalsMetadataTableFilterComposer,
          $$DbDebtPayoffGoalsMetadataTableOrderingComposer,
          $$DbDebtPayoffGoalsMetadataTableAnnotationComposer,
          $$DbDebtPayoffGoalsMetadataTableCreateCompanionBuilder,
          $$DbDebtPayoffGoalsMetadataTableUpdateCompanionBuilder,
          (
            DbDebtPayoffGoalsMetadataData,
            BaseReferences<
              _$LocalDatabase,
              $DbDebtPayoffGoalsMetadataTable,
              DbDebtPayoffGoalsMetadataData
            >,
          ),
          DbDebtPayoffGoalsMetadataData,
          PrefetchHooks Function()
        > {
  $$DbDebtPayoffGoalsMetadataTableTableManager(
    _$LocalDatabase db,
    $DbDebtPayoffGoalsMetadataTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DbDebtPayoffGoalsMetadataTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DbDebtPayoffGoalsMetadataTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DbDebtPayoffGoalsMetadataTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> goalId = const Value.absent(),
                Value<DateTime?> targetDate = const Value.absent(),
              }) => DbDebtPayoffGoalsMetadataCompanion(
                id: id,
                goalId: goalId,
                targetDate: targetDate,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int goalId,
                Value<DateTime?> targetDate = const Value.absent(),
              }) => DbDebtPayoffGoalsMetadataCompanion.insert(
                id: id,
                goalId: goalId,
                targetDate: targetDate,
              ),
          withReferenceMapper: (p0) =>
              p0.map((e) => (e.readTable(table), BaseReferences(db, table, e))).toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DbDebtPayoffGoalsMetadataTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $DbDebtPayoffGoalsMetadataTable,
      DbDebtPayoffGoalsMetadataData,
      $$DbDebtPayoffGoalsMetadataTableFilterComposer,
      $$DbDebtPayoffGoalsMetadataTableOrderingComposer,
      $$DbDebtPayoffGoalsMetadataTableAnnotationComposer,
      $$DbDebtPayoffGoalsMetadataTableCreateCompanionBuilder,
      $$DbDebtPayoffGoalsMetadataTableUpdateCompanionBuilder,
      (
        DbDebtPayoffGoalsMetadataData,
        BaseReferences<
          _$LocalDatabase,
          $DbDebtPayoffGoalsMetadataTable,
          DbDebtPayoffGoalsMetadataData
        >,
      ),
      DbDebtPayoffGoalsMetadataData,
      PrefetchHooks Function()
    >;
typedef $$DbDebtPayoffGoalsAccountsTableCreateCompanionBuilder =
    DbDebtPayoffGoalsAccountsCompanion Function({
      required int goalId,
      required String accountId,
      required int originalBalance,
      Value<int> rowid,
    });
typedef $$DbDebtPayoffGoalsAccountsTableUpdateCompanionBuilder =
    DbDebtPayoffGoalsAccountsCompanion Function({
      Value<int> goalId,
      Value<String> accountId,
      Value<int> originalBalance,
      Value<int> rowid,
    });

class $$DbDebtPayoffGoalsAccountsTableFilterComposer
    extends Composer<_$LocalDatabase, $DbDebtPayoffGoalsAccountsTable> {
  $$DbDebtPayoffGoalsAccountsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get goalId =>
      $composableBuilder(column: $table.goalId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get originalBalance => $composableBuilder(
    column: $table.originalBalance,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DbDebtPayoffGoalsAccountsTableOrderingComposer
    extends Composer<_$LocalDatabase, $DbDebtPayoffGoalsAccountsTable> {
  $$DbDebtPayoffGoalsAccountsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get goalId =>
      $composableBuilder(column: $table.goalId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get originalBalance => $composableBuilder(
    column: $table.originalBalance,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DbDebtPayoffGoalsAccountsTableAnnotationComposer
    extends Composer<_$LocalDatabase, $DbDebtPayoffGoalsAccountsTable> {
  $$DbDebtPayoffGoalsAccountsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get goalId =>
      $composableBuilder(column: $table.goalId, builder: (column) => column);

  GeneratedColumn<String> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<int> get originalBalance =>
      $composableBuilder(column: $table.originalBalance, builder: (column) => column);
}

class $$DbDebtPayoffGoalsAccountsTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $DbDebtPayoffGoalsAccountsTable,
          DbDebtPayoffGoalsAccount,
          $$DbDebtPayoffGoalsAccountsTableFilterComposer,
          $$DbDebtPayoffGoalsAccountsTableOrderingComposer,
          $$DbDebtPayoffGoalsAccountsTableAnnotationComposer,
          $$DbDebtPayoffGoalsAccountsTableCreateCompanionBuilder,
          $$DbDebtPayoffGoalsAccountsTableUpdateCompanionBuilder,
          (
            DbDebtPayoffGoalsAccount,
            BaseReferences<
              _$LocalDatabase,
              $DbDebtPayoffGoalsAccountsTable,
              DbDebtPayoffGoalsAccount
            >,
          ),
          DbDebtPayoffGoalsAccount,
          PrefetchHooks Function()
        > {
  $$DbDebtPayoffGoalsAccountsTableTableManager(
    _$LocalDatabase db,
    $DbDebtPayoffGoalsAccountsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DbDebtPayoffGoalsAccountsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DbDebtPayoffGoalsAccountsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DbDebtPayoffGoalsAccountsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> goalId = const Value.absent(),
                Value<String> accountId = const Value.absent(),
                Value<int> originalBalance = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DbDebtPayoffGoalsAccountsCompanion(
                goalId: goalId,
                accountId: accountId,
                originalBalance: originalBalance,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int goalId,
                required String accountId,
                required int originalBalance,
                Value<int> rowid = const Value.absent(),
              }) => DbDebtPayoffGoalsAccountsCompanion.insert(
                goalId: goalId,
                accountId: accountId,
                originalBalance: originalBalance,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) =>
              p0.map((e) => (e.readTable(table), BaseReferences(db, table, e))).toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DbDebtPayoffGoalsAccountsTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $DbDebtPayoffGoalsAccountsTable,
      DbDebtPayoffGoalsAccount,
      $$DbDebtPayoffGoalsAccountsTableFilterComposer,
      $$DbDebtPayoffGoalsAccountsTableOrderingComposer,
      $$DbDebtPayoffGoalsAccountsTableAnnotationComposer,
      $$DbDebtPayoffGoalsAccountsTableCreateCompanionBuilder,
      $$DbDebtPayoffGoalsAccountsTableUpdateCompanionBuilder,
      (
        DbDebtPayoffGoalsAccount,
        BaseReferences<_$LocalDatabase, $DbDebtPayoffGoalsAccountsTable, DbDebtPayoffGoalsAccount>,
      ),
      DbDebtPayoffGoalsAccount,
      PrefetchHooks Function()
    >;

class $LocalDatabaseManager {
  final _$LocalDatabase _db;
  $LocalDatabaseManager(this._db);
  $$DbBudgetsTableTableManager get dbBudgets => $$DbBudgetsTableTableManager(_db, _db.dbBudgets);
  $$DbCurrencyFormatsTableTableManager get dbCurrencyFormats =>
      $$DbCurrencyFormatsTableTableManager(_db, _db.dbCurrencyFormats);
  $$DbAccountsTableTableManager get dbAccounts =>
      $$DbAccountsTableTableManager(_db, _db.dbAccounts);
  $$DbAccountInterestRatesTableTableManager get dbAccountInterestRates =>
      $$DbAccountInterestRatesTableTableManager(_db, _db.dbAccountInterestRates);
  $$DbAccountMinimumPaymentsTableTableManager get dbAccountMinimumPayments =>
      $$DbAccountMinimumPaymentsTableTableManager(_db, _db.dbAccountMinimumPayments);
  $$DbAccountEscrowAmountsTableTableManager get dbAccountEscrowAmounts =>
      $$DbAccountEscrowAmountsTableTableManager(_db, _db.dbAccountEscrowAmounts);
  $$DbPayeesTableTableManager get dbPayees => $$DbPayeesTableTableManager(_db, _db.dbPayees);
  $$DbCategoryGroupsTableTableManager get dbCategoryGroups =>
      $$DbCategoryGroupsTableTableManager(_db, _db.dbCategoryGroups);
  $$DbCategoriesTableTableManager get dbCategories =>
      $$DbCategoriesTableTableManager(_db, _db.dbCategories);
  $$DbTransactionsTableTableManager get dbTransactions =>
      $$DbTransactionsTableTableManager(_db, _db.dbTransactions);
  $$DbSubTransactionsTableTableManager get dbSubTransactions =>
      $$DbSubTransactionsTableTableManager(_db, _db.dbSubTransactions);
  $$DbScheduledTransactionsTableTableManager get dbScheduledTransactions =>
      $$DbScheduledTransactionsTableTableManager(_db, _db.dbScheduledTransactions);
  $$DbScheduledSubTransactionsTableTableManager get dbScheduledSubTransactions =>
      $$DbScheduledSubTransactionsTableTableManager(_db, _db.dbScheduledSubTransactions);
  $$DbMonthsTableTableManager get dbMonths => $$DbMonthsTableTableManager(_db, _db.dbMonths);
  $$DbAccountKnowledgesTableTableManager get dbAccountKnowledges =>
      $$DbAccountKnowledgesTableTableManager(_db, _db.dbAccountKnowledges);
  $$DbCategoryKnowledgesTableTableManager get dbCategoryKnowledges =>
      $$DbCategoryKnowledgesTableTableManager(_db, _db.dbCategoryKnowledges);
  $$DbPayeeKnowledgesTableTableManager get dbPayeeKnowledges =>
      $$DbPayeeKnowledgesTableTableManager(_db, _db.dbPayeeKnowledges);
  $$DbTransactionKnowledgesTableTableManager get dbTransactionKnowledges =>
      $$DbTransactionKnowledgesTableTableManager(_db, _db.dbTransactionKnowledges);
  $$DbScheduledTransactionKnowledgesTableTableManager get dbScheduledTransactionKnowledges =>
      $$DbScheduledTransactionKnowledgesTableTableManager(
        _db,
        _db.dbScheduledTransactionKnowledges,
      );
  $$DbMonthKnowledgesTableTableManager get dbMonthKnowledges =>
      $$DbMonthKnowledgesTableTableManager(_db, _db.dbMonthKnowledges);
  $$DbCategoryViewsTableTableManager get dbCategoryViews =>
      $$DbCategoryViewsTableTableManager(_db, _db.dbCategoryViews);
  $$DbCategoryViewCategoriesTableTableManager get dbCategoryViewCategories =>
      $$DbCategoryViewCategoriesTableTableManager(_db, _db.dbCategoryViewCategories);
  $$DbCategoryViewCategoryGroupsTableTableManager get dbCategoryViewCategoryGroups =>
      $$DbCategoryViewCategoryGroupsTableTableManager(_db, _db.dbCategoryViewCategoryGroups);
  $$DbLegacySpendTrackersTableTableManager get dbLegacySpendTrackers =>
      $$DbLegacySpendTrackersTableTableManager(_db, _db.dbLegacySpendTrackers);
  $$DbQuerySpendTrackersTableTableManager get dbQuerySpendTrackers =>
      $$DbQuerySpendTrackersTableTableManager(_db, _db.dbQuerySpendTrackers);
  $$DbSpendTrackerConditionsTableTableManager get dbSpendTrackerConditions =>
      $$DbSpendTrackerConditionsTableTableManager(_db, _db.dbSpendTrackerConditions);
  $$DbSpendTrackerTestsTableTableManager get dbSpendTrackerTests =>
      $$DbSpendTrackerTestsTableTableManager(_db, _db.dbSpendTrackerTests);
  $$DbFrugalMonthsTableTableManager get dbFrugalMonths =>
      $$DbFrugalMonthsTableTableManager(_db, _db.dbFrugalMonths);
  $$DbFrugalMonthCategoriesTableTableManager get dbFrugalMonthCategories =>
      $$DbFrugalMonthCategoriesTableTableManager(_db, _db.dbFrugalMonthCategories);
  $$DbFrugalMonthAccountsTableTableManager get dbFrugalMonthAccounts =>
      $$DbFrugalMonthAccountsTableTableManager(_db, _db.dbFrugalMonthAccounts);
  $$DbGoalsTableTableManager get dbGoals => $$DbGoalsTableTableManager(_db, _db.dbGoals);
  $$DbDebtPayoffGoalsMetadataTableTableManager get dbDebtPayoffGoalsMetadata =>
      $$DbDebtPayoffGoalsMetadataTableTableManager(_db, _db.dbDebtPayoffGoalsMetadata);
  $$DbDebtPayoffGoalsAccountsTableTableManager get dbDebtPayoffGoalsAccounts =>
      $$DbDebtPayoffGoalsAccountsTableTableManager(_db, _db.dbDebtPayoffGoalsAccounts);
}
