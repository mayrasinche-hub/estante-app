import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/paleta_lomo.dart';

class LomoLibro extends StatelessWidget {
  const LomoLibro({
    super.key,
    required this.titulo,
    required this.autor,
    this.onTap,
    this.escala = 1,
  });

  final String titulo;
  final String autor;
  final VoidCallback? onTap;
  final double escala;

  @override
  Widget build(BuildContext context) {
    final semilla = PaletaLomo.semilla(titulo);
    final color = PaletaLomo.color(titulo);
    final tinta = PaletaLomo.textoSobre(color);
    final ancho = (38.0 + (semilla % 4) * 6) * escala;
    final alto = (150.0 + (semilla % 5) * 9) * escala;

    return Semantics(
      button: onTap != null,
      label: 'Libro $titulo, de $autor',
      excludeSemantics: true,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: ancho,
          height: alto,
          margin: EdgeInsets.symmetric(horizontal: 2 * escala),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(3 * escala),
              bottom: Radius.circular(2 * escala),
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
                blurRadius: 3 * escala,
                offset: Offset(1 * escala, 2 * escala),
              ),
            ],
          ),
          child: Column(
            children: [
              SizedBox(height: 12 * escala),
              _Banda(color: tinta, escala: escala),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10 * escala),
                  child: Center(
                    child: RotatedBox(
                      quarterTurns: 3,
                      child: Text(
                        titulo,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.fraunces(
                          fontSize: 13 * escala,
                          fontWeight: FontWeight.w600,
                          color: tinta,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              _Banda(color: tinta, escala: escala),
              SizedBox(height: 10 * escala),
            ],
          ),
        ),
      ),
    );
  }
}

class _Banda extends StatelessWidget {
  const _Banda({required this.color, required this.escala});

  final Color color;
  final double escala;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 2 * escala,
      margin: EdgeInsets.symmetric(horizontal: 6 * escala),
      color: color.withValues(alpha: 0.5),
    );
  }
}