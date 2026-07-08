import 'package:dart_mappable/dart_mappable.dart';

part 'delete_spend_tracker_request.mapper.dart';

@MappableClass()
class DeleteSpendTrackerRequest with DeleteSpendTrackerRequestMappable {
  DeleteSpendTrackerRequest({required this.spendTrackerId, required this.userId});

  final String spendTrackerId;
  final String userId;
}
