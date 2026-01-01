import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';
import 'Perfil.dart';
import '../widgets/TextoJefado.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  int _indiceFrase = -1; 
  final AudioPlayer _player = AudioPlayer();
  double _escalaKirra = 1.0; 

  static const int timingPadrao = 1500;
  
  final List<Map<String, dynamic>> _sequenciaIntro = [
    {"texto": "PARA CONVERSAR", "duracao": timingPadrao},
    {"texto": "PARA PROGRAMAR", "duracao": timingPadrao},
    {"texto": "PARA COMPARTILHAR", "duracao": timingPadrao},
    {"texto": "PARA IMAGINAR", "duracao": timingPadrao},
    {"texto": "PARA CRIAR", "duracao": timingPadrao},
    {"texto": "TUDO ISSO E MUITO", "duracao": 1300},
    {"texto": "KIRRA", "duracao": 5000},
  ];

  void _iniciarSequencia() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Apenas marca que a intro foi vista
    await prefs.setBool('first_access', false);

    // Play na música
    try {
      await _player.play(AssetSource('audio/intro_kirra.mp3'));
    } catch (e) {
      debugPrint("Erro de áudio: $e");
    }

    // Loop da sequência
    for (int i = 0; i < _sequenciaIntro.length; i++) {
      if (!mounted) return;
      
      setState(() {
        _indiceFrase = i;
      });

      if (_sequenciaIntro[i]['texto'] == "KIRRA") {
        Future.delayed(const Duration(milliseconds: 50), () {
          if (mounted) setState(() => _escalaKirra = 2.5); 
        });
      }

      await Future.delayed(Duration(milliseconds: _sequenciaIntro[i]['duracao']));
    }

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const PerfilPage()),
      );
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: _indiceFrase == -1
            ? _buildTelaInicial()
            : _buildSequencia(),
      ),
    );
  }

  Widget _buildTelaInicial() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "KIRRA",
          style: TextStyle(
            fontSize: 40, 
            fontWeight: FontWeight.w900, 
            color: Colors.white,
            letterSpacing: 8
          ),
        ),
        const SizedBox(height: 50),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
          ),
          onPressed: _iniciarSequencia,
          child: const Text("INICIAR"),
        ),
      ],
    );
  }

  Widget _buildSequencia() {
    final frase = _sequenciaIntro[_indiceFrase]['texto'];

    if (frase == "KIRRA") {
      return AnimatedScale(
        scale: _escalaKirra,
        duration: const Duration(milliseconds: 4800),
        curve: Curves.easeOut,
        child: const Text(
          "KIRRA",
          style: TextStyle(
            color: Color(0xFF660000), 
            fontSize: 50,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    } else {
      return TextoJefado(texto: frase);
    }
  }
}
