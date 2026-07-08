import 'package:dart_mappable/dart_mappable.dart';

part 'ynab_api_error.mapper.dart';

@MappableClass(discriminatorKey: 'id')
abstract class YnabApiError with YnabApiErrorMappable {
  YnabApiError({required this.id, required this.name, required this.detail});

  final String id;
  final String name;
  final String detail;
}

@MappableClass(discriminatorValue: '400')
class BadRequest extends YnabApiError with BadRequestMappable {
  BadRequest({required super.id, required super.name, required super.detail});
}

@MappableClass(discriminatorValue: '401')
class NotAuthorized extends YnabApiError with NotAuthorizedMappable {
  NotAuthorized({required super.id, required super.name, required super.detail});
}

@MappableClass(discriminatorValue: '403.1')
class SubscriptionLapsed extends YnabApiError with SubscriptionLapsedMappable {
  SubscriptionLapsed({required super.id, required super.name, required super.detail});
}

@MappableClass(discriminatorValue: '403.2')
class TrialExpired extends YnabApiError with TrialExpiredMappable {
  TrialExpired({required super.id, required super.name, required super.detail});
}

@MappableClass(discriminatorValue: '403.3')
class UnauthorizedScope extends YnabApiError with UnauthorizedScopeMappable {
  UnauthorizedScope({required super.id, required super.name, required super.detail});
}

@MappableClass(discriminatorValue: '403.4')
class DataLimitReached extends YnabApiError with DataLimitReachedMappable {
  DataLimitReached({required super.id, required super.name, required super.detail});
}

@MappableClass(discriminatorValue: '404.1')
class NotFound extends YnabApiError with NotFoundMappable {
  NotFound({required super.id, required super.name, required super.detail});
}

@MappableClass(discriminatorValue: '404.2')
class ResourceNotFound extends YnabApiError with ResourceNotFoundMappable {
  ResourceNotFound({required super.id, required super.name, required super.detail});
}

@MappableClass(discriminatorValue: '409')
class Conflict extends YnabApiError with ConflictMappable {
  Conflict({required super.id, required super.name, required super.detail});
}

@MappableClass(discriminatorValue: '429')
class TooManyRequests extends YnabApiError with TooManyRequestsMappable {
  TooManyRequests({required super.id, required super.name, required super.detail});
}

@MappableClass(discriminatorValue: '500')
class InternalServerError extends YnabApiError with InternalServerErrorMappable {
  InternalServerError({required super.id, required super.name, required super.detail});
}

@MappableClass(discriminatorValue: '503')
class ServiceUnavailable extends YnabApiError with ServiceUnavailableMappable {
  ServiceUnavailable({required super.id, required super.name, required super.detail});
}
