import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:admin_panel_manager/main.dart';

import '../Class/profile_class.dart';
import 'get_user_fonction.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController =
      TextEditingController(text: "sentinelle@sahelpolitica.ch");
  final TextEditingController _passwordController =
      TextEditingController(text: "Sentinelle226//");

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _login();
  }

  // Fonction pour crypter le mot de passe
  String _hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Récupérer les utilisateurs correspondant à l'email
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('AdminUsers')
          .where('email', isEqualTo: _emailController.text.trim())
          .get();

      if (snapshot.docs.isEmpty) {
        setState(() {
          _errorMessage = "User not found.";
        });
        return;
      }

      final userDoc = snapshot.docs.first;
      final userData = userDoc.data() as Map<String, dynamic>;
      final hashedPassword = _hashPassword(_passwordController.text.trim());

      if (userData['password'] != hashedPassword) {
        setState(() {
          _errorMessage = "Incorrect password.";
        });
        return;
      }

      // Connexion réussie, enregistrer l'ID dans les cookies
      await _secureStorage.write(key: 'userId', value: userDoc.id);
      Profile? a = await getConnectedUser();
      // Naviguer vers la page d'accueil
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => MyHomePage(
                  currentProfile: a!,
                )),
      );
    } catch (e) {
      setState(() {
        _errorMessage = "An unexpected error occurred. Please try again.";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(50.0),
          height: 600,
          width: 700,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Image.asset(
                    'favicon.png',
                    width: 150,
                  ),
                  Text(
                    "Sahel Politica",
                    style: GoogleFonts.kanit(
                        fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Navigating risk, Ensuring impact",
                    style: GoogleFonts.kanit(fontSize: 20),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              if (_errorMessage != null) ...[
                const SizedBox(height: 10),
                Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ],
              const SizedBox(height: 20),
              _isLoading
                  ? CircularProgressIndicator(
                      color: Colors.yellow[800],
                    )
                  : MaterialButton(
                      minWidth: 300,
                      height: 70,
                      color: const Color(0xffFACB01),
                      onPressed: _login,
                      shape: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Text(
                        "Login",
                        style: GoogleFonts.nunitoSans(
                          fontSize: 18,
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
