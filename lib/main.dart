import 'package:flutter/material.dart';
import 'login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // Pastikan file ini benar dan sudah ada

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Pastikan binding Flutter siap
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions
        .currentPlatform, // Pastikan file firebase_options.dart benar
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Hilangkan label DEBUG
      title: 'Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: LoginScreen(), // Set home ke LoginScreen
    );
  }
}
