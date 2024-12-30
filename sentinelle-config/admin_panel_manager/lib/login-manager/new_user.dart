import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import '../Class/profile_class.dart';

Future<bool> addUser(Profile profile, String password, BuildContext context,
    Function loading) async {
  try {
    // Cryptage du mot de passe
    var bytes = utf8.encode(password); // Convertir le mot de passe en bytes
    var hashedPassword =
        sha256.convert(bytes).toString(); // Hasher le mot de passe avec SHA-256

    // Préparer les données utilisateur
    Map<String, dynamic> userData =
        profile.toJson(); // Convertir le profil en JSON
    userData['password'] = hashedPassword; // Ajouter le mot de passe crypté

    // Ajouter l'utilisateur dans Firestore sans spécifier d'ID (ID généré automatiquement)
    await FirebaseFirestore.instance.collection('AdminUsers').add(userData);

    print("User added successfully: ${profile.displayName()}");

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
