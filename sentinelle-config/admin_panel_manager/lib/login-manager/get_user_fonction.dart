import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  try {
    // Lire l'ID utilisateur stocké dans les cookies
    final String? userId = await _secureStorage.read(key: 'userId');

    if (userId == null) {
      print("No user ID found in cookies.");
      return null;
    }

    // Rechercher l'utilisateur dans Firestore
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('AdminUsers')
        .doc(userId)
        .get();

    if (userDoc.exists) {
      // Retourner les données de l'utilisateur
      final userData = userDoc.data() as Map<String, dynamic>?;
      return Profile.fromJson(userData!, userId);
    } else {
      print("No user found with ID: $userId");
      return null;
    }
  } catch (e) {
    print("Error fetching user: $e");
    return null;
  }
}
