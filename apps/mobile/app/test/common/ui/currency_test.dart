import 'package:flutter_test/flutter_test.dart';
import 'package:lumy/common/presentation/currency.dart';
import 'package:oxidized/oxidized.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

void main() {
  group('formatted', () {
    group('abbreviated', () {
      const usdCurrency = CurrencyFormat(
        isoCode: 'USD',
        decimalDigits: 2,
        decimalSeparator: '.',
        groupSeparator: ',',
        currencySymbol: r'$',
        isSymbolFirst: true,
        shouldDisplaySymbol: true,
        exampleFormat: '123,456.78',
      );

      const iraqiCurrency = CurrencyFormat(
        isoCode: 'JOD',
        decimalDigits: 3,
        decimalSeparator: '.',
        groupSeparator: ',',
        currencySymbol: 'ع.د',
        isSymbolFirst: false,
        shouldDisplaySymbol: true,
        exampleFormat: '123,456.789',
      );

      test('negative abbreviated for axis', () async {
        const amount = -1234567890;
        final formatted = amount.formatForAxis(
          currencyFormat: const Some(usdCurrency),
          interval: 1000000, // $1000
        );
        expect(formatted, r'-$1.23M');
      });

      test('standard abbreviated with zeros', () async {
        const amount = 12345000;
        final formatted = amount.formatForAxis(
          currencyFormat: const Some(iraqiCurrency),
          interval: 1000000, // 1,000
        );
        expect(formatted, '12Kع.د');
      });
    });

    group('USD', () {
      const usdCurrency = CurrencyFormat(
        isoCode: 'USD',
        decimalDigits: 2,
        decimalSeparator: '.',
        groupSeparator: ',',
        currencySymbol: r'$',
        isSymbolFirst: true,
        shouldDisplaySymbol: true,
        exampleFormat: '123,456.78',
      );

      test('standard', () {
        const amount = 1234567890;
        final formatted = amount.format(const Some(usdCurrency));
        expect(formatted, r'$1,234,567.89');
      });

      test('standard with zeros', () {
        const amount = 100000000;
        final formatted = amount.format(const Some(usdCurrency));
        expect(formatted, r'$100,000.00');
      });

      test('negative', () {
        const amount = -1234567890;
        final formatted = amount.format(const Some(usdCurrency));
        expect(formatted, r'-$1,234,567.89');
      });

      test('zero', () {
        const amount = 0;
        final formatted = amount.format(const Some(usdCurrency));
        expect(formatted, r'$0.00');
      });

      test('one cent', () {
        const amount = 10;
        final formatted = amount.format(const Some(usdCurrency));
        expect(formatted, r'$0.01');
      });
    });

    group('Euro', () {
      const euroCurrency = CurrencyFormat(
        isoCode: 'EUR',
        decimalDigits: 2,
        decimalSeparator: ',',
        groupSeparator: '.',
        currencySymbol: '€',
        isSymbolFirst: false,
        shouldDisplaySymbol: true,
        exampleFormat: '123.456,78',
      );

      test('standard', () {
        const amount = 1234567890;
        final formatted = amount.format(const Some(euroCurrency));
        expect(formatted, '1.234.567,89€');
      });

      test('standard with zeros', () {
        const amount = 100000000;
        final formatted = amount.format(const Some(euroCurrency));
        expect(formatted, '100.000,00€');
      });

      test('negative', () {
        const amount = -1234567890;
        final formatted = amount.format(const Some(euroCurrency));
        expect(formatted, '-1.234.567,89€');
      });

      test('zero', () {
        const amount = 0;
        final formatted = amount.format(const Some(euroCurrency));
        expect(formatted, '0,00€');
      });

      test('one euro', () {
        const amount = 10;
        final formatted = amount.format(const Some(euroCurrency));
        expect(formatted, '0,01€');
      });
    });

    group('Iraqi Dinar', () {
      const iraqiCurrency = CurrencyFormat(
        isoCode: 'JOD',
        decimalDigits: 3,
        decimalSeparator: '.',
        groupSeparator: ',',
        currencySymbol: 'ع.د',
        isSymbolFirst: false,
        shouldDisplaySymbol: true,
        exampleFormat: '123,456.789',
      );

      test('standard', () {
        const amount = 1234567890;
        final formatted = amount.format(const Some(iraqiCurrency));
        expect(formatted, '1,234,567.890ع.د');
      });

      test('standard with zeros', () {
        const amount = 100000000;
        final formatted = amount.format(const Some(iraqiCurrency));
        expect(formatted, '100,000.000ع.د');
      });

      test('negative', () {
        const amount = -1234567890;
        final formatted = amount.format(const Some(iraqiCurrency));
        expect(formatted, '-1,234,567.890ع.د');
      });

      test('zero', () {
        const amount = 0;
        final formatted = amount.format(const Some(iraqiCurrency));
        expect(formatted, '0.000ع.د');
      });

      test('one cent', () {
        const amount = 1;
        final formatted = amount.format(const Some(iraqiCurrency));
        expect(formatted, '0.001ع.د');
      });
    });

    group('example formats', () {
      test('group separator as space', () {
        const euroCurrency = CurrencyFormat(
          isoCode: 'EUR',
          decimalDigits: 2,
          decimalSeparator: ',',
          groupSeparator: ' ',
          currencySymbol: '€',
          isSymbolFirst: false,
          shouldDisplaySymbol: true,
          exampleFormat: '123 456,78',
        );

        const amount = 1234567890;
        final formatted = amount.format(const Some(euroCurrency));
        expect(formatted, '1 234 567,89€');
      });

      test('decimal separator as hyphen', () {
        const euroCurrency = CurrencyFormat(
          isoCode: 'EUR',
          decimalDigits: 2,
          decimalSeparator: '-',
          groupSeparator: ' ',
          currencySymbol: '€',
          isSymbolFirst: false,
          shouldDisplaySymbol: true,
          exampleFormat: '123 456-78',
        );

        const amount = 1234567890;
        final formatted = amount.format(const Some(euroCurrency));
        expect(formatted, '1 234 567-89€');
      });

      test('decimal separator as slash', () {
        const euroCurrency = CurrencyFormat(
          isoCode: 'EUR',
          decimalDigits: 2,
          decimalSeparator: '/',
          groupSeparator: ' ',
          currencySymbol: '€',
          isSymbolFirst: false,
          shouldDisplaySymbol: true,
          exampleFormat: '123 456/78',
        );

        const amount = 1234567890;
        final formatted = amount.format(const Some(euroCurrency));
        expect(formatted, '1 234 567/89€');
      });

      test('no decimal digits', () {
        const euroCurrency = CurrencyFormat(
          isoCode: 'EUR',
          decimalDigits: 0,
          decimalSeparator: ',',
          groupSeparator: ' ',
          currencySymbol: '€',
          isSymbolFirst: false,
          shouldDisplaySymbol: true,
          exampleFormat: '123 456',
        );

        const amount = 2000000;
        final formatted = amount.format(const Some(euroCurrency));
        expect(formatted, '2 000€');
      });
    });
  });

  group('toMilliUnits', () {
    test('USD', () {
      const usdCurrency = CurrencyFormat(
        isoCode: 'USD',
        decimalDigits: 2,
        decimalSeparator: '.',
        groupSeparator: ',',
        currencySymbol: r'$',
        isSymbolFirst: true,
        shouldDisplaySymbol: true,
        exampleFormat: '123,456.78',
      );

      const amount = 5000; // $50.00
      final milliUnits = amount.toMilliunits(const Some(usdCurrency));
      expect(milliUnits, 50000);
    });

    test('Euro', () {
      const euroCurrency = CurrencyFormat(
        isoCode: 'EUR',
        decimalDigits: 2,
        decimalSeparator: ',',
        groupSeparator: '.',
        currencySymbol: '€',
        isSymbolFirst: false,
        shouldDisplaySymbol: true,
        exampleFormat: '123.456,78',
      );

      const amount = 1234567890; // €12,345,678.90
      final milliUnits = amount.toMilliunits(const Some(euroCurrency));
      expect(milliUnits, 12345678900);
    });

    test('Iraqi Dinar', () {
      const iraqiCurrency = CurrencyFormat(
        isoCode: 'JOD',
        decimalDigits: 3,
        decimalSeparator: '.',
        groupSeparator: ',',
        currencySymbol: 'ع.د',
        isSymbolFirst: false,
        shouldDisplaySymbol: true,
        exampleFormat: '123,456.789',
      );

      const amount = 1234567890; // 1,234,567.890ع.د
      final milliUnits = amount.toMilliunits(const Some(iraqiCurrency));
      expect(milliUnits, 1234567890);
    });
  });
}
