import 'package:admin_panel_manager/Class/event_class.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_network/image_network.dart';
import 'package:intl/intl.dart';

import '../constants.dart';

class NewEventDialog extends StatefulWidget {
  const NewEventDialog({super.key, required this.refresh});

  final Function() refresh;

  @override
  State<NewEventDialog> createState() => _NewEventDialogState();
}

class _NewEventDialogState extends State<NewEventDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late TextEditingController title;
  late TextEditingController titleFR;
  late TextEditingController smallTitle;
  late TextEditingController smallTitleFR;
  late TextEditingController location;
  late TextEditingController linkedinPost;
  late TextEditingController imageUrl;
  late TextEditingController category;

  late Event eventToModify;

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
    eventToModify = Event.empty();

//On initialise des donnés à afficher
    title = TextEditingController();
    titleFR = TextEditingController();
    smallTitle = TextEditingController();
    smallTitleFR = TextEditingController();
    location = TextEditingController();
    linkedinPost = TextEditingController();
    imageUrl = TextEditingController();
    category = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void publishEvent() {}

  bool showEnglishTitle = true;
  bool showEnglishSmallTitle = true;

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: eventToModify.start,
      firstDate: DateTime(2010, 1, 1),
      lastDate: DateTime(DateTime.now().year + 10),
    );

    if (picked != null && picked != eventToModify.start) {
      //Après avoir choisi la date de fin si elle est avant la date de debut on initalise les deux date au même jour
      setState(() {
        eventToModify.start = picked;
        if (eventToModify.end.isBefore(eventToModify.start)) {
          eventToModify.end = eventToModify.start;
        }
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: eventToModify.end,
      firstDate: DateTime(2010, 1, 1),
      lastDate: DateTime(DateTime.now().year + 10),
    );

    if (picked != null && picked != eventToModify.end) {
      //Après avoir choisi la date de fin si elle est avant la date de debut on initalise les deux date au même jour
      setState(() {
        eventToModify.end = picked;
        if (eventToModify.start.isAfter(eventToModify.end)) {
          eventToModify.start = eventToModify.end;
        }
      });
    }
  }

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
                        "New event",
                        style: secondTitleStyle,
                      ),
                    ),
                    MaterialButton(
                      onPressed: () {
                        setState(() {
                          //Publier l'event
                          publishEvent();
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
                        "Publish",
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
                //Img box
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  width: MediaQuery.of(context).size.width,
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: ImageNetwork(
                          image: eventToModify.imageUrl,
                          width: 540,
                          height: 300,
                          duration: 1500,
                          curve: Curves.easeIn,
                          onPointer: true,
                          debugPrint: false,
                          fullScreen: false,
                          fitAndroidIos: BoxFit.cover,
                          fitWeb: BoxFitWeb.cover,
                          onLoading: const CircularProgressIndicator(
                            color: Color(0xffFACB01),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          MaterialButton(
                            onPressed: () {
                              //Selection de l'image
                            },
                            color: Colors.white,
                            shape: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(20)),
                            minWidth: 60,
                            height: 60,
                            child: const Center(
                              child: Icon(
                                Icons.image,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                //Title info
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
                            "Title in  ${showEnglishTitle ? "English" : "French"}",
                            style: thirdTitleStyle,
                          ),
                          Row(
                            children: [
                              MaterialButton(
                                onPressed: () {
                                  setState(() {
                                    showEnglishTitle = true;
                                  });
                                },
                                color: showEnglishTitle
                                    ? const Color(0xffFACB01)
                                    : const Color(0xffECECEC),
                                minWidth: 50,
                                height: 50,
                                child: Text(
                                  "EN",
                                  style: buttonTitleStyle,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              MaterialButton(
                                onPressed: () {
                                  setState(() {
                                    showEnglishTitle = false;
                                  });
                                },
                                color: !showEnglishTitle
                                    ? const Color(0xffFACB01)
                                    : const Color(0xffECECEC),
                                minWidth: 50,
                                height: 50,
                                child: Text(
                                  "FR",
                                  style: buttonTitleStyle,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: const Color(0xffECECEC),
                            borderRadius: BorderRadius.circular(5)),
                        child: showEnglishTitle
                            ? TextField(
                                controller: title,
                                onChanged: (value) {
                                  setState(() {
                                    eventToModify.title = value;
                                  });
                                },
                                decoration: InputDecoration(
                                  filled: true,
                                  hintText: "title...",
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
                            : TextField(
                                controller: titleFR,
                                onChanged: (value) {
                                  setState(() {
                                    eventToModify.titleFR = value;
                                  });
                                },
                                decoration: InputDecoration(
                                  filled: true,
                                  hintText: "title...",
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
                              ),
                      ),
                    ],
                  ),
                ),
                //Short title info
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
                            "Short title in ${showEnglishSmallTitle ? "English" : "French"}",
                            style: thirdTitleStyle,
                          ),
                          Row(
                            children: [
                              MaterialButton(
                                onPressed: () {
                                  setState(() {
                                    showEnglishSmallTitle = true;
                                  });
                                },
                                color: showEnglishSmallTitle
                                    ? const Color(0xffFACB01)
                                    : const Color(0xffECECEC),
                                minWidth: 50,
                                height: 50,
                                child: Text(
                                  "EN",
                                  style: buttonTitleStyle,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              MaterialButton(
                                onPressed: () {
                                  setState(() {
                                    showEnglishSmallTitle = false;
                                  });
                                },
                                color: !showEnglishSmallTitle
                                    ? const Color(0xffFACB01)
                                    : const Color(0xffECECEC),
                                minWidth: 50,
                                height: 50,
                                child: Text(
                                  "FR",
                                  style: buttonTitleStyle,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: const Color(0xffECECEC),
                            borderRadius: BorderRadius.circular(5)),
                        child: showEnglishSmallTitle
                            ? TextField(
                                controller: smallTitle,
                                onChanged: (value) {
                                  setState(() {
                                    eventToModify.smallTitle = value;
                                  });
                                },
                                decoration: InputDecoration(
                                  filled: true,
                                  hintText: "small title...",
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
                            : TextField(
                                controller: smallTitleFR,
                                onChanged: (value) {
                                  setState(() {
                                    eventToModify.smallTitleFR = value;
                                  });
                                },
                                decoration: InputDecoration(
                                  filled: true,
                                  hintText: "title...",
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
                              ),
                      ),
                    ],
                  ),
                ),
                //Location info
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
                        "Location",
                        style: thirdTitleStyle,
                      ),
                      Container(
                          margin: const EdgeInsets.only(top: 20),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: const Color(0xffECECEC),
                              borderRadius: BorderRadius.circular(5)),
                          child: TextField(
                            controller: location,
                            onChanged: (value) {
                              setState(() {
                                eventToModify.location = value;
                              });
                            },
                            decoration: InputDecoration(
                              filled: true,
                              hintText: "location...",
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
                //Location info
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
                        "Category",
                        style: thirdTitleStyle,
                      ),
                      Container(
                          margin: const EdgeInsets.only(top: 20),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: const Color(0xffECECEC),
                              borderRadius: BorderRadius.circular(5)),
                          child: TextField(
                            controller: category,
                            onChanged: (value) {
                              setState(() {
                                eventToModify.category = value;
                              });
                            },
                            decoration: InputDecoration(
                              filled: true,
                              hintText: "category...",
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
                //Date info
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
                        "Date",
                        style: thirdTitleStyle,
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: Center(
                                  child: Text(
                            "Start :",
                            style: GoogleFonts.nunitoSans(fontSize: 20),
                          ))),
                          InkWell(
                            onTap: () {
                              _selectStartDate(context);
                            },
                            child: Container(
                              width: 350,
                              height: 50,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: const Color(0xffECECEC),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Center(
                                child: Text(
                                  DateFormat.yMd().format(eventToModify.start),
                                  style: GoogleFonts.nunitoSans(
                                      fontSize: 20, color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: Center(
                                  child: Text(
                            "End :",
                            style: GoogleFonts.nunitoSans(fontSize: 20),
                          ))),
                          InkWell(
                            onTap: () {
                              _selectEndDate(context);
                            },
                            child: Container(
                              width: 350,
                              height: 50,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: const Color(0xffECECEC),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Center(
                                child: Text(
                                  DateFormat.yMd().format(eventToModify.end),
                                  style: GoogleFonts.nunitoSans(
                                      fontSize: 20, color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
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
