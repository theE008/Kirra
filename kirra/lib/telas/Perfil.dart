import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Intro.dart'; // Import necessário para voltar à Intro

class PerfilPage extends StatelessWidget {
  const PerfilPage({super.key});

  // Função para apagar tudo e resetar o app
  Future<void> _resetarApp(BuildContext context) async {
    final confirmacao = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Destruir Identidade?"),
        content: const Text("Isso apagará seu ID Key e todas as mensagens locais. Esta ação é irreversível."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("CANCELAR"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("DESTRUIR", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmacao == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear(); // Apaga first_access, user_id, etc.

      if (context.mounted) {
        // Manda de volta para a Intro e remove todas as telas anteriores da memória
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const IntroPage()),
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("KIRRA"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50)),
            const SizedBox(height: 20),
            const Text("Seu Perfil", style: TextStyle(fontSize: 22)),
            const SizedBox(height: 8),
            const Text("Chave: #KIRRA-XXXX-XXXX", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 50),
            
            // Botão de Reset
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
              ),
              onPressed: () => _resetarApp(context),
              icon: const Icon(Icons.delete_forever),
              label: const Text("DESTRUIR CONTA LOCAL"),
            ),
          ],
        ),
      ),
    );
  }
}
