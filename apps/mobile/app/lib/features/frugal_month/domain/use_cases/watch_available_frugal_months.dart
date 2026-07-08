import 'package:collection/collection.dart';
import 'package:time_machine/time_machine.dart';

import '../../../../utils/_local_date.dart';
import 'watch_frugal_months.dart';

class WatchAvailableFrugalMonths {
  WatchAvailableFrugalMonths({required WatchFrugalMonths watchFrugalMonths})
    : _watchFrugalMonths = watchFrugalMonths;

  factory WatchAvailableFrugalMonths.create() {
    return WatchAvailableFrugalMonths(watchFrugalMonths: WatchFrugalMonths.create());
  }

  final WatchFrugalMonths _watchFrugalMonths;

  Stream<List<LocalDate>> call() {
    return _watchFrugalMonths().map((frugalMonths) {
      bool canCreate(LocalDate month) {
        return frugalMonths.none((fMonth) => fMonth.month.isSameMonthAs(month));
      }

      Iterable<LocalDate> months() sync* {
        if (canCreate(thisMonth)) yield thisMonth;
        if (canCreate(nextMonth)) yield nextMonth;
      }

      return months().toList();
    });
  }
}
