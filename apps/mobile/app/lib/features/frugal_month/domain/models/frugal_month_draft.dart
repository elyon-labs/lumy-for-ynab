import 'package:dart_mappable/dart_mappable.dart';
import 'package:time_machine/time_machine.dart';

part 'frugal_month_draft.mapper.dart';

@MappableClass()
class FrugalMonthDraft with FrugalMonthDraftMappable {
  FrugalMonthDraft({this.month, this.targetAmount, this.categoryIds, this.accountIds});

  final LocalDate? month;
  final int? targetAmount;
  final List<String>? categoryIds;
  final List<String>? accountIds;

  bool get isValid =>
      month != null &&
      targetAmount != null && //
      categoryIds != null &&
      categoryIds!.isNotEmpty &&
      accountIds != null &&
      accountIds!.isNotEmpty;

  FrugalMonthDraft setMonth(LocalDate month) => copyWith(month: month);
  FrugalMonthDraft setLimit(int targetAmount) => copyWith(targetAmount: targetAmount);
  FrugalMonthDraft setCategoryIds(List<String> categoryIds) => copyWith(categoryIds: categoryIds);
  FrugalMonthDraft setAccountIds(List<String> accountIds) => copyWith(accountIds: accountIds);
}
