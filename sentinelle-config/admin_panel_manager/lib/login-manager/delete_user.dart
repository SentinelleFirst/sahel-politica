//import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Future<bool> deleteUser(
    String userId, BuildContext context, Function refresh) async {
  try {
    // Étape 1: Supprimer l'utilisateur de Firestore
    await FirebaseFirestore.instance
        .collection('AdminUsers')
        .doc(userId)
        .delete();

    // Étape 2: Supprimer l'utilisateur de Firebase Authentication
    //Impossible dans Firebase Authentication recherche d'une autre option
    /*FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    // Récupérer l'utilisateur via son UID dans Firebase Authentication
    User? userToDelete = await firebaseAuth.getUser(userId);

    if (userToDelete != null) {
      await userToDelete.delete();
    } else {
      print("User not found in Firebase Authentication.");
    }*/
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Profile deleted"),
      ),
    );
    refresh();
    return true; // Retourne true si tout s'est bien passé
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Error, try later"),
      ),
    );
    refresh();
    print('Error deleting user: $e');
    return false; // Retourne false en cas d'erreur
  }
}
