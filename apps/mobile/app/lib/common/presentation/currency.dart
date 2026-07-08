import 'package:dart_foundation/dart_foundation.dart';
import 'package:money2/money2.dart';
import 'package:oxidized/oxidized.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

extension CurrencyIntX on int {
  /// Converts the receiver int to milliunits. This calculation is dependent on
  /// the number of decimal digits in the provided [CurrencyFormat].
  int toMilliunits(Option<CurrencyFormat> currencyFormat) {
    final d = currencyFormat.getOrDefault().decimalDigits;
    if (d <= 3) {
      final factor = 1000 ~/ _pow10(d);
      return this * factor;
    } else {
      final divisor = _pow10(d - 3);
      return this ~/ divisor; // trunc toward zero
    }
  }

  /// Returns the absolute value of this integer as a number of minor units
  /// for formatting.
  ///
  /// To determine the number of minor units, we need to use YNAB's concept of
  /// "milliunits":
  ///
  /// YNAB uses "milliunits" which are 1/1000 of a unit.
  /// Each unit of a currency is therefore 1000 milliunits.
  /// e.g 1 USD is 1000 milliunits, 1 Euro is 1000 milliunits.
  /// See: https://api.ynab.com/#formats
  /// Web-safe (arbitrary size) version using BigInt.
  int toMinorUnits(int decimalDigits) {
    assert(decimalDigits >= 0, 'decimalDigits must be >= 0');

    final raw = abs();
    if (decimalDigits <= 3) {
      final factorDiv = 1000 ~/ _pow10(decimalDigits);
      return raw ~/ factorDiv;
    } else {
      final factorMul = _pow10(decimalDigits - 3);
      return raw * factorMul;
    }
  }

  /// Formats an [int] returned from the YNAB API as a [String] to display to the user.
  /// The [int] is expected to be in milliunits and will be converted to minor units prior
  /// to formatting.
  String format(Option<CurrencyFormat> currencyFormat) {
    // Get minor units of the `int`.
    final resolvedCurrencyFormat = currencyFormat.getOrDefault();
    final minorUnits = toMinorUnits(resolvedCurrencyFormat.decimalDigits);

    // Produce a Money object based on the CurrencyFormat and minor units.
    final currency = resolvedCurrencyFormat.toMoneyCurrency();
    final money = Money.fromIntWithCurrency(
      minorUnits,
      currency,
      scale: resolvedCurrencyFormat.decimalDigits,
    );

    // Format according to user's preferences
    return addSign(money.toString()).withCustomSeparators(
      group: resolvedCurrencyFormat.groupSeparator,
      decimal: resolvedCurrencyFormat.decimalSeparator,
    );
  }

  /// Formats an [int] returned from the YNAB API as a [String] to display to the user on the
  /// axis of a chart.
  ///
  /// Specifically, it uses the provided [interval] to determine how to format the number,
  /// attempting to truncate the formatted [String] if possible for better readability.
  ///
  /// The [int] is expected to be in milliunits and will be converted to minor units prior
  /// to formatting.
  String formatForAxis({required Option<CurrencyFormat> currencyFormat, required num interval}) {
    final resolvedCurrencyFormat = currencyFormat.getOrDefault();
    final decimalDigits = resolvedCurrencyFormat.decimalDigits;

    // Convert this milliunits -> minor -> major (whole currency units) as double
    final minor = toMinorUnits(decimalDigits);
    final major = minor / _pow10(decimalDigits);

    if (major == 0) {
      const zero = '0';
      final withSymbol = resolvedCurrencyFormat.shouldDisplaySymbol
          ? (resolvedCurrencyFormat.isSymbolFirst
                ? '${resolvedCurrencyFormat.currencySymbol}$zero'
                : '$zero${resolvedCurrencyFormat.currencySymbol}')
          : zero;
      return addSign(withSymbol);
    }

    // Interval in major units (used to choose precision)
    final intervalMajor = interval.toInt().toMinorUnits(decimalDigits) / _pow10(decimalDigits);

    // Decide suffix + divisor
    String suffix;
    double divisor;
    final absMajor = major.abs();
    if (absMajor >= 1e9) {
      suffix = 'B';
      divisor = 1e9;
    } else if (absMajor >= 1e6) {
      suffix = 'M';
      divisor = 1e6;
    } else if (absMajor >= 1e3) {
      suffix = 'K';
      divisor = 1e3;
    } else {
      suffix = '';
      divisor = 1.0;
    }

    // Precision rule (matches your intent)
    // - If showing raw units (no suffix): 0 decimals.
    // - With suffix:
    //   - If interval >= 1 suffix unit: 0 decimals
    //   - else if interval >= 0.01 suffix unit: 1 decimal
    //   - else: 2 decimals
    int precision;
    if (suffix.isEmpty) {
      precision = 0;
    } else if (intervalMajor >= divisor) {
      precision = 0;
    } else if (intervalMajor >= divisor / 100) {
      precision = 1;
    } else {
      precision = 2;
    }

    final scaled = major / divisor;
    final number = scaled.toStringAsFixed(precision);
    final core = suffix.isEmpty ? number : '$number$suffix';

    final withSymbol = resolvedCurrencyFormat.shouldDisplaySymbol
        ? (resolvedCurrencyFormat.isSymbolFirst
              ? '${resolvedCurrencyFormat.currencySymbol}$core'
              : '$core${resolvedCurrencyFormat.currencySymbol}')
        : core;

    return addSign(withSymbol);
  }

