import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Reservation {
  String id;
  String firstname;
  String lastname;
  String phone;
  String company;
  String email;
  String linkmeet;
  String location;
  String service;
  String message;
  Map answer;
  String statue;
  DateTime emissionDate;
  DateTime reservationDate;

  Reservation(
      this.id,
      this.firstname,
      this.lastname,
      this.phone,
      this.company,
      this.email,
      this.linkmeet,
      this.location,
      this.service,
      this.message,
      this.answer,
      this.statue,
      this.emissionDate,
      this.reservationDate);

  factory Reservation.empty() {
    return Reservation(
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      {},
      "",
      DateTime.now(),
      DateTime.now(),
    );
  }

  factory Reservation.copy(Reservation r) {
    return Reservation(
        r.id,
        r.firstname,
        r.lastname,
        r.phone,
        r.company,
        r.email,
        r.linkmeet,
        r.location,
        r.service,
        r.message,
        r.answer,
        r.statue,
        r.emissionDate,
        r.reservationDate);
  }

  // Conversion d'un document Firestore en une instance de Reservation
  factory Reservation.fromJson(String id, Map<String, dynamic> data) {
    return Reservation(
      id,
      data['firstname'] ?? "",
      data['lastname'] ?? "",
      data['phone'] ?? "",
      data['company'] ?? "",
      data['email'] ?? "",
      data['linkmeet'] ?? "",
      data['location'] ?? "",
      data['service'] ?? "",
      data['message'] ?? "",
      Map<String, dynamic>.from(data['answers'] ?? {}), // Conversion sûre
      data['statue'] ?? "",
      (data['emissionDate'] as Timestamp).toDate(),
      (data['reservationDate'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "firstname": firstname,
      "lastname": lastname,
      "phone": phone,
      "company": company,
      "email": email,
      "linkmeet": linkmeet,
      "location": location,
      "service": service,
      "message": message,
      "answer": answer,
      "statue": statue,
      "emissionDate":
          Timestamp.fromDate(emissionDate), // Conversion en Timestamp
      "reservationDate":
          Timestamp.fromDate(reservationDate), // Conversion en Timestamp
    };
  }

  bool isPending() {
    return statue == 'Pending';
  }

  void setPending() {
    statue = 'Pending';
  }

  bool isConfirmed() {
    return statue == 'Confirmed';
  }

  void setConfirmed() {
    statue = 'Confirmed';
  }

  bool isCanceled() {
    return statue == 'Canceled';
  }

  void setCanceled() {
    statue = 'Canceled';
  }

  bool isPassed() {
    return statue == 'Passed';
  }

  void setPassed() {
    statue = 'Passed';
  }

  String displayName() {
    return '$firstname $lastname';
  }

  String displayAnswers() {
    String a = "";
    for (var i = 0; i < answer.entries.length; i++) {
      a += "${i + 1} - ${answer.entries.toList()[i].key}\n";
      a += "${answer.entries.toList()[i].value}\n";
      if (i != answer.entries.length - 1) {
        a += "\n";
      }
    }
    return a;
  }
}

Future<List<Reservation>> fetchDBReservations() async {
  try {
    // Récupère tous les documents de la collection "Reservations"
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('Reservations').get();

    // Convertit chaque document en une instance de Reservation
    return querySnapshot.docs.map((doc) {
      return Reservation.fromJson(doc.id, doc.data() as Map<String, dynamic>);
    }).toList();
  } catch (e) {
    print("Error fetching reservations: $e");
    return []; // Retourne une liste vide en cas d'erreur
  }
}

Future<void> updateDBReservation(Reservation reservation) async {
  try {
    await FirebaseFirestore.instance
        .collection('Reservations')
        .doc(reservation.id)
        .update(reservation.toJson());
  } catch (e) {
    print("Error updating reservation: $e");
  }
}

Future<void> deleteReservation(
    String documentId, Function loading, BuildContext context) async {
  try {
    // Supprime le document avec l'ID spécifié dans la collection donnée
    await FirebaseFirestore.instance
        .collection("Reservations")
        .doc(documentId)
        .delete();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Reservation deleted."),
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
    print("Error deleting document from Reservation: $e");
  }
}
