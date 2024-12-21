import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<void> deleteContact(
    String email, Function() loading, BuildContext context) async {
  final apiKey = ''; // Remplacez par votre clé API
  final url = Uri.parse('https://api.brevo.com/v3/contacts/$email');
  final headers = {
    'accept': 'application/json',
    'api-key': apiKey,
  };

  try {
    final response = await http.delete(url, headers: headers);

    if (response.statusCode == 204) {
      print('Contact supprimé avec succès.');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Contact deleted."),
        ),
      );
    } else {
      print('Erreur lors de la suppression du contact : ${response.body}');
    }
    loading();
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Error, try later"),
      ),
    );
    print('Exception lors de la suppression du contact : $e');
  }
}
