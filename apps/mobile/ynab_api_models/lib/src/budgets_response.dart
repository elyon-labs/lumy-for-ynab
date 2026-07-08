import 'package:dart_mappable/dart_mappable.dart';
import 'package:equatable/equatable.dart';

part 'budgets_response.mapper.dart';

@MappableClass()
class BudgetsResponse with BudgetsResponseMappable {
  const BudgetsResponse({required this.data});

  final Budgets data;
}

@MappableClass()
class Budgets with BudgetsMappable {
  const Budgets({required this.budgets});

  final List<Budget> budgets;
}

@MappableClass()
class Budget extends Equatable with BudgetMappable {
  const Budget({
    required this.id,
    required this.name,
    required this.lastModifiedOn,
    required this.firstMonth,
    required this.lastMonth,
    this.currencyFormat,
  });

  final String id;
  final String name;
  @MappableField(key: 'last_modified_on')
  final String? lastModifiedOn;
  @MappableField(key: 'first_month')
  final String? firstMonth;
  @MappableField(key: 'last_month')
  final String? lastMonth;
  @MappableField(key: 'currency_format')
  final CurrencyFormat? currencyFormat;

  @override
  List<Object?> get props => [id, name, lastModifiedOn, firstMonth, lastMonth, currencyFormat];
}

@MappableClass()
class CurrencyFormat extends Equatable with CurrencyFormatMappable {
  const CurrencyFormat({
    required this.isoCode,
    required this.decimalDigits,
    required this.decimalSeparator,
    required this.isSymbolFirst,
    required this.groupSeparator,
    required this.currencySymbol,
    required this.shouldDisplaySymbol,
    required this.exampleFormat,
  });

  @MappableField(key: 'iso_code')
  final String isoCode;
  @MappableField(key: 'decimal_digits')
  final int decimalDigits;
  @MappableField(key: 'decimal_separator')
  final String decimalSeparator;
  @MappableField(key: 'symbol_first')
  final bool isSymbolFirst;
  @MappableField(key: 'group_separator')
  final String groupSeparator;
  @MappableField(key: 'currency_symbol')
  final String currencySymbol;
  @MappableField(key: 'display_symbol')
  final bool shouldDisplaySymbol;
  @MappableField(key: 'example_format')
  final String exampleFormat;

  @override
  List<Object?> get props => [
    isoCode,
    decimalDigits,
    decimalSeparator,
    isSymbolFirst,
    groupSeparator,
    currencySymbol,
    shouldDisplaySymbol,
    exampleFormat,
  ];
}
