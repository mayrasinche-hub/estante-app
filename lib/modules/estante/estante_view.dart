import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/models/libro.dart';
import '../../data/repositories/libros_repositorio.dart';
import '../auth/auth_controller.dart';

class EstanteView extends StatelessWidget {
  const EstanteView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estante'),
        actions: [
          IconButton(
            tooltip: 'Cerrar sesión',
            icon: const Icon(Icons.logout),
            onPressed: Get.find<AuthController>().cerrarSesion,
          ),
        ],
      ),
      body: FutureBuilder<List<Libro>>(
        future: Get.find<LibrosRepositorio>().listar(),
        builder: (context, s) {
          if (s.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (s.hasError) {
            return Center(child: Text(s.error.toString()));
          }
          final libros = s.data!;
          if (libros.isEmpty) {
            return const Center(child: Text('Sesión iniciada. Tu estante está vacío.'));
          }
          return ListView(
            children: [
              for (final l in libros)
                ListTile(title: Text(l.titulo), subtitle: Text('${l.autor} · ${l.estado.api}')),
            ],
          );
        },
      ),
    );
  }
}