import 'package:flutter/material.dart';
import 'views/log_in.dart';
import 'views/register_page.dart'; // IMPORTANTE: Importa la página que creamos

void main() {
  runApp(const BilleApp());
}

class BilleApp extends StatelessWidget {
  const BilleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bille - Billetera Digital',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF006C35)),
      ),
      home: const LoginPage(),
      // ESTE BLOQUE ES EL QUE HACE QUE EL BOTÓN FUNCIONE
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
      },
    );
  }
}