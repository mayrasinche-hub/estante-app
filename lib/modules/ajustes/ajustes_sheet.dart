import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/app_tokens.dart';
import '../auth/auth_controller.dart';
import 'ajustes_controller.dart';

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
    final c = Get.find<AjustesController>();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.lg),
        child: Obx(
          () => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Ajustes'.tr, style: tema.textTheme.headlineSmall),
              const SizedBox(height: AppSpacing.lg),
              Text('Apariencia'.tr, style: tema.textTheme.titleMedium),
              const SizedBox(height: AppSpacing.sm),
              SegmentedButton<ThemeMode>(
                segments: [
                  ButtonSegment(
                    value: ThemeMode.light,
                    icon: const Icon(Icons.light_mode_outlined),
                    label: Text('Claro'.tr),
                  ),
                  ButtonSegment(
                    value: ThemeMode.dark,
                    icon: const Icon(Icons.dark_mode_outlined),
                    label: Text('Oscuro'.tr),
                  ),
                  ButtonSegment(
                    value: ThemeMode.system,
                    icon: const Icon(Icons.phone_android),
                    label: Text('Sistema'.tr),
                  ),
                ],
                selected: {c.modo.value},
                onSelectionChanged: (s) => c.cambiarTema(s.first),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text('Idioma'.tr, style: tema.textTheme.titleMedium),
              const SizedBox(height: AppSpacing.sm),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'es', label: Text('Español')),
                  ButtonSegment(value: 'en', label: Text('English')),
                ],
                selected: {c.idioma.value},
                onSelectionChanged: (s) => c.cambiarIdioma(s.first),
              ),
              const SizedBox(height: AppSpacing.xl),
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                  Get.find<AuthController>().cerrarSesion();
                },
                icon: const Icon(Icons.logout),
                label: Text('Cerrar sesión'.tr),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
