import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../app/di.dart';
import '../../../persistence/settings.dart';
import '../../../utils/_cubit.dart';
import '../../../utils/_local_date.dart';
import '../domain/models/date_range.dart';

/// TODO: Remove this, either Stream directly from Settings or add `WatchSelectedDateRange` use case.
class SelectedDateRangeCubit extends Cubit<DateRange> {
  SelectedDateRangeCubit({required this.settings})
    : super((from: today.firstDayOfMonth(), to: today.lastDayOfMonth())) {
    fetch();
  }

  factory SelectedDateRangeCubit.create() {
    return SelectedDateRangeCubit(settings: inject());
  }

  final Settings settings;
  final subs = CompositeSubscription();

  void fetch() {
    final selectedDateRange = settings.watchSelectedDateRange();
    subs.add(selectedDateRange.listen(safeEmit));
  }

  @override
  Future<void> close() async {
    await subs.dispose();
    return super.close();
  }
}
