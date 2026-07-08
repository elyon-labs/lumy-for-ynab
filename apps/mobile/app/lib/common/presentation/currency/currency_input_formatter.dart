import 'package:dart_foundation/dart_foundation.dart';
import 'package:flutter/services.dart';
import 'package:money2/money2.dart';
import 'package:oxidized/oxidized.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import '../currency.dart';

class CurrencyInputFormatter extends TextInputFormatter {
  CurrencyInputFormatter({required Option<CurrencyFormat> currencyFormat}) {
    this.currencyFormat = currencyFormat.getOrDefault();
  }

  late final CurrencyFormat currencyFormat;

  // Optional: to prevent absurdly long numbers (and extreme CPU work),
  // cap digit count (adjust as you like). This is DISPLAY cap only.
  static const int _maxDigits = 30;

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final raw = newValue.text.digitsOnly();
    if (raw.isEmpty) {
      // If field is cleared, show zero with proper decimals.
      final zero = _format(0);
      return newValue.copyWith(text: zero, selection: _end(zero));
    }

    // Guard excessive length
    final digits = raw.length > _maxDigits ? raw.substring(0, _maxDigits) : raw;

    // MARK: Can cause issues on web, use `BigInt`?
    final positive = int.parse(digits);

    // Interpret the typed digits as the MINOR units (cents for USD=2, fils for JOD=3, etc.)
    // i.e., user types "4" -> 0.04 for 2 decimals. That's exactly "positive / _scale".
    final formatted = _format(positive);

    return TextEditingValue(text: formatted, selection: _end(formatted));
  }

  /// Format a non-negative amount given as MINOR units [int] into a string
  /// using the currency’s decimalDigits/groupSeparator/decimalSeparator/symbol.
  String _format(int minorUnits) {
    final decimalDigits = currencyFormat.decimalDigits;
    final groupSeparator = currencyFormat.groupSeparator;
    final decimalSeparator = currencyFormat.decimalSeparator;

    final money = Money.fromIntWithCurrency(
      minorUnits,
      currencyFormat.toMoneyCurrency(),
      scale: decimalDigits,
    );

    final formatted = minorUnits.addSign(money.toString());
    final withCustomSeparators = formatted.withCustomSeparators(
      group: groupSeparator,
      decimal: decimalSeparator,
    );

    return withCustomSeparators;
  }

  TextSelection _end(String s) => TextSelection(baseOffset: s.length, extentOffset: s.length);
}
