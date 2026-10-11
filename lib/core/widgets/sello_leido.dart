import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../i18n/fechas.dart';

class SelloLeido extends StatelessWidget {
  const SelloLeido({super.key, this.fecha, this.animar = false});

  final DateTime? fecha;
  final bool animar;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    final f = fecha;
    final texto = f == null ? null : fechaCorta(f);

    final sello = Transform.rotate(
      angle: -0.14,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          border: Border.all(color: color, width: 3),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
          decoration: BoxDecoration(
            border: Border.all(color: color.withValues(alpha: 0.6), width: 1.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'LEÍDO'.tr,
                style: GoogleFonts.fraunces(
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  color: color,
                  letterSpacing: 4,
                ),
              ),
              if (texto != null)
                Text(
                  texto.toUpperCase(),
                  style: GoogleFonts.workSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: color,
                    letterSpacing: 2,
                  ),
                ),
            ],
          ),
        ),
      ),
    );

    return Semantics(
      label: texto == null ? 'Libro leído'.tr : 'Libro leído el @f'.trParams({'f': texto}),
      excludeSemantics: true,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: animar ? 0.0 : 1.0, end: 1.0),
        duration: animar ? const Duration(milliseconds: 520) : Duration.zero,
        curve: Curves.easeOutBack,
        builder: (context, v, child) => Opacity(
          opacity: v.clamp(0.0, 1.0),
          child: Transform.scale(scale: 1.8 - 0.8 * v, child: child),
        ),
        child: sello,
      ),
    );
  }
}
