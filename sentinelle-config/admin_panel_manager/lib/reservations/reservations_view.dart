import 'package:admin_panel_manager/Class/reservation_class.dart';
import 'package:admin_panel_manager/reservations/reservation_details_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../Class/profile_class.dart';
import '../constants.dart';
import '../widgets/simple_page_title.dart';

class ReservationsView extends StatefulWidget {
  const ReservationsView({super.key, required this.connectedProfil});

  final Profile connectedProfil;

  @override
  State<ReservationsView> createState() => _ReservationsViewState();
}

class _ReservationsViewState extends State<ReservationsView> {
  String search = "";
  List<Reservation> reservations = [];
  List<Reservation> commingReservations = [];

  @override
  void initState() {
    super.initState();
    //Récupération des messages
    getAllReservations();
  }

  Future<void> getAllReservations() async {
    List<Reservation> an = await fetchDBReservations();
    setState(() {
      an.sort(
        (a, b) => b.emissionDate.compareTo(a.emissionDate),
      );
      reservations = an;
      commingReservations = [];
      commingReservations.addAll(reservations.where((re) => re.isConfirmed()));
      commingReservations.sort(
        (a, b) => b.reservationDate.compareTo(a.reservationDate),
      );
    });
  }

  List<Reservation> fetchReservations() {
    if (search.isEmpty) {
      return reservations;
    } else {
      return reservations.where((m) {
        return m.service.toLowerCase().contains(search.toLowerCase()) ||
            m.email.toLowerCase().contains(search.toLowerCase()) ||
            m.company.toLowerCase().contains(search.toLowerCase());
      }).toList();
    }
  }

  void setSearchValue(String value) {
    setState(() {
      search = value;
    });
  }

  void openReservation(Reservation reservation) {
    // Ajoutez une action pour ouvrir la réservation
    showDialog(
      context: context,
      builder: (context) => ReservationDetailsDialog(
        connectedProfil: widget.connectedProfil,
        reservation: reservation,
        refresh: getAllReservations,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      child: Column(
        children: [
          const SimplePageTitle(title: "Reservations"),
          const SizedBox(height: 30),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Your next appointments",
                            style: secondTitleStyle,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(bottom: 20),
                      width: MediaQuery.of(context).size.width,
                      height: 150,
                      child: GridView.count(
                        primary: false,
                        padding: const EdgeInsets.all(20),
                        crossAxisSpacing: 30,
                        mainAxisSpacing: 30,
                        crossAxisCount: 2,
                        childAspectRatio:
                            (MediaQuery.of(context).size.width / 2) / 120,
                        children: List<Widget>.generate(
                          commingReservations.length,
                          (index) => Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                                color: const Color(0xffFACB01).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(15)),
                            child: InkWell(
                              onTap: () {
                                openReservation(commingReservations[index]);
                              },
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    "admin-page-reservation-icon.svg",
                                    width: 30,
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    "${commingReservations[index].service} service - the ${DateFormat.yMMMd().format(commingReservations[index].reservationDate)} - ${DateFormat.Hm().format(commingReservations[index].reservationDate)}\nWith ${commingReservations[index].displayName()}",
                                    style: GoogleFonts.nunitoSans(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      decoration: const BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: Color(0xffDBDBDB), width: 2))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Appointment request",
                            style: secondTitleStyle,
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
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 18),
                      decoration: const BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: Color(0xffDBDBDB), width: 2))),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 150,
                            child: Text(
                              "Service",
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.grey),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            flex: 2,
                            child: Text(
                              "Email",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.grey),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            flex: 2,
                            child: Text(
                              "Company",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.grey),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            flex: 1,
                            child: Text(
                              "Date",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.grey),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            flex: 1,
                            child: Text(
                              "Hour",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.grey),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Text(
                            "Status",
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 550,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              itemCount: fetchReservations().length,
                              itemBuilder: (_, int index) {
                                return ReservationInfoLine(
                                  reservation: fetchReservations()[index],
                                  readAction: () {
                                    openReservation(fetchReservations()[index]);
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ReservationInfoLine extends StatelessWidget {
  const ReservationInfoLine(
      {super.key, required this.reservation, required this.readAction});

  final Reservation reservation;
  final Function() readAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(
              bottom:
                  BorderSide(width: 1, color: Colors.black.withOpacity(0.3)))),
      child: ListTile(
        onTap: readAction,
        title: Row(
          children: [
            SizedBox(
              width: 150,
              child: Text(
                reservation.service,
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w800, fontSize: 16),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              flex: 2,
              child: Text(
                reservation.email,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: GoogleFonts.nunitoSans(
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              flex: 2,
              child: Text(
                reservation.company,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: GoogleFonts.nunitoSans(
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              flex: 1,
              child: Text(
                !reservation.isPending() && !reservation.isCanceled()
                    ? DateFormat.yMd().format(reservation.reservationDate)
                    : "--/--/----",
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: GoogleFonts.nunitoSans(
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              flex: 1,
              child: Text(
                !reservation.isPending() && !reservation.isCanceled()
                    ? DateFormat.Hm().format(reservation.reservationDate)
                    : "--:--",
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: GoogleFonts.nunitoSans(
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(width: 20),
            SizedBox(
              width: 120,
              child: Text(
                reservation.statue,
                textAlign: TextAlign.end,
                style: GoogleFonts.nunitoSans(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: reservation.isPending()
                        ? const Color(0xffFAA701)
                        : reservation.isConfirmed()
                            ? Colors.green
                            : Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
