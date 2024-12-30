import 'package:cloud_firestore/cloud_firestore.dart';

class Publications {
  String id;
  String title;
  String author;
  String category;
  String imageUrl;
  DateTime date;

  Publications(this.id, this.title, this.author, this.category, this.imageUrl,
      this.date);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'category': category,
      'imageUrl': imageUrl,
      'date': Timestamp.fromDate(date),
    };
  }

  factory Publications.fromJson(Map<String, dynamic> json) {
    return Publications(
      json['id'],
      json['title'],
      json['author'],
      json['category'],
      json['imageUrl'],
      (json['date'] as Timestamp).toDate(),
    );
  }
}
