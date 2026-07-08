import 'package:dart_foundation/dart_foundation.dart';
import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import '../../../../app/di.dart';
import '../../../../common/domain/categories/categories_repository.dart';
import '../../../../common/domain/categories/category_groups_view.dart';
import '../../../../common/presentation/bottom_glow_container.dart';
import '../../../../common/presentation/categories/choose_categories.dart';
import '../../../../utils/_cubit.dart';
import '../../../../ynab_api/_category.dart';
import '../../../../ynab_api/_category_group.dart';
import '../flows/create_frugal_month_flow.dart';

class ChooseFrugalMonthCategoriesScreenState {
  ChooseFrugalMonthCategoriesScreenState({required this.categoryGroups});

  factory ChooseFrugalMonthCategoriesScreenState.initial() {
    return ChooseFrugalMonthCategoriesScreenState(categoryGroups: const Loading());
  }

  final Async<List<CategoryGroup>> categoryGroups;
}

class ChooseFrugalMonthCategoriesScreenCubit extends Cubit<ChooseFrugalMonthCategoriesScreenState> {
  ChooseFrugalMonthCategoriesScreenCubit({required this.categoriesRepo})
    : super(ChooseFrugalMonthCategoriesScreenState.initial()) {
    fetch();
  }

  factory ChooseFrugalMonthCategoriesScreenCubit.create() {
    return ChooseFrugalMonthCategoriesScreenCubit(categoriesRepo: inject());
  }

  final CategoriesRepository categoriesRepo;
  final subs = CompositeSubscription();

  void fetch() {
    final categoryGroups = categoriesRepo.watchCategoryGroups(
      const WithoutHiddenAndSpecialGroups(),
    );
    final sub = categoryGroups.listen((value) {
      safeEmit(ChooseFrugalMonthCategoriesScreenState(categoryGroups: Loaded(value)));
    });
    subs.add(sub);
  }

  @override
  Future<void> close() async {
    await subs.dispose();
    return super.close();
  }
}

class ChooseFrugalMonthCategoriesScreen extends StatelessWidget {
  const ChooseFrugalMonthCategoriesScreen({super.key, required this.afterMonthChoice});
  final bool afterMonthChoice;

  static String buildRoute(bool afterMonthChoice) {
    return afterMonthChoice
        ? '/budget/choose_frugal_month/choose_categories' //
        : '/budget/choose_categories';
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateFrugalMonthFlow, CreateFrugalMonthState>(
      builder: (context, state) {
        final showClose = state.availableMonths.valueOr([]).length <= 1;
        return BlocProvider(
          create: (context) => ChooseFrugalMonthCategoriesScreenCubit.create(),
          child: Scaffold(
            appBar: AppBar(
              // Need to show this due to being the first route in a ShellRoute
              leading: showClose ? CloseButton(onPressed: () => GoRouter.of(context).pop()) : null,
              title: const Text('Choose categories'),
            ),
            body:
                BlocBuilder<
                  ChooseFrugalMonthCategoriesScreenCubit,
                  ChooseFrugalMonthCategoriesScreenState
                >(
                  builder: (context, state) {
                    return switch (state.categoryGroups) {
                      Loaded(:final value) => _LoadedBody(
                        groups: value,
                        afterMonthChoice: afterMonthChoice,
                      ),
                      _ => const Center(child: CircularProgressIndicator.adaptive()),
                    };
                  },
                ),
          ),
        );
      },
    );
  }
}

class _LoadedBody extends HookWidget {
  const _LoadedBody({required this.afterMonthChoice, required this.groups});

  final List<CategoryGroup> groups;
  final bool afterMonthChoice;

  @override
  Widget build(BuildContext context) {
    final selectedCategoryIds = useState(groups.categories.ids.toList());
    return VLayout(
      spacing: 0,
      children: [
        Expanded(
          child: ChooseCategories(
            selectedCategoryIds: selectedCategoryIds,
            selectedCategoryGroupIds: ValueNotifier(List.empty()),
            options: groups,
          ),
        ),
        BottomGlowContainer(
          child: PrimaryButton(
            onPressed: selectedCategoryIds.value.isEmpty
                ? null
                : () async {
                    final step = ChooseCategoriesStep(
                      selectedCategories: selectedCategoryIds.value,
                    );
                    await context.read<CreateFrugalMonthFlow>().stepComplete(step);
                  },
            child: const Text('Confirm Categories'),
          ),
        ),
      ],
    );
  }
}
