import 'package:dart_foundation/dart_foundation.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'write_access_screen_state.mapper.dart';

@MappableClass()
class WriteAccessScreenState with WriteAccessScreenStateMappable {
  WriteAccessScreenState({required this.accessRequest});

  factory WriteAccessScreenState.initial() {
    return WriteAccessScreenState(accessRequest: const Idle());
  }

  final Async<bool> accessRequest;
}
