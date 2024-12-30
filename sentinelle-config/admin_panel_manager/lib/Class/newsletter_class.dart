import 'package:admin_panel_manager/Class/analysis_class.dart';
import 'package:admin_panel_manager/Class/article_class.dart';
import 'package:admin_panel_manager/Class/contacts_class.dart';
import 'package:admin_panel_manager/Class/event_class.dart';
import 'package:admin_panel_manager/login-manager/get_user_fonction.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../login-manager/collection_manager.dart';
import 'publications_class.dart';

class Newsletter {
  String id;
  String object;
  String message;
  String link;
  String linkText;
  Event? event;
  Article? article;
  Analysis? analysis;
  List<Publications> publications;
  List<ContactClass> contacts;
  String author;
  DateTime date;
  bool allContacts;
  int type; //Type d'annonce => 1 pour un event / 2 pour un article / 3 pour un analysis / 4 pour plusieurs annonces / 5 pour une simple annonce

  Newsletter(
      this.id,
      this.object,
      this.message,
      this.link,
      this.linkText,
      this.event,
      this.article,
      this.analysis,
      this.publications,
      this.contacts,
      this.author,
      this.date,
      this.allContacts,
      this.type);

  factory Newsletter.empty() {
    return Newsletter("", "", "", "", "", Event.empty(), Article.empty(),
        Analysis.empty(), [], [], "", DateTime.now(), false, 5);
  }

  factory Newsletter.copy(Newsletter n) {
    return Newsletter(
        n.id,
        n.object,
        n.message,
        n.link,
        n.linkText,
        n.event,
        n.article,
        n.analysis,
        n.publications,
        n.contacts,
        n.author,
        n.date,
        n.allContacts,
        n.type);
  }
  factory Newsletter.fromJson(Map<String, dynamic> json, String id) {
    return Newsletter(
        id,
        json['object'] ?? "",
        json['message'] ?? "",
        json['link'] ?? "",
        json['linkText'] ?? "",
        Event.fromJson(json['event'], ""),
        Article.fromJson(json['article'], ""),
        Analysis.fromJson(json['analysis'], ""),
        (json['publications'] as List<dynamic>)
            .map((contactJson) =>
                Publications.fromJson(contactJson as Map<String, dynamic>))
            .toList(),
        (json['contacts'] as List<dynamic>)
            .map((contactJson) =>
                ContactClass.fromJson(contactJson as Map<String, dynamic>))
            .toList(),
        json['author'] ?? "",
        (json['date'] as Timestamp).toDate(),
        json['allContacts'] ?? false,
        json['type']);
  }

  Map<String, dynamic> toJson() {
    return {
      "object": object,
      "message": message,
      "link": link,
      "linkText": linkText,
      "event": event != null ? event!.toJson() : {},
      "article": article != null ? article!.toJson() : {},
      "analysis": analysis != null ? analysis!.toJson() : {},
      "publications":
          publications.map((publication) => publication.toJson()).toList(),
      "contacts": contacts.map((contact) => contact.toJson()).toList(),
      "author": author,
      "date": Timestamp.fromDate(date),
      "allContacts": allContacts,
      "type": type,
    };
  }

  bool isEventNewsletter() {
    return type == 1;
  }

  bool isArticleNewsletter() {
    return type == 2;
  }

  bool isAnalysisNewsletter() {
    return type == 3;
  }

  bool isMultiplePublicationNewsletter() {
    return type == 4;
  }

  bool isSimpleNewsletter() {
    return type == 5;
  }

  void changeTypeInEventNewsletter() {
    article = null;
    analysis = null;
    publications = [];
    type = 1;
  }

  void changeTypeInArticleNewsletter() {
    event = null;
    analysis = null;
    publications = [];
    type = 2;
  }

  void changeTypeInAnalysisNewsletter() {
    event = null;
    article = null;
    publications = [];
    type = 3;
  }

  void changeTypeInMultiplePublicationNewsletter() {
    event = null;
    article = null;
    analysis = null;
    type = 4;
  }

  void changeTypeInSimpleNewsletter() {
    event = null;
    article = null;
    analysis = null;
    publications = [];
    type = 5;
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
