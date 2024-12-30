import 'package:admin_panel_manager/Class/profile_class.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';

class PasswordChangeDialog extends StatefulWidget {
  const PasswordChangeDialog({super.key, required this.id});

  final String id;

  @override
  State<PasswordChangeDialog> createState() => _PasswordChangeDialogState();
}

class _PasswordChangeDialogState extends State<PasswordChangeDialog> {
  late TextEditingController passwordController;
  late TextEditingController passwordConfirmController;
  String password = "";
  String passwordConfirm = "";

  @override
  void initState() {
    super.initState();
    passwordController = TextEditingController();
    passwordConfirmController = TextEditingController();
  }

  bool validateEntries() {
    if (password.isEmpty) {
      setState(() {
        errorMessage = "Please enter your new password";
      });
      return false;
    } else if (password != passwordConfirm) {
      setState(() {
        errorMessage = "Passwords do not match";
      });
      return false;
    }
    return true;
  }

  String errorMessage = "";
  bool saving = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.all(20),
        color: const Color(0xffF5F5F5),
        width: 600,
        height: 400,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              "Enter a new password",
              style: secondTitleStyle,
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Password :",
                  style: normalTextStyle,
                ),
                Container(
                    width: 350,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5)),
                    child: TextField(
                      textAlignVertical: TextAlignVertical.center,
                      textAlign: TextAlign.center,
                      controller: passwordController,
                      onChanged: (value) {
                        setState(() {
                          password = value;
                        });
                      },
                      decoration: InputDecoration(
                        filled: true,
                        hintText: "...",
                        fillColor: Colors.white,
                        border: InputBorder.none,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    )),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Confirm password :",
                  style: normalTextStyle,
                ),
                Container(
                    width: 350,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5)),
                    child: TextField(
                      textAlignVertical: TextAlignVertical.center,
                      textAlign: TextAlign.center,
                      controller: passwordConfirmController,
                      onChanged: (value) {
                        setState(() {
                          passwordConfirm = value;
                        });
                      },
                      decoration: InputDecoration(
                        filled: true,
                        hintText: "...",
                        fillColor: Colors.white,
                        border: InputBorder.none,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    )),
              ],
            ),
            Text(
              errorMessage,
              style: GoogleFonts.nunitoSans(fontSize: 16, color: Colors.red),
            ),
            if (saving)
              const CircularProgressIndicator(
                color: Colors.yellow,
              ),
            if (!saving)
              MaterialButton(
                onPressed: () async {
                  if (validateEntries()) {
                    setState(() {
                      saving = true;
                    });
                    await changePassword(widget.id, passwordConfirm, context,
                        () {
                      Navigator.pop(context);
                    });
                  }
                },
                shape: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide.none,
                ),
                minWidth: 100,
                height: 50,
                color: const Color(0xffFACB01),
                child: Text(
                  "Save",
                  style: buttonTitleStyle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
