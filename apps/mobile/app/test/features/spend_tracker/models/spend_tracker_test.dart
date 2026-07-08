import 'package:flutter_test/flutter_test.dart';
import 'package:lumy/features/spend_tracker/domain/models/spend_tracker.dart';

import '../../../factory/spend_tracker_factory.dart';

void main() {
  group('ListSpendTrackerX', () {
    group('orderAlphabetically', () {
      test('real life input', () {
        final trackers = [
          SpendTrackerFactory.build(nickName: 'Medical:Counseling(2)'),
          SpendTrackerFactory.build(nickName: 'Red flag'),
          SpendTrackerFactory.build(nickName: 'Wooga'),
          SpendTrackerFactory.build(nickName: 'f150'),
          SpendTrackerFactory.build(nickName: '🆘Emergency Fund (5) - manual'),
          SpendTrackerFactory.build(nickName: '🍹Alcohol (3)'),
          SpendTrackerFactory.build(nickName: '💊Medical:Prescription (1)'),
          SpendTrackerFactory.build(nickName: '🚗Auto Service (3)'),
          SpendTrackerFactory.build(nickName: '🩺Medical:Doctor (1)'),
          SpendTrackerFactory.build(nickName: '🛍️Groceries (1)'),
          SpendTrackerFactory.build(nickName: '🔥Natural Gas (23rd)'),
          SpendTrackerFactory.build(nickName: 'cancer'),
          SpendTrackerFactory.build(nickName: 'Oxygen/medical supplies'),
        ];

        final sorted = trackers.orderAlphabetically();

        expect(sorted.map((e) => e.preferredName).toList(), [
          '🍹Alcohol (3)',
          '🚗Auto Service (3)',
          'cancer',
          '🆘Emergency Fund (5) - manual',
          'f150',
          '🛍️Groceries (1)',
          'Medical:Counseling(2)',
          '🩺Medical:Doctor (1)',
          '💊Medical:Prescription (1)',
          '🔥Natural Gas (23rd)',
          'Oxygen/medical supplies',
          'Red flag',
          'Wooga',
        ]);
      });
    });
  });
}
