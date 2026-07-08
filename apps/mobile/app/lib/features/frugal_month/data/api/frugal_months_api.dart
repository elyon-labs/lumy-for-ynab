import 'package:oxidized/oxidized.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:time_machine/time_machine.dart';

import '../../../../app/di.dart';
import 'models/frugal_month_from_backend.dart';
import 'models/insert_frugal_month_request.dart';

class FrugalMonthsApi {
  const FrugalMonthsApi({required SupabaseClient client}) : _client = client;

  factory FrugalMonthsApi.create() {
    return FrugalMonthsApi(client: inject());
  }

  final SupabaseClient _client;

  Future<List<JoinedFrugalMonthFromBackend>> fetchFrugalMonths() async {
    final data = await _client
        .from('v_user_frugal_months')
        .select('*')
        .order('month', ascending: false);
    return data.map(JoinedFrugalMonthFromBackendMapper.fromMap).toList();
  }

  Future<Result<String, Exception>> insertFrugalMonth({
    required String userId,
    required String budgetId,
    required LocalDate month,
    required int targetAmount,
    required List<String> categoryIds,
    required List<String> accountIds,
  }) async {
    return Result.asyncOf(() async {
      final request = InsertFrugalMonthRequest(
        userId: userId,
        budgetId: budgetId,
        month: month,
        targetAmount: targetAmount,
        categoryIds: categoryIds,
        accountIds: accountIds,
      );

      final response = await _client.functions.invoke('insert-frugal-month', body: request.toMap());

      // ignore: avoid_dynamic_calls
      if (response.data == null || response.data['error'] != null) {
        throw Exception(
          // ignore: avoid_dynamic_calls
          'Failed to insert frugal month: ${response.data?['error'] ?? 'Unknown error'}',
        );
      }

      // ignore: avoid_dynamic_calls
      return response.data['id'] as String;
    });
  }

  Future<Result<void, Exception>> deleteFrugalMonth(String frugalMonthId) async {
    return Result.asyncOf(() async {
      await _client.from('frugal_months').delete().eq('id', frugalMonthId);
    });
  }
}
