import 'dart:convert';
import 'package:admin_panel_manager/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Fonction pour envoyer un email
Future<void> sendEmailAPI({
  required String name,
  required String email,
  required String subject,
  required String message,
  required BuildContext context,
  required Function() loading,
}) async {
  final url = Uri.parse('https://api.brevo.com/v3/smtp/email');
  final headers = {
    'accept': 'application/json',
    'content-type': 'application/json',
    'api-key': brevoKey,
  };

  // Corps de la requête
  final payload = {
    'sender': {
      'name': 'Sahel Politica', // Remplacez par votre nom d'expéditeur
      'email':
          'sentinelle@sahelpolitica.ch', // Remplacez par votre email d'expéditeur
    },
    'to': [
      {
        'email': email,
      }
    ],
    'subject': subject,
    'htmlContent': '''<html>
<head>
  <style>
    body {
      margin: 0;
      padding: 0;
      font-family: Arial, sans-serif;
      background-color: #f4f4f4;
      color: #333;
    }
    .email-container {
      max-width: 600px;
      margin: 20px auto;
      background-color: #fff;
    }
    .header {
      background-color: #ffc107;
      text-align: center;
    }
    .header img {
      max-height: 80px;
    }
    .content {
      padding: 20px;
    }
    .footer {
      background-color: #000;
      color: #fff;
      padding: 15px;
      text-align: center;
      font-size: 14px;
    }
    .footer a {
      color: #ffc107;
      text-decoration: none;
    }
    .footer a:hover {
      text-decoration: underline;
    }
  </style>
</head>
<body>
  <div class="email-container">
    <!-- Header -->
    <div class="header">
      <img src="https://firebasestorage.googleapis.com/v0/b/websitesapo-79e6f.firebasestorage.app/o/logo-email.png?alt=media&token=358a6751-f9d7-48f8-abed-71263066ba5d" alt="Company Logo">
    </div>

    <!-- Content -->
    <div class="content">
      <h2>Hello, $name</h2>
      <p>$message</p>
    </div>

    <!-- Footer -->
    <div class="footer">
      <p>Sahel Politica, Chamerstrasse 172, 6300 Zug</p>
      <p><a href="https://sahelpolitica.ch">Visit our website</a></p>
      <p>© sahel policica, 2025, All rights reserved</p>
    </div>
  </div>
</body>
</html>''',
  };

  try {
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(payload),
    );

    if (response.statusCode == 201) {
      print('Email sent successfully to $email.');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Email sent successfully to $email."),
        ),
      );
      loading();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to send email to $email. Try later"),
        ),
      );
      loading();
      print('Failed to send email to $email: ${response.body}');
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Failed to send email to $email. Try later"),
      ),
    );
    loading();
    print('Exception occurred while sending email to $email: $e');
  }
}

// Fonction pour envoyer un email
Future<void> sendNewsletterEmail({
  required String name,
  required String email,
  required String subject,
  required String message,
  required BuildContext context,
  required Function() loading,
}) async {
  final url = Uri.parse('https://api.brevo.com/v3/smtp/email');
  final headers = {
    'accept': 'application/json',
    'content-type': 'application/json',
    'api-key': brevoKey,
  };

  // Corps de la requête
  final payload = {
    'sender': {
      'name': 'Sahel Politica', // Remplacez par votre nom d'expéditeur
      'email':
          'sentinelle@sahelpolitica.ch', // Remplacez par votre email d'expéditeur
    },
    'to': [
      {
        'email': email,
      }
    ],
    'subject': subject,
    'htmlContent': '''<html>
<head>
  <style>
    body {
      margin: 0;
      padding: 0;
      font-family: Arial, sans-serif;
      background-color: #f4f4f4;
      color: #333;
    }
    .email-container {
      max-width: 600px;
      margin: 20px auto;
      background-color: #fff;
    }
    .header {
      background-color: #ffc107;
      text-align: center;
    }
    .header img {
      max-height: 80px;
    }
    .content {
      padding: 20px;
    }
    .footer {
      background-color: #000;
      color: #fff;
      padding: 15px;
      text-align: center;
      font-size: 14px;
    }
    .footer a {
      color: #ffc107;
      text-decoration: none;
    }
    .footer a:hover {
      text-decoration: underline;
    }
  </style>
</head>
<body>
  <div class="email-container">
    <!-- Header -->
    <div class="header">
      <img src="https://firebasestorage.googleapis.com/v0/b/websitesapo-79e6f.firebasestorage.app/o/logo-email.png?alt=media&token=358a6751-f9d7-48f8-abed-71263066ba5d" alt="Company Logo">
    </div>

    <!-- Content -->
    <div class="content">
      <h2>Hello, $name</h2>
      <p>$message</p>
    </div>

    <!-- Footer -->
    <div class="footer">
      <p>Sahel Politica, Chamerstrasse 172, 6300 Zug</p>
      <p><a href="https://sahelpolitica.ch">Visit our website</a></p>
      <p>© sahel policica, 2025, All rights reserved</p>
    </div>
  </div>
</body>
</html>''',
  };

  try {
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(payload),
    );

    if (response.statusCode == 201) {
      loading();
    } else {
      loading();
      print('Failed to send email to $email: ${response.body}');
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Failed to send email to $email. Try later"),
      ),
    );
    loading();
    print('Exception occurred while sending email to $email: $e');
  }
}
