import 'package:dart_mappable/dart_mappable.dart';
import 'package:time_machine/time_machine.dart';

import '../_date_time.dart';
import '../_local_date.dart';

class LocalDateMapper extends SimpleMapper<LocalDate> {
  const LocalDateMapper();

  @override
  LocalDate decode(Object value) {
    assert(value is String, 'Expected a String for LocalDate, but got ${value.runtimeType}');
    return DateTime.parse(value as String).toLocal().toLocalDate();
  }

  @override
  String encode(LocalDate value) {
    return value.yyyyMMdd();
  }
}
