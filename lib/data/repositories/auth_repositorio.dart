import 'package:dio/dio.dart';

import '../api/api_cliente.dart';
import '../api/api_error.dart';
import '../storage/sesion_storage.dart';

abstract class AuthRepositorio {
  Future<void> registrar(String email, String password);
  Future<void> iniciarSesion(String email, String password);
  Future<bool> haySesion();
  Future<void> cerrarSesion();
}

class AuthRepositorioApi implements AuthRepositorio {
  AuthRepositorioApi(this._cliente, this._sesion);

  final ApiCliente _cliente;
  final SesionStorage _sesion;

  @override
  Future<void> registrar(String email, String password) async {
    try {
      await _cliente.dio.post(
        '/usuarios/',
        data: {'email': email, 'password': password},
      );
    } catch (e) {
      throw ApiError.desde(e);
    }
  }

  @override
  Future<void> iniciarSesion(String email, String password) async {
    try {
      final respuesta = await _cliente.dio.post(
        '/usuarios/token',
        data: {'username': email, 'password': password},
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );
      await _sesion.guardarToken(respuesta.data['access_token'] as String);
    } catch (e) {
      throw ApiError.desde(e);
    }
  }

  @override
  Future<bool> haySesion() async => await _sesion.leerToken() != null;

  @override
  Future<void> cerrarSesion() => _sesion.borrarToken();
}