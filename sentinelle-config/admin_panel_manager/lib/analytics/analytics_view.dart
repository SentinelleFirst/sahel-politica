import 'package:flutter/material.dart';

import '../Class/profile_class.dart';
import '../widgets/simple_page_title.dart';

class AnalyticsView extends StatefulWidget {
  const AnalyticsView({super.key, required this.connectedProfil});

  final Profile connectedProfil;

  @override
  State<AnalyticsView> createState() => _AnalyticsViewState();
}

class _AnalyticsViewState extends State<AnalyticsView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      child: Column(
        children: [
          const SimplePageTitle(title: "Analytics"),
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
