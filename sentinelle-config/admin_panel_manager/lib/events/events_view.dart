import 'package:admin_panel_manager/events/delete_event_dialog.dart';
import 'package:admin_panel_manager/events/event_details_dialog.dart';
import 'package:admin_panel_manager/events/new_event_dialog.dart';
import 'package:admin_panel_manager/widgets/simple_divider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Class/event_class.dart';
import '../widgets/simple_page_title.dart';
import 'package:image_network/image_network.dart';
import 'package:intl/intl.dart';

class EventsView extends StatefulWidget {
  const EventsView({super.key});

  @override
  State<EventsView> createState() => _EventsViewState();
}

class _EventsViewState extends State<EventsView> {
  String search = "";
  bool isLoading = true;
  List<Event> events = [];
  List<Event> rawEvents = [];
  @override
  void initState() {
    super.initState();
    getAllEvents();
  }

  Future<void> getAllEvents() async {
    List<Event> an = await fetchDBEvents();
    setState(() {
      an.sort(
        (a, b) => b.start.compareTo(a.start),
      );
      rawEvents = an;
      _loadEventImages();
    });
  }

  Future<void> _loadEventImages() async {
    try {
      for (var event in rawEvents) {
        final ref =
            FirebaseStorage.instance.ref(event.imageUrl); // Chemin Firebase
        final downloadUrl =
            await ref.getDownloadURL(); // Téléchargement de l'URL
        event.imageUrl = downloadUrl; // Mise à jour de l'URL dans l'objet
      }
      setState(() {
        events = rawEvents;
        isLoading = false;
      });
    } catch (e) {
      print("Error loading images: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  List<Event> fetchEvents() {
    if (search.isEmpty) {
      return events;
    } else {
      return events.where((ev) {
        return ev.title.toLowerCase().contains(search.toLowerCase()) ||
            ev.titleFR.toLowerCase().contains(search.toLowerCase());
      }).toList();
    }
  }

  void setSearchValue(String value) {
    setState(() {
      search = value;
    });
  }

  void openEvent(Event event) {
    // Ajoutez une action pour ouvrir l'événement
    showDialog(
      context: context,
      builder: (context) => EventDetailsDialog(
        event: event,
        refresh: () {},
      ),
    );
  }

  void newEvent() {
    showDialog(
      context: context,
      builder: (context) => NewEventDialog(
        refresh: getAllEvents,
      ),
    );
  }

  void deleteEvent(String id) {
    showDialog(
      context: context,
      builder: (context) => DeleteEventDialog(
        id: id,
        refresh: getAllEvents,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      child: Column(
        children: [
          ComplexePageTitle(
            title: "Events",
            buttonTitle: "New event",
            buttonAction: newEvent,
            searchFieldChange: setSearchValue,
          ),
          const SizedBox(height: 30),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListView.builder(
                      itemCount: fetchEvents().length,
                      itemBuilder: (_, int index) {
                        return EventInfoLine(
                          event: fetchEvents()[index],
                          delete: () {
                            deleteEvent(fetchEvents()[index].id);
                          },
                          readAction: () {
                            openEvent(fetchEvents()[index]);
                          },
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class EventInfoLine extends StatelessWidget {
  const EventInfoLine({
    super.key,
    required this.event,
    required this.readAction,
    required this.delete,
  });

  final Event event;
  final Function() readAction;
  final Function() delete;

  bool isSameDay(DateTime a, DateTime b) {
    return a.day == b.day && a.month == b.month && a.year == b.year;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color.fromARGB(24, 0, 0, 0), width: 2),
        ),
      ),
      child: ListTile(
        title: Row(
          children: [
            SizedBox(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: ImageNetwork(
                      key: ValueKey(event.imageUrl),
                      image: event.imageUrl,
                      width: 300,
                      height: 200,
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
                  Container(
                    width: 300,
                    height: 200,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.black.withOpacity(0.3)),
                    child: Center(
                      child: Text(
                        "${DateFormat.Md().format(event.start)}${!isSameDay(event.start, event.end) ? " - ${DateFormat.Md().format(event.end)}" : ""}\n${event.start.year}\nGMT",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.nunitoSans(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(width: 20),
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
                          event.category,
                          style: GoogleFonts.poppins(
                              fontSize: 18, color: Colors.grey),
                        ),
                      ],
                    ),
                    Text(
                      event.title,
                      style: GoogleFonts.poppins(fontSize: 20),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                    Text(
                      event.location,
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
                      onPressed: () async {
                        if (event.linkedinPost.isNotEmpty) {
                          final Uri url = Uri.parse(event.linkedinPost);
                          if (await canLaunchUrl(url)) {
                            await launchUrl(url);
                          } else {
                            throw 'Could not launch $url';
                          }
                        }
                      },
                      icon: const Icon(
                        Icons.remove_red_eye_outlined,
                        size: 20,
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
