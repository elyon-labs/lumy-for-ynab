import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:time_machine/time_machine.dart';

import '../../../common/domain/budgets/currency_format_cubit.dart';
import '../../../common/presentation/currency.dart';
import '../../../utils/_local_date.dart';

// ignore: non_constant_identifier_names
ChartLabelFormatterCallback CurrencyYAxisFormatter(BuildContext context) {
  return (details) {
    final axis = details.axis;
    final value = details.value.toInt();
    final formatted = value.formatForAxis(
      currencyFormat: context.read<CurrencyFormatCubit>().state,
      interval: axis.visibleInterval,
    );
    return ChartAxisLabel(formatted, TextStyle(color: context.colors.foreground));
  };
}

// ignore: non_constant_identifier_names
ChartLabelFormatterCallback MonthXAxisFormatter(
  BuildContext context,
  List<MapEntry<LocalDate, dynamic>> source,
) {
  return (details) {
    final month = source.elementAt(details.value.toInt()).key;
    final durationBetweenKeys = source.length < 2
        ? null
        : source[1].key.toDateTimeUnspecified().difference(source[0].key.toDateTimeUnspecified());

    String formatter(LocalDate date) {
      final duration = durationBetweenKeys?.inDays ?? 0;
      return switch (duration) {
        < 7 => date.dayOfMonth.toString(),
        < 31 => date.dayOfMonth.toString(),
        < 365 => date.Myy(),
        _ => date.Myy(),
      };
    }

    return ChartAxisLabel(formatter(month), TextStyle(color: context.colors.foreground));
  };
}
