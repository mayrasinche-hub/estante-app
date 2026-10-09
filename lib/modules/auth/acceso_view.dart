import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/app_tokens.dart';
import '../../core/widgets/lomo_libro.dart';
import 'auth_controller.dart';

class AccesoView extends StatefulWidget {
  const AccesoView({super.key});

  @override
  State<AccesoView> createState() => _AccesoViewState();
}

class _AccesoViewState extends State<AccesoView> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _clave = TextEditingController();
  final _c = Get.find<AuthController>();

  @override
  void dispose() {
    _email.dispose();
    _clave.dispose();
    super.dispose();
  }

  void _enviar() {
    FocusScope.of(context).unfocus();
    if (_form.currentState?.validate() ?? false) {
      _c.enviar(_email.text, _clave.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final suave = tema.colorScheme.onSurface.withValues(alpha: 0.7);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Obx(() {
                final registro = _c.modoRegistro.value;
                final cargando = _c.cargando.value;
                return Form(
                  key: _form,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const _EstanteMini(),
                      const SizedBox(height: AppSpacing.lg),
                      Text('Estante', style: tema.textTheme.displaySmall),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        registro
                            ? 'Abre tu biblioteca personal.'
                            : 'Tus libros te estaban esperando.',
                        style: tema.textTheme.bodyLarge?.copyWith(color: suave),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      TextFormField(
                        controller: _email,
                        keyboardType: TextInputType.emailAddress,
                        autofillHints: const [AutofillHints.email],
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(labelText: 'Correo'),
                        validator: _c.validarEmail,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      TextFormField(
                        controller: _clave,
                        obscureText: _c.ocultarClave.value,
                        autofillHints: const [AutofillHints.password],
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _enviar(),
                        decoration: InputDecoration(
                          labelText: 'Contraseña',
                          suffixIcon: IconButton(
                            tooltip: _c.ocultarClave.value
                                ? 'Mostrar contraseña'
                                : 'Ocultar contraseña',
                            icon: Icon(
                              _c.ocultarClave.value
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                            onPressed: _c.ocultarClave.toggle,
                          ),
                        ),
                        validator: _c.validarClave,
                      ),
                      if (_c.error.value != null) ...[
                        const SizedBox(height: AppSpacing.md),
                        _MensajeError(texto: _c.error.value!),
                      ],
                      const SizedBox(height: AppSpacing.lg),
                      FilledButton(
                        onPressed: cargando ? null : _enviar,
                        child: cargando
                            ? SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.4,
                                  color: tema.colorScheme.onPrimary,
                                ),
                              )
                            : Text(registro ? 'Crear cuenta' : 'Entrar'),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      TextButton(
                        onPressed: cargando ? null : _c.alternarModo,
                        child: Text(
                          registro ? 'Ya tengo cuenta' : 'Soy nuevo, crear cuenta',
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _EstanteMini extends StatelessWidget {
  const _EstanteMini();

  static const _titulos = ['Huasipungo', 'Rayuela', 'Ficciones', 'A la Costa', 'Pedro Páramo'];

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 110,
            child: FittedBox(
              alignment: Alignment.bottomLeft,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  for (final t in _titulos) LomoLibro(titulo: t, autor: ''),
                ],
              ),
            ),
          ),
          Container(
            height: 6,
            width: 190,
            decoration: BoxDecoration(
              color: AppColors.madera,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }
}

class _MensajeError extends StatelessWidget {
  const _MensajeError({required this.texto});

  final String texto;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.error;
    return Semantics(
      liveRegion: true,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Row(
          children: [
            Icon(Icons.error_outline, color: color),
            const SizedBox(width: AppSpacing.sm),
            Expanded(child: Text(texto, style: TextStyle(color: color))),
          ],
        ),
      ),
    );
  }
}