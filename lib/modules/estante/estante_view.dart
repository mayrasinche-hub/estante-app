import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/app_tokens.dart';
import '../../core/widgets/lomo_libro.dart';
import '../../data/models/libro.dart';
import '../auth/auth_controller.dart';
import 'agregar_libro_sheet.dart';
import 'estante_controller.dart';

class EstanteView extends GetView<EstanteController> {
  const EstanteView({super.key});

  static const _repisas = {
    EstadoLibro.porLeer: 'En espera',
    EstadoLibro.leyendo: 'Abiertos',
    EstadoLibro.leido: 'Terminados',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Obx(
        () => controller.estado.value == Carga.exito
            ? FloatingActionButton.extended(
                onPressed: () => abrirAgregarLibro(context),
                icon: const Icon(Icons.add),
                label: const Text('Agregar libro'),
              )
            : const SizedBox.shrink(),
      ),
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
      body: SafeArea(
        child: Obx(
          () => switch (controller.estado.value) {
            Carga.cargando => const _Esqueleto(),
            Carga.error => _Error(
                mensaje: controller.mensajeError.value,
                alReintentar: controller.cargar,
              ),
            Carga.exito => _contenido(context),
          },
        ),
      ),
    );
  }

  Widget _contenido(BuildContext context) {
    final tema = Theme.of(context);
    final libros = controller.libros;
    return RefreshIndicator(
      onRefresh: controller.cargar,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.sm, AppSpacing.lg, 96),
            children: [
              if (controller.sinConexion.value) const _AvisoSinConexion(),
              Text(
                _resumen(libros.length),
                style: tema.textTheme.bodyLarge?.copyWith(
                  color: tema.colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              if (libros.isEmpty)
                const _EstanteVacio()
              else
                for (final e in EstadoLibro.values)
                  _Repisa(titulo: _repisas[e]!, libros: controller.de(e)),
            ],
          ),
        ),
      ),
    );
  }

  String _resumen(int n) => switch (n) {
        0 => 'Empecemos tu biblioteca.',
        1 => '1 libro en tu biblioteca.',
        _ => '$n libros en tu biblioteca.',
      };
}

class _Repisa extends StatelessWidget {
  const _Repisa({required this.titulo, required this.libros});

  final String titulo;
  final List<Libro> libros;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(titulo, style: tema.textTheme.titleLarge),
              const SizedBox(width: AppSpacing.sm),
              _Contador(n: libros.length),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          if (libros.isEmpty)
            SizedBox(
              height: 72,
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: Text(
                    'Nada por aquí todavía.',
                    style: tema.textTheme.bodyMedium?.copyWith(
                      color: tema.colorScheme.onSurface.withValues(alpha: 0.55),
                    ),
                  ),
                ),
              ),
            )
          else
            SizedBox(
              height: 196,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  for (final l in libros)
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: LomoLibro(titulo: l.titulo, autor: l.autor),
                    ),
                ],
              ),
            ),
          const _Tabla(),
        ],
      ),
    );
  }
}

class _Tabla extends StatelessWidget {
  const _Tabla({this.ancho});

  final double? ancho;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 10,
      width: ancho,
      decoration: BoxDecoration(
        color: AppColors.madera,
        borderRadius: BorderRadius.circular(2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 4,
            offset: const Offset(0, 3),
          ),
        ],
      ),
    );
  }
}

class _Contador extends StatelessWidget {
  const _Contador({required this.n});

  final int n;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return Semantics(
      label: '$n libros',
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 2),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(99),
        ),
        child: Text(
          '$n',
          style: TextStyle(color: color, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class _EstanteVacio extends StatelessWidget {
  const _EstanteVacio();

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Column(
      children: [
        const SizedBox(height: AppSpacing.lg),
        SizedBox(
          height: 200,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ExcludeSemantics(
                child: Transform.rotate(
                  angle: -0.18,
                  alignment: Alignment.bottomRight,
                  child: const LomoLibro(titulo: 'Tu primer libro', autor: ''),
                ),
              ),
            ],
          ),
        ),
        const _Tabla(ancho: 200),
        const SizedBox(height: AppSpacing.lg),
        Text(
          'Tu estante está esperando\nsu primer libro.',
          textAlign: TextAlign.center,
          style: tema.textTheme.headlineSmall,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Toca «Agregar libro» para empezar.',
          style: tema.textTheme.bodyMedium?.copyWith(
            color: tema.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
}

class _AvisoSinConexion extends StatelessWidget {
  const _AvisoSinConexion();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.ocre.withValues(alpha: 0.22),
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: const Row(
          children: [
            Icon(Icons.cloud_off_outlined),
            SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text('Sin conexión. Te mostramos tu último estante guardado.'),
            ),
          ],
        ),
      ),
    );
  }
}

class _Esqueleto extends StatelessWidget {
  const _Esqueleto();

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.07);
    return Semantics(
      label: 'Cargando tu estante',
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          for (var r = 0; r < 3; r++) ...[
            Container(
              width: 110,
              height: 18,
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(4)),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (var i = 0; i < 6; i++)
                  Container(
                    width: 34.0 + (i % 3) * 6,
                    height: 120.0 + (i * 17 % 40),
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(3)),
                  ),
              ],
            ),
            Container(height: 10, color: c),
            const SizedBox(height: AppSpacing.xl),
          ],
        ],
      ),
    );
  }
}

class _Error extends StatelessWidget {
  const _Error({required this.mensaje, required this.alReintentar});

  final String mensaje;
  final Future<void> Function() alReintentar;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 320),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(Icons.cloud_off_outlined, size: 48, color: tema.colorScheme.primary),
              const SizedBox(height: AppSpacing.md),
              Text(mensaje, textAlign: TextAlign.center, style: tema.textTheme.titleMedium),
              const SizedBox(height: AppSpacing.lg),
              FilledButton(onPressed: alReintentar, child: const Text('Reintentar')),
            ],
          ),
        ),
      ),
    );
  }
}