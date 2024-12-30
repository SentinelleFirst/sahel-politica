import 'package:admin_panel_manager/Class/reservation_class.dart';
import 'package:admin_panel_manager/login-manager/send_email.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../Class/profile_class.dart';
import '../constants.dart';

class ReservationDetailsDialog extends StatefulWidget {
  const ReservationDetailsDialog(
      {super.key,
      required this.reservation,
      required this.refresh,
      required this.connectedProfil});

  final Profile connectedProfil;
  final Reservation reservation;
  final Function() refresh;

  @override
  State<ReservationDetailsDialog> createState() =>
      _ReservationDetailsDialogState();
}

class _ReservationDetailsDialogState extends State<ReservationDetailsDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late TextEditingController location;
  late TextEditingController linkmeet;
  late TextEditingController message;

  bool showBookView = false;

  Reservation reservationToModify = Reservation.empty();

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

//On initialise des donnés à afficher
    reservationToModify = Reservation.copy(widget.reservation);
    location = TextEditingController(text: reservationToModify.location);
    linkmeet = TextEditingController(text: reservationToModify.linkmeet);
    message = TextEditingController(text: reservationToModify.message);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void saveAndSendReservationEmail() {
    setState(() {
      saving = true;
    });
    if (validateEntries()) {
      //Envoie email
      if (reservationToModify.isConfirmed()) {
        sendReservationConfirmationEmail(
            reservation: reservationToModify,
            context: context,
            loading: () {
              saveModification();
            });
      } else if (reservationToModify.isCanceled()) {
        sendReservationCancelEmail(
            reservations: reservationToModify,
            context: context,
            loading: () {
              saveModification();
            });
      }
    }
    setState(() {
      saving = false;
    });
  }

  bool validateEntries() {
    if (reservationToModify.location.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Meeting location empty..."),
        ),
      );
      return false;
    } else if (reservationToModify.message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Message empty..."),
        ),
      );
      return false;
    }
    return true;
  }

  bool saving = false;

  void saveModification() async {
    await updateDBReservation(reservationToModify, () {
      widget.refresh();
    }, context);
  }

  List<String> statues = ["Pending", "Confirmed", "Canceled", "Passed"];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: reservationToModify.reservationDate,
      firstDate: DateTime(2010, 1, 1),
      lastDate: DateTime(DateTime.now().year + 10),
    );

    if (picked != null) {
      setState(() {
        reservationToModify.reservationDate = picked;
      });
    }
  }

  Future<void> _selectHour(BuildContext context) async {
    final TimeOfDay? picked =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());

    if (picked != null) {
      setState(() {
        int year = reservationToModify.reservationDate.year;
        int mounth = reservationToModify.reservationDate.month;
        int day = reservationToModify.reservationDate.day;
        reservationToModify.reservationDate =
            DateTime(year, mounth, day, picked.hour, picked.minute);
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
                    if (showBookView)
                      IconButton(
                          onPressed: () {
                            setState(() {
                              showBookView = false;
                            });
                          },
                          icon: const Icon(
                            Icons.arrow_back_rounded,
                            color: Colors.black,
                            size: 30,
                          )),
                    Expanded(
                      child: Text(
                        showBookView
                            ? "Your answer"
                            : "Meet request ${DateFormat.yMd().format(reservationToModify.emissionDate)}\nby ${reservationToModify.displayName()}",
                        style: secondTitleStyle,
                      ),
                    ),
                    if (saving)
                      const CircularProgressIndicator(
                        color: Colors.yellow,
                      ),
                    if (!saving && showBookView)
                      MaterialButton(
                        onPressed:
                            gotAccesToReservationEdit(widget.connectedProfil)
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
                          "Save",
                          style: buttonTitleStyle,
                        ),
                      ),
                    if (!saving && showBookView)
                      const SizedBox(
                        width: 10,
                      ),
                    if (!saving && showBookView)
                      MaterialButton(
                        onPressed: (gotAccesToReservationPublish(
                                    widget.connectedProfil) &&
                                (reservationToModify.isCanceled() ||
                                    reservationToModify.isConfirmed()))
                            ? () {
                                setState(() {
                                  //Save and Send email
                                  saveAndSendReservationEmail();
                                });
                              }
                            : null,
                        shape: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide.none,
                        ),
                        minWidth: 100,
                        height: 50,
                        color: Colors.green,
                        child: Text(
                          "Save & Send",
                          style: buttonTitleStyle,
                        ),
                      ),
                    if (!saving && !showBookView)
                      MaterialButton(
                        onPressed: () {
                          setState(() {
                            showBookView = true;
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
                          "Appointment info",
                          style: buttonTitleStyle,
                        ),
                      ),
                    if (!saving)
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
                //Statue box
                if (showBookView)
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
                          "Reservation statue",
                          style: thirdTitleStyle,
                        ),
                        Text(
                          "Actual statue : ${widget.reservation.statue}",
                          style: GoogleFonts.nunitoSans(
                              fontSize: 16,
                              color: widget.reservation.isPending()
                                  ? const Color(0xffFAA701)
                                  : widget.reservation.isConfirmed()
                                      ? Colors.green
                                      : Colors.black),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 20),
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: const Color(0xffECECEC),
                              borderRadius: BorderRadius.circular(5)),
                          child: DropdownButton<String>(
                            isExpanded: true,
                            alignment: AlignmentDirectional.topStart,
                            value: reservationToModify.statue,
                            onChanged: (String? newValue) {
                              setState(() {
                                if (newValue != null) {
                                  reservationToModify.statue = newValue;
                                }
                              });
                            },
                            items: statues
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
                  ),
                //Email box
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
                        "Email",
                        style: thirdTitleStyle,
                      ),
                      Container(
                          margin: const EdgeInsets.only(top: 20),
                          padding: const EdgeInsets.all(10),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: const Color(0xffECECEC),
                              borderRadius: BorderRadius.circular(5)),
                          child: Text(
                            reservationToModify.email,
                            style: normalTextStyle,
                          )),
                    ],
                  ),
                ),
                //Company and phone box
                if (!showBookView)
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Company",
                                style: thirdTitleStyle,
                              ),
                              Container(
                                  margin: const EdgeInsets.only(top: 20),
                                  padding: const EdgeInsets.all(10),
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      color: const Color(0xffECECEC),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Text(
                                    reservationToModify.company,
                                    style: normalTextStyle,
                                  )),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Phone",
                                style: thirdTitleStyle,
                              ),
                              Container(
                                  margin: const EdgeInsets.only(top: 20),
                                  padding: const EdgeInsets.all(10),
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      color: const Color(0xffECECEC),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Text(
                                    reservationToModify.phone,
                                    style: normalTextStyle,
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                //Answer box
                if (!showBookView)
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
                          "Question's answer",
                          style: thirdTitleStyle,
                        ),
                        Container(
                            margin: const EdgeInsets.only(top: 20),
                            width: MediaQuery.of(context).size.width,
                            child: Text(
                              "Type of service requiest : ${reservationToModify.service}\n\n${reservationToModify.displayAnswers()}",
                              style: normalTextStyle,
                            )),
                      ],
                    ),
                  ),
                //Date picker
                //Date info
                if (showBookView &&
                    !reservationToModify.isPassed() &&
                    !reservationToModify.isCanceled())
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
                              "Date :",
                              style: GoogleFonts.nunitoSans(fontSize: 20),
                            ))),
                            InkWell(
                              onTap: () {
                                _selectDate(context);
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
                                    DateFormat.yMd().format(
                                        reservationToModify.reservationDate),
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
                              "Hour :",
                              style: GoogleFonts.nunitoSans(fontSize: 20),
                            ))),
                            InkWell(
                              onTap: () {
                                _selectHour(context);
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
                                    DateFormat.Hm().format(
                                        reservationToModify.reservationDate),
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
                //location info
                if (showBookView &&
                    !reservationToModify.isPassed() &&
                    !reservationToModify.isCanceled())
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
                              textAlignVertical: TextAlignVertical.top,
                              controller: location,
                              onChanged: (value) {
                                setState(() {
                                  reservationToModify.location = value;
                                });
                              },
                              decoration: InputDecoration(
                                filled: true,
                                hintText:
                                    "Sahel Politica, Chamerstrasse 172, 6300 Zug...",
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
                //Meet link info
                if (showBookView &&
                    !reservationToModify.isPassed() &&
                    !reservationToModify.isCanceled())
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
                          "Meet link (optional)",
                          style: thirdTitleStyle,
                        ),
                        Container(
                            margin: const EdgeInsets.only(top: 20),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: const Color(0xffECECEC),
                                borderRadius: BorderRadius.circular(5)),
                            child: TextField(
                              textAlignVertical: TextAlignVertical.top,
                              controller: linkmeet,
                              onChanged: (value) {
                                setState(() {
                                  reservationToModify.linkmeet = value;
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
                //Message info
                if (showBookView)
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    width: MediaQuery.of(context).size.width,
                    height: 400,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Message",
                          style: thirdTitleStyle,
                        ),
                        Expanded(
                          child: Container(
                              margin: const EdgeInsets.only(top: 20),
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  color: const Color(0xffECECEC),
                                  borderRadius: BorderRadius.circular(5)),
                              child: TextField(
                                expands: true,
                                minLines: null,
                                maxLines: null,
                                textAlignVertical: TextAlignVertical.top,
                                controller: message,
                                onChanged: (value) {
                                  setState(() {
                                    reservationToModify.message = value;
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
