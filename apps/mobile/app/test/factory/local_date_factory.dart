import 'package:faker/faker.dart';
import 'package:time_machine/time_machine.dart';

final _faker = Faker();

abstract class LocalDateFactory {
  static LocalDate build({int? year, int? month, int? day}) {
    final random = _faker.date.dateTime();
    return LocalDate(year ?? random.year, month ?? random.month, day ?? random.day);
  }
}

extension LocalDateFactoryX on LocalDate {
  String yyyyMMddWithSlashes() {
    return toString('yyyy-MM-dd');
  }
}
