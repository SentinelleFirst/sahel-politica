import 'package:admin_panel_manager/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Class/profile_class.dart';
import 'get_user_fonction.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  /*final*/ TextEditingController _emailController = TextEditingController();
  /*final*/ TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance; // Déclarer _auth ici

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    //Pre Connexion
    _emailController =
        TextEditingController(text: "sentinelle@sahelpolitica.ch");
    _passwordController = TextEditingController(text: "Sentinelle226//");
    _login();
  }

  // Fonction de login
  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final String userId = userCredential.user?.uid ?? "";

      // Fetch additional user info from Firestore en utilisant le userId
      Profile? userProfile = await getUser(userId); // Passer userId ici

      if (userProfile != null) {
        // Si le profil a été récupéré avec succès, tu peux l'utiliser ici
        print('User Profile: ${userProfile.displayName()}');
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                const MyHomePage()), // Replace MyApp with the actual home page widget
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message;
      });
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
                  ? const CircularProgressIndicator()
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

class MyApp {
  const MyApp();
}
