import 'package:oxidized/oxidized.dart';

import '../../../../../../../../../category_views/domain/models/category_view.dart';

class ReportsTabCategoryViewButtonState {
  ReportsTabCategoryViewButtonState({
    required this.allViews,
    required this.selected,
    required this.unselectedViews,
  });

  factory ReportsTabCategoryViewButtonState.initial() {
    return ReportsTabCategoryViewButtonState(
      allViews: [],
      unselectedViews: [],
      selected: const None(),
    );
  }

  final List<CategoryView> allViews;
  final List<CategoryView> unselectedViews;
  final Option<CategoryView> selected;
}
