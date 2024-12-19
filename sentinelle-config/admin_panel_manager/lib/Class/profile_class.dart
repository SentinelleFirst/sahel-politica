import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../login-manager/collection_manager.dart';

class Profile {
  String id;
  String firstname;
  String lastname;
  String email;
  String post;
  Map<String, Map<String, bool>> access;
  DateTime dateOfCreation;

  Profile(this.id, this.firstname, this.lastname, this.email, this.post,
      this.access, this.dateOfCreation);

  factory Profile.empty() {
    Profile p = Profile("", "", "", "", "Custom", {}, DateTime.now());
    p.initCustomAccess();
    return p;
  }

  factory Profile.copy(Profile p) {
    return Profile(p.id, p.firstname, p.lastname, p.email, p.post, p.access,
        p.dateOfCreation);
  }

  void initAdminAccess() {
    Map<String, bool> analyticsPage = {
      "view": true,
    };
    Map<String, bool> articlesPage = {
      "view": true,
      "publish": true,
      "edit": true,
      "create": true,
      "delete": true,
    };
    Map<String, bool> analysisPage = {
      "view": true,
      "publish": true,
      "edit": true,
      "create": true,
      "delete": true,
    };
    Map<String, bool> eventsPage = {
      "view": true,
      "publish": true,
      "edit": true,
      "delete": true,
    };
    Map<String, bool> messagesPage = {
      "view": true,
      "publish": true,
      "delete": true,
    };
    Map<String, bool> reservationsPage = {
      "view": true,
      "publish": true,
      "edit": true,
      "delete": true,
    };
    Map<String, bool> newslettersPage = {
      "view": true,
      "publish": true,
      "edit": true,
      "create": true,
      "delete": true,
    };

    access.addAll({
      "Analytics": analyticsPage,
      "Articles": articlesPage,
      "In-dept analysis": analysisPage,
      "Events": eventsPage,
      "Messages": messagesPage,
      "Reservations": reservationsPage,
      "Newsletters": newslettersPage,
    });
  }

  void initITAccess() {
    Map<String, bool> analyticsPage = {
      "view": true,
    };
    Map<String, bool> articlesPage = {
      "view": true,
      "publish": true,
      "edit": true,
      "create": true,
      "delete": true,
    };
    Map<String, bool> analysisPage = {
      "view": true,
      "publish": true,
      "edit": true,
      "create": true,
      "delete": true,
    };
    Map<String, bool> eventsPage = {
      "view": true,
      "publish": true,
      "edit": true,
      "delete": true,
    };
    Map<String, bool> messagesPage = {
      "view": true,
      "publish": true,
      "delete": true,
    };
    Map<String, bool> reservationsPage = {
      "view": true,
      "publish": true,
      "edit": true,
      "delete": true,
    };
    Map<String, bool> newslettersPage = {
      "view": true,
      "publish": true,
      "edit": true,
      "create": true,
      "delete": true,
    };

    access.addAll({
      "Analytics": analyticsPage,
      "Articles": articlesPage,
      "In-dept analysis": analysisPage,
      "Events": eventsPage,
      "Messages": messagesPage,
      "Reservations": reservationsPage,
      "Newsletters": newslettersPage,
    });
  }

  void initCMAccess() {
    Map<String, bool> analyticsPage = {
      "view": true,
    };
    Map<String, bool> articlesPage = {
      "view": false,
      "publish": false,
      "edit": false,
      "create": false,
      "delete": false,
    };
    Map<String, bool> analysisPage = {
      "view": false,
      "publish": false,
      "edit": false,
      "create": false,
      "delete": false,
    };
    Map<String, bool> eventsPage = {
      "view": true,
      "publish": true,
      "edit": true,
      "delete": true,
    };
    Map<String, bool> messagesPage = {
      "view": true,
      "publish": true,
      "delete": true,
    };
    Map<String, bool> reservationsPage = {
      "view": true,
      "publish": true,
      "edit": true,
      "delete": true,
    };
    Map<String, bool> newslettersPage = {
      "view": true,
      "publish": true,
      "edit": true,
      "create": true,
      "delete": true,
    };

    access.clear();

    access.addAll({
      "Analytics": analyticsPage,
      "Articles": articlesPage,
      "In-dept analysis": analysisPage,
      "Events": eventsPage,
      "Messages": messagesPage,
      "Reservations": reservationsPage,
      "Newsletters": newslettersPage,
    });
  }

