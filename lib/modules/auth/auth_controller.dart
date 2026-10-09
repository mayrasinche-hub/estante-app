import 'package:get/get.dart';

import '../../data/api/api_error.dart';
import '../../data/repositories/auth_repositorio.dart';
import '../../data/storage/cache_storage.dart';
import '../../routes/rutas.dart';

class AuthController extends GetxController {
  AuthController(this._repo, this._cache);

  final AuthRepositorio _repo;
  final CacheStorage _cache;

  final modoRegistro = false.obs;
  final cargando = false.obs;
  final ocultarClave = true.obs;
  final error = RxnString();

  void alternarModo() {
    modoRegistro.toggle();
    error.value = null;
  }

  String? validarEmail(String? valor) {
    final texto = valor?.trim() ?? '';
    if (texto.isEmpty) {
      return 'Escribe tu correo';
    }
    if (!texto.contains('@') || !texto.contains('.')) {
      return 'Ese correo no parece válido';
    }
    return null;
  }

  String? validarClave(String? valor) {
    final texto = valor ?? '';
    if (texto.isEmpty) {
      return 'Escribe tu contraseña';
    }
    if (modoRegistro.value && texto.length < 6) {
      return 'Usa al menos 6 caracteres';
    }
    return null;
  }

  Future<void> enviar(String email, String clave) async {
    cargando.value = true;
    error.value = null;
    try {
      if (modoRegistro.value) {
        await _repo.registrar(email.trim(), clave);
      }
      await _repo.iniciarSesion(email.trim(), clave);
      Get.offAllNamed(Rutas.estante);
    } on ApiError catch (e) {
      error.value = _mensaje(e);
    } finally {
      cargando.value = false;
    }
  }

  Future<void> cerrarSesion() async {
    await _repo.cerrarSesion();
    await _cache.limpiar();
    Get.offAllNamed(Rutas.acceso);
  }

  String _mensaje(ApiError e) {
    if (e.sinConexion) {
      return 'No pudimos conectar con el servidor. Revisa que el backend esté encendido.';
    }
    if (e.codigo == 401) {
      return 'Correo o contraseña incorrectos.';
    }
    return e.mensaje;
  }
}