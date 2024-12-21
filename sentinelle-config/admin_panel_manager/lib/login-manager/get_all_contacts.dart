import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<String>> getContactEmails() async {
  final apiKey = ''; // Remplacez par votre clé API
  final url = Uri.parse('https://api.brevo.com/v3/contacts');
  final headers = {
    'accept': 'application/json',
    'api-key': apiKey,
  };

  final queryParams = {
    'limit': '50',
    'offset': '0',
    'modifiedSince': '2020-09-20T19:20:30+01:00',
  };

  try {
    final response = await http.get(url.replace(queryParameters: queryParams),
        headers: headers);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final contacts = responseData['contacts'] as List;
      return contacts
          .where((contact) => contact['email'] != null)
          .map<String>((contact) => contact['email'] as String)
          .toList();
    } else {
      print('Erreur lors de la récupération des contacts : ${response.body}');
      return [];
    }
  } catch (e) {
    print('Exception lors de la récupération des contacts : $e');
    return [];
  }
}
