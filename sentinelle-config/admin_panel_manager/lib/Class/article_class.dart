import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../login-manager/collection_manager.dart';
import '../login-manager/get_user_fonction.dart';
import 'publications_class.dart';

class Article extends Publications {
  String titleFR;
  String smallTitle;
  String smallTitleFR;
  String content;
  String contentFR;
  String linkedinPost;
  bool published; //Que 2 status possible: soit publié, soit brouillons

  Article(
    super.id,
    super.title,
    super.author,
    super.category,
    super.imageUrl,
    super.date,
    this.titleFR,
    this.smallTitle,
    this.smallTitleFR,
    this.content,
    this.contentFR,
    this.linkedinPost,
    this.published,
  );

  factory Article.empty() {
    return Article(
        "", "", "", "", "", DateTime.now(), "", "", "", "", "", "", false);
  }

  factory Article.copy(Article e) {
    return Article(
        e.id,
        e.title,
        e.author,
        e.category,
        e.imageUrl,
        e.date,
        e.titleFR,
        e.smallTitle,
        e.smallTitleFR,
        e.content,
        e.contentFR,
        e.linkedinPost,
        e.published);
  }
  factory Article.fromJson(Map<String, dynamic> json, String id) {
    return Article(
      id,
      json['title'] ?? "",
      json['author'] ?? "",
      json['category'] ?? "",
      json['imageUrl'] ?? "",
      (json['date'] as Timestamp).toDate(),
      json['titleFR'] ?? "",
      json['smallTitle'] ?? "",
      json['smallTitleFR'] ?? "",
      json['content'] ?? "",
      json['contentFR'] ?? "",
      json['linkedinPost'] ?? "",
      json['published'] ?? false,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "titleFR": titleFR,
      "smallTitle": smallTitle,
      "smallTitleFR": smallTitleFR,
      "content": content,
      "contentFR": contentFR,
      "linkedinPost": linkedinPost,
      "imageUrl": imageUrl,
      "category": category,
      "author": author,
      "published": published,
      "date": Timestamp.fromDate(date),
    };
  }
}

Future<List<Article>> fetchDBArticles() async {
  return await fetchCollection(
      "Articles", (data, documentId) => Article.fromJson(data, documentId));
}

Future<void> updateDBArticle(
    Article article, BuildContext context, Function loading) async {
  try {
    await FirebaseFirestore.instance
        .collection('Articles')
        .doc(article.id)
        .update(article.toJson());
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Article updated."),
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
    print("Error updating article: $e");
  }
}

Future<void> deleteDBArticle(
    String documentId, Function loading, BuildContext context) async {
  try {
    // Supprime le document avec l'ID spécifié dans la collection donnée
    await FirebaseFirestore.instance
        .collection("Articles")
        .doc(documentId)
        .delete();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Article deleted."),
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
    print("Error deleting document from Articles: $e");
  }
}

Future<void> addArticle(
    Article article, BuildContext context, Function loading) async {
  try {
    final currentAuthor = await getConnectedUser();
    if (currentAuthor != null) {
      article.author = currentAuthor.displayName();
    }
    // Ajoute un nouveau document dans la collection "AdminUsers"
    await FirebaseFirestore.instance
        .collection('Articles')
        .add(article.toJson());
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Article added successfully"),
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
    print("Error adding article: $e");
  }
}
