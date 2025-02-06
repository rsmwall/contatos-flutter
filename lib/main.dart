import 'package:flutter/material.dart';
import 'views/login_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App Flutter',
      theme: ThemeData(
        useMaterial3: true, // Ativa o Material Design 3
        colorSchemeSeed: const Color.fromARGB(255, 240, 243, 33), // Define a cor base
        brightness: Brightness.light, // Define o brilho do tema
      ),
      home: LoginView(),
    );
  }
}
