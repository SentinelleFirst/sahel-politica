import 'package:admin_panel_manager/Class/contacts_class.dart';
import 'package:admin_panel_manager/login-manager/get_user_fonction.dart';
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
  List<ContactClass> contacts;
  String author;
  DateTime date;
  bool allContacts;

  Newsletter(
      this.id,
      this.object,
      this.message,
      this.link,
      this.linkText,
      this.imageUrl,
      this.elementTitle,
      this.contacts,
      this.author,
      this.date,
      this.allContacts);

  factory Newsletter.empty() {
    return Newsletter(
        "", "", "", "", "", "", "", [], "", DateTime.now(), false);
  }

  factory Newsletter.copy(Newsletter n) {
    return Newsletter(n.id, n.object, n.message, n.link, n.linkText, n.imageUrl,
        n.elementTitle, n.contacts, n.author, n.date, n.allContacts);
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
      (json['contacts'] as List<dynamic>)
          .map((contactJson) =>
              ContactClass.fromJson(contactJson as Map<String, dynamic>))
          .toList(),
      json['author'] ?? "",
      (json['date'] as Timestamp).toDate(),
      json['allContacts'] ?? false,
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
      "contacts": contacts.map((contact) => contact.toJson()).toList(),
      "author": author,
      "date": Timestamp.fromDate(date),
      "allContacts": allContacts,
    };
  }
}

Future<List<Newsletter>> fetchDBNewsletters() async {
  return await fetchCollection("Newsletters",
      (data, documentId) => Newsletter.fromJson(data, documentId));
}

Future<void> updateDBNewsletter(
    Newsletter newsletter, BuildContext context, Function loading) async {
  try {
    await FirebaseFirestore.instance
        .collection('Newsletters')
        .doc(newsletter.id)
        .update(newsletter.toJson());

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Newsletter updated successfully"),
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
    print("Error updating newsletter: $e");
  }
}

Future<void> deleteDBNewsletter(
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

Future<void> addDBNewsletter(
    Newsletter newsletter, BuildContext context, Function loading) async {
  try {
    final currentAuthor = await getConnectedUser();
    if (currentAuthor != null) {
      newsletter.author = currentAuthor.displayName();
    }
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
