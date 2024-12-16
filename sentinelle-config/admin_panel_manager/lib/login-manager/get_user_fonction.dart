import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../Class/profile_class.dart';

// Fonction pour récupérer les informations de l'utilisateur depuis Firestore
Future<Profile?> getUser(String id) async {
  try {
    // Récupérez les données utilisateur depuis Firestore en utilisant l'id fourni
    final DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('AdminUsers').doc(id).get();

    if (!userDoc.exists) {
      return null; // Pas d'entrée pour cet utilisateur
    }

    // Mappez les données Firestore vers un objet Profile
    final data = userDoc.data() as Map<String, dynamic>;

    // Conversion sécurisée de 'access' en Map<String, Map<String, bool>>
    final accessData = data['access'] as Map<String, dynamic>? ?? {};
    final access = accessData.map<String, Map<String, bool>>((key, value) {
      // Vérifiez si 'value' est un Map<String, dynamic>
      final nestedMap = value as Map<String, dynamic>? ?? {};
      return MapEntry(
        key,
        nestedMap.map<String, bool>((nestedKey, nestedValue) {
          return MapEntry(
            nestedKey,
            nestedValue as bool? ??
                false, // Assurez-vous que les valeurs sont booléennes
          );
        }),
      );
    });

    return Profile(
      id,
      data['firstname'] ?? '',
      data['lastname'] ?? '',
      data['email'] ?? '',
      data['post'] ?? '',
      access,
      (data['dateOfCreation'] != null)
          ? (data['dateOfCreation'] as Timestamp).toDate()
          : DateTime.now(),
    );
  } catch (e) {
    debugPrint('Error fetching user profile: $e');
    return null; // Retourne null en cas d'erreur
  }
}

Future<Profile?> getConnectedUser() async {
  // Récupérer l'utilisateur connecté via FirebaseAuth
  User? currentUser = FirebaseAuth.instance.currentUser;

  // Vérifier si un utilisateur est connecté
  if (currentUser == null) {
    return null; // Si l'utilisateur n'est pas connecté, on retourne null
  }

  // Récupérer les informations supplémentaires de l'utilisateur à partir de Firestore
  try {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('AdminUsers')
        .doc(currentUser.uid)
        .get();

    if (userDoc.exists) {
      // Récupérer les données de l'utilisateur depuis Firestore
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

      // Conversion sécurisée de 'access' en Map<String, Map<String, bool>>
      final accessData = userData['access'] as Map<String, dynamic>? ?? {};
      final access = accessData.map<String, Map<String, bool>>((key, value) {
        // Vérifiez si 'value' est un Map<String, dynamic>
        final nestedMap = value as Map<String, dynamic>? ?? {};
        return MapEntry(
          key,
          nestedMap.map<String, bool>((nestedKey, nestedValue) {
            return MapEntry(
              nestedKey,
              nestedValue as bool? ??
                  false, // Assurez-vous que les valeurs sont booléennes
            );
          }),
        );
      });

      // Créer et retourner un objet Profile
      Profile profile = Profile(
        currentUser.uid,
        userData['firstname'] ?? '',
        userData['lastname'] ?? '',
        userData['email'] ?? '',
        userData['post'] ?? '',
        access,
        (userData['dateOfCreation'] != null)
            ? (userData['dateOfCreation'] as Timestamp).toDate()
            : DateTime.now(),
      );

      return profile;
    }
  } catch (e) {
    print("Error fetching user data: $e");
  }

  return null; // Si l'utilisateur n'a pas été trouvé ou une erreur est survenue, on retourne null
}
