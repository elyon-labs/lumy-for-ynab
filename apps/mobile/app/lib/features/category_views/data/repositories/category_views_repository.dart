import 'dart:async';

import 'package:oxidized/oxidized.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../app/di.dart';
import '../../../auth/data/api/auth_api.dart';
import '../../domain/models/category_view.dart';
import '../api/category_views_api.dart';
import '../api/models/category_view_from_backend.dart';

class CategoryViewsRepository {
  CategoryViewsRepository({required CategoryViewsApi api, required AuthApi authApi})
    : _api = api,
      _authApi = authApi {
    unawaited(_fetchCategoryViews());
    _subs.add(_authApi.onAuthenticated(refresh));
  }

  factory CategoryViewsRepository.create() {
    return CategoryViewsRepository(api: inject(), authApi: inject());
  }

  final CategoryViewsApi _api;
  final AuthApi _authApi;
  final _subs = CompositeSubscription();

  final _subject = BehaviorSubject<List<CategoryView>>.seeded([]);

  Future<void> _fetchCategoryViews() async {
    final views = await _api.getCategoryViews();
    _subject.add(views.map((view) => view.toDomain()).toList());
  }

  Stream<List<CategoryView>> get watch => _subject.stream;

  Future<void> refresh() async {
    await _fetchCategoryViews();
  }

  Future<Result<String, Exception>> insertCategoryView({
    required String name,
    required String budgetId,
    required List<String> categoryIds,
    required List<String> categoryGroupIds,
  }) async {
    return _authApi.withAuthenticatedUser((user) async {
      return _api.insertCategoryView(
        userId: user.id,
        name: name,
        budgetId: budgetId,
        categoryIds: categoryIds,
        categoryGroupIds: categoryGroupIds,
      );
    });
  }

  Future<Result<String, Exception>> updateCategoryView({
    required String id,
    required String name,
    required List<String> categoryIds,
    required List<String> categoryGroupIds,
  }) async {
    return _authApi.withAuthenticatedUser((user) async {
      return _api.updateCategoryView(
        userId: user.id,
        id: id,
        name: name,
        categoryIds: categoryIds,
        categoryGroupIds: categoryGroupIds,
      );
    });
  }

  Future<Result<void, Exception>> deleteCategoryView(String id) async {
    return _api.deleteCategoryView(id);
  }

  Future<void> dispose() async {
    await _subs.dispose();
    await _subject.close();
  }
}

extension CategoryViewFromBackendX on JoinedCategoryViewFromBackend {
  CategoryView toDomain() {
    return CategoryView(
      id: id,
      name: name,
      budgetId: budgetId,
      categoryIds: categories,
      categoryGroupIds: categoryGroups,
      isDeleted: false,
    );
  }
}
