import 'package:time_machine/time_machine.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import '../utils/_date_time.dart';

extension MonthX on Month {
  LocalDate get localDate {
    final parsed = DateTime.parse(month).toLocal();
    return parsed.toLocalDate();
  }
}
