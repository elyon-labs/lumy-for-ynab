import 'package:oxidized/oxidized.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../app/di.dart';
import '../../domain/models/transaction_conditions.dart';
import '../models/delete_spend_tracker_request.dart';
import '../models/insert_spend_tracker_request.dart';
import '../models/spend_tracker_condition_from_backend.dart';
import '../models/update_spend_tracker_request.dart';

class SpendTrackersApi {
  SpendTrackersApi({required SupabaseClient client}) : _client = client;

  factory SpendTrackersApi.create() {
    return SpendTrackersApi(client: inject());
  }

  final SupabaseClient _client;

  Future<List<SpendTrackerConditionFromBackend>> fetchSpendTrackers() async {
    final rows = await _client.from('v_spend_tracker_conditions_flat').select('*');
    return rows.map(SpendTrackerConditionFromBackendMapper.fromMap).toList();
  }

  Future<Result<String, Exception>> insertSpendTracker({
    required String userId,
    required String budgetId,
    required TransactionCondition condition,
    required String name,
    // Below are only for migration purposes
    String? nickName,
    DateTime? createdAt,
  }) async {
    return Result.asyncOf(() async {
      final request = InsertSpendTrackerRequest(
        userId: userId,
        budgetId: budgetId,
        condition: condition,
        name: name,
        nickName: nickName,
        createdAt: createdAt,
      );

      final response = await _client.functions.invoke(
        'insert-spend-tracker',
        body: request.toMap(),
      );

      // ignore: avoid_dynamic_calls
      if (response.data == null || response.data['error'] != null) {
        throw Exception(
          // ignore: avoid_dynamic_calls
          'Failed to insert spend tracker: ${response.data?['error'] ?? 'Unknown error'}',
        );
      }

      // ignore: avoid_dynamic_calls
      return response.data['id'] as String;
    });
  }

  Future<Result<void, Exception>> updateSpendTracker(
    String spendTrackerId, {
    required String userId,
    required TransactionCondition condition,
  }) async {
    return Result.asyncOf(() async {
      final request = UpdateSpendTrackerRequest(
        spendTrackerId: spendTrackerId,
        userId: userId,
        condition: condition,
      );

      final response = await _client.functions.invoke(
        'update-spend-tracker',
        body: request.toMap(),
      );

      // ignore: avoid_dynamic_calls
      if (response.data == null || response.data['error'] != null) {
        throw Exception(
          // ignore: avoid_dynamic_calls
          'Failed to update spend tracker: ${response.data?['error'] ?? 'Unknown error'}',
        );
      }
    });
  }

  Future<Result<void, Exception>> deleteSpendTracker(
    String spendTrackerId, {
    required String userId,
  }) async {
    return Result.asyncOf(() async {
      final request = DeleteSpendTrackerRequest(spendTrackerId: spendTrackerId, userId: userId);

      final response = await _client.functions.invoke(
        'delete-spend-tracker',
        body: request.toMap(),
      );

      // ignore: avoid_dynamic_calls
      if (response.data == null || response.data['error'] != null) {
        throw Exception(
          // ignore: avoid_dynamic_calls
          'Failed to delete spend tracker: ${response.data?['error'] ?? 'Unknown error'}',
        );
      }
    });
  }

  Future<Result<void, Exception>> renameSpendTracker(
    String spendTrackerId, {
    required String name,
  }) {
    return Result.asyncOf(() async {
      // TODO: Create a MappableClass for update
      await _client.from('spend_trackers').update({'nickname': name}).eq('id', spendTrackerId);
    });
  }
}
