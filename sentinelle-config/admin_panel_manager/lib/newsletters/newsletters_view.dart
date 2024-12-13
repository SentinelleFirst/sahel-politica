import 'package:flutter/material.dart';

import '../widgets/simple_page_title.dart';

class NewslettersView extends StatefulWidget {
  const NewslettersView({super.key});

  @override
  State<NewslettersView> createState() => _NewslettersViewState();
}

class _NewslettersViewState extends State<NewslettersView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      child: Column(
        children: [
          const SimplePageTitle(title: "Newsletters"),
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
