import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../login-manager/collection_manager.dart';

class Event {
  late String id;
  late String title;
  late String titleFR;
  late String smallTitle;
  late String smallTitleFR;
  late String location;
  late String linkedinPost;
  late String imageUrl;
  late String category;
  late DateTime start;
  late DateTime end;

  Event(
      this.id,
      this.title,
      this.titleFR,
      this.smallTitle,
      this.smallTitleFR,
      this.location,
      this.linkedinPost,
      this.imageUrl,
      this.category,
      this.start,
      this.end);

  factory Event.empty() {
    return Event(
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      DateTime.now(),
      DateTime.now(),
    );
  }

  factory Event.copy(Event e) {
    return Event(
      e.id,
      e.title,
      e.titleFR,
      e.smallTitle,
      e.smallTitleFR,
      e.location,
      e.linkedinPost,
      e.imageUrl,
      e.category,
      e.start,
      e.end,
    );
  }
  factory Event.fromJson(Map<String, dynamic> json, String id) {
    return Event(
      id,
      json['title'] ?? "",
      json['titleFR'] ?? "",
      json['smallTitle'] ?? "",
      json['smallTitleFR'] ?? "",
      json['location'] ?? "",
      json['linkedinPost'] ?? "",
      json['imageUrl'] ?? "",
      json['category'] ?? "",
      (json['start'] as Timestamp).toDate(),
      (json['end'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "titleFR": titleFR,
      "smallTitle": smallTitle,
      "smallTitleFR": smallTitleFR,
      "location": location,
      "linkedinPost": linkedinPost,
      "imageUrl": imageUrl,
      "category": category,
      "start": Timestamp.fromDate(start),
      "end": Timestamp.fromDate(end),
    };
  }
}

Future<List<Event>> fetchDBEvents() async {
  return await fetchCollection(
      "Events", (data, documentId) => Event.fromJson(data, documentId));
}

Future<void> updateDBEvent(Event event) async {
  try {
    await FirebaseFirestore.instance
        .collection('Events')
        .doc(event.id)
        .update(event.toJson());
  } catch (e) {
    print("Error updating Event: $e");
  }
}

Future<void> deleteReservation(
    String documentId, Function loading, BuildContext context) async {
  try {
    // Supprime le document avec l'ID spécifié dans la collection donnée
    await FirebaseFirestore.instance
        .collection("Events")
        .doc(documentId)
        .delete();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Event deleted."),
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
    print("Error deleting document from Events: $e");
  }
}

Future<void> addArticle(
    Event event, BuildContext context, Function loading) async {
  try {
    // Ajoute un nouveau document dans la collection "AdminUsers"
    await FirebaseFirestore.instance.collection('Events').add(event.toJson());
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Event added successfully"),
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
    print("Error adding event: $e");
  }
}
