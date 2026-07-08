import 'package:collection/collection.dart';
import 'package:time_machine/time_machine.dart';

import '../../../../utils/_local_date.dart';
import 'watch_frugal_months.dart';

class WatchCanCreateFrugalMonth {
  WatchCanCreateFrugalMonth({required WatchFrugalMonths watchFrugalMonths})
    : _watchFrugalMonths = watchFrugalMonths;

  factory WatchCanCreateFrugalMonth.create() {
    return WatchCanCreateFrugalMonth(watchFrugalMonths: WatchFrugalMonths.create());
  }

  final WatchFrugalMonths _watchFrugalMonths;

  Stream<bool> call(LocalDate month) {
    return _watchFrugalMonths().map((frugalMonths) {
      return frugalMonths.none((fMonth) {
        return fMonth.month.isSameMonthAs(month);
      });
    });
  }
}
