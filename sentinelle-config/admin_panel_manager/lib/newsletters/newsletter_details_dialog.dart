import 'package:admin_panel_manager/Class/analysis_class.dart';
import 'package:admin_panel_manager/Class/article_class.dart';
import 'package:admin_panel_manager/Class/contacts_class.dart';
import 'package:admin_panel_manager/Class/event_class.dart';
import 'package:admin_panel_manager/Class/newsletter_class.dart';
import 'package:admin_panel_manager/login-manager/send_email.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';

class NewsletterDetailsDialog extends StatefulWidget {
  const NewsletterDetailsDialog(
      {super.key,
      required this.newsletter,
      required this.refresh,
      required this.contacts});

  final Newsletter newsletter;
  final List<ContactClass> contacts;
  final Function() refresh;

  @override
  State<NewsletterDetailsDialog> createState() =>
      _NewsletterDetailsDialogState();
}

class _NewsletterDetailsDialogState extends State<NewsletterDetailsDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late TextEditingController object;
  late TextEditingController message;
  late TextEditingController link;
  late TextEditingController linkText;
  List<Event> events = [];
  List<Article> articles = [];
  List<Analysis> analysis = [];
  late Newsletter newsletterToModify;
  static String _displayStringForOption(ContactClass option) => option.email;
  static String _displayStringForEvent(Event option) => option.title;
  static String _displayStringForArticle(Article option) => option.title;
  static String _displayStringForAnalysis(Analysis option) => option.title;

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

//On initalise un objet event sopiant les donner de l'event sélectionné.
    newsletterToModify = Newsletter.copy(widget.newsletter);

