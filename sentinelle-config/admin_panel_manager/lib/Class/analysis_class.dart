import 'package:admin_panel_manager/Class/publications_class.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../login-manager/collection_manager.dart';
import '../login-manager/get_user_fonction.dart';

class Analysis extends Publications {
  String titleFR;
  String subtitle;
  String subtitleFR;
  String resume;
  String resumeFR;
  List<Map<String, String>> preview;
  List<Map<String, String>> previewFR;
  String linkPDFEN;
  String linkPDFFR;
  bool published;

  Analysis(
    super.id,
    super.title,
    super.author,
    super.category,
    super.imageUrl,
    super.date,
    this.titleFR,
    this.subtitle,
    this.subtitleFR,
    this.resume,
    this.resumeFR,
    this.preview,
    this.previewFR,
    this.linkPDFEN,
    this.linkPDFFR,
    this.published,
  );

  factory Analysis.empty() {
    return Analysis("", "", "", "", "", DateTime.now(), "", "", "", "", "", [],
        [], "", "", false);
  }

  factory Analysis.copy(Analysis e) {
    return Analysis(
        e.id,
        e.title,
        e.author,
        e.category,
        e.imageUrl,
        e.date,
        e.titleFR,
        e.subtitle,
        e.subtitleFR,
        e.resume,
        e.resumeFR,
        e.preview,
        e.previewFR,
        e.linkPDFEN,
        e.linkPDFFR,
        e.published);
  }
  factory Analysis.fromJson(Map<String, dynamic> json, String id) {
    return Analysis(
      id,
      json['title'] ?? "",
      json['author'] ?? "",
      json['category'] ?? "",
      json['imageUrl'] ?? "",
      (json['date'] as Timestamp).toDate(),
      json['titleFR'] ?? "",
      json['subtitle'] ?? "",
      json['subtitleFR'] ?? "",
      json['resume'] ?? "",
      json['resumeFR'] ?? "",
      (json['preview'] as List<dynamic>? ?? [])
          .map((item) => Map<String, String>.from(item as Map))
          .toList(),
      (json['previewFR'] as List<dynamic>? ?? [])
          .map((item) => Map<String, String>.from(item as Map))
          .toList(),
      json['linkPDFEN'] ?? "",
      json['linkPDFFR'] ?? "",
      json['published'] ?? false,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "titleFR": titleFR,
      "subtitle": subtitle,
      "subtitleFR": subtitleFR,
      "resume": resume,
      "resumeFR": resumeFR,
      "preview": preview,
      "previewFR": previewFR,
      "linkPDFEN": linkPDFEN,
      "linkPDFFR": linkPDFFR,
      "imageUrl": imageUrl,
      "category": category,
      "author": author,
      "published": published,
      "date": Timestamp.fromDate(date), // Conversion en Timestamp
    };
  }
}

Future<List<Analysis>> fetchDBAnalysis() async {
  return await fetchCollection(
      "Reports", (data, documentId) => Analysis.fromJson(data, documentId));
}

Future<void> updateDBAnalysis(
    Analysis analysis, BuildContext context, Function loading) async {
  try {
    await FirebaseFirestore.instance
        .collection('Reports')
        .doc(analysis.id)
        .update(analysis.toJson());
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Analysis updated."),
      ),
    );
    loading();
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Error, try later"),
      ),
    );
    print("Error updating analysis: $e");
  }
}

Future<void> deleteDBAnalysis(
    String documentId, Function loading, BuildContext context) async {
  try {
    // Supprime le document avec l'ID spécifié dans la collection donnée
    await FirebaseFirestore.instance
        .collection("Reports")
        .doc(documentId)
        .delete();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Analysis deleted."),
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
    print("Error deleting document from Reports: $e");
  }
}

Future<void> addAnalysis(
    Analysis analysis, BuildContext context, Function loading) async {
  try {
    final currentAuthor = await getConnectedUser();
    if (currentAuthor != null) {
      analysis.author = currentAuthor.displayName();
    }
    // Ajoute un nouveau document dans la collection "AdminUsers"
    await FirebaseFirestore.instance
        .collection('Reports')
        .add(analysis.toJson());
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Analysis added successfully"),
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
    print("Error adding analysis: $e");
  }
}
