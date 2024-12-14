import 'package:admin_panel_manager/articles/articles_view.dart';
import 'package:admin_panel_manager/messages/messages_view.dart';
import 'package:admin_panel_manager/newsletters/newsletters_view.dart';
import 'package:admin_panel_manager/reservations/reservations_view.dart';
import 'package:admin_panel_manager/events/events_view.dart';
import 'package:admin_panel_manager/widgets/menu_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'analysis/analysis_view.dart';
import 'analytics/analytics_view.dart';
import 'dashboard/dashboard_view.dart';
import 'users/users_view.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin Page Manager',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    menuSelect(4);
  }

  double menuIconSize = 25;
  int selectedMenuIndex = 1;

  Widget frameView = Container();

  void menuSelect(int i) {
    setState(() {
      selectedMenuIndex = i;
      switch (selectedMenuIndex) {
        case 1:
          frameView = const DashboardView();
          break;
        case 2:
          frameView = const UsersView();
          break;
        case 3:
          frameView = const AnalyticsView();
          break;
        case 4:
          frameView = const ArticlesView();
          break;
        case 5:
          frameView = const AnalysisView();
          break;
        case 6:
          frameView = const EventsView();
          break;
        case 7:
          frameView = const MessagesView();
          break;
        case 8:
          frameView = const ReservationsView();
          break;
        case 9:
          frameView = const NewslettersView();
          break;
        // Ajoutez d'autres cas selon vos besoins
        default:
          frameView = Container(); // Vue par défaut
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          //Menu de gauche
          Container(
            width: 270,
            height: MediaQuery.of(context).size.height,
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Row(
                      children: [
                        Image.asset(
                          'favicon.png',
                          width: 80,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Sahel Politica",
                                style: GoogleFonts.kanit(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Navigating risk, Ensuring impact",
                                style: GoogleFonts.kanit(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    children: [
                      MenuItems(
                        selected: selectedMenuIndex == 1,
                        menuSelect: () {
                          menuSelect(1);
                        },
                        title: "Dashboard",
                        icon: SvgPicture.asset(
                          "admin-page-dashboard-icon.svg",
                          width: menuIconSize,
                        ),
                      ),
                      MenuItems(
                        selected: selectedMenuIndex == 2,
                        menuSelect: () {
                          menuSelect(2);
                        },
                        title: "Users",
                        icon: SvgPicture.asset(
                          "admin-page-users-icon.svg",
                          width: menuIconSize,
                        ),
                      ),
                      MenuItems(
                        selected: selectedMenuIndex == 3,
                        menuSelect: () {
                          menuSelect(3);
                        },
                        title: "Analytics",
                        icon: SvgPicture.asset(
                          "admin-page-analytics-icon.svg",
                          width: menuIconSize,
                        ),
                      ),
                      MenuItems(
                        selected: selectedMenuIndex == 4,
                        menuSelect: () {
                          menuSelect(4);
                        },
                        title: "Articles",
                        icon: SvgPicture.asset(
                          "admin-page-articles-icon.svg",
                          width: menuIconSize,
                        ),
                      ),
                      MenuItems(
                        selected: selectedMenuIndex == 5,
                        menuSelect: () {
                          menuSelect(5);
                        },
                        title: "In-dept analysis",
                        icon: SvgPicture.asset(
                          "admin-page-report-icon.svg",
                          width: menuIconSize,
                        ),
                      ),
                      MenuItems(
                        selected: selectedMenuIndex == 6,
                        menuSelect: () {
                          menuSelect(6);
                        },
                        title: "Events",
                        icon: SvgPicture.asset(
                          "admin-page-events-icon.svg",
                          width: menuIconSize,
                        ),
                      ),
                      MenuItems(
                        selected: selectedMenuIndex == 7,
                        menuSelect: () {
                          menuSelect(7);
                        },
                        title: "Messages",
                        icon: SvgPicture.asset(
                          "admin-page-message-icon.svg",
                          width: menuIconSize,
                        ),
                      ),
                      MenuItems(
                        selected: selectedMenuIndex == 8,
                        menuSelect: () {
                          menuSelect(8);
                        },
                        title: "Reservations",
                        icon: SvgPicture.asset(
                          "admin-page-reservation-icon.svg",
                          width: menuIconSize,
                        ),
                      ),
                      MenuItems(
                        selected: selectedMenuIndex == 9,
                        menuSelect: () {
                          menuSelect(9);
                        },
                        title: "Newsletters",
                        icon: SvgPicture.asset(
                          "admin-page-newsletter-icon.svg",
                          width: menuIconSize,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  child: ListTile(
                    leading: Image.asset(
                      'profile.png',
                      width: 50,
                    ),
                    title: Text(
                      "Issaka OUDRAOGO-ISELI",
                      style: GoogleFonts.poppins(fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
          //Vue des différentes pages
          Expanded(
            child: frameView,
          ),
        ],
      ),
    );
  }
}
