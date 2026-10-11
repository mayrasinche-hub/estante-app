import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import '../../core/i18n/fechas.dart';
import '../../core/theme/app_tokens.dart';
import '../../core/theme/paleta_lomo.dart';
import '../../data/models/libro.dart';
import '../estante/estante_controller.dart';

class MapaView extends StatelessWidget {
  const MapaView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<EstanteController>();
    return Scaffold(
      appBar: AppBar(title: Text('Mapa de lecturas'.tr)),
      body: Obx(() {
        final puntos = [
          for (final l in c.libros)
            if (l.estado == EstadoLibro.leido && (c.sellos[l.id]?.tieneLugar ?? false)) l,
        ];
        if (puntos.isEmpty) {
          return const _SinPuntos();
        }
        final primero = c.sellos[puntos.first.id]!;
        return FlutterMap(
          options: MapOptions(
            initialCenter: LatLng(primero.lat!, primero.lng!),
            initialZoom: 13,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'ec.utpl.estante',
            ),
            MarkerLayer(
              markers: [
                for (final l in puntos)
                  Marker(
                    point: LatLng(c.sellos[l.id]!.lat!, c.sellos[l.id]!.lng!),
                    width: 40,
                    height: 56,
                    alignment: Alignment.topCenter,
                    child: _Pin(
                      libro: l,
                      alTocar: () => _mostrar(context, l, c.sellos[l.id]!.fecha),
                    ),
                  ),
              ],
            ),
            SimpleAttributionWidget(source: const Text('OpenStreetMap')),
          ],
        );
      }),
    );
  }

  void _mostrar(BuildContext context, Libro libro, DateTime f) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '«@t» · lo terminaste el @f'.trParams({'t': libro.titulo, 'f': fechaCorta(f)}),
        ),
      ),
    );
  }
}

class _Pin extends StatelessWidget {
  const _Pin({required this.libro, required this.alTocar});

  final Libro libro;
  final VoidCallback alTocar;

  @override
  Widget build(BuildContext context) {
    final color = PaletaLomo.color(libro.titulo);
    return Semantics(
      button: true,
      label: '@t, terminado aquí'.trParams({'t': libro.titulo}),
      excludeSemantics: true,
      child: GestureDetector(
        onTap: alTocar,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 24,
              height: 36,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(3),
                border: Border.all(color: AppColors.papel, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
            Container(width: 2, height: 12, color: AppColors.tinta),
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(color: AppColors.tinta, shape: BoxShape.circle),
            ),
          ],
        ),
      ),
    );
  }
}

class _SinPuntos extends StatelessWidget {
  const _SinPuntos();

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.map_outlined, size: 56, color: tema.colorScheme.primary),
            const SizedBox(height: AppSpacing.md),
            Text('Tu mapa está en blanco'.tr, style: tema.textTheme.headlineSmall),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Cuando termines un libro con la ubicación activada, su lomo aparecerá en el lugar donde lo cerraste.'.tr,
              textAlign: TextAlign.center,
              style: tema.textTheme.bodyMedium?.copyWith(
                color: tema.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