//On initialise des donnés à afficher
    object = TextEditingController(text: widget.newsletter.object);
    message = TextEditingController(text: widget.newsletter.message);
    link = TextEditingController(text: widget.newsletter.link);
    linkText = TextEditingController(text: widget.newsletter.linkText);
    getAllDocuments();
  }

  Future<void> getAllDocuments() async {
    List<Article> ar = await fetchDBArticles();
    List<Event> ev = await fetchDBEvents();
    List<Analysis> an = await fetchDBAnalysis();
    setState(() {
      ar.sort(
        (a, b) => b.date.compareTo(a.date),
      );
      ev.sort(
        (a, b) => b.start.compareTo(a.start),
      );
      an.sort(
        (a, b) => b.date.compareTo(a.date),
      );
      articles = ar;
      events = ev;
      analysis = an;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void publishNewsletter() {
    if (validateEntries()) {
      saveModification();
      //Envoie email
      /*sendEmailAPI(
          name: widget.message.displayName(),
          email: widget.message.email,
          subject: emailObject,
          message: emailContent,
          context: context,
          loading: () {
          });*/
      showDialog(
          context: context,
          builder: (context) => NewsletterSendingDialog(
              newsletter: newsletterToModify,
              contacts: newsletterToModify.allContacts
                  ? widget.contacts
                  : newsletterToModify.contacts));
    }
  }

  void saveModification() async {
    await updateDBNewsletter(newsletterToModify, context, () {
      widget.refresh();
    });
  }

  void simplySaveModification() async {
    if (validateEntries()) {
      await updateDBNewsletter(newsletterToModify, context, () {
        widget.refresh();
      });
    }
  }

  bool validateEntries() {
    if (newsletterToModify.object.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Object empty..."),
        ),
      );
      return false;
    } else if (newsletterToModify.contacts.isEmpty &&
        !newsletterToModify.allContacts) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Select contact..."),
        ),
      );
      return false;
    } else if (newsletterToModify.elementTitle.isEmpty && type != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Select the item to be announced..."),
        ),
      );
      return false;
    } else if (newsletterToModify.message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Put a text to be announce..."),
        ),
      );
      return false;
    } else if (newsletterToModify.link.isNotEmpty &&
        newsletterToModify.linkText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("No text for the link..."),
        ),
      );
      return false;
    } else if (newsletterToModify.link.isEmpty &&
        newsletterToModify.linkText.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("No link ..."),
        ),
      );
      return false;
    }
    return true;
  }

  int type = 1;

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
          width: 600,
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
                        "Edit newsletter",
                        style: secondTitleStyle,
                      ),
                    ),
                    MaterialButton(
                      onPressed: () {
                        setState(() {
                          //Save newsletter
                          simplySaveModification();
                        });
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
                    MaterialButton(
                      onPressed: () {
                        setState(() {
                          //Publier l'event
                          publishNewsletter();
                        });
                      },
                      shape: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide.none,
                      ),
                      minWidth: 100,
                      height: 50,
                      color: const Color(0xffFACB01),
                      child: Text(
                        "Send",
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
                //Object info
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Object",
                        style: thirdTitleStyle,
                      ),
                      Container(
                          margin: const EdgeInsets.only(top: 20),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: const Color(0xffECECEC),
                              borderRadius: BorderRadius.circular(5)),
                          child: TextField(
                            controller: object,
                            onChanged: (value) {
                              setState(() {
                                newsletterToModify.object = value;
                              });
                            },
                            decoration: InputDecoration(
                              filled: true,
                              hintText: "...",
                              fillColor: const Color(0xFFECECEC),
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
                //Contact info
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Contacts targets",
                            style: thirdTitleStyle,
                          ),
                          Row(
                            children: [
                              MaterialButton(
                                onPressed: () {
                                  setState(() {
                                    newsletterToModify.allContacts = true;
                                  });
                                },
                                color: newsletterToModify.allContacts
                                    ? const Color(0xffFACB01)
                                    : const Color(0xffECECEC),
                                minWidth: 50,
                                height: 50,
                                child: Text(
                                  "ALL",
                                  style: buttonTitleStyle,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              MaterialButton(
                                onPressed: () {
                                  setState(() {
                                    newsletterToModify.allContacts = false;
                                  });
                                },
                                color: !newsletterToModify.allContacts
                                    ? const Color(0xffFACB01)
                                    : const Color(0xffECECEC),
                                minWidth: 50,
                                height: 50,
                                child: Text(
                                  "Select",
                                  style: buttonTitleStyle,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      if (!newsletterToModify.allContacts)
                        const SizedBox(
                          height: 20,
                        ),
                      if (!newsletterToModify.allContacts)
                        Column(
                          children: List.generate(
                            newsletterToModify.contacts.length,
                            (index) => ListTile(
                              title: Text(
                                newsletterToModify.contacts[index].email,
                                style: normalTextStyle,
                              ),
                              trailing: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      final value =
                                          newsletterToModify.contacts[index];
                                      newsletterToModify.contacts.remove(value);
                                    });
                                  },
                                  icon: const Icon(Icons.close)),
                            ),
                          ),
                        ),
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: const Color(0xffECECEC),
                            borderRadius: BorderRadius.circular(5)),
                        child: newsletterToModify.allContacts
                            ? TextField(
                                enabled: false,
                                controller: TextEditingController(
                                    text:
                                        "All your ${widget.contacts.length} subscribers"),
                                decoration: InputDecoration(
                                  filled: true,
                                  hintText: "...",
                                  fillColor: const Color(0xFFECECEC),
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
                              )
                            : Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5)),
                                width: 300,
                                height: 55,
                                child: Autocomplete<ContactClass>(
                                  displayStringForOption:
                                      _displayStringForOption,
                                  optionsViewBuilder: (BuildContext context,
                                      AutocompleteOnSelected<ContactClass>
                                          onSelected,
                                      Iterable<ContactClass> options) {
                                    return Align(
                                      alignment: Alignment.topLeft,
                                      child: Material(
                                        elevation: 4.0,
                                        child: SizedBox(
                                          width:
                                              300, // Contrôlez la largeur ici
                                          height:
                                              200, // Contrôlez la largeur ici
                                          child: ListView.builder(
                                            itemCount: options.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              final ContactClass option =
                                                  options.elementAt(index);
                                              return GestureDetector(
                                                onTap: () {
                                                  onSelected(option);
                                                },
                                                child: ListTile(
                                                    title: Text(option.email)),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  optionsBuilder:
                                      (TextEditingValue textEditingValue) {
                                    if (textEditingValue.text == '') {
                                      return const Iterable<
                                          ContactClass>.empty();
                                    }
                                    return widget.contacts
                                        .where((ContactClass option) {
                                      return option.email
                                          .toLowerCase()
                                          .contains(textEditingValue.text
                                              .toLowerCase());
                                    });
                                  },
                                  onSelected: (ContactClass selection) {
                                    setState(() {
                                      if (!newsletterToModify.contacts
                                          .contains(selection)) {
                                        newsletterToModify.contacts
                                            .add(selection);
                                      }
                                    });
                                  },
                                  fieldViewBuilder: (BuildContext context,
                                      TextEditingController
                                          textEditingController,
                                      FocusNode focusNode,
                                      VoidCallback onFieldSubmitted) {
                                    return TextFormField(
                                      controller: textEditingController,
                                      focusNode: focusNode,
                                      decoration: const InputDecoration(
                                        labelText: '...',
                                        border: OutlineInputBorder(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
                //Type choice
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Type of annonce",
                        style: thirdTitleStyle,
                      ),
                      Container(
                          margin: const EdgeInsets.only(top: 20),
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              MaterialButton(
                                onPressed: () {
                                  setState(() {
                                    type = 1;
                                  });
                                },
                                color: type == 1
                                    ? const Color(0xffFACB01)
                                    : const Color(0xffECECEC),
                                minWidth: 50,
                                height: 50,
                                child: Text(
                                  "New event",
                                  style: buttonTitleStyle,
                                ),
                              ),
                              MaterialButton(
                                onPressed: () {
                                  setState(() {
                                    type = 2;
                                  });
                                },
                                color: type == 2
                                    ? const Color(0xffFACB01)
                                    : const Color(0xffECECEC),
                                minWidth: 50,
                                height: 50,
                                child: Text(
                                  "New article",
                                  style: buttonTitleStyle,
                                ),
                              ),
                              MaterialButton(
                                onPressed: () {
                                  setState(() {
                                    type = 3;
                                  });
                                },
                                color: type == 3
                                    ? const Color(0xffFACB01)
                                    : const Color(0xffECECEC),
                                minWidth: 50,
                                height: 50,
                                child: Text(
                                  "New analysis",
                                  style: buttonTitleStyle,
                                ),
                              ),
                              MaterialButton(
                                onPressed: () {
                                  setState(() {
                                    type = 4;
                                  });
                                },
                                color: type == 4
                                    ? const Color(0xffFACB01)
                                    : const Color(0xffECECEC),
                                minWidth: 50,
                                height: 50,
                                child: Text(
                                  "Simple Message",
                                  style: buttonTitleStyle,
                                ),
                              ),
                            ],
                          )),
                    ],
                  ),
                ),
                //Select element
                if (type != 4)
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (type == 1)
                          Text(
                            "Select event",
                            style: thirdTitleStyle,
                          ),
                        if (type == 2)
                          Text(
                            "Select article",
                            style: thirdTitleStyle,
                          ),
                        if (type == 3)
                          Text(
                            "Select analysis",
                            style: thirdTitleStyle,
                          ),
                        Text(
                          "Title of the element select:",
                          style: normalTextStyle,
                        ),
                        Text(
                          newsletterToModify.elementTitle,
                          style: normalTextStyle,
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 20),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: const Color(0xffECECEC),
                              borderRadius: BorderRadius.circular(5)),
                          child: type == 1
                              ? Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5)),
                                  width: 300,
                                  height: 55,
                                  child: Autocomplete<Event>(
                                    displayStringForOption:
                                        _displayStringForEvent,
                                    optionsViewBuilder: (BuildContext context,
                                        AutocompleteOnSelected<Event>
                                            onSelected,
                                        Iterable<Event> options) {
                                      return Align(
                                        alignment: Alignment.topLeft,
                                        child: Material(
                                          elevation: 4.0,
                                          child: SizedBox(
                                            width:
                                                300, // Contrôlez la largeur ici
                                            height:
                                                200, // Contrôlez la largeur ici
                                            child: ListView.builder(
                                              itemCount: options.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                final Event option =
                                                    options.elementAt(index);
                                                return GestureDetector(
                                                  onTap: () {
                                                    onSelected(option);
                                                  },
                                                  child: ListTile(
                                                      title:
                                                          Text(option.title)),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    optionsBuilder:
                                        (TextEditingValue textEditingValue) {
                                      if (textEditingValue.text == '') {
                                        return const Iterable<Event>.empty();
                                      }
                                      return events.where((Event option) {
                                        return option.title.contains(
                                            textEditingValue.text
                                                .toLowerCase());
                                      });
                                    },
                                    onSelected: (Event selection) {
                                      setState(() {
                                        newsletterToModify.imageUrl =
                                            selection.imageUrl;
                                        newsletterToModify.elementTitle =
                                            selection.title;
                                      });
                                    },
                                    fieldViewBuilder: (BuildContext context,
                                        TextEditingController
                                            textEditingController,
                                        FocusNode focusNode,
                                        VoidCallback onFieldSubmitted) {
                                      return TextFormField(
                                        controller: textEditingController,
                                        focusNode: focusNode,
                                        decoration: const InputDecoration(
                                          labelText: '...',
                                          border: OutlineInputBorder(),
                                        ),
                                      );
                                    },
                                  ),
                                )
                              : type == 2
                                  ? Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      width: 300,
                                      height: 55,
                                      child: Autocomplete<Article>(
                                        displayStringForOption:
                                            _displayStringForArticle,
                                        optionsViewBuilder:
                                            (BuildContext context,
                                                AutocompleteOnSelected<Article>
                                                    onSelected,
                                                Iterable<Article> options) {
                                          return Align(
                                            alignment: Alignment.topLeft,
                                            child: Material(
                                              elevation: 4.0,
                                              child: SizedBox(
                                                width:
                                                    300, // Contrôlez la largeur ici
                                                height:
                                                    200, // Contrôlez la largeur ici
                                                child: ListView.builder(
                                                  itemCount: options.length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    final Article option =
                                                        options
                                                            .elementAt(index);
                                                    return GestureDetector(
                                                      onTap: () {
                                                        onSelected(option);
                                                      },
                                                      child: ListTile(
                                                          title: Text(
                                                              option.title)),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                        optionsBuilder: (TextEditingValue
                                            textEditingValue) {
                                          if (textEditingValue.text == '') {
                                            return const Iterable<
                                                Article>.empty();
                                          }
                                          return articles
                                              .where((Article option) {
                                            return option.title.contains(
                                                textEditingValue.text
                                                    .toLowerCase());
                                          });
                                        },
                                        onSelected: (Article selection) {
                                          setState(() {
                                            newsletterToModify.imageUrl =
                                                selection.imageUrl;
                                            newsletterToModify.elementTitle =
                                                selection.title;
                                          });
                                        },
                                        fieldViewBuilder: (BuildContext context,
                                            TextEditingController
                                                textEditingController,
                                            FocusNode focusNode,
                                            VoidCallback onFieldSubmitted) {
                                          return TextFormField(
                                            controller: textEditingController,
                                            focusNode: focusNode,
                                            decoration: const InputDecoration(
                                              labelText: '...',
                                              border: OutlineInputBorder(),
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                  : Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      width: 300,
                                      height: 55,
                                      child: Autocomplete<Analysis>(
                                        displayStringForOption:
                                            _displayStringForAnalysis,
                                        optionsViewBuilder:
                                            (BuildContext context,
                                                AutocompleteOnSelected<Analysis>
                                                    onSelected,
                                                Iterable<Analysis> options) {
                                          return Align(
                                            alignment: Alignment.topLeft,
                                            child: Material(
                                              elevation: 4.0,
                                              child: SizedBox(
                                                width:
                                                    300, // Contrôlez la largeur ici
                                                height:
                                                    200, // Contrôlez la largeur ici
                                                child: ListView.builder(
                                                  itemCount: options.length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    final Analysis option =
                                                        options
                                                            .elementAt(index);
                                                    return GestureDetector(
                                                      onTap: () {
                                                        onSelected(option);
                                                      },
                                                      child: ListTile(
                                                          title: Text(
                                                              option.title)),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                        optionsBuilder: (TextEditingValue
                                            textEditingValue) {
                                          if (textEditingValue.text == '') {
                                            return const Iterable<
                                                Analysis>.empty();
                                          }
                                          return analysis
                                              .where((Analysis option) {
                                            return option.title.contains(
                                                textEditingValue.text
                                                    .toLowerCase());
                                          });
                                        },
                                        onSelected: (Analysis selection) {
                                          setState(() {
                                            newsletterToModify.imageUrl =
                                                selection.imageUrl;
                                            newsletterToModify.elementTitle =
                                                selection.title;
                                          });
                                        },
                                        fieldViewBuilder: (BuildContext context,
                                            TextEditingController
                                                textEditingController,
                                            FocusNode focusNode,
                                            VoidCallback onFieldSubmitted) {
                                          return TextFormField(
                                            controller: textEditingController,
                                            focusNode: focusNode,
                                            decoration: const InputDecoration(
                                              labelText: '...',
                                              border: OutlineInputBorder(),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                        ),
                      ],
                    ),
                  ),
                //link info
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Text for the annonce",
                        style: thirdTitleStyle,
                      ),
                      Container(
                          margin: const EdgeInsets.only(top: 20),
                          width: MediaQuery.of(context).size.width,
                          height: 300,
                          decoration: BoxDecoration(
                              color: const Color(0xffECECEC),
                              borderRadius: BorderRadius.circular(5)),
                          child: TextField(
                            expands: true,
                            maxLines: null,
                            minLines: null,
                            textAlignVertical: TextAlignVertical.top,
                            controller: message,
                            onChanged: (value) {
                              setState(() {
                                newsletterToModify.message = value;
                              });
                            },
                            decoration: InputDecoration(
                              filled: true,
                              hintText: "...",
                              fillColor: const Color(0xFFECECEC),
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
                //link info
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Link (optional)",
                        style: thirdTitleStyle,
                      ),
                      Container(
                          margin: const EdgeInsets.only(top: 20),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: const Color(0xffECECEC),
                              borderRadius: BorderRadius.circular(5)),
                          child: TextField(
                            controller: linkText,
                            onChanged: (value) {
                              setState(() {
                                newsletterToModify.linkText = value;
                              });
                            },
                            decoration: InputDecoration(
                              filled: true,
                              hintText: "See more by cliking here...",
                              fillColor: const Color(0xFFECECEC),
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
                      Container(
                          margin: const EdgeInsets.only(top: 20),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: const Color(0xffECECEC),
                              borderRadius: BorderRadius.circular(5)),
                          child: TextField(
                            controller: link,
                            onChanged: (value) {
                              setState(() {
                                newsletterToModify.link = value;
                              });
                            },
                            decoration: InputDecoration(
                              filled: true,
                              hintText: "https://...",
                              fillColor: const Color(0xFFECECEC),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NewsletterSendingDialog extends StatefulWidget {
  const NewsletterSendingDialog(
      {super.key, required this.newsletter, required this.contacts});

  final Newsletter newsletter;
  final List<ContactClass> contacts;

  @override
  State<NewsletterSendingDialog> createState() =>
      _NewsletterSendingDialogState();
}

class _NewsletterSendingDialogState extends State<NewsletterSendingDialog> {
  bool loading = false;
  bool end = false;
  int progress = 0;

  void sendCampaign() {
    setState(() {
      loading = true;
      end = false;
    });
    for (var contact in widget.contacts) {
      sendNewsletterEmail(
          name: contact.name,
          email: contact.email,
          subject: widget.newsletter.object,
          message: widget.newsletter.message,
          context: context,
          loading: () {
            setState(() {
              progress++;
            });
          });
    }
    setState(() {
      loading = false;
      end = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: 500,
        height: 500,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              "Send this newsletter to all the${widget.newsletter.allContacts ? "" : " ${widget.newsletter.contacts.length}"} contacts",
              style: thirdTitleStyle,
              textAlign: TextAlign.center,
            ),
            if (loading)
              const CircularProgressIndicator(
                color: Colors.yellow,
              ),
            if (loading)
              LinearProgressIndicator(
                backgroundColor: const Color.fromARGB(172, 0, 0, 0),
                value: progress / widget.contacts.length,
                color: Colors.yellow,
              ),
            if (end)
              Icon(
                Icons.verified,
                size: 40,
                color: Colors.green[700],
              ),
            if (!loading && !end)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                      onPressed: () {
                        sendCampaign();
                      },
                      child: Text(
                        "Send",
                        style: GoogleFonts.nunitoSans(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green),
                      )),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Cancel",
                        style: GoogleFonts.nunitoSans(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                      ))
                ],
              ),
            if (end)
              TextButton(
                  onPressed: () {
                    setState(() {
                      Navigator.pop(context);
                    });
                  },
                  child: Text(
                    "Done",
                    style: GoogleFonts.nunitoSans(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
                  )),
          ],
        ),
      ),
    );
  }
}
