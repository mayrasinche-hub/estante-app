import 'package:get/get.dart';

import 'data/api/api_cliente.dart';
import 'data/repositories/auth_repositorio.dart';
import 'data/repositories/libros_repositorio.dart';
import 'data/repositories/libros_repositorio_cache.dart';
import 'data/storage/cache_storage.dart';
import 'data/storage/sellos_storage.dart';
import 'data/storage/sesion_storage.dart';
import 'modules/auth/auth_controller.dart';
import 'routes/rutas.dart';

void registrarDependencias() {
  final sesion = SesionStorage();
  final cache = CacheStorage();
  final cliente = ApiCliente(
    sesion,
    alExpirarSesion: () {
      if (Get.currentRoute != Rutas.acceso) {
        Get.offAllNamed(Rutas.acceso);
      }
    },
  );

  Get.put<AuthRepositorio>(AuthRepositorioApi(cliente, sesion), permanent: true);
  Get.put<LibrosRepositorio>(
    LibrosRepositorioConCache(LibrosRepositorioApi(cliente), cache),
    permanent: true,
  );
  Get.put<RegistroSellos>(SellosStorage(), permanent: true);
  Get.put(AuthController(Get.find<AuthRepositorio>(), cache), permanent: true);
}