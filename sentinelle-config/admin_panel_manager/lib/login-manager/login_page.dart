import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  bool _isLoading = false;
  String? _errorMessage;

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

      // Fetch additional user info from Firestore
      DocumentSnapshot userDoc =
          await _firestore.collection('AdminUsers').doc(userId).get();

      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

        // Save user session with additional info
        await _storage.write(
            key: "user_email", value: userCredential.user?.email);
        await _storage.write(key: "user_name", value: userData['name']);
        await _storage.write(key: "user_surname", value: userData['surname']);
        await _storage.write(
            key: "user_creation_date", value: userData['creation_date']);
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MyApp()),
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

  Future<void> _checkSession() async {
    String? savedEmail = await _storage.read(key: "user_email");
    if (savedEmail != null) {
      try {
        final String? userId = _auth.currentUser?.uid;
        if (userId != null) {
          DocumentSnapshot userDoc =
              await _firestore.collection('AdminUsers').doc(userId).get();
          if (userDoc.exists) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MyApp()),
            );
          }
        }
      } catch (e) {
        await _logout();
      }
    }
  }

  Future<Map<String, String>> _getUserInfoFromStorage() async {
    final String? email = await _storage.read(key: "user_email");
    final String? name = await _storage.read(key: "user_name");
    final String? surname = await _storage.read(key: "user_surname");
    final String? creationDate = await _storage.read(key: "user_creation_date");

    return {
      "email": email ?? "",
      "name": name ?? "",
      "surname": surname ?? "",
      "creation_date": creationDate ?? "",
    };
  }

  Future<void> _logout() async {
    await _storage.deleteAll();
    await _auth.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  void initState() {
    super.initState();
    _checkSession();
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
                      color: Color(0xffFACB01),
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
