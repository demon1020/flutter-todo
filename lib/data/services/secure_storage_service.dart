import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class SecureStorageService<T> {
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  Future<void> setItem(String key, T value) async {
    await _secureStorage.write(key: key, value: value.toString());
  }

  Future<T?> getItem(String key) async {
    final String? value = await _secureStorage.read(key: key);
    if (value != null) {
      return _parseValue(value);
    }
    return null;
  }

  Future<void> deleteItem(String key) async {
    await _secureStorage.delete(key: key);
  }

  T _parseValue(String value) {
    throw UnimplementedError("Implement this in a subclass");
  }
}

class StringSecureStorageService extends SecureStorageService<String> {
  @override
  String _parseValue(String value) {
    return value;
  }
}

class IntSecureStorageService extends SecureStorageService<int> {
  @override
  int _parseValue(String value) {
    return int.parse(value);
  }
}

class DoubleSecureStorageService extends SecureStorageService<double> {
  @override
  double _parseValue(String value) {
    return double.parse(value);
  }
}

class BoolSecureStorageService extends SecureStorageService<bool> {
  @override
  bool _parseValue(String value) {
    return value.toLowerCase() == 'true';
  }
}

void main() async {
  final stringStorage = StringSecureStorageService();
  await stringStorage.setItem('name', 'John');
  final name = await stringStorage.getItem('name');
  print('Name: $name'); // Output: Name: John

  final intStorage = IntSecureStorageService();
  await intStorage.setItem('age', 30);
  final age = await intStorage.getItem('age');
  print('Age: $age'); // Output: Age: 30
}
