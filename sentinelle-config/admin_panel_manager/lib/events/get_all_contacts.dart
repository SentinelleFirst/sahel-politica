import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<String>> getContactEmails() async {
  final apiKey =
      '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'; // Remplacez par votre clé API
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
