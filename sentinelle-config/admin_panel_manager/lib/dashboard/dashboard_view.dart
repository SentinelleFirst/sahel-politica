import 'package:flutter/material.dart';

import '../Class/profile_class.dart';
import '../widgets/simple_page_title.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key, required this.connectedProfil});

  final Profile connectedProfil;

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      child: Column(
        children: [
          const SimplePageTitle(title: "Dashboard"),
          const SizedBox(
            height: 30,
          ),
          Expanded(
              child: Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
          ))
        ],
      ),
    );
  }
}
