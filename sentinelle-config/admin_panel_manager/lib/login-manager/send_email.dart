import 'dart:convert';
import 'package:admin_panel_manager/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../Class/reservation_class.dart';

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
<body style="margin: 0; padding: 0; font-family: Arial, sans-serif; background-color: #f4f4f4; color: #333;">
    <table style="width: 100%; background-color: #f4f4f4; padding: 20px 0;" cellpadding="0" cellspacing="0">
        <tr>
            <td align="center">
                <!-- Header -->
                <table style="max-width: 800px; width: 100%; border-radius: 10px;" cellpadding="0" cellspacing="0">
                    <tr>
                        <td style="padding: 20px; text-align: center;">
                            <table cellpadding="0" cellspacing="0" style="width: 100%; text-align: center;">
                                <tr>
                                    <td style="text-align: center;">
                                        <img src="https://firebasestorage.googleapis.com/v0/b/websitesapo-79e6f.firebasestorage.app/o/emails_image%2Ffavicon.png?alt=media&token=f71ed7c4-cb64-4043-995b-7b52da5575e6" alt="Company Logo" style="max-height: 60px; display: block; margin: 0 auto;">
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align: center;">
                                        <h2 style="margin: 10px 0 5px; font-family: Arial, sans-serif; font-weight: bold;">Sahel Politica</h2>
                                        <h4 style="margin: 5px 0; font-family: Arial, sans-serif; font-weight: bold;">Navigating risk, Ensuring impact</h4>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
                <!-- Content -->
                <table style=" margin-top: 20px; max-width: 800px; width: 100%; background-color: #fff; border-radius: 10px;" cellpadding="0" cellspacing="0">
                    <tr>
                        <td style="padding: 30px; text-align: center;">
                            <h2 style="font-family: Arial, sans-serif; margin: 0;">Hi, $name</h2>
                        </td>
                    </tr>
                    <tr>
                        <td style="padding: 30px; text-align: start;">
                            <p style="font-family: Arial, sans-serif; font-size: 18px; margin: 20px 0;">$message</p>
                        </td>
                    </tr>
                </table>

                <!-- Footer -->
                <table style="max-width: 800px; width: 100%; background-color: #000; border-radius: 20px; color: #fff; text-align: center; margin-top: 20px;" cellpadding="0" cellspacing="0">
                    <tr>
                        <td style="padding: 15px;">
                            <p style="font-family: Arial, sans-serif; font-size: 15px; margin: 0;">Sahel Politica, Chamerstrasse 172, 6300 Zug</p>
                            <p style="font-family: Arial, sans-serif; font-size: 15px; margin: 10px 0;">Don't like these emails? <a href="#" target="_blank" style="color: #ffc107; text-decoration: none;">Unsubscribe</a></p>
                            <p style="font-family: Arial, sans-serif; font-size: 15px; margin: 10px 0;"><a href="https://sahelpolitica.ch" target="_blank" style="color: #ffc107; text-decoration: none;">Visit our website</a></p>

                            <table style="width: auto; margin: 10px auto;" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td style="padding: 0 5px;">
                                        <a href="https://www.linkedin.com/company/sahelpolitica/" target="_blank">
                                            <img src="https://firebasestorage.googleapis.com/v0/b/websitesapo-79e6f.firebasestorage.app/o/emails_image%2Flinkedin.png?alt=media&token=97c3ae0a-18ab-431b-9fe9-2f9274c018c5" alt="LinkedIn" style="width: 50px;">
                                        </a>
                                    </td>
                                    <td style="padding: 0 5px;">
                                        <a href="https://x.com/SahelPolitica" target="_blank">
                                            <img src="https://firebasestorage.googleapis.com/v0/b/websitesapo-79e6f.firebasestorage.app/o/emails_image%2Fx.png?alt=media&token=d490dadd-a108-41af-a8ba-95dc2bf20c56" alt="X" style="width: 50px;">
                                        </a>
                                    </td>
                                    <td style="padding: 0 5px;">
                                        <a href="https://www.youtube.com/@SahelPolitica_A" target="_blank">
                                            <img src="https://firebasestorage.googleapis.com/v0/b/websitesapo-79e6f.firebasestorage.app/o/emails_image%2Fyoutube.png?alt=media&token=c03224ae-e0f2-4d55-83a1-2c8dbdfd2a2b" alt="YouTube" style="width: 50px;">
                                        </a>
                                    </td>
                                </tr>
                            </table>

                            <p style="font-family: Arial, sans-serif; font-size: 15px; margin: 10px 0;">© Sahel Politica, 2025, All rights reserved</p>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</body>
