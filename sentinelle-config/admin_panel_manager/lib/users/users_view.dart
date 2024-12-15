import 'package:admin_panel_manager/login-manager/get_user_fonction.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../Class/profile_class.dart';
import '../widgets/simple_page_title.dart';

class UsersView extends StatefulWidget {
  const UsersView({super.key});

  @override
  State<UsersView> createState() => _UsersViewState();
}

class _UsersViewState extends State<UsersView> {
  String search = "";
  List<Profile> profiles = [];
  Profile? profileConnected;
  User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    //Récupération des messages
    profiles = List<Profile>.generate(
      5,
      (int index) => Profile("$index", "Saydil", "SIDIBE",
          "sentinelle@sahelpolitica.ch", "ITSupport", {}, DateTime.now()),
      growable: true,
    );
    profiles.add(
      Profile("ao06HCE5shZf90ViU2vxbtK78yp2", "Saydil", "SIDIBE",
          "sentinelle@sahelpolitica.ch", "ITSupport", {}, DateTime.now()),
    );
    findUser();
  }

  Future<void> findUser() async {
    Profile? pro = await getUser(currentUser!.uid);
    setState(() {
      profileConnected = pro;
    });
  }

  List<Profile> fetchUsers() {
    if (search.isEmpty) {
      return profiles;
    } else {
      return profiles.where((p) {
        return p.displayName().toLowerCase().contains(search.toLowerCase()) ||
            p.email.toLowerCase().contains(search.toLowerCase());
      }).toList();
    }
  }

  void setSearchValue(String value) {
    setState(() {
      search = value;
    });
  }

  void seeProfile(Profile profile) {
    // Ajoutez une action pour ouvrir l'événement
    showDialog(
      context: context,
      builder: (context) => const Dialog(),
    );
  }

  List<String> usersIds = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      child: Column(
        children: [
          const SimplePageTitle(title: "Your team"),
          const SizedBox(height: 30),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(30),
                    decoration: const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(width: 2, color: Colors.grey))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            TextButton(
                                onPressed: () {},
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.add_circle_outline_rounded,
                                      size: 20,
                                      color: Color(0xFFFACB01),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "New member",
                                      style: GoogleFonts.nunitoSans(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xffAC8C00)),
                                    )
                                  ],
                                )),
                            const SizedBox(
                              width: 30,
                            ),
                            TextButton(
                                onPressed: () {},
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.delete,
                                      size: 20,
                                      color: Colors.red,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "DELETE",
                                      style: GoogleFonts.nunitoSans(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red,
                                      ),
                                    )
                                  ],
                                ))
                          ],
                        ),
                        Container(
                            margin: const EdgeInsets.only(top: 20),
                            width: 300,
                            height: 50,
                            decoration: BoxDecoration(
                                color: const Color(0xffECECEC),
                                borderRadius: BorderRadius.circular(5)),
                            child: TextField(
                              onChanged: (value) {
                                setState(() {
                                  search = value;
                                });
                              },
                              decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.search,
                                  color: Color(0xff929200),
                                ),
                                filled: true,
                                hintText: "Research...",
                                fillColor: const Color(0xffECECEC),
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
                  ),
                  Expanded(
                      child: SingleChildScrollView(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: DataTable(
                          columns: const [
                            DataColumn(label: Text("Name")),
                            DataColumn(label: Text("Email")),
                            DataColumn(label: Text("Post")),
                            DataColumn(label: Text("Authorisations")),
                            DataColumn(label: Text("Date of creation")),
                          ],
                          rows: List<DataRow>.generate(
                            fetchUsers().length,
                            (index) {
                              return DataRow(
                                  selected:
                                      usersIds.contains(fetchUsers()[index].id),
                                  onSelectChanged: profileConnected != null &&
                                          profileConnected!.id !=
                                              fetchUsers()[index].id
                                      ? (value) {
                                          setState(() {
                                            if (usersIds.contains(
                                                fetchUsers()[index].id)) {
                                              usersIds.remove(
                                                  fetchUsers()[index].id);
                                            } else {
                                              usersIds
                                                  .add(fetchUsers()[index].id);
                                            }
                                          });
                                        }
                                      : null,
                                  cells: [
                                    DataCell(Text(
                                        fetchUsers()[index].displayName(),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: GoogleFonts.nunitoSans())),
                                    DataCell(onTap: () {
                                      seeProfile(fetchUsers()[index]);
                                    },
                                        Text(
                                          fetchUsers()[index].email,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: GoogleFonts.nunitoSans(
                                            color: Colors.blue,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        )),
                                    DataCell(Text(fetchUsers()[index].post,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: GoogleFonts.nunitoSans())),
                                    DataCell(Text(
                                        fetchUsers()[index]
                                            .access
                                            .length
                                            .toString(),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: GoogleFonts.nunitoSans())),
                                    DataCell(Text(
                                        DateFormat.yMd().format(
                                            fetchUsers()[index].dateOfCreation),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: GoogleFonts.nunitoSans())),
                                  ]);
                            },
                          )),
                    ),
                  )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
