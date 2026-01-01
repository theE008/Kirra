import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'telas/Intro.dart';
import 'telas/Perfil.dart';
// import 'firebase_options.dart'; // Comente esta linha até rodar o flutterfire configure

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Suporte Desktop
  if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  // Inicializa o Firebase (Comente as 3 linhas abaixo para testar sem Firebase)
  /* await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); */

  final prefs = await SharedPreferences.getInstance();
  final bool firstAccess = prefs.getBool('first_access') ?? true;

  runApp(KirraApp(isFirstAccess: firstAccess));
}

class KirraApp extends StatelessWidget {
  final bool isFirstAccess;
  const KirraApp({super.key, required this.isFirstAccess});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kirra',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF6A1B9A), // Roxo Kirra
        useMaterial3: true,
      ),
      home: isFirstAccess ? IntroPage() : PerfilPage(),
    );
  }
}