  /// Formats the money value with the appropriate sign.
  ///
  /// The [formattedMoney] is expected to have already been formatted according to the user's
  /// [CurrencyFormat].
  String addSign(String formattedMoney) {
    return isNegative ? '-$formattedMoney' : formattedMoney;
  }
}

int _pow10(int n) => BigInt.from(10).pow(n).toInt();

extension StringCurrencyX on String {
  /// Converts this string to a number of milliunits for formatting.
  int toMilliUnits(Option<CurrencyFormat> currencyFormat) {
    final digitsOnly = this.digitsOnly();
    // MARK: Can cause issues on web, use `BigInt`?
    final parsed = int.parse(digitsOnly);
    return parsed.toMilliunits(currencyFormat);
  }

  /// Replaces default group and decimal separators with the provided ones.
  String withCustomSeparators({required String group, required String decimal}) {
    // Replace Money2's separators with the ones provided by YNAB.
    // Use a temporary character to avoid replacing the wrong ones.
    return replaceAll(',', '@') // group separator
        .replaceAll('.', '#') // decimal separator
        .replaceAll('#', decimal)
        .replaceAll('@', group);
  }
}

extension OptionCurrencyFormatX on Option<CurrencyFormat> {
  /// Returns the currency format if it exists, otherwise returns a default
  /// currency format with 2 decimal digits and no symbol.
  CurrencyFormat getOrDefault() {
    return mapOr(
      (c) => c,
      const CurrencyFormat(
        exampleFormat: '123,456.78',
        isoCode: 'USD',
        decimalDigits: 2,
        groupSeparator: ',',
        decimalSeparator: '.',
        currencySymbol: '',
        isSymbolFirst: true,
        shouldDisplaySymbol: false,
      ),
    );
  }
}

extension CurrencyFormatX on CurrencyFormat {
  // Example patterns are provided by the YNAB API without the currency
  // symbol.
  // - Replace all digits with `#`
  // - Use 0s to denote post-decimal precision
  // - Add symbol back in at the beginning or end of the pattern, as needed.
  String get pattern {
    // e.g 123,456.789
    final sourceFormat = exampleFormat;
    // e.g ###,###.###
    final hashes = sourceFormat.replaceAll(RegExp(r'\d'), '#');
    final groupIndex = hashes.indexOf(groupSeparator);
    final decimalIndex = decimalDigits > 0 ? hashes.indexOf(decimalSeparator) : sourceFormat.length;
    final zeros = List.generate(decimalDigits, (i) => '0').join();
    // e.g ###,###.000
    final groupSubstring = hashes.substring(0, groupIndex);
    final decimalSubstring = hashes.substring(groupIndex + 1, decimalIndex);
    // Since Money2 doesn't support special group & decimal separators,
    // use our own, and then replace them with custom ones post-format.
    final pattern = '$groupSubstring,$decimalSubstring.$zeros';
    // e.g S###,###.000
    return shouldDisplaySymbol
        ? isSymbolFirst
              ? 'S$pattern'
              : '${pattern}S'
        : pattern;
  }

  Currency toMoneyCurrency() {
    final symbol = shouldDisplaySymbol ? currencySymbol : '';
    return Currency.create(isoCode, decimalDigits, symbol: symbol, pattern: pattern);
  }
}
