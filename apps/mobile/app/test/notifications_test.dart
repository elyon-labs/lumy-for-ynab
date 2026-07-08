import 'package:flutter_test/flutter_test.dart';
import 'package:lumy/features/notifications/notifications.dart';

void main() {
  group('Notifications', () {
    group('stringToInt', () {
      test('isUnique', () {
        const id = 'my_long_notification_id_1';
        const id2 = 'my_long_notification_id_2';

        expect(stringToInt(id), isNot(stringToInt(id2)));
      });
    });
  });
}
