import 'package:cloud_firestore/cloud_firestore.dart';

import '../login-manager/collection_manager.dart';

class Message {
  String id;
  String email;
  String fistname;
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
      this.fistname,
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
    return '$fistname $lastname';
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      json['id'] ?? "",
      json['email'] ?? "",
      json['fistname'] ?? "",
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
}

Future<List<Message>> fetchDBMessages() async {
  return await fetchCollection(
      "ContactFormMessage", (data) => Message.fromJson(data));
}
