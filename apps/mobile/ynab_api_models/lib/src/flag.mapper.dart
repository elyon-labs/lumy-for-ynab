// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'flag.dart';

class FlagMapper extends EnumMapper<Flag> {
  FlagMapper._();

  static FlagMapper? _instance;
  static FlagMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FlagMapper._());
    }
    return _instance!;
  }

  static Flag fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  Flag decode(dynamic value) {
    switch (value) {
      case 'red':
        return Flag.red;
      case 'orange':
        return Flag.orange;
      case 'yellow':
        return Flag.yellow;
      case 'green':
        return Flag.green;
      case 'blue':
        return Flag.blue;
      case 'purple':
        return Flag.purple;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(Flag self) {
    switch (self) {
      case Flag.red:
        return 'red';
      case Flag.orange:
        return 'orange';
      case Flag.yellow:
        return 'yellow';
      case Flag.green:
        return 'green';
      case Flag.blue:
        return 'blue';
      case Flag.purple:
        return 'purple';
    }
  }
}

extension FlagMapperExtension on Flag {
  String toValue() {
    FlagMapper.ensureInitialized();
    return MapperContainer.globals.toValue<Flag>(this) as String;
  }
}
