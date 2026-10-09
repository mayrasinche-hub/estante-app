import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'core/theme/app_theme.dart';
import 'data/repositories/auth_repositorio.dart';
import 'dependencias.dart';
import 'modules/auth/acceso_view.dart';
import 'modules/estante/estante_view.dart';
import 'routes/rutas.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  registrarDependencias();
  final haySesion = await Get.find<AuthRepositorio>().haySesion();
  runApp(EstanteApp(rutaInicial: haySesion ? Rutas.estante : Rutas.acceso));
}

class EstanteApp extends StatelessWidget {
  const EstanteApp({super.key, required this.rutaInicial});

  final String rutaInicial;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Estante',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.claro,
      darkTheme: AppTheme.oscuro,
      themeMode: ThemeMode.system,
      initialRoute: rutaInicial,
      getPages: [
        GetPage(name: Rutas.acceso, page: () => const AccesoView()),
        GetPage(name: Rutas.estante, page: () => const EstanteView()),
      ],
    );
  }
}