import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Class/profile_class.dart';

// Fonction pour récupérer les informations de l'utilisateur depuis Firestore
Future<Profile?> getUser(String userId) async {
  try {
    // Accéder aux données de l'utilisateur dans Firestore en utilisant userId
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    DocumentSnapshot userDoc =
        await _firestore.collection('AdminUsers').doc(userId).get();

    if (userDoc.exists) {
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

      // Créer l'objet Profile à partir des données récupérées
      Profile profile = Profile(
        userId,
        userData['firstname'] ?? '',
        userData['lastname'] ?? '',
        userData['email'] ?? '',
        userData['post'] ?? '',
        userData['access'] ?? {},
        (userData['dateOfCreation'] as Timestamp).toDate(),
      );
      return profile;
    } else {
      return null; // L'utilisateur n'existe pas dans Firestore
    }
  } catch (e) {
    print('Error fetching user data: $e');
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

      // Créer et retourner un objet Profile
      Profile profile = Profile(
        currentUser.uid,
        userData[
            'firstname'], // Assurez-vous que le champ 'firstname' existe dans votre base de données
        userData[
            'lastname'], // Assurez-vous que le champ 'lastname' existe dans votre base de données
        currentUser.email ?? '', // L'email de l'utilisateur connecté
        userData[
            'post'], // Assurez-vous que le champ 'post' existe dans votre base de données
        userData[
            'access'], // Assurez-vous que le champ 'access' existe dans votre base de données
        DateTime.parse(userData[
            'dateOfCreation']), // Assurez-vous que le champ 'creation_date' existe
      );

      return profile;
    }
  } catch (e) {
    print("Error fetching user data: $e");
  }

  return null; // Si l'utilisateur n'a pas été trouvé ou une erreur est survenue, on retourne null
}
