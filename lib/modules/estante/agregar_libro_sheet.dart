import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/app_tokens.dart';
import '../../core/widgets/lomo_libro.dart';
import 'estante_controller.dart';

Future<void> abrirAgregarLibro(BuildContext context) async {
  final agregado = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
    ),
    builder: (_) => const _AgregarLibroSheet(),
  );
  if (agregado == true && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Listo. Quedó en la repisa «En espera».')),
    );
  }
}

class _AgregarLibroSheet extends StatefulWidget {
  const _AgregarLibroSheet();

  @override
  State<_AgregarLibroSheet> createState() => _AgregarLibroSheetState();
}

class _AgregarLibroSheetState extends State<_AgregarLibroSheet> {
  final _form = GlobalKey<FormState>();
  final _titulo = TextEditingController();
  final _autor = TextEditingController();
  final _c = Get.find<EstanteController>();
  String? _error;

  @override
  void dispose() {
    _titulo.dispose();
    _autor.dispose();
    super.dispose();
  }

  String? _requerido(String? valor, String campo) =>
      (valor == null || valor.trim().isEmpty) ? 'Escribe el $campo' : null;

  Future<void> _guardar() async {
    if (!(_form.currentState?.validate() ?? false)) {
      return;
    }
    setState(() => _error = null);
    final error = await _c.agregar(_titulo.text, _autor.text);
    if (!mounted) {
      return;
    }
    if (error == null) {
      Navigator.of(context).pop(true);
    } else {
      setState(() => _error = error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final suave = tema.colorScheme.onSurface.withValues(alpha: 0.7);

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg,
        0,
        AppSpacing.lg,
        AppSpacing.lg + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Form(
        key: _form,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ExcludeSemantics(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 190,
                        width: 64,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: ValueListenableBuilder<TextEditingValue>(
                            valueListenable: _titulo,
                            builder: (context, valor, child) => LomoLibro(
                              titulo: valor.text.trim().isEmpty ? 'Tu libro' : valor.text.trim(),
                              autor: '',
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 64,
                        height: 8,
                        decoration: BoxDecoration(
                          color: AppColors.madera,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Nuevo libro', style: tema.textTheme.headlineSmall),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          'Su lomo toma color según el título. Llegará a la repisa «En espera».',
                          style: tema.textTheme.bodyMedium?.copyWith(color: suave),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            TextFormField(
              controller: _titulo,
              autofocus: true,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(labelText: 'Título'),
              validator: (v) => _requerido(v, 'título'),
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _autor,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _guardar(),
              decoration: const InputDecoration(labelText: 'Autor'),
              validator: (v) => _requerido(v, 'autor'),
            ),
            if (_error != null) ...[
              const SizedBox(height: AppSpacing.md),
              Text(_error!, style: TextStyle(color: tema.colorScheme.error)),
            ],
            const SizedBox(height: AppSpacing.lg),
            Obx(
              () => FilledButton(
                onPressed: _c.guardando.value ? null : _guardar,
                child: _c.guardando.value
                    ? SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.4,
                          color: tema.colorScheme.onPrimary,
                        ),
                      )
                    : const Text('Poner en el estante'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}