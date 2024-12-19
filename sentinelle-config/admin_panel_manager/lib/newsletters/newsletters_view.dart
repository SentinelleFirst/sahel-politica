import 'package:admin_panel_manager/Class/newsletter_class.dart';
import 'package:admin_panel_manager/newsletters/delete_newsletter_dialog.dart';
import 'package:admin_panel_manager/newsletters/new_newsletter_dialog.dart';
import 'package:admin_panel_manager/newsletters/newsletter_details_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../constants.dart';
import '../events/get_all_contacts.dart';
import '../widgets/simple_divider.dart';
import '../widgets/simple_page_title.dart';

class NewslettersView extends StatefulWidget {
  const NewslettersView({super.key});

  @override
  State<NewslettersView> createState() => _NewslettersViewState();
}

class _NewslettersViewState extends State<NewslettersView> {
  String search = "";
  String searchContact = "";
  bool isLoading = true;
  List<Newsletter> newsletters = [];
  List<String> contacts = [
    "sidibesaydil@gmail.com",
    "saydilsidibe352@gmail.com"
  ];

  @override
  void initState() {
    super.initState();

    getAllNewsletters();
    getAllContacts();
  }

  Future<void> getAllNewsletters() async {
    List<Newsletter> an = await fetchDBNewsletters();
    setState(() {
      an.sort(
        (a, b) => b.date.compareTo(a.date),
      );
      newsletters = an;
      isLoading = false;
    });
  }

  Future<void> getAllContacts() async {
    List<String> cs = await getContactEmails();
    setState(() {
      contacts = cs;
    });
  }

  List<Newsletter> fetchNewsletters() {
    if (search.isEmpty) {
      return newsletters;
    } else {
      return newsletters.where((ev) {
        return ev.object.toLowerCase().contains(search.toLowerCase());
      }).toList();
    }
  }

  List<String> fetchContacts() {
    if (searchContact.isEmpty) {
      return contacts;
    } else {
      return contacts.where((ev) {
        return ev.contains(search.toLowerCase());
      }).toList();
    }
  }

  void setSearchValue(String value) {
    setState(() {
      search = value;
    });
  }

  void openNewsletter(Newsletter newsletter) {
    // Ajoutez une action pour ouvrir l'événement
    showDialog(
      context: context,
      builder: (context) => NewsletterDetailsDialog(
        newsletter: newsletter,
        contacts: contacts,
        refresh: getAllNewsletters,
      ),
    );
  }

  void newNewsletter() {
    showDialog(
      context: context,
      builder: (context) => NewNewsletterDialog(
        contacts: contacts,
        refresh: getAllNewsletters,
      ),
    );
  }

  void deleteNewsletter(String id) {
    showDialog(
      context: context,
      builder: (context) => DeleteNewsletterDialog(
        id: id,
        refresh: getAllNewsletters,
      ),
    );
  }

  void deleteContact(String contact) {
    showDialog(
      context: context,
      builder: (context) => const Dialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      child: Column(
        children: [
          ComplexePageTitle(
            title: "Newsletter",
            buttonTitle: "New campaign",
            buttonAction: newNewsletter,
            searchFieldChange: setSearchValue,
          ),
          const SizedBox(height: 30),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : SizedBox(
                          child: ListView.builder(
                            itemCount: fetchNewsletters().length,
                            itemBuilder: (_, int index) {
                              return NewsletterInfoLine(
                                newsletter: fetchNewsletters()[index],
                                delete: () {
                                  deleteNewsletter(
                                      fetchNewsletters()[index].id);
                                },
                                readAction: () {
                                  openNewsletter(fetchNewsletters()[index]);
                                },
                              );
                            },
                          ),
                        ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.only(left: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Subscribers",
                              style: secondTitleStyle,
                            ),
                            Text(
                              contacts.length.toString(),
                              style: secondTitleStyle,
                            ),
                          ],
                        ),
                        Container(
                            margin: const EdgeInsets.only(top: 20),
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                            decoration: BoxDecoration(
                                color: const Color(0xffECECEC),
                                borderRadius: BorderRadius.circular(5)),
                            child: TextField(
                              onChanged: (value) {
                                setState(() {
                                  searchContact = value;
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
                        SimpleDivider(
                            width: MediaQuery.of(context).size.width,
                            height: 2,
                            color: Colors.grey,
                            borderRadius: 0,
                            margin: const EdgeInsets.symmetric(vertical: 20)),
                        Expanded(
                            child: ListView.builder(
                          itemCount: contacts.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(
                                contacts[index],
                                style: normalTextStyle,
                              ),
                              trailing: IconButton(
                                  onPressed: () {
                                    deleteContact(contacts[index]);
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                    size: 25,
                                  )),
                            );
                          },
                        ))
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NewsletterInfoLine extends StatelessWidget {
  const NewsletterInfoLine({
    super.key,
    required this.newsletter,
    required this.readAction,
    required this.delete,
  });

  final Newsletter newsletter;
  final Function() readAction;
  final Function() delete;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 30),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color.fromARGB(52, 0, 0, 0), width: 2),
        ),
      ),
      child: ListTile(
        title: Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 180,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const SimpleDivider(
                            margin: EdgeInsets.only(right: 10),
                            width: 30,
                            height: 3,
                            color: Colors.grey,
                            borderRadius: 2),
                        Text(
                          "Target dispatch : ${newsletter.contacts.length} contacts",
                          style: GoogleFonts.poppins(
                              fontSize: 18, color: Colors.grey),
                        ),
                      ],
                    ),
                    Text(
                      "Newsletter object :\n${newsletter.object}",
                      style: GoogleFonts.poppins(fontSize: 20),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                    Text(
                      "${DateFormat.yMd().format(newsletter.date)}  -  send by ${newsletter.author}",
                      style: GoogleFonts.poppins(fontSize: 18),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 100,
              height: 180,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                      onPressed: readAction,
                      icon: const Icon(
                        Icons.edit_note_rounded,
                        size: 30,
                      )),
                  IconButton(
                      onPressed: delete,
                      icon: const Icon(
                        Icons.delete_outlined,
                        color: Colors.red,
                        size: 20,
                      )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
