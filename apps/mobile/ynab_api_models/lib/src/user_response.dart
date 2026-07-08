import 'package:dart_mappable/dart_mappable.dart';
import 'package:equatable/equatable.dart';

part 'user_response.mapper.dart';

@MappableClass()
class UserResponse with UserResponseMappable {
  const UserResponse({required this.data});

  final UserData data;
}

@MappableClass()
class UserData with UserDataMappable {
  const UserData({required this.user});

  final User user;
}

@MappableClass()
class User extends Equatable with UserMappable {
  const User({required this.id});

  final String id;

  @override
  List<Object?> get props => [id];
}
