import 'package:clock/clock.dart';
import 'package:time_machine/time_machine.dart';

DateTime get nowLocal => clock.now();

extension DateTimeX on DateTime {
  LocalDate toLocalDate() {
    return LocalDate(year, month, day);
  }
}
