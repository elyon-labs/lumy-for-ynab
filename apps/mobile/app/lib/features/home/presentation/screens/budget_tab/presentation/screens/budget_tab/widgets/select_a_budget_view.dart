import 'package:dart_foundation/dart_foundation.dart';
import 'package:design/design.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import '../../../../../../../../../app/di.dart';
import '../../../../../../../../../common/domain/budgets/budgets_fetch_cubit.dart';
import '../../../../../../../../../common/domain/budgets/budgets_repository.dart';
import '../../../../../../../../../common/presentation/design_system/list_row.dart';
import '../../../../../../../../../common/presentation/design_system/section_body.dart';
import '../../../../../../../../../external/http_client.dart';
import '../../../../../../../../../utils/_cubit.dart';
import '../../../../../../../../../utils/_local_date.dart';
import '../../../../../../../../../ynab_api/_budget.dart';
import '../../../../../../../../../ynab_api/_response.dart';

class SelectABudgetViewState {
  SelectABudgetViewState({required this.budgets});

  factory SelectABudgetViewState.initial() {
    return SelectABudgetViewState(budgets: List.empty());
  }

  final List<Budget> budgets;
}

class SelectABudgetViewCubit extends Cubit<SelectABudgetViewState> {
  SelectABudgetViewCubit({required this.budgetsRepo}) : super(SelectABudgetViewState.initial()) {
    fetch();
  }

  factory SelectABudgetViewCubit.create() {
    return SelectABudgetViewCubit(budgetsRepo: inject());
  }

  final BudgetsRepository budgetsRepo;
  final subs = CompositeSubscription();

  void fetch() {
    final budgetsSub = budgetsRepo.watch().listen((budgets) {
      safeEmit(SelectABudgetViewState(budgets: budgets));
    });
    subs.add(budgetsSub);
  }

  @override
  Future<void> close() async {
    await subs.dispose();
    return super.close();
  }
}

class SelectABudgetView extends StatelessWidget {
  const SelectABudgetView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SelectABudgetViewCubit.create(),
      child: switch (context.watch<BudgetsFetchCubit>().state) {
        Loaded() => const _LoadedBody(),
        Error(:final error) => _ErrorBody(error: error),
        _ => const Scaffold(body: Center(child: CircularProgressIndicator.adaptive())),
      },
    );
  }
}

class _LoadedBody extends StatelessWidget {
  const _LoadedBody();

  @override
  Widget build(BuildContext context) {
    final budgets = context.watch<SelectABudgetViewCubit>().state.budgets;
    final children = List<Widget>.from(
      budgets.map((budget) {
        return ListRow(
          title: Text(budget.name),
          subtitle: budget.lastModifiedOn != null
              ? Text('Modified ${budget.lastModifiedOnDate!.MMMdyyyy()}')
              : const SizedBox.shrink(),
          onTap: () => $settings().setSelectedBudgetId(budget.id),
        );
      }),
    );
    return Scaffold(
      appBar: AppBar(title: const Text('Select a budget')),
      body: SingleChildScrollView(
        child: VLayout(
          children: [
            const VSpace(space: Sizes.edgePadding),
            ListSection(children: children),
            const VSpace(space: Sizes.edgePadding),
          ],
        ),
      ),
    );
  }
}

class _ErrorBody extends StatelessWidget {
  const _ErrorBody({required this.error});

  final Object error;

  @override
  Widget build(BuildContext context) {
    final ynabApiError = error.let((e) {
      if (error is! ErrorResponse) return null;
      return (error as ErrorResponse).response?.ynabApiError;
    });

    final errorIdentifier = ynabApiError?.id ?? 'Unknown error';
    final errorMessage =
        ynabApiError?.detail ??
        "Something's up but we're not quite sure what. We'll figure it out!";

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(Sizes.edgePadding),
        child: SafeArea(
          child: VLayout(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: VLayout(
                    children: [
                      CircleAvatar(
                        radius: Sizes.unit * 4,
                        backgroundColor: context.colors.error,
                        child: Icon(
                          Ionicons.alert_outline,
                          size: Sizes.unit * 4,
                          color: context.colors.onError,
                        ),
                      ),
                      const VSpace(space: Sizes.unit * 2),
                      Text(errorIdentifier, style: context.text.headline),
                      Text(
                        errorMessage,
                        style: context.text.body.copyWith(color: context.colors.muted),
                      ),
                    ],
                  ),
                ),
              ),
              PrimaryButton(
                child: const Text('Try again'),
                onPressed: () async {
                  await context.read<BudgetsFetchCubit>().fetch();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
