import '../../../../utils/_local_date.dart';
import '../models/frugal_month.dart';
import 'watch_frugal_months.dart';

class WatchPastFrugalMonths {
  WatchPastFrugalMonths({required WatchFrugalMonths watchFrugalMonths})
    : _watchFrugalMonths = watchFrugalMonths;

  factory WatchPastFrugalMonths.create() {
    return WatchPastFrugalMonths(watchFrugalMonths: WatchFrugalMonths.create());
  }

  final WatchFrugalMonths _watchFrugalMonths;

  Stream<List<FrugalMonth>> call() {
    return _watchFrugalMonths().map((months) {
      return months.where((month) => month.month.isBefore(thisMonth)).toList();
    });
  }
}
