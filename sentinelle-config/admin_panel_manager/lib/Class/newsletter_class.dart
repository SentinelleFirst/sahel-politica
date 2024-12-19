import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../login-manager/collection_manager.dart';

class Newsletter {
  String id;
  String object;
  String message;
  String link;
  String linkText;
  String imageUrl;
  String elementTitle;
  List<String> contacts;
  String author;
  DateTime date;

  Newsletter(this.id, this.object, this.message, this.link, this.linkText,
      this.imageUrl, this.elementTitle, this.contacts, this.author, this.date);

  factory Newsletter.empty() {
    return Newsletter("", "", "", "", "", "", "", [], "", DateTime.now());
  }

  factory Newsletter.copy(Newsletter n) {
    return Newsletter(n.id, n.object, n.message, n.link, n.linkText, n.imageUrl,
        n.elementTitle, n.contacts, n.author, n.date);
  }
  factory Newsletter.fromJson(Map<String, dynamic> json, String id) {
    return Newsletter(
      id,
      json['object'] ?? "",
      json['message'] ?? "",
      json['link'] ?? "",
      json['linkText'] ?? "",
      json['imageUrl'] ?? "",
      json['elementTitle'] ?? "",
      List<String>.from(json['contacts'] ?? []),
      json['author'] ?? "",
      (json['date'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "object": object,
      "message": message,
      "link": link,
      "linkText": linkText,
      "imageUrl": imageUrl,
      "elementTitle": elementTitle,
      "contacts": contacts,
      "author": author,
      "date": Timestamp.fromDate(date),
    };
  }
}

Future<List<Newsletter>> fetchDBNewsletters() async {
  return await fetchCollection("Newsletters",
      (data, documentId) => Newsletter.fromJson(data, documentId));
}

Future<void> updateDBNewsletter(Newsletter newsletter) async {
  try {
    await FirebaseFirestore.instance
        .collection('Newsletters')
        .doc(newsletter.id)
        .update(newsletter.toJson());
  } catch (e) {
    print("Error updating newsletter: $e");
  }
}

Future<void> deleteReservation(
    String documentId, Function loading, BuildContext context) async {
  try {
    // Supprime le document avec l'ID spécifié dans la collection donnée
    await FirebaseFirestore.instance
        .collection("Newsletters")
        .doc(documentId)
        .delete();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Newsletter deleted."),
      ),
    );
    loading();
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Error, try later"),
      ),
    );
    loading();
    print("Error deleting document from Newsletters: $e");
  }
}

Future<void> addArticle(
    Newsletter newsletter, BuildContext context, Function loading) async {
  try {
    // Ajoute un nouveau document dans la collection "AdminUsers"
    await FirebaseFirestore.instance
        .collection('Newsletters')
        .add(newsletter.toJson());
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Newsletter added successfully"),
      ),
    );
    loading();
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Error, try later"),
      ),
    );
    loading();
    print("Error adding newsletter: $e");
  }
}
