import 'package:dart_foundation/dart_foundation.dart';
import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import '../../../../common/domain/budgets/currency_format_cubit.dart';
import '../../../../common/presentation/charts/loading_chart.dart';
import '../../../../common/presentation/colored_dot.dart';
import '../../../../common/presentation/currency.dart';
import '../../../../common/presentation/design_system/_build_context.dart';
import '../../../../common/presentation/design_system/list_row.dart';
import '../../templates/circular_chart_template.dart';
import '../state/spend_by_category_chart_data_cubit.dart';

class SpendByCategoryPie extends StatelessWidget {
  const SpendByCategoryPie({super.key});

  @override
  Widget build(BuildContext context) {
    final data = context.watch<SpendByCategoryChartDataCubit>().state;

    return switch (data) {
      Loaded(:final value) => _Chart(value: value),
      _ => const LoadingChart(),
    };
  }
}

enum _View { categories, categoryGroups }

const _maxObjects = 9;

class _Chart extends HookWidget {
  const _Chart({required this.value});

  final SpendByCategoryData value;

  @override
  Widget build(BuildContext context) {
    final categoryGroups = value.categoryGroupsToSpendData;
    final categories = value.categorySpendData;
    final selectedGroup = useState<CategoryGroup?>(null);
    final selectedView = useState<_View>(_View.categoryGroups);

    return VLayout(
      spacing: 0,
      children: [
        if (selectedGroup.value != null)
          _GroupSelectedView(
            categories: categories,
            selectedGroup: selectedGroup.value!,
            onBackToAllGroups: () => selectedGroup.value = null,
          ),
        if (selectedGroup.value == null && selectedView.value == _View.categories)
          _CategoriesView(
            categories: categories,
            onSwitchToCategoryGroups: () => selectedView.value = _View.categoryGroups,
          ),
        if (selectedGroup.value == null && selectedView.value == _View.categoryGroups)
          CategoryGroupsView(
            categoryGroups: categoryGroups,
            onGroupSelected: (group) => selectedGroup.value = group,
            onSwitchToCategories: () => selectedView.value = _View.categories,
          ),
      ],
    );
  }
}

class _GroupSelectedView extends HookWidget {
  const _GroupSelectedView({
    required this.categories,
    required this.selectedGroup,
    required this.onBackToAllGroups,
  });

  final List<SingleCategorySpendData> categories;
  final CategoryGroup selectedGroup;
  final VoidCallback onBackToAllGroups;

  @override
  Widget build(BuildContext context) {
    final currencyFormat = useCurrencyFormat();
    final sorted = categories
        .where((c) => c.category.categoryGroupId == selectedGroup.id)
        .sortedBySpendAsc;
    final firstMaxObjects = sorted.take(_maxObjects);
    final others = sorted.skip(_maxObjects);
    final combinedOthers = others.length == 1
        ? others.single
        : OtherCategoriesSpendData(
            spend: others.map((e) => e.spend).fold(0, (a, b) => a + b),
            percentOfGroupSpend: others.map((e) => e.percentOfGroupSpend).fold(0, (a, b) => a + b),
            percentOfTotalSpend: others.map((e) => e.percentOfTotalSpend).fold(0, (a, b) => a + b),
          );

    final data = [...firstMaxObjects.map((v) => v), if (others.isNotEmpty) combinedOthers];

    return VLayout(
      spacing: 0,
      children: [
        CircularChart(
          series: [
            context.createDoughnutSeries<CategorySpendData, String>(
              pointColorMapper: (datum, index) {
                return context.bespokeColors.chartColors.elementAtOrNull(index) ??
                    context.bespokeColors.chartCompare;
              },
              innerRadius: '80%',
              radius: '90%',
              strokeWidth: 0,
              xValueMapper: (entry, _) => switch (entry) {
                SingleCategorySpendData(:final category) => category.name,
                OtherCategoriesSpendData() => 'Others',
              },
              yValueMapper: (entry, _) => entry.spend.abs(),
              source: data,
            ),
          ],
        ),
        Align(
          child: TextButton(onPressed: onBackToAllGroups, child: const Text('Back to all groups')),
        ),
        Builder(
          builder: (context) {
            final length = data.length;
            return VLayout(
              spacing: 0,
              children: [
                for (int i = 0; i < length; i++) ...[
                  Builder(
                    builder: (context) {
                      final entry = data.elementAt(i);
                      return ListRow(
                        externalPadding: const EdgeInsets.symmetric(horizontal: Sizes.edgePadding),
                        leading: ColoredDot(
                          color: context.bespokeColors.chartColors[i],
                          size: Sizes.unit * 2,
                        ),
                        visualDensity: VisualDensity.compact,
                        title: Text(entry.name, overflow: TextOverflow.ellipsis),
                        trailing: Text(
                          '${entry.spend.abs().format(currencyFormat)} (${entry.percentOfGroupSpend.toStringAsFixed(2)}%)',
                        ),
                      );
                    },
                  ),
                  if (i < length - 1) const Divider(),
                ],
              ],
            );
          },
        ),
      ],
    );
  }
}

class _CategoriesView extends HookWidget {
  const _CategoriesView({required this.categories, required this.onSwitchToCategoryGroups});

  final List<SingleCategorySpendData> categories;
  final VoidCallback onSwitchToCategoryGroups;

