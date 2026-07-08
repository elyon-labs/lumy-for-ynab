import 'package:collection/collection.dart';
import 'package:time_machine/time_machine.dart';

import '../../../../utils/_local_date.dart';

typedef DateRange = ({LocalDate from, LocalDate to});

extension DateRangeX on DateRange {
  /// The duration of the [DateRange], including the last day.
  /// For example, if the [DateRange] was from 2021-01-01 to 2021-01-31,
  /// the duration would be 31 days.
  Duration duration() {
    return to
        .addDays(1) // Include the last day.
        .subtractInternal(from);
  }

  String get description {
    if (from.isSameMonthAs(to)) {
      return from.MMMMyyyy();
    }
    return '${from.MMMMyyyy()} to ${to.MMMMyyyy()}';
  }

  String toPreferencesString() {
    final formattedFrom = yearMonthFormatter.format(from.toDateTimeUnspecified());
    final formattedTo = yearMonthFormatter.format(to.toDateTimeUnspecified());
    return '$formattedFrom|$formattedTo';
  }

  Iterable<LocalDate> daysInRange() {
    final out = <LocalDate>[];
    var start = from;
    while (start.isBefore(to) || start == to) {
      out.add(start);
      start = start.addDays(1);
    }
    return out;
  }

  Iterable<LocalDate> monthsInRange({bool useTodayForCurrentMonth = false}) {
    final days = daysInRange().toList();
    final months = <LocalDate>[];
    for (final day in days) {
      if (day.dayOfMonth == 1 && months.none((d) => d.isSameMonthAs(day))) {
        months.add(day);
      }
    }
    if (months.isEmpty) months.add(today.firstDayOfMonth());
    if (!useTodayForCurrentMonth) return months;
    return months.map(
      (month) => month.isSameMonthAs(today)
          ? month.isBefore(today)
                ? today
                : month
          : month,
    );
  }

  Iterable<LocalDate> weeksInRange() {
    final weeks = daysInRange().where((d) => d.dayOfWeek == DayOfWeek.monday);
    if (weeks.isEmpty) {
      // Presumably we're in the very beginning of the month, so we'll
      // just use the first day of the month.
      return weeks.toList()..add(today.firstDayOfMonth());
    }
    return weeks;
  }
}

extension DateRangeStringX on String {
  DateRange toDateRange() {
    final splits = split('|');
    final parsedFrom = LocalDate.dateTime(yearMonthFormatter.parse(splits.first));
    final parsedTo = LocalDate.dateTime(yearMonthFormatter.parse(splits.last));
    return (from: parsedFrom, to: parsedTo);
  }
}
