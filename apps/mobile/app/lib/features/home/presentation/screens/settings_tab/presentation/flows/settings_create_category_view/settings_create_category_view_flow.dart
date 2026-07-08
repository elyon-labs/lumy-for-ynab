import 'dart:async';

import 'package:dart_foundation/dart_foundation.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:oxidized/oxidized.dart';

import '../../../../../../../../app/di.dart';
import '../../../../../../../../external/flow.dart';
import '../../../../../../../../persistence/settings.dart';
import '../../../../../../../../utils/_cubit.dart';
import '../../../../../../../app_review/app_review_service.dart';
import '../../../../../../../category_views/domain/models/category_view_draft.dart';
import '../../../../../../../category_views/domain/use_cases/insert_category_view.dart';
import 'screens/settings_choose_categories_for_view_screen.dart';
import 'screens/settings_name_new_category_view_screen.dart';

part 'settings_create_category_view_flow.mapper.dart';

@MappableClass()
class SettingsCreateCategoryViewState extends FlowState
    with SettingsCreateCategoryViewStateMappable {
  SettingsCreateCategoryViewState({required super.route, required this.draft});

  factory SettingsCreateCategoryViewState.initial() {
    return SettingsCreateCategoryViewState(
      route: SettingsChooseCategoriesForViewScreen.route,
      draft: const CategoryViewDraft(),
    );
  }

  final CategoryViewDraft draft;
}

class SettingsCreateCategoryViewFlow
    extends FlowManager<SettingsCreateCategoryViewState, CreateCategoryViewStep> {
  SettingsCreateCategoryViewFlow({
    required InsertCategoryView insertCategoryView,
    required Settings settings,
    required AppReviewService appReviewService,
  }) : _appReviewService = appReviewService,
       _settings = settings,
       _insertCategoryView = insertCategoryView,
       super(SettingsCreateCategoryViewState.initial());

  factory SettingsCreateCategoryViewFlow.create() {
    return SettingsCreateCategoryViewFlow(
      insertCategoryView: InsertCategoryView.create(),
      settings: inject(),
      appReviewService: inject(),
    );
  }

  final InsertCategoryView _insertCategoryView;
  final Settings _settings;
  final AppReviewService _appReviewService;

  @override
  void stepComplete(CreateCategoryViewStep step) {
    switch (step) {
      case SelectCategories():
        safeEmit(
          state.copyWith(
            route: SettingsNameNewCategoryViewScreen.route,
            draft: state.draft.copyWith(
              categoryIds: step.categoryIds,
              categoryGroupIds: step.categoryGroupIds,
            ),
          ),
        );
      case SetName():
        safeEmit(state.copyWith(draft: state.draft.copyWith(name: step.name)));
    }
  }

  Future<Result<String, Exception>> save() async {
    if (!state.draft.isValid) {
      return Err(Exception('Category View is invalid or no budget selected'));
    } else {
      final budgetId = await _settings.watchSelectedBudgetId().nextValue();
      final result =
          await _insertCategoryView(
            budgetId: budgetId.unwrap(),
            name: state.draft.name!,
            categoryIds: state.draft.categoryIds!,
            categoryGroupIds: state.draft.categoryGroupIds!,
          ).map((ok) {
            unawaited(_appReviewService.onEvent());
            return ok;
          });
      return result;
    }
  }
}

sealed class CreateCategoryViewStep {
  const CreateCategoryViewStep();
}

class SelectCategories extends CreateCategoryViewStep {
  const SelectCategories({required this.categoryIds, required this.categoryGroupIds});

  final List<String> categoryGroupIds;
  final List<String> categoryIds;
}

class SetName extends CreateCategoryViewStep {
  const SetName({required this.name});

  final String name;
}
