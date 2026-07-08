import 'package:shared_preferences/shared_preferences.dart';

class FakeSharedPreferences implements SharedPreferences {
  FakeSharedPreferences([Map<String, Object?> initialData = const {}])
    : _map = Map.from(initialData);

  final Map<String, Object?> _map;

  @override
  Future<bool> clear() {
    _map.clear();
    return Future.value(true);
  }

  @override
  Future<bool> commit() {
    return Future.value(true);
  }

  @override
  bool containsKey(String key) {
    return _map.containsKey(key);
  }

  @override
  Object? get(String key) {
    return _map[key];
  }

  @override
  bool? getBool(String key) {
    return _map[key] as bool?;
  }

  @override
  double? getDouble(String key) {
    return _map[key] as double?;
  }

  @override
  int? getInt(String key) {
    return _map[key] as int?;
  }

  @override
  Set<String> getKeys() {
    return _map.keys.toSet();
  }

  @override
  String? getString(String key) {
    return _map[key] as String?;
  }

  @override
  List<String>? getStringList(String key) {
    return _map[key] as List<String>?;
  }

  @override
  Future<void> reload() {
    return Future.value();
  }

  @override
  Future<bool> remove(String key) {
    _map.remove(key);
    return Future.value(true);
  }

  @override
  Future<bool> setBool(String key, bool value) {
    _map[key] = value;
    return Future.value(true);
  }

  @override
  Future<bool> setDouble(String key, double value) {
    _map[key] = value;
    return Future.value(true);
  }

  @override
  Future<bool> setInt(String key, int value) {
    _map[key] = value;
    return Future.value(true);
  }

  @override
  Future<bool> setString(String key, String value) {
    _map[key] = value;
    return Future.value(true);
  }

  @override
  Future<bool> setStringList(String key, List<String> value) {
    _map[key] = value;
    return Future.value(true);
  }
}
