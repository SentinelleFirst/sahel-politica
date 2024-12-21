import 'dart:convert';
import 'package:admin_panel_manager/login-manager/get_user_fonction.dart';
import 'package:http/http.dart' as http;

Future<void> sendEmailCampaign(
    {required String subject,
    required List<Map<String, String>> recipientEmails,
    required String content}) async {
  final currentUser = await getConnectedUser();
  final senderName = currentUser!.displayName();
  const senderEmail = "sidibesaydil@gmail.com";
  const apiKey = '';
  final url = Uri.parse('https://api.brevo.com/v3/smtp/email');
  final headers = {
    'accept': 'application/json',
    'content-type': 'application/json',
    'api-key': apiKey,
  };

  String htmlContent = '<html><body><h1>$content</h1></body></html>';
  // Construct the payload
  final payload = {
    'sender': {
      'name': senderName,
      'email': senderEmail,
    },
    'to': recipientEmails,
    'subject': subject,
    'htmlContent': htmlContent,
    // Optional fields (can be removed if not needed)
    'bcc': [],
    'cc': [],
    'replyTo': {
      'email': senderEmail,
      'name': senderName,
    },
    'headers': {
      'Some-Custom-Name': 'unique-id-1234',
    },
    'params': {
      'parameter': 'My param value',
      'subject': 'New Subject',
    },
  };

  try {
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(payload),
    );

    if (response.statusCode == 201) {
      print('Email campaign sent successfully.');
    } else {
      print('Error sending email campaign: ${response.body}');
    }
  } catch (e) {
    print('Exception during email campaign: $e');
  }
}
