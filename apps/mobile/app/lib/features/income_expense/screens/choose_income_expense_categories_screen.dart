import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:oxidized/oxidized.dart';
import 'package:rxdart/rxdart.dart';

import '../../../app/di.dart';
import '../../../common/presentation/categories/choose_category_view.dart';
import '../../../persistence/settings.dart';
import '../../../utils/_cubit.dart';
import '../../category_views/presentation/flows/create_category_view/state/create_category_view_cubit.dart';
import '../category_view.dart/income_expense_create_category_view.dart';

class ChooseIncomeExpenseCategoriesScreenState {
  ChooseIncomeExpenseCategoriesScreenState({required this.categoryView});

  factory ChooseIncomeExpenseCategoriesScreenState.initial() {
    return ChooseIncomeExpenseCategoriesScreenState(categoryView: const None());
  }

  final Option<String> categoryView;
}

class ChooseIncomeExpenseCategoriesScreenCubit
    extends Cubit<ChooseIncomeExpenseCategoriesScreenState> {
  ChooseIncomeExpenseCategoriesScreenCubit({required this.settings})
    : super(ChooseIncomeExpenseCategoriesScreenState.initial()) {
    fetch();
  }

  factory ChooseIncomeExpenseCategoriesScreenCubit.create() {
    return ChooseIncomeExpenseCategoriesScreenCubit(settings: inject());
  }

  final Settings settings;
  final subs = CompositeSubscription();

  void fetch() {
    final categoryView = settings.watchIncomeExpenseCategoryView();
    final sub = categoryView.listen(
      (value) => safeEmit(ChooseIncomeExpenseCategoriesScreenState(categoryView: value)),
    );
    subs.add(sub);
  }

  @override
  Future<void> close() async {
    await subs.dispose();
    return super.close();
  }
}

class ChooseIncomeExpenseCategoriesScreen extends HookWidget {
  const ChooseIncomeExpenseCategoriesScreen({super.key});

  static String route = '/reports/income_expense/categories';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Choose categories')),
      body: BlocProvider(
        create: (context) => ChooseIncomeExpenseCategoriesScreenCubit.create(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: Sizes.edgePadding),
          child: VLayout(
            spacing: 0,
            children: [
              SafeArea(
                child:
                    BlocBuilder<
                      ChooseIncomeExpenseCategoriesScreenCubit,
                      ChooseIncomeExpenseCategoriesScreenState
                    >(
                      builder: (context, state) {
                        return ChooseCategoryView(
                          current: state.categoryView,
                          onTapCreateView: () {
                            context.read<CreateCategoryViewCubit>().reset();
                            GoRouter.of(context).go(IncomeExpenseCreateCategoryView.route);
                          },
                          onUpdateSetting: (value) async {
                            await $settings().setIncomeExpenseCategoryView(value);
                          },
                        );
                      },
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
