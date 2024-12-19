import 'package:admin_panel_manager/Class/profile_class.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';
import '../login-manager/new_user.dart';

class NewUserDialog extends StatefulWidget {
  const NewUserDialog({super.key, required this.refresh});

  final Function() refresh;

  @override
  State<NewUserDialog> createState() => _NewUserDialogState();
}

class _NewUserDialogState extends State<NewUserDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  Profile profileToModify = Profile.empty();
  late TextEditingController firstname;
  late TextEditingController lastname;
  late TextEditingController email;
  late TextEditingController passwordController;
  late TextEditingController passwordConfirmController;
  String password = "";
  String passwordConfirm = "";

  @override
  void initState() {
    super.initState();
    //Init Animation
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
    _controller.forward();
    firstname = TextEditingController();
    lastname = TextEditingController();
    email = TextEditingController();
    passwordController = TextEditingController();
    passwordConfirmController = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void saveModification() async {
    setState(() {
      isLoading = true;
    });

    if (validateEntries()) {
      await addUser(profileToModify, passwordController.text, context, () {
        setState(() {
          isLoading = false;
          widget.refresh();
          Navigator.pop(context);
        });
      });
    }
  }

  bool validateEntries() {
    if (profileToModify.firstname.isEmpty) {
      return false;
    } else if (profileToModify.lastname.isEmpty) {
      return false;
    } else if (profileToModify.email.isEmpty) {
      return false;
    } else if (!isEmailValid(profileToModify.email)) {
      //Verifie si l'email est correct
      return false;
    } else if (password.length < 6) {
      return false;
    } else if (password != passwordConfirm) {
      return false;
    }
    return true;
  }

  bool isEmailValid(String email) {
    // Regex pattern for validating an email
    final RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    return emailRegex.hasMatch(email);
  }

  bool isLoading = false;

  List<String> postes = [
    "Administrator",
    "ITSupport",
    "Community Manager",
    "Editor",
    "Custom"
  ];
  String selectedPost = "Custom";

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      alignment: Alignment.bottomRight,
      insetPadding: EdgeInsets.zero,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return SlideTransition(
            position: _offsetAnimation,
            child: child,
          );
        },
        child: Container(
          width: 700,
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
          height: MediaQuery.of(context).size.height,
          color: const Color(0xffF5F5F5),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Edit profile",
                        style: secondTitleStyle,
                      ),
                    ),
                    if (isLoading)
                      const CircularProgressIndicator(
                        color: Colors.yellow,
                      ),
                    if (!isLoading)
                      MaterialButton(
                        onPressed: validateEntries()
                            ? () {
                                saveModification();
                              }
                            : null,
                        shape: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide.none,
                        ),
                        minWidth: 100,
                        height: 50,
                        color: const Color(0xffFACB01),
                        child: Text(
                          "Create",
                          style: buttonTitleStyle,
                        ),
                      ),
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.close,
                          color: Colors.black,
                          size: 30,
                        ))
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Firstname :",
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
                          controller: firstname,
                          onChanged: (value) {
                            setState(() {
                              profileToModify.firstname = value;
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
                      "Lastname :",
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
                          controller: lastname,
                          onChanged: (value) {
                            setState(() {
                              profileToModify.lastname = value;
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
                      "Email :",
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
                          controller: email,
                          onChanged: (value) {
                            setState(() {
                              profileToModify.email = value;
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
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Poste :",
                      style: normalTextStyle,
                    ),
                    Container(
                      width: 350,
                      height: 55,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5)),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        alignment: AlignmentDirectional.center,
                        value: selectedPost,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedPost = newValue!;
                            profileToModify.post = newValue;

                            if (newValue == postes[0]) {
                              profileToModify.initAdminAccess();
                            } else if (newValue == postes[1]) {
                              profileToModify.initITAccess();
                            } else if (newValue == postes[2]) {
                              profileToModify.initCMAccess();
                            } else if (newValue == postes[3]) {
                              profileToModify.initEditorAccess();
                            } else if (newValue == postes[4]) {
                              profileToModify.initCustomAccess();
                            }
                          });
                        },
                        items: postes
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Center(child: Text(value)),
                          );
                        }).toList(),
                        icon: const SizedBox.shrink(), // Retirer l'icône
                        underline: const SizedBox.shrink(),
                      ),
                    ),
                  ],
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(top: 50),
                  height: 500,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Custom role",
                              style: GoogleFonts.nunitoSans(
                                  fontSize: 17, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Actions",
                              style: GoogleFonts.nunitoSans(
                                  fontSize: 17, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: DataTable(
                            columns: const [
                              DataColumn(label: Text("")),
                              DataColumn(label: Text("View")),
                              DataColumn(label: Text("Publish")),
                              DataColumn(label: Text("Edit")),
                              DataColumn(label: Text("Create")),
                              DataColumn(label: Text("Delete")),
                            ],
                            rows: List<DataRow>.generate(
                              7,
                              (index) {
                                return DataRow(cells: [
                                  DataCell(SizedBox(
                                    width: 90,
                                    child: Text(profileToModify.access.keys
                                        .toList()[index]),
                                  )),
                                  DataCell(IconButton(
                                      onPressed: () {
                                        setState(() {
                                          if (profileToModify.getAcces(
                                              profileToModify.access.keys
                                                  .toList()[index],
                                              "view")) {
                                            profileToModify.setAcces(
                                                profileToModify.access.keys
                                                    .toList()[index],
                                                "view",
                                                false);
                                          } else {
                                            profileToModify.setAcces(
                                                profileToModify.access.keys
                                                    .toList()[index],
                                                "view",
                                                true);
                                          }
                                        });
                                      },
                                      icon: profileToModify.access[
                                              profileToModify.access.keys
                                                  .toList()[index]]!["view"]!
                                          ? const Icon(
                                              Icons.check_box_outlined,
                                              size: 18,
                                              color: Colors.black,
                                            )
                                          : const Icon(
                                              Icons
                                                  .check_box_outline_blank_outlined,
                                              size: 18,
                                              color: Colors.black,
                                            ))),
                                  DataCell(profileToModify.access[
                                              profileToModify.access.keys
                                                  .toList()[index]]!
                                          .containsKey("publish")
                                      ? IconButton(
                                          onPressed: () {
                                            setState(() {
                                              if (profileToModify.getAcces(
                                                  profileToModify.access.keys
                                                      .toList()[index],
                                                  "publish")) {
                                                profileToModify.setAcces(
                                                    profileToModify.access.keys
                                                        .toList()[index],
                                                    "publish",
                                                    false);
                                              } else {
                                                profileToModify.setAcces(
                                                    profileToModify.access.keys
                                                        .toList()[index],
                                                    "publish",
                                                    true);
                                              }
                                            });
                                          },
                                          icon: profileToModify.access[
                                                  profileToModify.access.keys
                                                          .toList()[
                                                      index]]!["publish"]!
                                              ? const Icon(
                                                  Icons.check_box_outlined,
                                                  size: 18,
                                                  color: Colors.black,
                                                )
                                              : const Icon(
                                                  Icons
                                                      .check_box_outline_blank_outlined,
                                                  size: 18,
                                                  color: Colors.black,
                                                ))
                                      : const Text("")),
                                  DataCell(profileToModify.access[
                                              profileToModify.access.keys
                                                  .toList()[index]]!
                                          .containsKey("edit")
                                      ? IconButton(
                                          onPressed: () {
                                            setState(() {
                                              if (profileToModify.getAcces(
                                                  profileToModify.access.keys
                                                      .toList()[index],
                                                  "edit")) {
                                                profileToModify.setAcces(
                                                    profileToModify.access.keys
                                                        .toList()[index],
                                                    "edit",
                                                    false);
                                              } else {
                                                profileToModify.setAcces(
                                                    profileToModify.access.keys
                                                        .toList()[index],
                                                    "edit",
                                                    true);
                                              }
                                            });
                                          },
                                          icon: profileToModify.access[
                                                  profileToModify.access.keys
                                                          .toList()[
                                                      index]]!["edit"]!
                                              ? const Icon(
                                                  Icons.check_box_outlined,
                                                  size: 18,
                                                  color: Colors.black,
                                                )
                                              : const Icon(
                                                  Icons
                                                      .check_box_outline_blank_outlined,
                                                  size: 18,
                                                  color: Colors.black,
                                                ))
                                      : const Text("")),
                                  DataCell(profileToModify.access[
                                              profileToModify.access.keys
                                                  .toList()[index]]!
                                          .containsKey("create")
                                      ? IconButton(
                                          onPressed: () {
                                            setState(() {
                                              if (profileToModify.getAcces(
                                                  profileToModify.access.keys
                                                      .toList()[index],
                                                  "create")) {
                                                profileToModify.setAcces(
                                                    profileToModify.access.keys
                                                        .toList()[index],
                                                    "create",
                                                    false);
                                              } else {
                                                profileToModify.setAcces(
                                                    profileToModify.access.keys
                                                        .toList()[index],
                                                    "create",
                                                    true);
                                              }
                                            });
                                          },
                                          icon: profileToModify.access[
                                                  profileToModify.access.keys
                                                          .toList()[
                                                      index]]!["create"]!
                                              ? const Icon(
                                                  Icons.check_box_outlined,
                                                  size: 18,
                                                  color: Colors.black,
                                                )
                                              : const Icon(
                                                  Icons
                                                      .check_box_outline_blank_outlined,
                                                  size: 18,
                                                  color: Colors.black,
                                                ))
                                      : const Text("")),
                                  DataCell(profileToModify.access[
                                              profileToModify.access.keys
                                                  .toList()[index]]!
                                          .containsKey("delete")
                                      ? IconButton(
                                          onPressed: () {
                                            setState(() {
                                              if (profileToModify.getAcces(
                                                  profileToModify.access.keys
                                                      .toList()[index],
                                                  "delete")) {
                                                profileToModify.setAcces(
                                                    profileToModify.access.keys
                                                        .toList()[index],
                                                    "delete",
                                                    false);
                                              } else {
                                                profileToModify.setAcces(
                                                    profileToModify.access.keys
                                                        .toList()[index],
                                                    "delete",
                                                    true);
                                              }
                                            });
                                          },
                                          icon: profileToModify.access[
                                                  profileToModify.access.keys
                                                          .toList()[
                                                      index]]!["delete"]!
                                              ? const Icon(
                                                  Icons.check_box_outlined,
                                                  size: 18,
                                                  color: Colors.black,
                                                )
                                              : const Icon(
                                                  Icons
                                                      .check_box_outline_blank_outlined,
                                                  size: 18,
                                                  color: Colors.black,
                                                ))
                                      : const Text("")),
                                ]);
                              },
                            )),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
