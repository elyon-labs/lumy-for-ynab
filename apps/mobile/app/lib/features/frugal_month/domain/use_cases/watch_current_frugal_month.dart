import 'package:collection/collection.dart';
import 'package:oxidized/oxidized.dart';
import 'package:rxdart/streams.dart';

import '../../../../utils/_local_date.dart';
import '../models/frugal_month.dart';
import 'watch_frugal_months.dart';

class WatchCurrentFrugalMonth {
  WatchCurrentFrugalMonth({required WatchFrugalMonths watchFrugalMonths})
    : _watchFrugalMonths = watchFrugalMonths;

  factory WatchCurrentFrugalMonth.create() {
    return WatchCurrentFrugalMonth(watchFrugalMonths: WatchFrugalMonths.create());
  }

  final WatchFrugalMonths _watchFrugalMonths;

  ValueStream<Option<FrugalMonth>> call() {
    final frugalMonthsStream = _watchFrugalMonths();
    return frugalMonthsStream.map((frugalMonths) {
      return Option.from(
        frugalMonths.firstWhereOrNull((month) => month.month.isSameMonthAs(thisMonth)),
      );
    }).shareValue();
  }
}
