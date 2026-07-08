import 'package:flutter_test/flutter_test.dart';
import 'package:lumy/ynab_api/_category.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import '../factory/category_factory.dart';

void main() {
  group('CategoryX', () {
    group('hasRecurringTarget', () {
      test('it returns true if cadence > 0', () {
        final category = CategoryFactory.build(targetCadence: 1, targetType: TargetType.NEED);

        expect(category.hasRecurringTarget, isTrue);
      });

      test('it returns false if cadence is null', () {
        final category = CategoryFactory.build(targetCadence: null, targetType: TargetType.NEED);

        expect(category.hasRecurringTarget, isFalse);
      });

      test('it returns false if cadence is 0', () {
        final category = CategoryFactory.build(targetCadence: 0, targetType: TargetType.NEED);

        expect(category.hasRecurringTarget, isFalse);
      });
    });

    group('monthsInTargetCadence', () {
      group('TargetType.NEED', () {
        group('monthly', () {
          test('it returns the target frequency', () {
            final category = CategoryFactory.build(
              targetType: TargetType.NEED,
              targetCadence: 1, // monthly
              targetCadenceFrequency: 6,
              targetBalance: 100,
            );

            expect(category.monthsInTargetCadence, 6);
          });
        });

        group('weekly', () {
          test('it returns months if > 1', () {
            final category = CategoryFactory.build(
              targetType: TargetType.NEED,
              targetCadence: 2, // weekly
              targetCadenceFrequency: 26, // every 26 weeks
              targetBalance: 100000,
            );

            expect(category.monthsInTargetCadence, 6);
          });

          test('it returns null if < 1', () {
            final category = CategoryFactory.build(
              targetType: TargetType.NEED,
              targetCadence: 2, // weekly
              targetCadenceFrequency: 3, // every 3
              targetBalance: 100000,
            );

            expect(category.monthsInTargetCadence, null);
          });
        });

        group('yearly', () {
          test('it returns targetFrequency * 12', () {
            final category = CategoryFactory.build(
              targetType: TargetType.NEED,
              targetCadence: 13, // yearly
              targetCadenceFrequency: 2, // every 2 years
              targetBalance: 100000,
            );

            expect(category.monthsInTargetCadence, 24);
          });
        });
      });
    });

    group('monthlyNeededForTarget', () {
      group('TargetType.NEED', () {
        group('monthly', () {
          test('it returns the target balance', () {
            final category = CategoryFactory.build(
              targetType: TargetType.NEED,
              targetCadence: 1,
              targetBalance: 100,
            );

            expect(category.monthlyNeededForTarget, 100);
          });
        });

        group('weekly', () {
          test('it returns amount needed per week * 4', () {
            final category = CategoryFactory.build(
              targetType: TargetType.NEED,
              targetCadence: 2, // weekly
              targetCadenceFrequency: 2, // every 2 weeks
              targetBalance: 100000, // need 100000 every 2 weeks
            );

            expect(category.monthlyNeededForTarget, 217500);
          });

          test('it returns amount needed per week * 4', () {
            final category = CategoryFactory.build(
              targetType: TargetType.NEED,
              targetCadence: 2, // weekly
              targetCadenceFrequency: 6, // every 6 weeks
              targetBalance: 100000, // need 100000 every 6 weeks
            );

            expect(category.monthlyNeededForTarget, 72498);
          });
        });

        group('yearly', () {
          test('it returns amount needed per year / 12', () {
            final category = CategoryFactory.build(
              targetType: TargetType.NEED,
              targetCadence: 13, // yearly
              targetCadenceFrequency: 2, // every 2 years
              targetBalance: 100000, // need 100000 every 2 years
            );

            expect(category.monthlyNeededForTarget, 4166);
          });

          test('it returns amount needed per year / 12', () {
            final category = CategoryFactory.build(
              targetType: TargetType.NEED,
              targetCadence: 13, // yearly
              targetCadenceFrequency: 6, // every 6 years
              targetBalance: 100000, // need 100000 every 6 years
            );

            expect(category.monthlyNeededForTarget, 1388);
          });
        });

        group('every 2 years', () {
          test('it returns amount needed per 2 years / 24', () {
            final category = CategoryFactory.build(
              targetType: TargetType.NEED,
              targetCadence: 14, // every 2 years
              targetCadenceFrequency: 2, // every 4 years
              targetBalance: 100000, // need 100000 every 4 years
            );

            expect(category.monthlyNeededForTarget, 2083);
          });

          test('it returns amount needed per 2 years / 24', () {
            final category = CategoryFactory.build(
              targetType: TargetType.NEED,
              targetCadence: 14, // every 2 years
              targetCadenceFrequency: 6, // every 12 years
              targetBalance: 100000, // need 100000 every 12 years
            );

            expect(category.monthlyNeededForTarget, 694);
          });
        });
      });
    });
  });
}