</html>
''',
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

// Fonction pour envoyer un email
Future<void> sendReservationConfirmationEmail({
  required Reservation reservation,
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
        'email': reservation.email,
      }
    ],
    'subject': "Appointments confirmed",
    'htmlContent': '''<html>

<body style="margin: 0; padding: 0; font-family: Arial, sans-serif; background-color: #f4f4f4; color: #333;">
    <table style="width: 100%; background-color: #f4f4f4; padding: 20px 0;" cellpadding="0" cellspacing="0">
        <tr>
            <td align="center">
                <!-- Header -->
                <table style="max-width: 800px; width: 100%; border-radius: 10px;" cellpadding="0" cellspacing="0">
                    <tr>
                        <td style="padding: 20px; text-align: center;">
                            <table cellpadding="0" cellspacing="0" style="width: 100%; text-align: center;">
                                <tr>
                                    <td style="text-align: center;">
                                        <img src="https://firebasestorage.googleapis.com/v0/b/websitesapo-79e6f.firebasestorage.app/o/emails_image%2Ffavicon.png?alt=media&token=f71ed7c4-cb64-4043-995b-7b52da5575e6"
                                            alt="Company Logo"
                                            style="max-height: 60px; display: block; margin: 0 auto;">
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align: center;">
                                        <h2
                                            style="margin: 10px 0 5px; font-family: Arial, sans-serif; font-weight: bold;">
                                            Sahel Politica</h2>
                                        <h4 style="margin: 5px 0; font-family: Arial, sans-serif; font-weight: bold;">
                                            Navigating risk, Ensuring impact</h4>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
                <!-- Content -->
                <table
                    style=" margin-top: 20px; max-width: 800px; width: 100%; background-color: #fff; border-radius: 10px;"
                    cellpadding="0" cellspacing="0">
                    <tr>
                        <td style="padding: 30px; text-align: center;">
                            <h2 style="font-family: Arial, sans-serif; margin: 0;">RESERVATION CONFIRMATION</h2>
                        </td>
                    </tr>
                    <tr>
                        <td style="padding: 30px; text-align: start;">
                            <p style="font-family: Nunito, Arial, sans-serif; font-size: 18px; margin: 20px 0;">We are pleased
                                to confirm your reservation for ${reservation.service}.</p>
                            <p style="font-family: Nunito, Arial, sans-serif; font-size: 18px; margin: 20px 0;">Below are the
                                details of your booking:</p>
                            <p style="font-family: Nunito, Arial, sans-serif; font-size: 18px; margin: 10px 0 20px 0;">
                                <ul>
                                    <li>Date : ${DateFormat.yMMMd().format(reservation.reservationDate)}</li>
                                    <li>Time : ${DateFormat.Hm().format(reservation.reservationDate)}</li>
                                    <li>Location : ${reservation.location}</li>
                                </ul>
                            </p>
                        </td>
                    </tr>
                    ${reservation.linkmeet.isNotEmpty ? '''
<tr>
                        <td style="padding: 30px; text-align: center;">
                            
                            <a href="${reservation.linkmeet}" target="_blank" rel="noopener noreferrer" style="text-decoration: none; color:#000; padding: 20px 40px; background-color: #FACB01; border-radius: 16px">Join now!</a>
                            
                        </td>
                    </tr>
''' : ''''''}
                    <tr>
                        <td style="padding: 30px; text-align: start;">
                            <p style="font-family: Nunito, Arial, sans-serif; font-size: 18px; margin: 20px 0;">${reservation.message}
                            </p>
                            <p style="font-family: Nunito, Arial, sans-serif; font-size: 18px; margin: 20px 0;">See you soon!
                            </p>
                            <p style="font-family: Nunito, Arial, sans-serif; font-size: 18px; margin: 20px 0;">Best regards</p>
                            <p style="font-family: Nunito, Arial, sans-serif; font-size: 18px; margin: 20px 0;">Sahel Politica
                                Team</p>
                        </td>
                    </tr>
                </table>

                <!-- Footer -->
                <table
                    style="max-width: 800px; width: 100%; background-color: #000; border-radius: 20px; color: #fff; text-align: center; margin-top: 20px;"
                    cellpadding="0" cellspacing="0">
                    <tr>
                        <td style="padding: 15px;">
                            <p style="font-family: Nunito, Arial, sans-serif; font-size: 15px; margin: 0;">Sahel Politica,
                                Chamerstrasse 172, 6300 Zug</p>
                            <p style="font-family: Nunito, Arial, sans-serif; font-size: 15px; margin: 10px 0;">Don't like these
                                emails? <a href="#" target="_blank"
                                    style="color: #ffc107; text-decoration: none;">Unsubscribe</a></p>
                            <p style="font-family: Nunito, Arial, sans-serif; font-size: 15px; margin: 10px 0;"><a
                                    href="https://sahelpolitica.ch" target="_blank"
                                    style="color: #ffc107; text-decoration: none;">Visit our website</a></p>

                            <table style="width: auto; margin: 10px auto;" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td style="padding: 0 5px;">
                                        <a href="https://www.linkedin.com/company/sahelpolitica/" target="_blank">
                                            <img src="https://firebasestorage.googleapis.com/v0/b/websitesapo-79e6f.firebasestorage.app/o/emails_image%2Flinkedin.png?alt=media&token=97c3ae0a-18ab-431b-9fe9-2f9274c018c5"
                                                alt="LinkedIn" style="width: 50px;">
                                        </a>
                                    </td>
                                    <td style="padding: 0 5px;">
                                        <a href="https://x.com/SahelPolitica" target="_blank">
                                            <img src="https://firebasestorage.googleapis.com/v0/b/websitesapo-79e6f.firebasestorage.app/o/emails_image%2Fx.png?alt=media&token=d490dadd-a108-41af-a8ba-95dc2bf20c56"
                                                alt="X" style="width: 50px;">
                                        </a>
                                    </td>
                                    <td style="padding: 0 5px;">
                                        <a href="https://www.youtube.com/@SahelPolitica_A" target="_blank">
                                            <img src="https://firebasestorage.googleapis.com/v0/b/websitesapo-79e6f.firebasestorage.app/o/emails_image%2Fyoutube.png?alt=media&token=c03224ae-e0f2-4d55-83a1-2c8dbdfd2a2b"
                                                alt="YouTube" style="width: 50px;">
                                        </a>
                                    </td>
                                </tr>
                            </table>

                            <p style="font-family: Nunito, Arial, sans-serif; font-size: 15px; margin: 10px 0;">© Sahel
                                Politica, 2025, All rights reserved</p>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
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
      print('Failed to send email to ${reservation.email}: ${response.body}');
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text("Failed to send email to ${reservation.email}. Try later"),
      ),
    );
    loading();
    print('Exception occurred while sending email to ${reservation.email}: $e');
  }
}

