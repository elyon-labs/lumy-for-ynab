import 'package:collection/collection.dart';
import 'package:design/design.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:oxidized/oxidized.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import '../../../../../../../../../app/di.dart';
import '../../../../../../../../../common/domain/budgets/budgets_repository.dart';
import '../../../../../../../../../common/domain/categories/categories_repository.dart';
import '../../../../../../../../../common/domain/categories/categories_view.dart';
import '../../../../../../../../../common/domain/categories/category_groups_view.dart';
import '../../../../../../../../../common/presentation/_color.dart';
import '../../../../../../../../../common/presentation/currency.dart';
import '../../../../../../../../../common/presentation/design_system/_build_context.dart';
import '../../../../../../../../../common/presentation/design_system/section_header.dart';
import '../../../../../../../../../persistence/settings.dart';
import '../../../../../../../../../utils/_cubit.dart';
import '../../../../../../../../../ynab_api/_category.dart';
import '../../../../../../../../../ynab_api/_category_group.dart';
import '../../../../../../../../charts/widgets/visual_card.dart';

class BurndownSectionState extends Equatable {
  const BurndownSectionState({
    required this.categoryGroups,
    required this.totalBalanceRemaining,
    required this.currencyFormat,
    required this.isLoading,
  });

  factory BurndownSectionState.initial() {
    return const BurndownSectionState(
      categoryGroups: [],
      totalBalanceRemaining: 0,
      currencyFormat: None(),
      isLoading: true,
    );
  }

  final List<CategoryGroup> categoryGroups;
  final int totalBalanceRemaining;
  final Option<CurrencyFormat> currencyFormat;
  final bool isLoading;

  @override
  List<Object> get props => [categoryGroups, totalBalanceRemaining, isLoading];
}

class BurndownSectionCubit extends Cubit<BurndownSectionState> {
  BurndownSectionCubit({
    required this.budgetsRepo,
    required this.categoriesRepo,
    required this.settings,
  }) : super(BurndownSectionState.initial()) {
    fetch();
  }

  factory BurndownSectionCubit.create() {
    return BurndownSectionCubit(
      budgetsRepo: inject(),
      categoriesRepo: inject(),
      settings: inject(),
    );
  }

  final BudgetsRepository budgetsRepo;
  final CategoriesRepository categoriesRepo;
  final Settings settings;
  final subs = CompositeSubscription();

  void fetch() {
    final categoryViewStream = settings.watchBudgetTabCategoryView();
    final sub = categoryViewStream
        .switchMap((viewId) async* {
          final categoryView = viewId.mapOr(CategoriesInView.new, const ExpenseCategories());
          final groups = categoriesRepo.watchCategoryGroups(const WithoutHiddenAndSpecialGroups());
          final categories = categoriesRepo.watchCategories(categoryView);
          final currencyFormat = budgetsRepo.watchCurrencyFormat();
          yield* Rx.combineLatest3(groups, categories, currencyFormat, (a, b, c) => (a, b, c));
        })
        .listen((event) {
          final (groups, categories, currencyFormat) = event;
          final filteredCategories = categories.whereNot((c) => c.initialBalance == 0);

          final filteredGroups = groups
              .map((e) {
                return e.copyWith(
                  categories: filteredCategories.where((c) => c.categoryGroupId == e.id).toList(),
                );
              })
              .where((cg) => cg.categories.isNotEmpty)
              .toList();

          final totalBalanceRemaining = filteredGroups.map((c) => c.remainingBalance).sum;

          safeEmit(
            BurndownSectionState(
              categoryGroups: filteredGroups,
              totalBalanceRemaining: totalBalanceRemaining,
              currencyFormat: currencyFormat,
              isLoading: false,
            ),
          );
        });
    subs.add(sub);
  }

  @override
  Future<void> close() async {
    await subs.cancel();
    return super.close();
  }
}

