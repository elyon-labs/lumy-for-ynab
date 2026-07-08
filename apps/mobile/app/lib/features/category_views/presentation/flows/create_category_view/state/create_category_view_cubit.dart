import 'dart:async';

import 'package:dart_foundation/dart_foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oxidized/oxidized.dart';

import '../../../../../../app/di.dart';
import '../../../../../../persistence/settings.dart';
import '../../../../../../utils/_cubit.dart';
import '../../../../../app_review/app_review_service.dart';
import '../../../../domain/models/category_view.dart';
import '../../../../domain/models/category_view_draft.dart';
import '../../../../domain/use_cases/insert_category_view.dart';
import '../../../../domain/use_cases/update_category_view.dart';

class CreateCategoryViewState {
  CreateCategoryViewState({required this.draft});

  factory CreateCategoryViewState.initial() {
    return CreateCategoryViewState(draft: const CategoryViewDraft());
  }

  final CategoryViewDraft draft;
}

class CreateCategoryViewCubit extends Cubit<CreateCategoryViewState> {
  CreateCategoryViewCubit({
    required UpdateCategoryView updateCategoryView,
    required InsertCategoryView insertCategoryView,
    required Settings settings,
    required AppReviewService appReviewService,
  }) : _appReviewService = appReviewService,
       _settings = settings,
       _updateCategoryView = updateCategoryView,
       _insertCategoryView = insertCategoryView,
       super(CreateCategoryViewState.initial());

  factory CreateCategoryViewCubit.create() {
    return CreateCategoryViewCubit(
      updateCategoryView: UpdateCategoryView.create(),
      insertCategoryView: InsertCategoryView.create(),
      settings: inject(),
      appReviewService: inject(),
    );
  }

  final UpdateCategoryView _updateCategoryView;
  final InsertCategoryView _insertCategoryView;
  final Settings _settings;
  final AppReviewService _appReviewService;

  void setSelected({required List<String> categoryIds, required List<String> categoryGroupIds}) {
    safeEmit(
      CreateCategoryViewState(
        draft: state.draft.copyWith(categoryIds: categoryIds, categoryGroupIds: categoryGroupIds),
      ),
    );
  }

  void setName(String name) {
    safeEmit(CreateCategoryViewState(draft: state.draft.copyWith(name: name)));
  }

  void reset() {
    safeEmit(CreateCategoryViewState(draft: const CategoryViewDraft()));
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

  Future<Result<void, Exception>> update(CategoryView view) async {
    if (!state.draft.isValid) {
      return Err(Exception('Category View is invalid or no budget selected'));
    }
    return _updateCategoryView(
      id: view.id,
      name: state.draft.name!,
      categoryIds: state.draft.categoryIds!,
      categoryGroupIds: state.draft.categoryGroupIds!,
    );
  }
}
