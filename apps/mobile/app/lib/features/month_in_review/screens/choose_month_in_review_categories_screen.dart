import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:oxidized/oxidized.dart';
import 'package:rxdart/rxdart.dart';

import '../../../app/di.dart';
import '../../../common/presentation/categories/choose_category_view.dart';
import '../../../common/presentation/design_system/app_screen.dart';
import '../../../persistence/settings.dart';
import '../../../utils/_cubit.dart';
import '../../category_views/presentation/flows/create_category_view/state/create_category_view_cubit.dart';
import '../category_view/month_in_review_create_category_view.dart';

class ChooseMonthInReviewCategoriesScreenState {
  ChooseMonthInReviewCategoriesScreenState({required this.categoryView});

  factory ChooseMonthInReviewCategoriesScreenState.initial() {
    return ChooseMonthInReviewCategoriesScreenState(categoryView: const None());
  }

  final Option<String> categoryView;
}

class ChooseMonthInReviewCategoriesScreenCubit
    extends Cubit<ChooseMonthInReviewCategoriesScreenState> {
  ChooseMonthInReviewCategoriesScreenCubit({required this.settings})
    : super(ChooseMonthInReviewCategoriesScreenState.initial()) {
    fetch();
  }

  factory ChooseMonthInReviewCategoriesScreenCubit.create() {
    return ChooseMonthInReviewCategoriesScreenCubit(settings: inject());
  }

  final Settings settings;
  final subs = CompositeSubscription();

  void fetch() {
    final categoryView = settings.watchMonthInReviewCategoryViewStream();
    final sub = categoryView.listen((value) {
      safeEmit(ChooseMonthInReviewCategoriesScreenState(categoryView: value));
    });
    subs.add(sub);
  }

  @override
  Future<void> close() async {
    await subs.dispose();
    return super.close();
  }
}

class ChooseMonthInReviewCategoriesScreen extends HookWidget {
  const ChooseMonthInReviewCategoriesScreen({super.key});

  static String route = '/reports/month_in_review/categories';

  @override
  Widget build(BuildContext context) {
    return AppScreen(
      title: const Text('Choose categories'),
      child: BlocProvider(
        create: (context) => ChooseMonthInReviewCategoriesScreenCubit.create(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: Sizes.edgePadding),
          child: SafeArea(
            child:
                BlocBuilder<
                  ChooseMonthInReviewCategoriesScreenCubit,
                  ChooseMonthInReviewCategoriesScreenState
                >(
                  builder: (context, state) {
                    return ChooseCategoryView(
                      current: state.categoryView,
                      onTapCreateView: () {
                        context.read<CreateCategoryViewCubit>().reset();
                        GoRouter.of(context).go(MonthInReviewCreateCategoryView.route);
                      },
                      onUpdateSetting: (value) async {
                        await $settings().setMonthInReviewCategoryView(value);
                      },
                    );
                  },
                ),
          ),
        ),
      ),
    );
  }
}
