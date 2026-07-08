import 'package:package_info_plus/package_info_plus.dart';

// ignore: avoid_implementing_value_types
class FakePackageInfo implements PackageInfo {
  @override
  String get appName => throw UnimplementedError();

  @override
  String get buildNumber => throw UnimplementedError();

  @override
  String get buildSignature => throw UnimplementedError();

  @override
  Map<String, dynamic> get data => throw UnimplementedError();

  @override
  String? get installerStore => throw UnimplementedError();

  @override
  String get packageName => throw UnimplementedError();

  @override
  String get version => throw UnimplementedError();

  @override
  DateTime? get installTime => throw UnimplementedError();

  @override
  DateTime? get updateTime => throw UnimplementedError();
}
