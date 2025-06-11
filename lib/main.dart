import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // Este archivo se genera automáticamente
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BlondGames',
      theme: ThemeData(
        // Tema inspirado en videojuegos con tonos oscuros y acentos vibrantes
        primaryColor: const Color(0xFF1A237E), // Azul medianoche - para AppBar, botones, etc.
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.deepPurple, // Una paleta para generar tonos
        ).copyWith(
          secondary: const Color(0xFFE040FB), // Un magenta vibrante para acentos
          background: const Color(0xFF121212), // Fondo muy oscuro
        ),
        scaffoldBackgroundColor: const Color(0xFF121212), // Fondo principal de la pantalla
        cardColor: const Color(0xFF212121), // Gris oscuro para tarjetas
        textTheme: const TextTheme(
          titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24),
          bodyLarge: TextStyle(color: Colors.white70, fontSize: 16),
          bodyMedium: TextStyle(color: Colors.white70, fontSize: 14),
          labelLarge: TextStyle(color: Colors.white),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF2C2C2C), // Fondo del input más claro que el fondo
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide.none, // Sin borde visible
          ),
          labelStyle: const TextStyle(color: Color(0xFFBBDEFB)), // Azul claro para etiquetas
          hintStyle: const TextStyle(color: Colors.white54),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFE040FB), // Magenta vibrante para botones
            foregroundColor: Colors.white, // Texto blanco en el botón
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        // Puedes añadir una fuente personalizada si tienes un archivo .ttf, por ejemplo:
        // fontFamily: 'PixelifySans',
      ),
      home: const HomeScreen(),
    );
  }
}