import 'package:cloud_firestore/cloud_firestore.dart';

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
  factory Newsletter.fromJson(Map<String, dynamic> json) {
    return Newsletter(
      json['id'] ?? "",
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
}

Future<List<Newsletter>> fetchDBNewsletters() async {
  return await fetchCollection(
      "Newsletters", (data) => Newsletter.fromJson(data));
}
