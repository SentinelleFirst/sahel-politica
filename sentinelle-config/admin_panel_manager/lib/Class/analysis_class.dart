import 'package:cloud_firestore/cloud_firestore.dart';

import '../login-manager/collection_manager.dart';

class Analysis {
  String id;
  String title;
  String titleFR;
  String subtitle;
  String subtitleFR;
  String resume;
  String resumeFR;
  List<Map<String, String>> preview;
  List<Map<String, String>> previewFR;
  String linkPDFEN;
  String linkPDFFR;
  String imageUrl;
  String category;
  String author;
  bool published;
  DateTime date;

  Analysis(
      this.id,
      this.title,
      this.titleFR,
      this.subtitle,
      this.subtitleFR,
      this.resume,
      this.resumeFR,
      this.preview,
      this.previewFR,
      this.linkPDFEN,
      this.linkPDFFR,
      this.imageUrl,
      this.category,
      this.author,
      this.published,
      this.date);

  factory Analysis.empty() {
    return Analysis(
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      [],
      [],
      "",
      "",
      "",
      "",
      "",
      false,
      DateTime.now(),
    );
  }

  factory Analysis.copy(Analysis e) {
    return Analysis(
        e.id,
        e.title,
        e.titleFR,
        e.subtitle,
        e.subtitleFR,
        e.resume,
        e.resumeFR,
        e.preview,
        e.previewFR,
        e.linkPDFEN,
        e.linkPDFFR,
        e.imageUrl,
        e.category,
        e.author,
        e.published,
        e.date);
  }
  factory Analysis.fromJson(Map<String, dynamic> json) {
    return Analysis(
      json['id'] ?? "",
      json['title'] ?? "",
      json['titleFR'] ?? "",
      json['subtitle'] ?? "",
      json['subtitleFR'] ?? "",
      json['resume'] ?? "",
      json['resumeFR'] ?? "",
      List<Map<String, String>>.from(json['preview'] ?? []),
      List<Map<String, String>>.from(json['previewFR'] ?? []),
      json['linkPDFEN'] ?? "",
      json['linkPDFFR'] ?? "",
      json['imageUrl'] ?? "",
      json['category'] ?? "",
      json['author'] ?? "",
      json['published'] ?? false,
      (json['date'] as Timestamp).toDate(),
    );
  }
}

Future<List<Analysis>> fetchDBAnalysis() async {
  return await fetchCollection("Reports", (data) => Analysis.fromJson(data));
}
