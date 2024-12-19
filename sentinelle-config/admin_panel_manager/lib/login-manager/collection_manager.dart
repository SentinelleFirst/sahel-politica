import 'package:cloud_firestore/cloud_firestore.dart';

Future<List<T>> fetchCollection<T>(String collectionPath,
    T Function(Map<String, dynamic>, String) fromJson) async {
  try {
    // Récupère tous les documents de la collection spécifiée
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection(collectionPath).get();

    // Mappe chaque document Firestore à un objet T en utilisant la fonction fromJson
    return querySnapshot.docs.map((doc) {
      return fromJson(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  } catch (e) {
    print("Error fetching collection $collectionPath: $e");
    return [];
  }
}
