import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../Class/profile_class.dart';

Future<bool> addUser(Profile profile, String password, BuildContext context,
    Function loading) async {
  try {
    // Étape 1: Créer un utilisateur dans Firebase Authentication
    UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: profile.email,
      password: password,
    );

    // Récupérer l'UID généré par Firebase Authentication
    String userId = userCredential.user!.uid;

    // Étape 2: Ajouter les informations de l'utilisateur dans Firestore
    await FirebaseFirestore.instance.collection('AdminUsers').doc(userId).set({
      'firstname': profile.firstname,
      'lastname': profile.lastname,
      'email': profile.email,
      'post': profile.post,
      'access': profile.access,
      'dateOfCreation': profile.dateOfCreation,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("New user successfully created"),
      ),
    );
    loading();
    return true; // Retourne true si tout s'est bien passé
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Error, try later"),
      ),
    );
    loading();
    print('Error adding user: $e');
    return false; // Retourne false en cas d'erreur
  }
}
