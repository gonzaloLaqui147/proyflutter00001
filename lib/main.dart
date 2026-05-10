import 'package:flutter/material.dart';
import 'views/log_in.dart';

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
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF006C35), // El verde de tu botón
          brightness: Brightness.light,
        ),
      ),
      home: const LoginPage(),
    );
  }
}