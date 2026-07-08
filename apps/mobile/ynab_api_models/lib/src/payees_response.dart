import 'package:dart_foundation/dart_foundation.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:equatable/equatable.dart';

part 'payees_response.mapper.dart';

@MappableClass()
class PayeesResponse with PayeesResponseMappable {
  const PayeesResponse({required this.data});

  final Payees data;
}

@MappableClass()
class Payees with PayeesMappable {
  const Payees({required this.serverKnowledge, required this.payees});

  @MappableField(key: 'server_knowledge')
  final int serverKnowledge;
  final List<Payee> payees;
}

@MappableClass()
class Payee extends Equatable with Searchable, PayeeMappable {
  const Payee({required this.id, required this.name, required this.isDeleted});

  final String id;
  final String name;
  @MappableField(key: 'deleted')
  final bool isDeleted;

  @override
  List<Object?> get props => [id, name, isDeleted];

  @override
  String get searchKey => name;
}
