import 'package:flutter_test/flutter_test.dart';
import 'package:lumy/features/templates/domain/models/legacy_transaction_template.dart';
import 'package:lumy/persistence/settings.dart';
import 'package:oxidized/oxidized.dart';

import '../utilities/fake_shared_preferences.dart';

void main() {
  group('Settings', () {
    test('allows multiple observers', () async {
      final prefs = FakeSharedPreferences({'selected_budget_id': '1234'});
      final subject = Settings(prefs);

      final emitted1 = <Option<String>>[];
      final observer1 = subject.watchSelectedBudgetId().listen(emitted1.add);

      final emitted2 = <Option<String>>[];
      final observer2 = subject.watchSelectedBudgetId().listen(emitted2.add);

      await pumpEventQueue();

      expect(emitted1, contains(const Some('1234')));
      expect(emitted2, contains(const Some('1234')));

      subject.setSelectedBudgetId('2345');

      await pumpEventQueue();

      expect(emitted1, contains(const Some('2345')));
      expect(emitted2, contains(const Some('2345')));

      await observer1.cancel();
      await observer2.cancel();

      final emitted3 = <Option<String>>[];
      final observer3 = subject.watchSelectedBudgetId().listen(emitted3.add);

      await pumpEventQueue();

      expect(emitted3, contains(const Some('2345')));
      expect(emitted3.contains(const Some('1234')), isFalse);

      await observer3.cancel();
    });

    test('ignores non-template values with transaction template prefix', () async {
      final prefs = FakeSharedPreferences({'transaction_templates_sync': 'notSynced'});
      final subject = Settings(prefs);

      final templates = await subject.fetchAllTransactionTemplates();

      expect(templates, isEmpty);
    });

    test('checks transaction template presence without decoding templates', () async {
      final prefs = FakeSharedPreferences({
        'transaction_templates_budget-id': ['{"amount": 1}'],
      });
      final subject = Settings(prefs);

      final hasTemplates = await subject.hasAnyTransactionTemplates();

      expect(hasTemplates, isTrue);
    });

    test('fetchAllTransactionTemplates skips and deletes invalid legacy templates', () async {
      final validTemplate = LegacyTransactionTemplate(name: 'Valid template');
      final prefs = FakeSharedPreferences({
        'transaction_templates_budget-id': ['{"amount": 1}', validTemplate.toJson()],
      });
      final subject = Settings(prefs);

      final templates = await subject.fetchAllTransactionTemplates();

      expect(templates, hasLength(1));
      expect(templates.single.name, 'Valid template');
      expect(prefs.getStringList('transaction_templates_budget-id'), [validTemplate.toJson()]);
    });
  });
}
