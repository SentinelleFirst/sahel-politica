import 'package:cloud_firestore/cloud_firestore.dart';

Future<List<T>> fetchCollection<T>(
    String collectionPath, T Function(Map<String, dynamic>) fromJson) async {
  try {
    final querySnapshot =
        await FirebaseFirestore.instance.collection(collectionPath).get();
    return querySnapshot.docs.map((doc) => fromJson(doc.data())).toList();
  } catch (e) {
    print("Error fetching collection $collectionPath: $e");
    return [];
  }
}
