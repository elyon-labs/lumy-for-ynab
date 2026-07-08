import 'package:time_machine/time_machine.dart';

enum ChosenPeriodType {
  thisMonth('This Month'),
  lastMonth('Last Month'),
  last3Months('Latest 3 months'),
  last6Months('Latest 6 months'),
  last12Months('Latest 12 months'),
  thisYear('Year To Date'),
  lastYear('Last Year'),
  custom('Custom');

  const ChosenPeriodType(this.userFriendlyName);

  final String userFriendlyName;
}

class ChosenPeriod {
  ChosenPeriod({required this.type, required this.startDate, required this.endDate});

  final ChosenPeriodType type;
  final LocalDate startDate;
  final LocalDate endDate;
}
