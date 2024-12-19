import 'package:admin_panel_manager/constants.dart';
import 'package:admin_panel_manager/login-manager/delete_user.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DeleteUserDialog extends StatefulWidget {
  const DeleteUserDialog({
    super.key,
    required this.usersID,
    required this.refresh,
  });

  final List<String> usersID;
  final Function() refresh;

  @override
  State<DeleteUserDialog> createState() => _DeleteUserDialogState();
}

class _DeleteUserDialogState extends State<DeleteUserDialog> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        isLoading
            ? "Just a moment ..."
            : "Voulez-vous vraiment supprimer ces profiles ?",
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
                  for (var i = 0; i < widget.usersID.length; i++) {
                    if (i != widget.usersID.length - 1) {
                      await deleteUser(widget.usersID[0], context, () {});
                    } else {
                      await deleteUser(widget.usersID[0], context, () {
                        widget.refresh();
                        Navigator.pop(context);
                      });
                    }
                  }
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
