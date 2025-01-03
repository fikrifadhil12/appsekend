import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Controller untuk inputan form
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Fungsi untuk registrasi pengguna
  Future<void> _register() async {
    String email = _emailController.text;
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      // Validasi input kosong
      print("Please enter email and password.");
      return;
    }

    if (password != confirmPassword) {
      // Validasi password tidak cocok
      print("Passwords do not match.");
      return;
    }

    try {
      // Mendaftar akun dengan email dan password menggunakan Firebase Authentication
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Jika registrasi berhasil
      print('Registration successful: ${userCredential.user?.email}');

      // Navigasi ke halaman login setelah registrasi berhasil (opsional)
      Navigator.pop(context); // Kembali ke halaman login
    } catch (e) {
      // Menangani error jika registrasi gagal
      print("Registration failed: $e");

      // Menampilkan pesan error menggunakan SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration failed: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 0, // Menyembunyikan AppBar
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Logo
              Image.asset(
                '2.png', // Path harus sesuai dengan struktur folder
                height: 150,
                width: 150,
              ),
              SizedBox(height: 40),
              // Teks "Enter your Email"
              SizedBox(height: 20),
              // Email Input
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 16),
              // Password Input
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              // Confirm Password Input
              TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 24),
              // Create Account Button
              ElevatedButton(
                onPressed: _register, // Fungsi untuk registrasi
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple, // Warna ungu
                  minimumSize: Size(double.infinity, 50),
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text(
                  'Create Account',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              SizedBox(height: 16),
              // Back to Login Button
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Kembali ke halaman login
                },
                child: Text(
                  'Back to Login',
                  style: TextStyle(color: Colors.purple, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
