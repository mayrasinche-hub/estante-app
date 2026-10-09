import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/paleta_lomo.dart';

class Marcapaginas extends StatefulWidget {
  const Marcapaginas({
    super.key,
    required this.texto,
    required this.color,
    required this.alCompletar,
    this.ocupado = false,
  });

  final String texto;
  final Color color;
  final Future<void> Function() alCompletar;
  final bool ocupado;

  @override
  State<Marcapaginas> createState() => _MarcapaginasState();
}

class _MarcapaginasState extends State<Marcapaginas> {
  static const _alto = 64.0;
  double _avance = 0;
  bool _arrastrando = false;

  Future<void> _completar() async {
    HapticFeedback.mediumImpact();
    setState(() => _avance = 1);
    await widget.alCompletar();
    if (mounted) {
      setState(() => _avance = 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final sobre = PaletaLomo.textoSobre(widget.color);
    final texto = Theme.of(context).colorScheme.onSurface;
    final duracion = _arrastrando ? Duration.zero : const Duration(milliseconds: 250);

    return Semantics(
      button: true,
      label: widget.texto,
      onTap: widget.ocupado ? null : _completar,
      excludeSemantics: true,
      child: LayoutBuilder(
        builder: (context, c) {
          final recorrido = c.maxWidth - _alto;
          return GestureDetector(
            onHorizontalDragStart: widget.ocupado ? null : (_) => setState(() => _arrastrando = true),
            onHorizontalDragUpdate: widget.ocupado
                ? null
                : (d) => setState(
                      () => _avance = (_avance + d.delta.dx / recorrido).clamp(0.0, 1.0),
                    ),
            onHorizontalDragEnd: widget.ocupado
                ? null
                : (_) {
                    setState(() => _arrastrando = false);
                    if (_avance > 0.8) {
                      _completar();
                    } else {
                      setState(() => _avance = 0);
                    }
                  },
            child: Container(
              height: _alto,
              decoration: BoxDecoration(
                color: widget.color.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(_alto / 2),
              ),
              child: Stack(
                children: [
                  AnimatedContainer(
                    duration: duracion,
                    height: _alto,
                    width: _alto + recorrido * _avance,
                    decoration: BoxDecoration(
                      color: widget.color.withValues(alpha: 0.28),
                      borderRadius: BorderRadius.circular(_alto / 2),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: _alto * 0.6),
                      child: Opacity(
                        opacity: (1 - _avance * 1.4).clamp(0.0, 1.0),
                        child: Text(
                          widget.texto,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: texto, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                  AnimatedPositioned(
                    duration: duracion,
                    curve: Curves.easeOut,
                    left: recorrido * _avance,
                    top: 0,
                    bottom: 0,
                    child: Container(
                      width: _alto,
                      decoration: BoxDecoration(
                        color: widget.color,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: widget.ocupado
                          ? Padding(
                              padding: const EdgeInsets.all(20),
                              child: CircularProgressIndicator(strokeWidth: 2.4, color: sobre),
                            )
                          : Icon(Icons.bookmark, color: sobre),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}