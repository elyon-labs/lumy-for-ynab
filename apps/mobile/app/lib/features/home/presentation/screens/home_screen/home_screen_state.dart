import 'package:dart_foundation/dart_foundation.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:oxidized/oxidized.dart';

part 'home_screen_state.mapper.dart';

@MappableClass()
class HomeScreenState with HomeScreenStateMappable {
  HomeScreenState({required this.budgetId, required this.hasUnsyncedData});

  factory HomeScreenState.initial() {
    return HomeScreenState(budgetId: const Loading(), hasUnsyncedData: false);
  }

  final Async<Option<String>> budgetId;
  final bool hasUnsyncedData;
}