class BurndownSection extends HookWidget {
  const BurndownSection({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedGroup = useState<CategoryGroup?>(null);
    final showAll = useState(false);

    return HEdgePadding(
      child: BlocBuilder<BurndownSectionCubit, BurndownSectionState>(
        builder: (context, state) {
          final categoryGroups = state.categoryGroups;
          const limit = 10;
          final shown = showAll.value ? categoryGroups : categoryGroups.take(limit);
          Iterable<Widget> buildRows() sync* {
            final $selectedGroup = selectedGroup.value;
            for (final group in shown) {
              final allRemaining = group.categories.map((c) => c.remainingPercent);
              final lowestRemaining = allRemaining.min;
              final remainingPercent = group.remainingPercent;
              final remainingBalance = group.remainingBalance;
              final initial = group.initialBalance;
              // Header
              yield InkWell(
                onTap: () {
                  if ($selectedGroup == group) {
                    selectedGroup.value = null;
                  } else {
                    selectedGroup.value = group;
                  }
                },
                child: VEdgePadding(
                  padding: Sizes.unit / 2,
                  child: HEdgePadding(
                    child: VLayout(
                      spacing: Sizes.unit / 2,
                      children: [
                        _CategoryGroup(
                          group: group,
                          colorOfLowestRemaining: context.colors.forPercent(lowestRemaining),
                          remainingBalance: remainingBalance,
                          initialBalance: initial,
                          currencyFormat: state.currencyFormat,
                        ),
                        _Bar(
                          avgRemaining: remainingPercent,
                          color: context.colors.forPercent(remainingPercent),
                        ),
                      ],
                    ),
                  ),
                ),
              );
              // Categories
              if ($selectedGroup == group) {
                yield const VSpace(space: Sizes.unit / 2);
                for (final category in group.categories) {
                  final remaining = category.remainingPercent;
                  yield Padding(
                    padding: const EdgeInsets.only(
                      left: Sizes.edgePadding * 2.5,
                      right: Sizes.edgePadding,
                    ),
                    child: VLayout(
                      spacing: Sizes.unit / 2,
                      children: [
                        _Category(
                          category: category,
                          balance: category.balance,
                          initial: category.initialBalance,
                          currencyFormat: state.currencyFormat,
                        ),
                        _Bar(avgRemaining: remaining, color: context.colors.forPercent(remaining)),
                      ],
                    ),
                  );
                  yield const VSpace(space: Sizes.unit);
                }
              }
            }
            if (categoryGroups.length > limit) {
              yield* [
                Padding(
                  padding: const EdgeInsets.all(Sizes.edgePadding),
                  child: SecondaryButton(
                    onPressed: () {
                      showAll.value = !showAll.value;
                      if (!showAll.value) selectedGroup.value = null;
                    },
                    child: Text(showAll.value ? 'Show less' : 'Show all'),
                  ),
                ),
              ];
            } else {
              yield const VSpace(space: Sizes.edgePadding);
            }
          }

          return VisualCard(
            title: const SectionHeader('Budget burndown'),
            subtitle: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: state.totalBalanceRemaining.format(state.currencyFormat),
                    style: context.text.headline,
                  ),
                  const WidgetSpan(child: HSpace(space: Sizes.unit / 2)),
                  TextSpan(text: 'left', style: context.text.title),
                ],
              ),
            ),
            child: VLayout(spacing: 0, children: buildRows()),
          );
        },
      ),
    );
  }
}

class _CategoryGroup extends StatelessWidget {
  const _CategoryGroup({
    required this.group,
    required this.colorOfLowestRemaining,
    required this.remainingBalance,
    required this.initialBalance,
    required this.currencyFormat,
  });

  final CategoryGroup group;
  final Color colorOfLowestRemaining;
  final int remainingBalance;
  final int initialBalance;
  final Option<CurrencyFormat> currencyFormat;

  @override
  Widget build(BuildContext context) {
    final isOverspent = remainingBalance < 0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            group.name,
            style: const TextStyle(fontWeight: FontWeight.bold),
            overflow: TextOverflow.fade,
            softWrap: false,
          ),
        ),
        const HSpace(space: Sizes.unit * 2),
        if (isOverspent)
          Text(
            '${remainingBalance.abs().format(currencyFormat)} overspent',
            style: context.text.body.copyWith(
              color: context.colors.error,
              fontWeight: FontWeight.bold,
            ),
          ),
        if (!isOverspent)
          Text(
            '${remainingBalance.format(currencyFormat)} of ${initialBalance.format(currencyFormat)}',
          ),
      ],
    );
  }
}

class _Category extends StatelessWidget {
  const _Category({
    required this.category,
    required this.balance,
    required this.initial,
    required this.currencyFormat,
  });

  final Category category;
  final int balance;
  final int initial;
  final Option<CurrencyFormat> currencyFormat;

  @override
  Widget build(BuildContext context) {
    final isOverspent = balance < 0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(child: Text(category.name, overflow: TextOverflow.fade, softWrap: false)),
        const HSpace(space: Sizes.unit * 2),
        if (isOverspent)
          Text(
            '${balance.abs().format(currencyFormat)} overspent',
            style: context.text.body.copyWith(
              color: context.colors.error,
              fontWeight: FontWeight.bold,
            ),
          ),
        if (!isOverspent)
          Text('${balance.format(currencyFormat)} of ${initial.format(currencyFormat)}'),
      ],
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({required this.avgRemaining, required this.color});

  final double avgRemaining;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value: avgRemaining,
      backgroundColor: context.bespokeColors.chartCompare,
      valueColor: AlwaysStoppedAnimation(color),
      minHeight: Sizes.unit * 1.5,
      borderRadius: const BorderRadius.all(Radius.circular(Sizes.borderRadius)),
    );
  }
}
