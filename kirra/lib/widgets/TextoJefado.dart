import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextoJefado extends StatefulWidget {
  final String texto;
  const TextoJefado({super.key, required this.texto});

  @override
  State<TextoJefado> createState() => _TextoJefadoState();
}

class _TextoJefadoState extends State<TextoJefado> {
  Timer? _timer;
  Color _corAtual = Colors.white;
  String _fonteAtual = 'Roboto';

  // Lista de fontes para o efeito "jefado"
  final List<String> _fontes = [
    'Press Start 2P', 'Courier Prime', 'DotGothic16', 
    'Permanent Marker', 'Rubik Glitch', 'Bungee Spice'
  ];

  @override
  void initState() {
    super.initState();
    // Muda a cada 250ms (um quarto de segundo)
    _timer = Timer.periodic(const Duration(milliseconds: 250), (timer) {
      setState(() {
        _corAtual = Colors.primaries[Random().nextInt(Colors.primaries.length)];
        _fonteAtual = _fontes[Random().nextInt(_fontes.length)];
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      widget.texto,
      textAlign: TextAlign.center,
      style: GoogleFonts.getFont(
        _fonteAtual,
        textStyle: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w900   ,
          color: _corAtual,
        ),
      ),
    );
  }
}