// Fonction pour envoyer un email
Future<void> sendReservationCancelEmail({
  required Reservation reservations,
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
        'email': reservations.email,
      }
    ],
    'subject': "Appointments Canceled",
    'htmlContent': '''<html>
<body style="margin: 0; padding: 0; font-family: Arial, sans-serif; background-color: #f4f4f4; color: #333;">
    <table style="width: 100%; background-color: #f4f4f4; padding: 20px 0;" cellpadding="0" cellspacing="0">
        <tr>
            <td align="center">
                <!-- Header -->
                <table style="max-width: 800px; width: 100%; border-radius: 10px;" cellpadding="0" cellspacing="0">
                    <tr>
                        <td style="padding: 20px; text-align: center;">
                            <table cellpadding="0" cellspacing="0" style="width: 100%; text-align: center;">
                                <tr>
                                    <td style="text-align: center;">
                                        <img src="https://firebasestorage.googleapis.com/v0/b/websitesapo-79e6f.firebasestorage.app/o/emails_image%2Ffavicon.png?alt=media&token=f71ed7c4-cb64-4043-995b-7b52da5575e6" alt="Company Logo" style="max-height: 60px; display: block; margin: 0 auto;">
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align: center;">
                                        <h2 style="margin: 10px 0 5px; font-family: Arial, sans-serif; font-weight: bold;">Sahel Politica</h2>
                                        <h4 style="margin: 5px 0; font-family: Arial, sans-serif; font-weight: bold;">Navigating risk, Ensuring impact</h4>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
                <!-- Content -->
                <table style=" margin-top: 20px; max-width: 800px; width: 100%; background-color: #fff; border-radius: 10px;" cellpadding="0" cellspacing="0">
                    <tr>
                        <td style="padding: 30px; text-align: center;">
                            <h2 style="font-family: Arial, sans-serif; margin: 0;">RESERVATION CANCELLATION</h2>
                        </td>
                    </tr>
                    <tr>
                        <td style="padding: 30px; text-align: start;">
                            <p style="font-family: Arial, sans-serif; font-size: 18px; margin: 20px 0;">We wanted to confirm that your reservation for ${reservations.service} has been canceled.</p>
                            <p style="font-family: Arial, sans-serif; font-size: 18px; margin: 20px 0;">${reservations.message}</p>
                            <p style="font-family: Arial, sans-serif; font-size: 18px; margin: 20px 0;">Best regards</p>
                            <p style="font-family: Arial, sans-serif; font-size: 18px; margin: 20px 0;">Sahel Politica Team</p>
                        </td>
                    </tr>
                </table>

                <!-- Footer -->
                <table style="max-width: 800px; width: 100%; background-color: #000; border-radius: 20px; color: #fff; text-align: center; margin-top: 20px;" cellpadding="0" cellspacing="0">
                    <tr>
                        <td style="padding: 15px;">
                            <p style="font-family: Arial, sans-serif; font-size: 15px; margin: 0;">Sahel Politica, Chamerstrasse 172, 6300 Zug</p>
                            <p style="font-family: Arial, sans-serif; font-size: 15px; margin: 10px 0;">Don't like these emails? <a href="#" target="_blank" style="color: #ffc107; text-decoration: none;">Unsubscribe</a></p>
                            <p style="font-family: Arial, sans-serif; font-size: 15px; margin: 10px 0;"><a href="https://sahelpolitica.ch" target="_blank" style="color: #ffc107; text-decoration: none;">Visit our website</a></p>

                            <table style="width: auto; margin: 10px auto;" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td style="padding: 0 5px;">
                                        <a href="https://www.linkedin.com/company/sahelpolitica/" target="_blank">
                                            <img src="https://firebasestorage.googleapis.com/v0/b/websitesapo-79e6f.firebasestorage.app/o/emails_image%2Flinkedin.png?alt=media&token=97c3ae0a-18ab-431b-9fe9-2f9274c018c5" alt="LinkedIn" style="width: 50px;">
                                        </a>
                                    </td>
                                    <td style="padding: 0 5px;">
                                        <a href="https://x.com/SahelPolitica" target="_blank">
                                            <img src="https://firebasestorage.googleapis.com/v0/b/websitesapo-79e6f.firebasestorage.app/o/emails_image%2Fx.png?alt=media&token=d490dadd-a108-41af-a8ba-95dc2bf20c56" alt="X" style="width: 50px;">
                                        </a>
                                    </td>
                                    <td style="padding: 0 5px;">
                                        <a href="https://www.youtube.com/@SahelPolitica_A" target="_blank">
                                            <img src="https://firebasestorage.googleapis.com/v0/b/websitesapo-79e6f.firebasestorage.app/o/emails_image%2Fyoutube.png?alt=media&token=c03224ae-e0f2-4d55-83a1-2c8dbdfd2a2b" alt="YouTube" style="width: 50px;">
                                        </a>
                                    </td>
                                </tr>
                            </table>

                            <p style="font-family: Arial, sans-serif; font-size: 15px; margin: 10px 0;">© Sahel Politica, 2025, All rights reserved</p>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</body>
</html>

''',
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
      print('Failed to send email to ${reservations.email}: ${response.body}');
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text("Failed to send email to ${reservations.email}. Try later"),
      ),
    );
    loading();
    print(
        'Exception occurred while sending email to ${reservations.email}: $e');
  }
}
