import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('chart feature code does not import small async transaction helpers', () {
    final chartFiles = Directory(
      'lib/features/charts',
    ).listSync(recursive: true).whereType<File>().where((file) => file.path.endsWith('.dart'));

    for (final file in chartFiles) {
      final contents = file.readAsStringSync();
      expect(contents, isNot(contains('_base_transactions_async.dart')), reason: file.path);
      expect(contents, isNot(contains('_transactions_async.dart')), reason: file.path);
    }
  });
}