  void initEditorAccess() {
    Map<String, bool> analyticsPage = {
      "view": false,
    };
    Map<String, bool> articlesPage = {
      "view": true,
      "publish": true,
      "edit": true,
      "create": true,
      "delete": true,
    };
    Map<String, bool> analysisPage = {
      "view": true,
      "publish": true,
      "edit": true,
      "create": true,
      "delete": true,
    };
    Map<String, bool> eventsPage = {
      "view": false,
      "publish": false,
      "edit": false,
      "delete": false,
    };
    Map<String, bool> messagesPage = {
      "view": false,
      "publish": false,
      "delete": false,
    };
    Map<String, bool> reservationsPage = {
      "view": false,
      "publish": false,
      "edit": false,
      "delete": false,
    };
    Map<String, bool> newslettersPage = {
      "view": false,
      "publish": false,
      "edit": false,
      "create": false,
      "delete": false,
    };

    access.clear();

    access.addAll({
      "Analytics": analyticsPage,
      "Articles": articlesPage,
      "In-dept analysis": analysisPage,
      "Events": eventsPage,
      "Messages": messagesPage,
      "Reservations": reservationsPage,
      "Newsletters": newslettersPage,
    });
  }

  void initCustomAccess() {
    Map<String, bool> analyticsPage = {
      "view": true,
    };
    Map<String, bool> articlesPage = {
      "view": true,
      "publish": false,
      "edit": false,
      "create": false,
      "delete": false,
    };
    Map<String, bool> analysisPage = {
      "view": true,
      "publish": false,
      "edit": false,
      "create": false,
      "delete": false,
    };
    Map<String, bool> eventsPage = {
      "view": true,
      "publish": false,
      "edit": false,
      "delete": false,
    };
    Map<String, bool> messagesPage = {
      "view": true,
      "publish": false,
      "delete": false,
    };
    Map<String, bool> reservationsPage = {
      "view": true,
      "publish": false,
      "edit": false,
      "delete": false,
    };
    Map<String, bool> newslettersPage = {
      "view": true,
      "publish": false,
      "edit": false,
      "create": false,
      "delete": false,
    };

    access.clear();

    access.addAll({
      "Analytics": analyticsPage,
      "Articles": articlesPage,
      "In-dept analysis": analysisPage,
      "Events": eventsPage,
      "Messages": messagesPage,
      "Reservations": reservationsPage,
      "Newsletters": newslettersPage,
    });
  }

  void setAcces(String page, String action, bool active) {
    access[page]![action] = active;
  }

  bool getAcces(String page, String action) {
    return access[page]![action]!;
  }

  String displayName() {
    return '$firstname $lastname';
  }

  factory Profile.fromJson(Map<String, dynamic> json, String id) {
    Map<String, Map<String, bool>> parsedAccess = {};
    if (json['access'] != null) {
      json['access'].forEach((key, value) {
        parsedAccess[key] = Map<String, bool>.from(value as Map);
      });
    }

    return Profile(
      id,
      json['firstname'] ?? "",
      json['lastname'] ?? "",
      json['email'] ?? "",
      json['post'] ?? "Custom",
      parsedAccess,
      (json['dateOfCreation'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "firstname": firstname,
      "lastname": lastname,
      "email": email,
      "post": post,
      "access": access,
      "dateOfCreation": Timestamp.fromDate(dateOfCreation),
    };
  }
}

Future<List<Profile>> fetchDBProfiles() async {
  return await fetchCollection(
      "AdminUsers", (data, documentId) => Profile.fromJson(data, documentId));
}

Future<void> updateDBProfile(
    Profile profile, BuildContext context, Function loading) async {
  try {
    await FirebaseFirestore.instance
        .collection('AdminUsers')
        .doc(profile.id)
        .update(profile.toJson());
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Modification saved."),
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
    print("Error updating other class: $e");
  }
}
