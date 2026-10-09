import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/paleta_lomo.dart';

class LomoLibro extends StatelessWidget {
  const LomoLibro({super.key, required this.titulo, required this.autor, this.onTap});

  final String titulo;
  final String autor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final semilla = PaletaLomo.semilla(titulo);
    final color = PaletaLomo.color(titulo);
    final tinta = PaletaLomo.textoSobre(color);
    final ancho = 38.0 + (semilla % 4) * 6;
    final alto = 150.0 + (semilla % 5) * 9;

    return Semantics(
      button: onTap != null,
      label: 'Libro $titulo, de $autor',
      excludeSemantics: true,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: ancho,
          height: alto,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(3),
              bottom: Radius.circular(2),
            ),
            gradient: LinearGradient(
              colors: [
                Color.lerp(color, Colors.white, 0.12)!,
                color,
                Color.lerp(color, Colors.black, 0.22)!,
              ],
              stops: const [0, 0.35, 1],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.18),
                blurRadius: 3,
                offset: const Offset(1, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              _Banda(color: tinta),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                    child: RotatedBox(
                      quarterTurns: 3,
                      child: Text(
                        titulo,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.fraunces(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: tinta,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              _Banda(color: tinta),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

class _Banda extends StatelessWidget {
  const _Banda({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 2,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      color: color.withValues(alpha: 0.5),
    );
  }
}