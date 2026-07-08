import 'package:dart_foundation/dart_foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ynab_api_models/ynab_api_models.dart';

import '../../../app/di.dart';
import '../../../external/_async_snapshot.dart';
import 'categories_repository.dart';
import 'categories_view.dart';

Async<List<Category>> useCategories({CategoriesView view = const AllCategories()}) {
  final repo = useMemoized(inject<CategoriesRepository>);
  final stream = useMemoized(() => repo.watchCategories(view), [view]);
  final value = useStream(stream);
  return value.toAsync();
}
