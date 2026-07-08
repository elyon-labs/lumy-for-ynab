import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oxidized/oxidized.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import '../../../../app/di.dart';
import '../../../../common/domain/budgets/budgets_repository.dart';
import '../../../../common/domain/categories/categories_repository.dart';
import '../../../../common/domain/categories/categories_view.dart';
import '../../../../common/domain/categories/category_groups_view.dart';
import '../../../../common/presentation/categories/category_list.dart';
import '../../../../utils/_cubit.dart';
import '../../domain/use_cases/watch_frugal_month_data.dart';

class ViewFrugalMonthCategoriesScreenState {
  ViewFrugalMonthCategoriesScreenState({
    required this.frugalMonthId,
    required this.currencyFormat,
    required this.categories,
    required this.allCategoryGroups,
  });

  factory ViewFrugalMonthCategoriesScreenState.initial({required String frugalMonthId}) {
    return ViewFrugalMonthCategoriesScreenState(
      frugalMonthId: frugalMonthId,
      currencyFormat: const None(),
      categories: [],
      allCategoryGroups: [],
    );
  }

  final String frugalMonthId;
  final Option<CurrencyFormat> currencyFormat;
  final List<Category> categories;
  final List<CategoryGroup> allCategoryGroups;
}

class ViewFrugalMonthCategoriesScreenCubit extends Cubit<ViewFrugalMonthCategoriesScreenState> {
  ViewFrugalMonthCategoriesScreenCubit({
    required this.frugalMonthId,
    required WatchFrugalMonthData watchFrugalMonthData,
    required BudgetsRepository budgetsRepo,
    required CategoriesRepository categoriesRepo,
  }) : _categoriesRepository = categoriesRepo,
       _budgetsRepository = budgetsRepo,
       _watchFrugalMonthData = watchFrugalMonthData,
       super(ViewFrugalMonthCategoriesScreenState.initial(frugalMonthId: frugalMonthId)) {
    fetch();
  }

  factory ViewFrugalMonthCategoriesScreenCubit.create(String frugalMonthId) {
    return ViewFrugalMonthCategoriesScreenCubit(
      frugalMonthId: frugalMonthId,
      watchFrugalMonthData: WatchFrugalMonthData.create(),
      budgetsRepo: inject(),
      categoriesRepo: inject(),
    );
  }

  final String frugalMonthId;
  final WatchFrugalMonthData _watchFrugalMonthData;
  final BudgetsRepository _budgetsRepository;
  final CategoriesRepository _categoriesRepository;
  final subs = CompositeSubscription();

  void fetch() {
    final frugalMonthDataStream = _watchFrugalMonthData(frugalMonthId);

    final stateStream = frugalMonthDataStream.switchMap((frugalMonthData) async* {
      yield* Rx.combineLatest3(
        _budgetsRepository.watchCurrencyFormat(),
        _categoriesRepository.watchCategoryGroups(const AllCategoryGroups()),
        _categoriesRepository.watchCategories(CategoriesWithIds(frugalMonthData.month.categoryIds)),
        (a, b, c) => (a, b, c),
      );
    });

    final sub = stateStream.listen((event) {
      final (currencyFormat, categoryGroups, categories) = event;
      safeEmit(
        ViewFrugalMonthCategoriesScreenState(
          frugalMonthId: frugalMonthId,
          currencyFormat: currencyFormat,
          categories: categories,
          allCategoryGroups: categoryGroups,
        ),
      );
    });
    subs.add(sub);
  }

  @override
  Future<void> close() async {
    await subs.dispose();
    return super.close();
  }
}

class ViewFrugalMonthCategoriesScreen extends StatelessWidget {
  const ViewFrugalMonthCategoriesScreen({super.key, required this.id});
  final String id;

  static String buildRoute(String id) {
    return '/budget/frugal_month/$id/settings/categories';
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ViewFrugalMonthCategoriesScreenCubit.create(id),
      child:
          BlocBuilder<ViewFrugalMonthCategoriesScreenCubit, ViewFrugalMonthCategoriesScreenState>(
            builder: (context, state) {
              return Scaffold(
                appBar: AppBar(title: const Text('Categories')),
                body: SingleChildScrollView(
                  child: CategoryList(
                    categories: state.categories,
                    allCategoryGroups: state.allCategoryGroups,
                    currencyFormat: state.currencyFormat,
                  ),
                ),
              );
            },
          ),
    );
  }
}
