import 'days_buffer/days_buffer_chart.dart';
import 'income_expense/income_expense_chart.dart';
import 'net_worth/net_worth_chart.dart';
import 'smoothed_income/smoothed_income_chart.dart';
import 'spend_by_category/spend_by_category_chart.dart';
import 'spend_by_payee/spend_by_payee_pie_chart.dart';
import 'targets/targets_health_report_chart.dart';

final allCharts = [
  IncomeExpenseChart(),
  NetWorthChart(),
  SpendByCategoryChart(),
  SpendByPayeePieChart(),
  DaysBufferChart(),
  SmoothedIncomeChart(),
  TargetsHealthReportChart(),
];
