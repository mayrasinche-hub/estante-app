import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SesionStorage {
  SesionStorage([FlutterSecureStorage? storage])
      : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;
  static const _claveToken = 'token';

  Future<String?> leerToken() => _storage.read(key: _claveToken);

  Future<void> guardarToken(String token) =>
      _storage.write(key: _claveToken, value: token);

  Future<void> borrarToken() => _storage.delete(key: _claveToken);
}