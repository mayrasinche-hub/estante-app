import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'core/i18n/traducciones.dart';
import 'core/theme/app_theme.dart';
import 'data/repositories/auth_repositorio.dart';
import 'data/repositories/libros_repositorio.dart';
import 'data/storage/preferencias_storage.dart';
import 'data/storage/sellos_storage.dart';
import 'data/ubicacion/ubicacion.dart';
import 'dependencias.dart';
import 'modules/ajustes/ajustes_controller.dart';
import 'modules/auth/acceso_view.dart';
import 'modules/estante/estante_controller.dart';
import 'modules/estante/estante_view.dart';
import 'routes/rutas.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  registrarDependencias();
  final preferencias = PreferenciasStorage();
  Get.put(
    AjustesController(
      preferencias,
      await preferencias.leerTema(),
      await preferencias.leerIdioma(),
    ),
    permanent: true,
  );
  final haySesion = await Get.find<AuthRepositorio>().haySesion();
  runApp(EstanteApp(rutaInicial: haySesion ? Rutas.estante : Rutas.acceso));
}

class EstanteApp extends StatelessWidget {
  const EstanteApp({super.key, required this.rutaInicial});

  final String rutaInicial;

  @override
  Widget build(BuildContext context) {
    final ajustes = Get.find<AjustesController>();
    return GetMaterialApp(
      title: 'Estante',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.claro,
      darkTheme: AppTheme.oscuro,
      themeMode: ajustes.modo.value,
      translations: Traducciones(),
      locale: ajustes.locale,
      fallbackLocale: const Locale('es', 'EC'),
      initialRoute: rutaInicial,
      getPages: [
        GetPage(name: Rutas.acceso, page: () => const AccesoView()),
        GetPage(
          name: Rutas.estante,
          page: () => const EstanteView(),
          binding: BindingsBuilder(() {
            Get.put(
              EstanteController(
                Get.find<LibrosRepositorio>(),
                Get.find<RegistroSellos>(),
                UbicacionGps(),
              ),
            );
          }),
        ),
      ],
    );
  }
}
