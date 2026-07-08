import 'package:oxidized/oxidized.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../app/di.dart';
import 'models/category_view_from_backend.dart';
import 'models/insert_category_view_request.dart';
import 'models/update_category_view_request.dart';

class CategoryViewsApi {
  CategoryViewsApi({required SupabaseClient client}) : _client = client;

  factory CategoryViewsApi.create() {
    return CategoryViewsApi(client: inject());
  }

  final SupabaseClient _client;

  Future<List<JoinedCategoryViewFromBackend>> getCategoryViews() async {
    final data = await _client.from('v_user_category_views').select('*');

    return data.map(JoinedCategoryViewFromBackendMapper.fromMap).toList();
  }

  Future<Result<String, Exception>> insertCategoryView({
    required String userId,
    required String name,
    required String budgetId,
    required List<String> categoryIds,
    required List<String> categoryGroupIds,
  }) async {
    return Result.asyncOf(() async {
      final request = InsertCategoryViewRequest(
        userId: userId,
        name: name,
        budgetId: budgetId,
        categoryIds: categoryIds,
        categoryGroupIds: categoryGroupIds,
      );

      final response = await _client.functions.invoke(
        'insert-category-view',
        body: request.toMap(),
      );

      // ignore: avoid_dynamic_calls
      if (response.data == null || response.data['error'] != null) {
        throw Exception(
          // ignore: avoid_dynamic_calls
          'Failed to insert category view: ${response.data?['error'] ?? 'Unknown error'}',
        );
      }

      // ignore: avoid_dynamic_calls
      return response.data['id'] as String;
    });
  }

  Future<Result<String, Exception>> updateCategoryView({
    required String userId,
    required String id,
    required String name,
    required List<String> categoryIds,
    required List<String> categoryGroupIds,
  }) async {
    return Result.asyncOf(() async {
      final request = UpdateCategoryViewRequest(
        userId: userId,
        id: id,
        name: name,
        categoryIds: categoryIds,
        categoryGroupIds: categoryGroupIds,
      );

      final response = await _client.functions.invoke(
        'update-category-view',
        body: request.toMap(),
      );

      // ignore: avoid_dynamic_calls
      if (response.data == null || response.data['error'] != null) {
        throw Exception(
          // ignore: avoid_dynamic_calls
          'Failed to update category view: ${response.data?['error'] ?? 'Unknown error'}',
        );
      }

      // ignore: avoid_dynamic_calls
      return response.data['id'] as String;
    });
  }

  Future<Result<void, Exception>> deleteCategoryView(String id) async {
    return Result.asyncOf(() async {
      await _client.from('category_views').delete().eq('id', id);
    });
  }
}
