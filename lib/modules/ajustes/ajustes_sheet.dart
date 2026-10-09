import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/app_tokens.dart';
import '../auth/auth_controller.dart';
import 'tema_controller.dart';

Future<void> abrirAjustes(BuildContext context) => showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      builder: (_) => const _AjustesSheet(),
    );

class _AjustesSheet extends StatelessWidget {
  const _AjustesSheet();

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final c = Get.find<TemaController>();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Ajustes', style: tema.textTheme.headlineSmall),
            const SizedBox(height: AppSpacing.lg),
            Text('Apariencia', style: tema.textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            Obx(
              () => SegmentedButton<ThemeMode>(
                segments: const [
                  ButtonSegment(
                    value: ThemeMode.light,
                    icon: Icon(Icons.light_mode_outlined),
                    label: Text('Claro'),
                  ),
                  ButtonSegment(
                    value: ThemeMode.dark,
                    icon: Icon(Icons.dark_mode_outlined),
                    label: Text('Oscuro'),
                  ),
                  ButtonSegment(
                    value: ThemeMode.system,
                    icon: Icon(Icons.phone_android),
                    label: Text('Sistema'),
                  ),
                ],
                selected: {c.modo.value},
                onSelectionChanged: (s) => c.cambiar(s.first),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            OutlinedButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
                Get.find<AuthController>().cerrarSesion();
              },
              icon: const Icon(Icons.logout),
              label: const Text('Cerrar sesión'),
            ),
          ],
        ),
      ),
    );
  }
}