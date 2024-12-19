import 'dart:io' show File;
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:mime_type/mime_type.dart';

Future<String?> uploadImageToFirebase(
    String folderPath, Function(String) loading) async {
  try {
    // Utilisation de file_picker pour choisir un fichier
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image, // Permet uniquement les fichiers image
      withData: true, // Nécessaire pour Web
    );

    if (result == null) {
      print("Aucun fichier sélectionné");
      return null;
    }

    // Récupération des informations du fichier
    String extension = result.files.first.name.split('.').last;
    String fileName = "${DateTime.now().millisecondsSinceEpoch}.$extension";
    String fullPath = "$folderPath/$fileName";
    String? mimeType = mime(result.files.first.name);

    // Pour Web
    if (result.files.first.bytes != null) {
      Reference storageRef = FirebaseStorage.instance.ref(fullPath);
      UploadTask uploadTask = storageRef.putData(
        result.files.first.bytes!,
        SettableMetadata(contentType: mimeType),
      );

      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      print("Fichier téléchargé avec succès: $downloadUrl");
      loading(downloadUrl);
      return downloadUrl;
    }

    // Pour Mobile/Desktop
    if (result.files.first.path != null) {
      File file = File(result.files.first.path!);
      Reference storageRef = FirebaseStorage.instance.ref(fullPath);
      UploadTask uploadTask = storageRef.putFile(
        file,
        SettableMetadata(contentType: mimeType),
      );

      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      print("Fichier téléchargé avec succès: $downloadUrl");
      loading(downloadUrl);
      return downloadUrl;
    }

    print("Erreur : fichier non pris en charge");
    return null;
  } catch (e) {
    loading('');
    print("Erreur lors du téléchargement: $e");
    return null;
  }
}

Future<String> pdfPickerAndUpload(
    String folderPath, Function(String) loading) async {
  // Ouvre le sélecteur de fichiers pour un fichier PDF
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['pdf'],
  );

  if (result != null) {
    // Récupère le fichier sélectionné
    PlatformFile file = result.files.first;

    // Récupère le nom du fichier avec son extension (cela devrait déjà être fait par `file.name`)
    String fileName = file.name;

    // Assurez-vous que le nom du fichier conserve l'extension correcte
    if (!fileName.toLowerCase().endsWith('.pdf')) {
      fileName += '.pdf'; // Ajoute l'extension PDF si elle est manquante
    }

    try {
      // Crée une référence vers le dossier de destination dans Firebase Storage
      Reference storageReference =
          FirebaseStorage.instance.ref().child('$folderPath/$fileName');

      // Si on est sur le web, on utilise les bytes pour le téléchargement
      if (kIsWeb) {
        // Télécharge le fichier en utilisant les bytes
        Uint8List fileBytes = file.bytes!;

        // Spécifie le mimeType pour un fichier PDF
        UploadTask uploadTask = storageReference.putData(
          fileBytes,
          SettableMetadata(contentType: 'application/pdf'),
        );

        await uploadTask.whenComplete(() => null);
      } else {
        // Sinon, on utilise le chemin du fichier (mobile ou desktop)
        File localFile = File(file.path!);
        UploadTask uploadTask = storageReference.putFile(localFile);
        await uploadTask.whenComplete(() => null);
      }

      // Récupère l'URL de téléchargement du fichier
      String downloadUrl = await storageReference.getDownloadURL();
      loading(downloadUrl);
      return downloadUrl; // Retourne l'URL du fichier dans Firebase Storage
    } catch (e) {
      loading("downloadUrl");
      print("Erreur lors du téléchargement du fichier : $e");
      return "";
    }
  } else {
    // Si l'utilisateur annule la sélection
    return "";
  }
}