  @override
  Widget build(BuildContext context) {
    final currencyFormat = useCurrencyFormat();
    final sorted = categories.sortedBySpendAsc;
    final firstMaxObjects = sorted.take(_maxObjects);
    final others = sorted.skip(_maxObjects);
    final combinedOthers = others.length == 1
        ? others.single
        : OtherCategoriesSpendData(
            spend: others.map((e) => e.spend).fold(0, (a, b) => a + b),
            percentOfGroupSpend: others.map((e) => e.percentOfGroupSpend).fold(0, (a, b) => a + b),
            percentOfTotalSpend: others.map((e) => e.percentOfTotalSpend).fold(0, (a, b) => a + b),
          );
    final data = [...firstMaxObjects.map((v) => v), if (others.isNotEmpty) combinedOthers];

    return VLayout(
      spacing: 0,
      children: [
        CircularChart(
          series: [
            context.createDoughnutSeries<CategorySpendData, String>(
              pointColorMapper: (datum, index) {
                return context.bespokeColors.chartColors.elementAtOrNull(index) ??
                    context.bespokeColors.chartCompare;
              },
              innerRadius: '80%',
              radius: '90%',
              strokeWidth: 0,
              xValueMapper: (entry, _) => switch (entry) {
                OtherCategoriesSpendData() => 'Others',
                SingleCategorySpendData(:final category) => category.name,
              },
              yValueMapper: (entry, _) => entry.spend.abs(),
              source: data,
            ),
          ],
        ),
        Align(
          child: TextButton(
            onPressed: onSwitchToCategoryGroups,
            child: const Text('Switch to groups'),
          ),
        ),
        Builder(
          builder: (context) {
            final length = data.length;
            return VLayout(
              spacing: 0,
              children: [
                for (int i = 0; i < length; i++) ...[
                  Builder(
                    builder: (context) {
                      final entry = data.elementAt(i);
                      return ListRow(
                        externalPadding: const EdgeInsets.symmetric(horizontal: Sizes.edgePadding),
                        leading: ColoredDot(
                          color: context.bespokeColors.chartColors[i],
                          size: Sizes.unit * 2,
                        ),
                        visualDensity: VisualDensity.compact,
                        title: Text(entry.name, overflow: TextOverflow.ellipsis),
                        trailing: Text(
                          '${entry.spend.abs().format(currencyFormat)} (${entry.percentOfTotalSpend.toStringAsFixed(2)}%)',
                        ),
                      );
                    },
                  ),
                  if (i < length - 1) const Divider(),
                ],
              ],
            );
          },
        ),
      ],
    );
  }
}

class CategoryGroupsView extends HookWidget {
  const CategoryGroupsView({
    super.key,
    required this.categoryGroups,
    required this.onGroupSelected,
    required this.onSwitchToCategories,
  });

  final List<CategoryGroupSpendData> categoryGroups;
  final ValueSetter<CategoryGroup> onGroupSelected;
  final VoidCallback onSwitchToCategories;

  @override
  Widget build(BuildContext context) {
    final currencyFormat = useCurrencyFormat();
    final sorted = categoryGroups.sortedBySpendAsc;
    final first10 = sorted.take(_maxObjects);
    final others = sorted.skip(_maxObjects);
    final combinedOthers = OtherCategoryGroupsSpendData(
      spend: others.map((e) => e.spend).fold(0, (a, b) => a + b),
      percentOfTotalSpend: others.map((e) => e.percentOfTotalSpend).fold(0, (a, b) => a + b),
    );
    final data = [...first10.map((v) => v), if (others.isNotEmpty) combinedOthers];

    return VLayout(
      spacing: 0,
      children: [
        CircularChart(
          series: [
            context.createDoughnutSeries<CategoryGroupSpendData, String>(
              pointColorMapper: (datum, index) {
                return context.bespokeColors.chartColors.elementAtOrNull(index) ??
                    context.bespokeColors.chartCompare;
              },
              innerRadius: '80%',
              radius: '90%',
              strokeWidth: 0,
              xValueMapper: (entry, _) => switch (entry) {
                SingleCategoryGroupSpendData(:final categoryGroup) => categoryGroup.name,
                OtherCategoryGroupsSpendData() => 'Others',
              },
              yValueMapper: (entry, _) => entry.spend.abs(),
              source: data,
            ),
          ],
        ),
        Align(
          child: TextButton(
            onPressed: onSwitchToCategories,
            child: const Text('Switch to categories'),
          ),
        ),
        Builder(
          builder: (context) {
            final length = data.length;
            return VLayout(
              spacing: 0,
              children: [
                for (int i = 0; i < length; i++) ...[
                  Builder(
                    builder: (context) {
                      final entry = data.elementAt(i);
                      return ListRow(
                        externalPadding: const EdgeInsets.symmetric(horizontal: Sizes.edgePadding),
                        leading: ColoredDot(
                          color: context.bespokeColors.chartColors[i],
                          size: Sizes.unit * 2,
                        ),
                        onTap: switch (entry) {
                          SingleCategoryGroupSpendData(:final categoryGroup) => () {
                            onGroupSelected(categoryGroup);
                          },
                          OtherCategoryGroupsSpendData() => null,
                        },
                        visualDensity: VisualDensity.compact,
                        title: Text(entry.name),
                        trailing: Text(
                          '${entry.spend.abs().format(currencyFormat)} (${entry.percentOfTotalSpend.toStringAsFixed(2)}%)',
                        ),
                      );
                    },
                  ),
                  if (i < length - 1) const Divider(),
                ],
              ],
            );
          },
        ),
      ],
    );
  }
}
