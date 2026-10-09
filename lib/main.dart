import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'core/theme/app_theme.dart';
import 'core/theme/app_tokens.dart';
import 'core/widgets/lomo_libro.dart';

void main() => runApp(const EstanteApp());

class EstanteApp extends StatelessWidget {
  const EstanteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Estante',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.claro,
      darkTheme: AppTheme.oscuro,
      themeMode: ThemeMode.light,
      home: const VistaPrevia(),
    );
  }
}

class VistaPrevia extends StatelessWidget {
  const VistaPrevia({super.key});

  static const _muestra = [
    ('Cien años de soledad', 'Gabriel García Márquez'),
    ('Huasipungo', 'Jorge Icaza'),
    ('Rayuela', 'Julio Cortázar'),
    ('A la Costa', 'Luis A. Martínez'),
    ('Pedro Páramo', 'Juan Rulfo'),
    ('Ficciones', 'Jorge Luis Borges'),
    ('La casa de los espíritus', 'Isabel Allende'),
  ];

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final oscuro = tema.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Estante'),
        actions: [
          IconButton(
            tooltip: 'Cambiar tema',
            icon: Icon(oscuro ? Icons.light_mode_outlined : Icons.dark_mode_outlined),
            onPressed: () => Get.changeThemeMode(oscuro ? ThemeMode.light : ThemeMode.dark),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Text('tu biblioteca,\na tu ritmo', style: tema.textTheme.displaySmall),
          const SizedBox(height: AppSpacing.xl),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (final (titulo, autor) in _muestra) LomoLibro(titulo: titulo, autor: autor),
              ],
            ),
          ),
          Container(
            height: 10,
            decoration: BoxDecoration(
              color: AppColors.madera,
              borderRadius: BorderRadius.circular(2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          const TextField(decoration: InputDecoration(labelText: 'Título del libro')),
          const SizedBox(height: AppSpacing.md),
          FilledButton(onPressed: () {}, child: const Text('Agregar al estante')),
          const SizedBox(height: AppSpacing.sm),
          OutlinedButton(onPressed: () {}, child: const Text('Ver mis lecturas')),
        ],
      ),
    );
  }
}