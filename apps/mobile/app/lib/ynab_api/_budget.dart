import 'package:time_machine/time_machine.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import '../utils/_date_time.dart';

extension BudgetX on Budget {
  LocalDate? get lastModifiedOnDate {
    if (lastModifiedOn == null) return null;
    final parsed = DateTime.parse(lastModifiedOn!).toLocal();
    return LocalDate.dateTime(parsed);
  }

  int get lastModifiedOnMillisSinceEpoch {
    if (lastModifiedOn == null) return nowLocal.millisecondsSinceEpoch;
    final parsed = DateTime.parse(lastModifiedOn!).toLocal();
    return parsed.millisecondsSinceEpoch;
  }

  LocalDate? get firstMonthDate {
    if (firstMonth == null) return null;
    final parsed = DateTime.parse(firstMonth!).toLocal();
    return LocalDate.dateTime(parsed);
  }

  LocalDate? get lastMonthDate {
    if (lastMonth == null) return null;
    final parsed = DateTime.parse(lastMonth!).toLocal();
    return LocalDate.dateTime(parsed);
  }
}
