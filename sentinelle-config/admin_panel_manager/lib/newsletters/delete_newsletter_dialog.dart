import 'package:admin_panel_manager/Class/newsletter_class.dart';
import 'package:admin_panel_manager/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DeleteNewsletterDialog extends StatefulWidget {
  const DeleteNewsletterDialog({
    super.key,
    required this.id,
    required this.refresh,
  });

  final String id;
  final Function() refresh;

  @override
  State<DeleteNewsletterDialog> createState() => _DeleteNewsletterDialogState();
}

class _DeleteNewsletterDialogState extends State<DeleteNewsletterDialog> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        isLoading
            ? "Just a moment ..."
            : "Do you really want to delete this newsletter ?",
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
                  await deleteDBNewsletter(
                    widget.id,
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
