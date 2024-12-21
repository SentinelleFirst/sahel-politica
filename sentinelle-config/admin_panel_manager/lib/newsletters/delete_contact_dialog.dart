import 'package:admin_panel_manager/constants.dart';
import 'package:admin_panel_manager/login-manager/delete_contacts.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DeleteContactDialog extends StatefulWidget {
  const DeleteContactDialog({
    super.key,
    required this.email,
    required this.refresh,
  });

  final String email;
  final Function() refresh;

  @override
  State<DeleteContactDialog> createState() => _DeleteContactDialogState();
}

class _DeleteContactDialogState extends State<DeleteContactDialog> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        isLoading
            ? "Just a moment ..."
            : "Do you really want to delete this contact ?",
        style: thirdTitleStyle,
      ),
      content: SizedBox(
        width: 300,
        height: 100,
        child: Center(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            if (isLoading)
              const CircularProgressIndicator(
                color: Colors.yellow,
              ),
            if (!isLoading)
              TextButton(
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });
                  await deleteContact(
                    widget.email,
                    () {
                      widget.refresh();
                      Navigator.pop(context);
                    },
                    context,
                  );
                },
                child: Text(
                  "OUI",
                  style: GoogleFonts.nunitoSans(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                ),
              ),
            if (!isLoading)
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "NON",
                  style: GoogleFonts.nunitoSans(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                ),
              ),
          ],
        )),
      ),
    );
  }
}
