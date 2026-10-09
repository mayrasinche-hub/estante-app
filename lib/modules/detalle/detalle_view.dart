import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/app_tokens.dart';
import '../../core/theme/paleta_lomo.dart';
import '../../core/widgets/lomo_libro.dart';
import '../../core/widgets/marcapaginas.dart';
import '../../core/widgets/sello_leido.dart';
import '../../data/models/libro.dart';
import '../estante/estante_controller.dart';

class DetalleView extends StatelessWidget {
  const DetalleView({super.key, required this.libroId});

  final int libroId;

  @override
  Widget build(BuildContext context) {
    final c = Get.find<EstanteController>();
    return Obx(() {
      final libro = c.porId(libroId);
      if (libro == null) {
        return const Scaffold();
      }
      final tema = Theme.of(context);
      final color = PaletaLomo.color(libro.titulo);
      final sello = c.sellos[libro.id];

      return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              tooltip: 'Quitar del estante',
              icon: const Icon(Icons.delete_outline),
              onPressed: c.guardando.value ? null : () => _confirmarEliminar(context, c, libro),
            ),
          ],
        ),
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.xl),
                children: [
                  Center(
                    child: Hero(
                      tag: 'lomo-${libro.id}',
                      child: LomoLibro(titulo: libro.titulo, autor: libro.autor, escala: 1.25),
                    ),
                  ),
                  Center(
                    child: Container(
                      width: 140,
                      height: 10,
                      decoration: BoxDecoration(
                        color: AppColors.madera,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Text(libro.titulo, textAlign: TextAlign.center, style: tema.textTheme.headlineMedium),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    libro.autor,
                    textAlign: TextAlign.center,
                    style: tema.textTheme.bodyLarge?.copyWith(
                      color: tema.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  _Recorrido(estado: libro.estado, color: color),
                  const SizedBox(height: AppSpacing.xl),
                  if (libro.estado == EstadoLibro.leido)
                    Center(
                      child: SelloLeido(
                        fecha: sello?.fecha,
                        animar: c.ultimoSellado.value == libro.id,
                      ),
                    )
                  else
                    Marcapaginas(
                      key: ValueKey(libro.estado),
                      texto: libro.estado == EstadoLibro.porLeer
                          ? 'Desliza para empezar a leer'
                          : 'Desliza cuando lo termines',
                      color: color,
                      ocupado: c.guardando.value,
                      alCompletar: () async {
                        final error = await c.avanzar(libro);
                        if (error != null && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
                        }
                      },
                    ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Future<void> _confirmarEliminar(BuildContext context, EstanteController c, Libro libro) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (dialogo) => AlertDialog(
        title: const Text('¿Quitar este libro?'),
        content: Text('«${libro.titulo}» saldrá de tu estante. No se puede deshacer.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogo, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogo, true),
            style: TextButton.styleFrom(foregroundColor: Theme.of(dialogo).colorScheme.error),
            child: const Text('Quitar'),
          ),
        ],
      ),
    );
    if (confirmado != true || !context.mounted) {
      return;
    }
    final mensajero = ScaffoldMessenger.of(context);
    final error = await c.eliminar(libro);
    if (error == null) {
      if (context.mounted) {
        Navigator.of(context).pop();
      }
      mensajero.showSnackBar(SnackBar(content: Text('Quitaste «${libro.titulo}» del estante.')));
    } else {
      mensajero.showSnackBar(SnackBar(content: Text(error)));
    }
  }
}

class _Recorrido extends StatelessWidget {
  const _Recorrido({required this.estado, required this.color});

  final EstadoLibro estado;
  final Color color;

  static const _nombres = ['Por leer', 'Leyendo', 'Leído'];

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final apagado = tema.colorScheme.onSurface.withValues(alpha: 0.2);
    final actual = estado.index;

    return Semantics(
      label: 'Estado: ${_nombres[actual]}',
      excludeSemantics: true,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < 3; i++) ...[
            if (i > 0)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 3,
                    color: i <= actual ? color : apagado,
                  ),
                ),
              ),
            Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 23,
                  height: 23,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: (i < actual || (i == 2 && actual == 2)) ? color : tema.scaffoldBackgroundColor,
                    border: Border.all(color: i <= actual ? color : apagado, width: 3),
                  ),
                  child: (i < actual || (i == 2 && actual == 2))
                      ? Icon(Icons.check, size: 13, color: PaletaLomo.textoSobre(color))
                      : null,
                ),
                const SizedBox(height: 6),
                Text(
                  _nombres[i],
                  style: tema.textTheme.labelMedium?.copyWith(
                    fontWeight: i == actual ? FontWeight.w700 : FontWeight.w400,
                    color: i > actual ? tema.colorScheme.onSurface.withValues(alpha: 0.5) : null,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}