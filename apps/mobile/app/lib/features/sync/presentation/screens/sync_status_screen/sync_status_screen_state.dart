import 'package:dart_foundation/dart_foundation.dart';
import 'package:dart_mappable/dart_mappable.dart';

import '../../../../auth/domain/models/user.dart';

part 'sync_status_screen_state.mapper.dart';

@MappableClass()
class SyncStatusScreenState with SyncStatusScreenStateMappable {
  SyncStatusScreenState({
    required this.user,
    required this.hasUnsyncedData,
    required this.hasSyncedData,
  });

  factory SyncStatusScreenState.initial() {
    return SyncStatusScreenState(
      user: const Loading(),
      hasUnsyncedData: false,
      hasSyncedData: false,
    );
  }

  final Async<User> user;
  final bool hasUnsyncedData;
  final bool hasSyncedData;
}
