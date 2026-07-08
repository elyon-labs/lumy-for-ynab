import 'package:dart_mappable/dart_mappable.dart';

part 'upsert_user.mapper.dart';

@MappableClass(ignoreNull: true)
class UpsertUser with UpsertUserMappable {
  UpsertUser({required this.id, required this.ynabUserId, required this.email});

  final String id;
  final String? ynabUserId;
  final String? email;
}
