import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../login-manager/collection_manager.dart';

class Message {
  String id;
  String email;
  String firstname;
  String lastname;
  String company;
  String phone;
  String object;
  String message;
  String answer;
  DateTime date;
  bool readStatus;

  Message(
      this.id,
      this.email,
      this.firstname,
      this.lastname,
      this.company,
      this.phone,
      this.object,
      this.message,
      this.answer,
      this.date,
      this.readStatus);

  void markRead() {
    readStatus = true;
  }

  void markUnread() {
    readStatus = false;
  }

  String displayName() {
    return '$firstname $lastname';
  }

  factory Message.fromJson(Map<String, dynamic> json, String id) {
    return Message(
      id,
      json['email'] ?? "",
      json['firstname'] ?? "",
      json['lastname'] ?? "",
      json['company'] ?? "",
      json['phone'] ?? "",
      json['object'] ?? "",
      json['message'] ?? "",
      json['answer'] ?? "",
      (json['date'] as Timestamp).toDate(),
      json['readStatus'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "firstname": firstname,
      "lastname": lastname,
      "company": company,
      "phone": phone,
      "object": object,
      "message": message,
      "answer": answer,
      "date": Timestamp.fromDate(date),
      "readStatus": readStatus,
    };
  }
}

Future<List<Message>> fetchDBMessages() async {
  return await fetchCollection("ContactFormMessage",
      (data, documentId) => Message.fromJson(data, documentId));
}

Future<void> updateDBMessage(Message message) async {
  try {
    await FirebaseFirestore.instance
        .collection('ContactFormMessage')
        .doc(message.id)
        .update(message.toJson());
  } catch (e) {
    print("Error updating message : $e");
  }
}

Future<void> deleteReservation(
    String documentId, Function loading, BuildContext context) async {
  try {
    // Supprime le document avec l'ID spécifié dans la collection donnée
    await FirebaseFirestore.instance
        .collection("ContactFormMessage")
        .doc(documentId)
        .delete();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Message deleted."),
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
    print("Error deleting document from ContactFormMessage: $e");
  }
}
