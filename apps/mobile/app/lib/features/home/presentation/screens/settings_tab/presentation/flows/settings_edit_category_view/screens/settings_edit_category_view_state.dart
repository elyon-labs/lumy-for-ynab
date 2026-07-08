import 'package:dart_foundation/dart_foundation.dart';

import '../../../../../../../../category_views/domain/models/category_view.dart';

class SettingsEditCategoryViewState {
  SettingsEditCategoryViewState({required this.categoryView});

  factory SettingsEditCategoryViewState.initial() {
    return SettingsEditCategoryViewState(categoryView: const Loading());
  }

  final Async<CategoryView> categoryView;
}
